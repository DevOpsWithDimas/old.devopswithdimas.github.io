---
layout: post
title: "DDL - Enabled, Disabled & Drop Constraints"
date: 2021-02-27T06:03:22+07:00
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/constraint.html#GUID-1055EA97-BA6F-4764-A15F-1024FD5B6DFE
youtube: https://www.youtube.com/watch?v=8Eq9Yj6Q7Pw&list=PLV1-tdmPblvzqS-Z57hZ_spTRtVvnYYpV&index=87
comments: true
image_path: /resources/posts/oracle12c/016n-disable-enable-constraints
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Sometime kita perlu me-disable constraint secara temporary untuk mempercepat proses seperti:

1. Batch insert operation, 
2. Load data dalam jumlah yang besar 
3. Import & Export semua data dalam table.
4. Melepas rule supaya bisa input data yang secara rule dilarang (exception)

Melakukan disabled constraint akan _improve performance operation_ khususnya pada data _warehouse configuration_. Untuk mencari informasi constraint kita bisa menggunakan perintah berikut:

{% gist page.gist "016n-select-from-user-constraints.sql" %}

maka hasilnya seperti berikut:

```sql
C TABLE_NAME                     CONSTRAINT_NAME      STATUS   VALIDATED
- ------------------------------ -------------------- -------- -------------
R TEST_FK_DETAIL_TABLE           FK_DETAIL_MASTER_ID  ENABLED  VALIDATED
R TEST_CONSTRAINT_FK_OPTIONS_SET FK_CONSTRAINT_OPTION ENABLED  VALIDATED
  _NULL                          _SET_NULL

R TEST_CONSTRAINT_FK_OPTIONS_CAS FK_CONSTRAINT_OPTION ENABLED  VALIDATED
  CADE                           _CASCADE
C TEST_CONSTRAINT_NOTNULL        SYS_C007462          ENABLED  VALIDATED
C TEST_CONSTRAINT_MULTI_UNIQUE   SYS_C007469          ENABLED  VALIDATED
C TEST_CONSTRAINT_CHECK          CK_SALDO_ALWAYS_ABS  ENABLED  VALIDATED
C TEST_CONSTRAINT_CHECK          CK_JK                ENABLED  VALIDATED
C TEST_CONSTRAINT_CHECK_MULTI_CO CK_DISCOUNT_BETWEEN  ENABLED  VALIDATED
  LUMNS
C TEST_CONSTRAINT_CHECK_MULTI_CO CK_PRICE_AND_DISCOUN ENABLED  VALIDATED
  LUMNS                          T
C TEST_CONSTRAINT_PK             SYS_C007476          ENABLED  VALIDATED
C TEST_FK_DETAIL_TABLE           SYS_C007481          ENABLED  VALIDATED
C TEST_CONSTRAINT_FK_OPTIONS_SET SYS_C007489          ENABLED  VALIDATED
  _NULL
C TEST_CONSTRAINT_FK_OPTIONS_CAS SYS_C007493          ENABLED  VALIDATED
  CADE
U TEST_CONSTRAINT_UNIQUE         SYS_C007465          ENABLED  VALIDATED
U TEST_CONSTRAINT_MULTI_UNIQUE   UQ_PRODUCT_ID        ENABLED  VALIDATED
U TEST_CONSTRAINT_CHECK          SYS_C007473          ENABLED  VALIDATED
P TEST_CONSTRAINT_PK             SYS_C007477          ENABLED  VALIDATED
P TEST_CONSTRAINT_COMPOSITE_PK   PK_COMPOSITE_PRODUCT ENABLED  VALIDATED
P TEST_FK_MASTER_TABLE           SYS_C007479          ENABLED  VALIDATED
P TEST_FK_DETAIL_TABLE           SYS_C007482          ENABLED  VALIDATED
P TEST_CONSTRAINT_FK_OPTIONS     SYS_C007484          ENABLED  VALIDATED
P TEST_CONSTRAINT_FK_OPTIONS_SET SYS_C007490          ENABLED  VALIDATED
  _NULL
P TEST_CONSTRAINT_FK_OPTIONS_CAS SYS_C007494          ENABLED  VALIDATED
  CADE

32 rows selected.
```

Berikut adalah penjelasannya:

**Field Constraint Type**:

1. `U`, artinya Unique
2. `P`, artinya Primary Key
3. `C`, artinya Check
4. `R`, artinya References atau Foreign Key

**Field Status:**

1. `ENABLED` = aktif
2. `DISABLED` = mati

