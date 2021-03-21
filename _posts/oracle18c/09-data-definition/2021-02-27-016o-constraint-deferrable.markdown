---
layout: post
title: "DDL - Deferring Constraint Checks"
date: 2021-02-27T10:07:36+07:00
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/constraint.html#GUID-1055EA97-BA6F-4764-A15F-1024FD5B6DFE
youtube: bgXLOM0kfRw
comments: true
image_path: /resources/posts/oracle12c/016o-constraint-deferrable
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Pengecekan data pada constraint secara default akan di lakukan setiap perintah manipulasi data di execute (`NOT DEFERREBLE`) sebagai contoh seperti berikut:

```sql
SQL> insert into TEST_CONSTRAINT_CHECK(NIK, NAMA, SALDO, JENIS_KELAMIN)
VALUES ('010101', 'Dimas Maryanto', 0, 'l');

insert into TEST_CONSTRAINT_CHECK(NIK, NAMA, SALDO, JENIS_KELAMIN)
*
ERROR at line 1:
ORA-02290: check constraint (HR.CK_JK) violated
```

Dengan `deferreble` kita bisa hold sampai perintah `commit` atau `rollback` di execute, untuk menggunakan `deferreble` kita harus definisikan constraintnya seperti berikut:

{% gist page.gist "016o-constraint-define-deferrable.sql" %}

Sekarang coba execute query berikut:

{% highlight sql %}
insert into TEST_CONSTRAINT_CHECK(NIK, NAMA, SALDO, JENIS_KELAMIN)
VALUES ('0202023', 'Test invalid saldo', -1, 'L');

insert into TEST_CONSTRAINT_CHECK(NIK, NAMA, SALDO, JENIS_KELAMIN)
VALUES ('0202022', 'Test Valid saldo', 10000, 'L');
{% endhighlight %}

Berikut hasilnya:

```sql
SQL> alter table TEST_CONSTRAINT_CHECK
    add constraint ck_saldo_always_abs check ( SALDO >= 0 )
        deferrable initially deferred;

Table altered.

SQL> select DEFERRABLE, STATUS
from USER_CONSTRAINTS
where TABLE_NAME = 'TEST_CONSTRAINT_CHECK'
  and lower(CONSTRAINT_NAME) = 'ck_saldo_always_abs';

DEFERRABLE     STATUS
-------------- --------
DEFERRABLE     ENABLED

SQL> insert into TEST_CONSTRAINT_CHECK(NIK, NAMA, SALDO, JENIS_KELAMIN)
VALUES ('0202023', 'Test invalid saldo', -1, 'L');

1 row created.

SQL> insert into TEST_CONSTRAINT_CHECK(NIK, NAMA, SALDO, JENIS_KELAMIN)
VALUES ('0202022', 'Test Valid saldo', 10000, 'L');

1 row created.

SQL> commit;
commit
*
ERROR at line 1:
ORA-02091: transaction rolled back
ORA-02290: check constraint (HR.CK_SALDO_ALWAYS_ABS) violated
```