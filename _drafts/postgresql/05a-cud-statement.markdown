---
layout: post
title: "Basic Create, Update, Delete statement"
lang: postgresql
authors:
- dimasm93
categories:
- RDBMS
- PostgreSQL
refs: 
- https://www.postgresql.org/docs/current/
youtube: 
image_path: /resources/posts/postgresql/05a-cud-statement
comments: true
gist: dimMaryanto93/7ae7632f9418feb724bc431eff412a3f
catalog_key: dml-statement
downloads: []
---

Hai semuanya di materi kali ini kita akan membahas basic dari Create, Update dan Delete statement di PostgreSQL. Adapun pembahasanya diantaranya:

1. Insert statement
2. Update statement
3. Delete statement
4. Returning data from modified rows
5. Error messeges in Data manipulation

Ok tanpa bercerita panjang lebar, lansung aja kita bahas materi yang pertama:

<!--more-->

## Insert statement

When a table is created, it contains no data. The first thing to do before a database can be of much use is to insert data. Data is inserted one row at a time. You can also insert more than one row in a single command, but it is not possible to insert something that is not a complete row.

Format penulisan insert statement yaitu sebagai berikut:

{% highlight sql %}
INSERT INTO <table-name> (<column1>[, ...])
VALUES (<value1> [, ...]);
{% endhighlight %}

Contoh penggunaanya adalah sebagai berikut, contohnya saya menambahkan data baru ke table `regions` dengan data seperti berikut:

| region_id |      region_name       |
|-----------+------------------------|
|         5 | Asia Tenggara          |

Maka berikut querynya:

{% gist page.gist "05a-simple-insert.sql" %}

berikut hasilnya:

```sql
hr=# INSERT INTO regions (region_id, region_name) 
hr=/ VALUES (5, 'Asia Tenggara');
INSERT 0 1

hr=# select * from regions;
 region_id |      region_name       
-----------+------------------------
         1 | Europe
         2 | Americas
         3 | Asia
         4 | Middle East and Africa
         5 | Asia Tenggara
(5 rows)
```

## Update statement

