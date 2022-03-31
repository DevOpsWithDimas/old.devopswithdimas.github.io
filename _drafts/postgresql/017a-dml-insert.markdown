---
layout: post
title: "DML - Insert Statement di PostgreSQL"
date: 2019-12-29T19:15:00+07:00
lang: psql
categories:
- RDBMS
- PostgreSQL
refs: 
- https://www.postgresql.org/docs/9.2/dml.html
youtube: S4CrEAgfLz0
comments: true
gist: dimMaryanto93/62ffa0d81f3835a4e9401baf14590cd2
downloads: []
---


Ketika tabel telah terbuat, biasanya tidak ada data yang tersedia di dalam tabel tersebut. Untuk mengisi datanya kita harus menjalankan perintah insert atau selain itu kita juga bisa menggunakan fitur backup/restore database, tpi fitur backup/restore tidak akan saya jelaskan di materi bootcamp sekarang. Jadi kita fokus ke materi dml dulu.

<!--more-->

Format penulisan insert statement yaitu sebagai berikut:

```sql
INSERT INTO table_name (column1, column2, ...)
VALUES (<value1>, <value2>, <value3>, ...);
```

Contoh penggunaanya adalah sebagai berikut, contohnya saya menambahkan data baru ke table `regions` dengan data seperti berikut:

| region_id |      region_name       |
|-----------+------------------------|
|         5 | Asia Tenggara          |

Maka berikut querynya:

{% gist page.gist "dml-insert.sql" %}

berikut hasilnya:

```postgresql-console
bootcamp=# INSERT INTO regions (region_name) VALUES ('Asia Tenggara');
INSERT 0 1

bootcamp=# select * from regions;
 region_id |      region_name       
-----------+------------------------
         1 | Europe
         2 | Americas
         3 | Asia
         4 | Middle East and Africa
         5 | Asia Tenggara
(5 rows)

bootcamp=# 
```