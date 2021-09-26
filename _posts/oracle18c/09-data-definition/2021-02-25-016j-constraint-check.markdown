---
layout: post
title: "DDL - Check Constraint"
date: 2021-02-25T15:43:59+07:00
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/19/cncpt/data-integrity.html#GUID-5AF9C206-0139-4506-96DE-F6AD1D41CD41
youtube: 2lfj8T3FM0U
comments: true
catalog_key: sql-ddl
image_path: /resources/posts/oracle12c/016j-constraint-check
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Constraint **Check** dapat diterapkan pada kolom tertentu dalam sebuah table, dengan tujuan memvalidasi data yang kita entry harus sesuai dengan criteria yang diterapkan pada constraint tersebut contohnya pada kolom `price` nilai minimal lebih besar dari `0`. Contoh penggunaanya seperti berikut:

{% gist page.gist "016j-ddl-constraint-check.sql" %}

Jadi dengan ddl untuk membuat table seperti diatas, maka kita tidak boleh entry data pada kolom `saldo` dengan nilai lebih kecil dari `0` dan pada kolom `jenis_kelamin` nilainya harus `L` atau `P`, nah sekarang kita coba untuk case yang error contoh dengan perintah entry seperti berikut:

{% highlight sql %}
insert into test_constraint_check(nik, nama, saldo, jenis_kelamin)
values ('6201010104', 'Test Salah saldo null', null, 'P');

insert into test_constraint_check(nik, nama, saldo, jenis_kelamin)
values ('6201010105', 'Test saldo minus', -1, 'P');

insert into test_constraint_check(nik, nama, saldo, jenis_kelamin)
values ('6201010106', 'Test jenis kelamin null', 1, null);

insert into test_constraint_check(nik, nama, saldo, jenis_kelamin)
values ('6201010107', 'Test jenis kelamin salah', 0, 'l');
{% endhighlight %}

Bila di execute, maka hasilnya seperti berikut:

{% highlight sql %}
SQL> insert into test_constraint_check(nik, nama, saldo, jenis_kelamin)
values ('6201010104', 'Test Salah saldo null', null, 'P');

1 row created.

SQL> insert into test_constraint_check(nik, nama, saldo, jenis_kelamin)
values ('6201010105', 'Test saldo minus', -1, 'P');
insert into test_constraint_check(nik, nama, saldo, jenis_kelamin)
*
ERROR at line 1:
ORA-02290: check constraint (HR.CK_SALDO_ALWAYS_ABS) violated


SQL> insert into test_constraint_check(nik, nama, saldo, jenis_kelamin)
values ('6201010106', 'Test jenis kelamin null', 1, null);

1 row created.

SQL> insert into test_constraint_check(nik, nama, saldo, jenis_kelamin)
values ('6201010107', 'Test jenis kelamin salah', 0, 'l'); 
insert into test_constraint_check(nik, nama, saldo, jenis_kelamin)
*
ERROR at line 1:
ORA-02290: check constraint (HR.CK_JK) violated

SQL> select nik, saldo, jenis_kelamin
from test_constraint_check;

NIK         SALDO      JK
----------- ---------- --
6201010101           0 L
6201010102           0 L
6201010103           0 P
6201010104             P
6201010106           1
{% endhighlight %}

## Multiple column check constraint

Selain itu juga kita bisa menggunakan untuk multiple column, contohnya seperti berikut

{% gist page.gist "016j-ddl-constraint-check-multiple-columns.sql" %}

Sekarang kita coba beberapa entry seperti berikut:

{% highlight sql %}
insert into test_constraint_check_multi_columns(product_id, name, price, discount)
VALUES (1, 'Test discount null', 25000, null);

insert into test_constraint_check_multi_columns(product_id, name, price, discount)
VALUES (1, 'Test price lower than', 9000, .2);

insert into test_constraint_check_multi_columns(product_id, name, price, discount)
VALUES (1, 'Test price discount lower than', 10000, .01);
{% endhighlight %}

jika di jalankan maka hasilnya seperti berikut:

{% highlight sql %}
SQL> insert into test_constraint_check_multi_columns(product_id, name, price, discount)
VALUES (1, 'Test discount null', 25000, null);

1 row created.

SQL> insert into test_constraint_check_multi_columns(product_id, name, price, discount)
VALUES (1, 'Test price lower than', 9000, .2); 
insert into test_constraint_check_multi_columns(product_id, name, price, discount)
*
ERROR at line 1:
ORA-02290: check constraint (HR.CK_PRICE_AND_DISCOUNT) violated

SQL> insert into test_constraint_check_multi_columns(product_id, name, price, discount)
VALUES (1, 'Test price discount lower than', 10000, .01);
insert into test_constraint_check_multi_columns(product_id, name, price, discount)
*
ERROR at line 1:
ORA-02290: check constraint (HR.CK_PRICE_AND_DISCOUNT) violated
{% endhighlight %}