---
layout: post
title: "Combining Queries (UNION, INTERSECT, EXCEPT)"
lang: postgresql
authors:
- dimasm93
categories:
- RDBMS
- PostgreSQL
- sql
- select
refs: 
- https://www.postgresql.org/docs/14/queries-union.html
youtube: 
image_path: /resources/posts/postgresql/03k-combining-queries
comments: true
gist: dimMaryanto93/7ae7632f9418feb724bc431eff412a3f
catalog_key: select-statement
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang Menggabungkan beberapa query menjadi suatu resutlset atau klo bahas kerennya Combining Queries. Pada combining queries ini ada beberapa macam teknik atau metode diataranya

1. UNION
2. INTERSECT
3. EXCEPT

Dari setiap method tersebut memiliki fungsinya masing-masing, Untuk lebih jelasnya yukk langsung aja kita bahas satu-per-satu

<!--more-->

## Using UNION queries

`UNION` effectively appends the result of **query2** to the result of **query1** (although there is no guarantee that this is the order in which the rows are actually returned). Furthermore, it eliminates duplicate rows from its result, in the same way as `DISTINCT`, unless `UNION ALL` is used.

The syntax:

{% highlight sql %}
select ... from ... 
UNION [ distinct | ALL ]
select ... from ...
{% endhighlight %}

Berikut adalah contohnya

{% gist page.gist "04e-select-union-distinct.sql" %}

Jika dijalankan maka hasilnya seperti berikut:

```sql
hr=# select *
hr-# from (values (1, 'dimasm93', 'Dimas Maryanto', true),
hr(#              (2, 'myusuf', 'Muhamad Yusuf', true),
hr(#              (3, 'mpurwadi', 'Muhamad Purwadi', false)
hr(#      ) as data1
hr-# union distinct
hr-# select *
hr-# from (values (1, 'dimasm93', 'Dimas Maryanto', true),
hr(#              (4, 'abdul', 'Abdul Rahman', false)
hr(#      ) as data2;
 column1 | column2  |     column3     | column4 
---------+----------+-----------------+---------
       4 | abdul    | Abdul Rahman    | f
       3 | mpurwadi | Muhamad Purwadi | f
       2 | myusuf   | Muhamad Yusuf   | t
       1 | dimasm93 | Dimas Maryanto  | t
(4 rows)
```

Nah jadi klo temen-temen perhatikan dari hasil diatas, hasilnya akan dibersihkan dari nilai yang redudansi (duplicate). Klausa `UNION` by default menggunakan `DISTINCT`, jadi akan memfilter nilai yang duplicate. Jika mau menampilkan semuanya kita bisa klausa `UNION ALL` seperti berikut:

{% gist page.gist "04e-select-union-all.sql" %}

Jika dijalankan hasilnya seperti berikut:

```sql
hr=# select *
hr-# from (values (1, 'dimasm93', 'Dimas Maryanto', true),
hr(#              (2, 'myusuf', 'Muhamad Yusuf', true),
hr(#              (3, 'mpurwadi', 'Muhamad Purwadi', false)
hr(#      ) as data1
hr-# union all
hr-# select *
hr-# from (values (1, 'dimasm93', 'Dimas Maryanto', true),
hr(#              (4, 'abdul', 'Abdul Rahman', false)
hr(#      ) as data2;
 column1 | column2  |     column3     | column4 
---------+----------+-----------------+---------
       1 | dimasm93 | Dimas Maryanto  | t
       2 | myusuf   | Muhamad Yusuf   | t
       3 | mpurwadi | Muhamad Purwadi | f
       1 | dimasm93 | Dimas Maryanto  | t
       4 | abdul    | Abdul Rahman    | f
(5 rows)
```

## Using `INTERSECT` queries

`INTERSECT` returns all rows that are both in the result of **query1** and in the result of **query2**. Duplicate rows are eliminated unless `INTERSECT ALL` is used.

The syntax:

{% highlight sql %}
select ... from ... 
INTERSECT [ ALL ]
select ... from ...
{% endhighlight %}

Berikut adalah contohnya

{% gist page.gist "04e-select-intersect.sql" %}

Jika dijalankan hasilnya seperti berikut:

```sql
hr=# select *
hr-# from (values (1, 'dimasm93', 'Dimas Maryanto', true),
hr(#              (2, 'myusuf', 'Muhamad Yusuf', true),
hr(#              (3, 'mpurwadi', 'Muhamad Purwadi', false)
hr(#      ) as data1
hr-# INTERSECT DISTINCT
hr-# select *
hr-# from (values (1, 'dimasm93', 'Dimas Maryanto', true),
hr(#              (4, 'abdul', 'Abdul Rahman', false),
hr(#              (3, 'mpurwadi', 'Muhamad Purwadi', false)
hr(#      ) as data2;
 column1 | column2  |     column3     | column4 
---------+----------+-----------------+---------
       3 | mpurwadi | Muhamad Purwadi | f
       1 | dimasm93 | Dimas Maryanto  | t
(2 rows)
```

Jika temen-temen perhatikan, `INTERSECT` hanya mengambil data yang sama saja pada kedua query tersebut, Sekarang kita coba menggunakan `INTERSECT ALL` dengan query seperti berikut:

{% gist page.gist "04e-select-intersect-all.sql" %}

Jika dijalankan hasilnya seperti berikut:

```sql
hr=# select *
hr-# from (values (1, 'dimasm93', 'Dimas Maryanto', true),
hr(#              (2, 'myusuf', 'Muhamad Yusuf', true),
hr(#              (2, 'myusuf', 'Muhamad Yusuf', true),
hr(#              (3, 'mpurwadi', 'Muhamad Purwadi', false)
hr(#      ) as data1
hr-# INTERSECT ALL
hr-# select *
hr-# from (values (1, 'dimasm93', 'Dimas Maryanto', true),
hr(#              (4, 'abdul', 'Abdul Rahman', false),
hr(#              (2, 'myusuf', 'Muhamad Yusuf', true),
hr(#              (2, 'myusuf', 'Muhamad Yusuf', true),
hr(#              (3, 'mpurwadi', 'Muhamad Purwadi', false)
hr(#      ) as data2;
 column1 | column2  |     column3     | column4 
---------+----------+-----------------+---------
       3 | mpurwadi | Muhamad Purwadi | f
       2 | myusuf   | Muhamad Yusuf   | t
       2 | myusuf   | Muhamad Yusuf   | t
       1 | dimasm93 | Dimas Maryanto  | t
(4 rows)
```