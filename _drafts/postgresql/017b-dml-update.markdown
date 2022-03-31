---
layout: post
title: "DML - Update Statement di PostgreSQL"
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

Perintah update data, biasanya kita melakukan modifikasi data terhadap beberapa column dalam sebuah tabel di Database dengan / tanpa menggunakan where klausa.

Format penulisan update statement yaitu sebagai berikut:

<!--more-->

```sql
UPDATE table_name SET 
    column_update1 = <value1>, 
    column_update2 = <value2>
WHERE column_key = <valueKey>
```

Contoh penggunaanya adalah sebagai berikut, contohnya saya mau update data pada table `regions` kolom `region_name` yang valuenya `Asia Tenggara` menjadi `Oceania`, maka berikut querynya:

{% gist page.gist "dml-update.sql" %}

berikut hasilnya:

```postgresql-console
bootcamp=# UPDATE regions 
bootcamp-# SET region_name = 'Oceania'
bootcamp-# WHERE region_id = 5;
UPDATE 1

bootcamp=# select * from regions;
 region_id |      region_name       
-----------+------------------------
         2 | Americas
         3 | Asia
         4 | Middle East and Africa
         1 | Europe
         5 | Oceania
(5 rows)

bootcamp=# 
```

**Note** jika kita tidak menggunakan where klausa, maka semua data akan terupdate!!

