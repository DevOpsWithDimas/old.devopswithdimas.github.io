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

The modification of data that is already in the database is referred to as updating. You can update individual rows, all the rows in a table, or a subset of all rows. Each column can be updated separately; the other columns are not affected.

To update existing rows, use the `UPDATE` command. This requires three pieces of information:

1. The name of the table and column to update
2. The new value of the column
3. Which row(s) to update

Format penulisan update statement yaitu sebagai berikut:

{% highlight bash %}
UPDATE <table-name> 
SET <column-name1> = <value1>[, ...]
WHERE <column-condition> = <value-condition>
{% endhighlight %}

Contoh penggunaanya adalah sebagai berikut, contohnya saya mau update data pada table `regions` kolom `region_name` yang valuenya `Asia Tenggara` menjadi `Oceania`, maka berikut querynya:

{% gist page.gist "05a-simple-update.sql" %}

berikut hasilnya:

```sql
hr=# UPDATE regions 
hr-# SET region_name = 'Oceania'
hr-# WHERE region_id = 5;
UPDATE 1

hr=# select * from regions;
 region_id |      region_name       
-----------+------------------------
         2 | Americas
         3 | Asia
         4 | Middle East and Africa
         1 | Europe
         5 | Oceania
(5 rows)
```