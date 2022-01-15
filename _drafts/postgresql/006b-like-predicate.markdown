---
layout: post
title: "Like Predicate pada klausa where di PostgreSQL"
date: 2018-11-09T20:40:06+07:00
lang: psql
categories:
- RDBMS
- PostgreSQL
refs: []
youtube: 7MLBNM576gA
comments: true
gist: dimMaryanto93/62ffa0d81f3835a4e9401baf14590cd2
downloads: []
---


Operator like biasanya digunakan untuk tipe data `varchar` atau string, ada 2 expresion yang kita bisa gunakan di operator ini yaitu 

1. `_` atau underscore, digunakan untuk mewakili expresion satu karakter.
2. `%` atau persent, digunakan untuk mewakili expresion beberapa karakter.

Contoh kasus untuk expresion `%`, saya ingin mencari nama depan karyawan yang diawali oleh huruf `A`. Berikut querynya:

{% gist page.gist "select-where-like-percent-el.sql" %}

Berikut hasilnya:

```postgresql-console
 employee_id | first_name | last_name |  email   |    phone_number    |  job_id  |  salary  
-------------+------------+-----------+----------+--------------------+----------+----------
         105 | David      | Austin    | DAUSTIN  | 590.423.4569       | IT_PROG  |  4800.00
         130 | Mozhe      | Atkinson  | MATKINSO | 650.124.6234       | ST_CLERK |  2800.00
         166 | Sundar     | Ande      | SANDE    | 011.44.1346.629268 | SA_REP   |  6400.00
         174 | Ellen      | Abel      | EABEL    | 011.44.1644.429267 | SA_REP   | 11000.00
(4 rows)

hr=# 
```

Contoh kasus untuk expresion `_`, saya ingin mencari huruf ke 2 dari kolom `job_id` di tabel `jobs` mengadung `T`. Berikut querynya:

{% gist page.gist "select-where-like-underscore-el.sql" %}

Berikut hasilnya:

```postgresql-console
  job_id  |   job_title   | min_salary | max_salary 
----------+---------------+------------+------------
 ST_MAN   | Stock Manager |       5500 |       8500
 ST_CLERK | Stock Clerk   |       2000 |       5000
 IT_PROG  | Programmer    |       4000 |      10000
(3 rows)
```
