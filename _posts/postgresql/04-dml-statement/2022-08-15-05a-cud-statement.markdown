---
layout: post
title: "Basic Create, Update, Delete statement"
date: 2022-08-15T22:06:18+07:00
lang: postgresql
authors:
- dimasm93
categories:
- RDBMS
- PostgreSQL
refs: 
- https://www.postgresql.org/docs/14/dml.html
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

## Delete statement

So far we have explained how to add data to tables and how to change data. What remains is to discuss how to remove data that is no longer needed. Just as adding data is only possible in whole rows, you can only remove entire rows from a table.

Therefore, removing rows can only be done by specifying conditions that the rows to be removed have to match. If you have a primary key in the table then you can specify the exact row. But you can also remove groups of rows matching a condition, or you can remove all rows in the table at once.

You use the `DELETE` command to remove rows; the syntax is very similar to the `UPDATE` command. Format penulisan `delete` statement yaitu seperti berikut:

{% highlight sql %}
DELETE FROM <table_name> 
WHERE <column_condition> = <value_condition>
{% endhighlight %}

Contoh penggunaanya adalah sebagai berikut, contohnya saya mau menghapus data yang telah saya insert tadi, yaitu dengan `region_id = 5`, maka berikut querynya:

{% gist page.gist "05a-simple-delete.sql" %}

berikut hasilnya:

```sql
hr=# delete from regions
hr-# where region_id = 5;
DELETE 1

hr=# select * from regions;
 region_id |      region_name       
-----------+------------------------
         2 | Americas
         3 | Asia
         4 | Middle East and Africa
         1 | Europe
(4 rows)
```

## Returning data from modified rows

Sometimes it is useful to obtain data from modified rows while they are being manipulated. The `INSERT`, `UPDATE`, and `DELETE` commands all have an optional `RETURNING` clause that supports this. Use of `RETURNING` avoids performing an extra database query to collect the data, and is especially valuable when it would otherwise be difficult to identify the modified rows reliably.

In an `INSERT`, the data available to `RETURNING` is the row as it was inserted. This is not so useful in trivial inserts, since it would just repeat the data provided by the client. But it can be very handy when relying on computed default values. For example, when using a serial column to provide unique identifiers, `RETURNING` can return the ID assigned to a new row:

{% highlight sql %}
INSERT INTO <table-name> (<column1>[, ...])
VALUES (<value1> [, ...]) 
RETURNING <column_primary_key>
{% endhighlight %}

Sebagai contoh karena pada table `regions` memiliki default value untuk column `region_id` kita bisa ambil nilai default tersebut ketika di insert data kemudian return value yang di generate dari default value tersebut. berikut adalah perintahnya:

{% gist page.gist "05a-simple-insert-returning.sql" %}

Jika dijalankan hasilnya seperti berikut:

```sql
hr=# INSERT INTO regions (region_name)
hr-# VALUES ('Asia Tenggara')
hr-# RETURNING region_id;

 region_id 
-----------
         6
(1 row)

INSERT 0 1

hr=# select * from regions;

 region_id |      region_name       
-----------+------------------------
         1 | Europe
         2 | Americas
         3 | Asia
         4 | Middle East and Africa
         6 | Asia Tenggara
(5 rows)
```