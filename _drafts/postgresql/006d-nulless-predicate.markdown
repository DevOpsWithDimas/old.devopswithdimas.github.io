---
layout: post
title: "Nulless Predicate pada klausa where di PostgreSQL"
date: 2018-11-09T20:40:09+07:00
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

Operator `IS NULL` digunakan untuk memfiter data yang bernilai null. Contoh kasusnya, saya mau menampilkan data karywan yang tidak memiliki manager. Berikut querynya:

{% gist page.gist "select-where-is-null.sql" %}

Berikut hasilnya:

```postgresql-console
 employee_id | first_name | last_name | email | phone_number | job_id  |  salary  | department_id 
-------------+------------+-----------+-------+--------------+---------+----------+---------------
         100 | Steven     | King      | SKING | 515.123.4567 | AD_PRES | 24000.00 |            90
(1 row)
```