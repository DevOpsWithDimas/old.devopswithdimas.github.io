---
layout: post
title: "DDL - Not Null Constraint"
date: 2021-02-24T22:02:19+07:00
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/19/cncpt/data-integrity.html#GUID-CF2E06A6-6A35-46CE-808E-305A459457CC
youtube: https://www.youtube.com/watch?v=BSKfOmqdZBc&list=PLV1-tdmPblvzqS-Z57hZ_spTRtVvnYYpV&index=81
comments: true
image_path: /resources/posts/oracle12c/016h-constraint-not-null
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Constraint **Not Null** diterapkan pada column tertentu dalam sebuah table, dengan tujuan untuk memvalidasi data yang kita entry tidak dapat bernilai null. Contoh penggunaanya seperti berikut:


{% gist page.gist "016h-constraint-notnull.sql" %}

Coba execute dan commit, maka hasilnya seperti berikut:

{% highlight sql %}
SQL> select * from test_constraint_notnull;

PRODUCT_NO NAME                                                    PRICE
---------- -------------------------------------------------- ----------
         1 Macbook Pro 13" (2017)                                  25000

{% endhighlight %}

Jadi dengan ddl untuk membuat table seperti diatas, maka kita **harus mengisi nilai** pada kolom `product_no` dan `name`, tidak boleh `null`. Contohnya dengan perintah entry yang salah seperti berikut:

{% highlight sql %}
insert into test_constraint_notnull(product_no, name, price)
values (2, null, 25000);
{% endhighlight %}


Bila di execute maka akan terjadi error:

{% highlight sql %}
values (2, null, 25000)
           *
ERROR at line 2:
ORA-01400: cannot insert NULL into ("HR"."TEST_CONSTRAINT_NOTNULL"."NAME")
{% endhighlight %}


## Add Not null constraint dengan Alter Table

Atau kalau misalnya tabel dan columnnya udah akan misalnya blum ada contraint `not null` kita bisa menggunakan alter table, seperti berikut:

{% gist page.gist "016h-alter-table-add-notnull-constraint.sql" %}

Sebelum kita exeucte `alter table` kita harus make sure dulu ya column yang mau di tambah constraint not null misalnya klo ada kita update ja columnya seperti diatas. Ok setelah itu coba execute maka hasilnya seperti berikut:

{% highlight sql %}
SQL> desc test_constraint_notnull;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 PRODUCT_NO                                NOT NULL NUMBER(38)
 NAME                                      NOT NULL VARCHAR2(50)
 PRICE                                     NOT NULL NUMBER(8,2)
 CATEGORY_ID                                        VARCHAR2(64)


SQL> update test_constraint_notnull
set category_id = ''
where category_id is null;

1 row updated.

SQL> commit;

SQL> alter table test_constraint_notnull
    modify category_id varchar2(64) default '' not null;

Table altered.

SQL> desc test_constraint_notnull;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 PRODUCT_NO                                NOT NULL NUMBER(38)
 NAME                                      NOT NULL VARCHAR2(50)
 PRICE                                     NOT NULL NUMBER(8,2)
 CATEGORY_ID                               NOT NULL VARCHAR2(64)
{% endhighlight %}