---
layout: post
title: "Getting started with Transaction Control (TCL)"
lang: postgresql
authors:
- dimasm93
categories:
- RDBMS
- PostgreSQL
- SQL
- TCL
refs: 
- https://www.postgresql.org/docs/current/sql-begin.html
- https://www.postgresql.org/docs/14/sql-commit.html
- https://www.postgresql.org/docs/14/sql-rollback.html
youtube: 
image_path: /resources/posts/postgresql/06a-basic-tcl
comments: true
gist: dimMaryanto93/7ae7632f9418feb724bc431eff412a3f
catalog_key: dml-statement
downloads: []
---

Hai semuanya, sekarang kita akan membahas tentang Transaction Language Control atau singkatanya TCL, dimana transaction control ini adalah salah satu feature di Relational Database Management System (RDBMS) yang secara umum digunakan untuk mengelompokan sekumpulan query yang akan dikirimkan ke database server secara atomic, consistent, isolated dan durable. 

Untuk lebih jelasnya, yuk kita bahas secara lebih detail. Adapun materi yang akan kita bahas kali ini adalah

1. Default Transaction Control behavior
2. Using Commit clause
3. Using Rollback clause
4. Using Savepoint clause
5. When you update data using diffrent sessions
6. Transaction isolation

Ok tanpa berlama-lama yuk langsung aja kita bahas materi yang pertama:

<!--more-->

## Default Transaction Control behavior

A PostgreSQL transaction is **atomic**, **consistent**, **isolated**, and **durable**. These properties are often referred to as ACID:

1. Atomicity guarantees that the transaction completes in an all-or-nothing manner.
2. Consistency ensures the change to data written to the database must be valid and follow predefined rules.
3. Isolation determines how transaction integrity is visible to other transactions.
4. Durability makes sure that transactions that have been committed will be stored in the database permanently.

By default PostgreSQL using auto-commit every single query executed by database atau setiap 1 query yang kita jalankan di database server PostgreSQL maka akan automatis di commit. Seperti berikut contohnya:

{% highlight sql %}
INSERT INTO regions(region_id, region_name)
VALUES (6, 'Other');
{% endhighlight %}

Ketika di execute, maka secara default data akan bertambah ke dalam tabel dan simpan secara permanent. Tetapi jika kita ingin merubah behavior menjadi manual, kita perlu menggunakan keywork `BEGIN` pada awal statement.

Syntaxnya seperti berikut

{% highlight sql %}
BEGIN;
--- Select, Insert, Update, and Delete statement here
{% endhighlight %}

Berikut adalah implementasi penggunakan manual transaction:

{% gist page.gist "06a-begin-transaction.sql" %}

Jika kita execute, maka hasilnya seperti berikut:

```bash
database/postgres-14 [master●] » psql -U hr
psql (14.6)
Type "help" for help.

hr= begin;
BEGIN
hr=* insert into regions(region_id, region_name)
hr-* values (7, 'Other 2');
INSERT 0 1
hr=* select * from regions where region_id = 7;
 region_id | region_name
-----------+-------------
         7 | Other 2
(1 row)

hr=* exit
database/postgres-14 [master●] » psql -U hr
psql (14.6)
Type "help" for help.

hr= select * from regions where region_id = 7;
 region_id | region_name
-----------+-------------
(0 rows)

hr=#
```

Nah terlihat hasilnya ketika query di execute, maka secara temporary data akan tersimpan ke tabel tetapi begitu session habis atau kita keluar dari session tersebut, maka datanya akan hilang.

## Using Commit clause

Perintah `commit` digunakan untuk menyimpan perubahan yang dilakukan oleh perintah Data Manipulation secara permanent di database, Seperti pada section sebelumnya jika kita tidak menggunakan perintah `commit` di akhir statement maka data akan hilang jika kita hapus session connection.

Perintah `commit` hanya bisa dilakukan jika diawali dengan menggunakan `begin` clause, tanpa perintah `begin` atau jika tidak memiliki transaction dalamnya maka, akan muncul warning `there is no transaction in progress`

Syntaxnya seperti berikut:

{% highlight sql %}
BEGIN;

--- Select, Insert, Update, and Delete statement here

COMMIT;
{% endhighlight %}

Implementasinya seperti berikut:

{% gist page.gist "06a-begin-commit-transaction.sql" %}

Jika dijalankan hasilnya seperti berikut:

```bash
database/postgres-14 [master●] » psql -U hr
psql (14.6)
Type "help" for help.

hr= BEGIN;
BEGIN

hr=* INSERT INTO regions(region_id, region_name)
hr-* VALUES (7, 'Other 2');
INSERT 0 1

hr=* COMMIT;
COMMIT

hr= select * from regions where region_id = 7;
 region_id | region_name
-----------+-------------
         7 | Other 2
(1 row)

hr= exit

database/postgres-14 [master●] » psql -U hr
psql (14.6)
Type "help" for help.

hr= select * from regions where region_id = 7;
 region_id | region_name
-----------+-------------
         7 | Other 2
(1 row)
```

Nah jadi bisa kita perhatihan dari output diatas, meskipun kita close session connect data masih tersimpan di table `regions` tersebut karena kita sudah menggunakan perintah `commit`.

## Using Rollback clause

Perintah `rollback` digunakan untuk membatalkan transaksi yang sedang aktif untuk mengembalikan ke last state commit pada database. Sama halnya dengan perintah `commit` perintah `rollback` tidak akan berjalan jika tanpa `begin` atau transaction sedang tidak aktif.

**NOTES:** Jika perintah `commit` sudah di execute kita tidak bisa mengembalikannya, perintah `rollback` hanya bisa mengembalikan perubahan ketika belum di `commit`.

Syntaxnya seperti berikut:

{% highlight sql %}
BEGIN;

--- Select, Insert, Update, and Delete statement here

ROLLBACK;
{% endhighlight %}

Perintah rollback ini biasanya digunakan jika terjadi kesalahan baik dari human error, system error maupun runtime error diataranya:

1. Salah input value pada data manipulation
2. Error pada constraint (unique, foreign key, check)

Contoh implementasinya seperti berikut:

{% gist page.gist "06a-begin-rollback-transaction.sql" %}

Jika dijalnakan maka outputnya seperti bertikut:

```sql
hr= BEGIN;
BEGIN

hr=* UPDATE regions set region_name = 'Other 3'
hr-* WHERE region_id = 7;
UPDATE 1

hr=* SELECT * FROM regions WHERE region_id = 7;
 region_id | region_name
-----------+-------------
         7 | Other 3
(1 row)

hr=* ROLLBACK;
ROLLBACK

hr= SELECT * FROM regions WHERE region_id = 7;
 region_id | region_name
-----------+-------------
         7 | Other 2
(1 row)
```

Nah jadi kita perhatikan pada output diatas, ketika kita jalankan perintah `update` dan juga `select` data sudah berubah di tabel begitu di rollback maka data akan kembali ke last update sebelumnya.

## Using Savepoint clause