---
layout: post
title: "DML - Delete Statement di PostgreSQL"
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


Perintah delete data, biasanya kita gunakan untuk menghapus data dari table tertentu dengan / tanpa menggukanan where klausa.

Format penulisan delete statement yaitu seperti berikut:

<!--more-->

```sql
DELETE FROM table_name 
WHERE column_key = <valueKey>
```

Contoh penggunaanya adalah sebagai berikut, contohnya saya mau menghapus data yang telah saya insert tadi, yaitu dengan `region_id = 5`, maka berikut querynya:

{% gist page.gist "dml-delete.sql" %}

berikut hasilnya:

```postgresql-console
bootcamp=# delete from regions
where region_id = 5;
DELETE 1

bootcamp=# select * from regions;
 region_id |      region_name       
-----------+------------------------
         2 | Americas
         3 | Asia
         4 | Middle East and Africa
         1 | Europe
(4 rows)
```

**Note** jika kita tidak menggunakan where klausa, maka semua data akan terhapus!!