**Field Validated:**

1. `VALIDATED`, di check secara berkala atau  operation. Dengan tujuan menjaga bahwa data baru dan lama valid semua
2. `NOT VALIDATED`, ketika di input di check tetapi jika data usah ada tidak di check.

Untuk melihat data definition language yang telah di buat, kita bisa menggunakan query berikut:

{% gist page.gist "016n-dbms-metadata-get-dll.sql" %}

berikut hasilnya:

```sql
Enter value for const_name: 'CK_PRICE_AND_DISCOUNT'

  ALTER TABLE "HR"."TEST_CONSTRAINT_CHECK_MULTI_COLUMNS" 
  ADD CONSTRAINT "CK_PRICE_AND_DISCOUNT" 
  CHECK ( price >= 10000 and discount >= 0.1 ) ENABLE
```

## Disable Constraint

Secara default begitu contraint di buat maka akan automatis `enabled` jika mau disable kita bisa menggunakan `alter table` seperti berikut:

{% gist page.gist "016n-alter-constraint-disabled.sql" %}

Dengan begitu kita bisa input, `price <= 10000` and `discount <= 0.1` seperti berikut:

{% highlight sql %}
insert into test_constraint_check_multi_columns(product_id, name, price, discount)
VALUES (1, 'Test price discount lower than', 10000, .01);
{% endhighlight %}

hasilnya seperti berikut:

```sql
SQL> insert into test_constraint_check_multi_columns(product_id, name, price, discount)
VALUES (1, 'Test price discount lower than', 10000, .01);  2

1 row created.

SQL> select * from test_constraint_check_multi_columns where product_id = 1;

PRODUCT_ID NAME                                                    PRICE   DISCOUNT
---------- -------------------------------------------------- ---------- ----------
         1 Test price discount lower than                          10000        .01
         1 Macbook Pro 13" (2017)                                  25000         .2
         1 Test discount null                                      25000

3 rows selected.

SQL> commit;

Commit complete.
```

## Enabled Constraint

Untuk mengaktifkannya kembali, sama kita bisa menggunakan `alter table` seperti berikut:

{% gist page.gist "016n-alter-constraint-enabled.sql" %}

Jika di execute ini akan terjadi error, karena ada data yang tidak sesuai criteria check contraint tersebut seperti berikut:

```sql
SQL> alter table TEST_CONSTRAINT_CHECK_MULTI_COLUMNS
    enable constraint CK_PRICE_AND_DISCOUNT;
                      *
ERROR at line 2:
ORA-02293: cannot validate (HR.CK_PRICE_AND_DISCOUNT) - check constraint violated


```

solusinya kita bisa menggunakan `NOVALIDATE` seperti berikut:

{% gist page.gist "016n-alter-constraint-enabled-novalidated.sql" %}

Hasilnya seperti berikut:

```sql
SQL> alter table TEST_CONSTRAINT_CHECK_MULTI_COLUMNS
    enable novalidate constraint CK_PRICE_AND_DISCOUNT;  2

Table altered.

SQL> select CONSTRAINT_TYPE, TABLE_NAME, CONSTRAINT_NAME, STATUS, VALIDATED
from USER_CONSTRAINTS
where CONSTRAINT_NAME = 'CK_PRICE_AND_DISCOUNT'
  and OWNER = user;  2    3    4

C TABLE_NAME                     CONSTRAINT_NAME      STATUS   VALIDATED
- ------------------------------ -------------------- -------- -------------
C TEST_CONSTRAINT_CHECK_MULTI_CO CK_PRICE_AND_DISCOUN ENABLED  NOT VALIDATED
  LUMNS                          T

1 row selected.
```

## Drop Constraint

Constraint yang telah di buat gak bisa di modifikasi, untuk mengubah rulenya kita harus drop dulu kemudian di buat baru lagi. Untuk menghapus constraint kit bisa menggunakan `drop constraint` seperti berikut:

{% gist page.gist "016n-drop-constraint.sql" %}

maka hasilnya seperti berikut:

```sql
SQL> alter table TEST_CONSTRAINT_CHECK_MULTI_COLUMNS
    drop constraint CK_PRICE_AND_DISCOUNT;

Table altered.

select CONSTRAINT_TYPE, TABLE_NAME, CONSTRAINT_NAME, STATUS, VALIDATED
from USER_CONSTRAINTS
where CONSTRAINT_NAME = 'CK_PRICE_AND_DISCOUNT'
  and OWNER = user;

no rows selected
```

