---
layout: post
title: "Filtering data with WHERE clause"
lang: postgresql
categories:
- RDBMS
- PostgreSQL
- sql
- select
refs: 
- https://www.postgresql.org/docs/current/
youtube: 
image_path: /resources/posts/postgresql/04-where-clause
comments: true
gist: dimMaryanto93/7ae7632f9418feb724bc431eff412a3f
catalog_key: sql-statement
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang mem-Filter data dengan menggunakan `WHERE` clause di PostgreSQL. By default jika kita menggunakan perintah `select` itu akan menampilkan semua data pada suatu atau berberapa table. Dengan menggunakan clause WHERE kita bisa memfilter atau memilih data yang akan kita tampilkan. 

Perintah dasar untuk `WHERE` clause seperti berikut:

{% highlight sql %}
select * | column_list ...
from a_table
where search_condition
{% endhighlight %}

Dimana `search_condition` adalah any value expression (`functions`, `operators` and `predicates` ) yang mengembalikan nilai boolean. Sebagai gambaran berikut ilustrasinya:

![filter-data]({{ page.image_path | prepend: site.baseurl }}/01-consept-where-cluase.png)

Ilustrasi tersebut menggambarkan, suatu predicate atau `search_condition` yaitu menggunakan operator equal pada column `status` dengan nilai `active` maka database akan mencari nilainya `active` saja pada kolom `status`. Untuk `search_condition` tersebut biasanya di sebut dengan predicate. Ada banyak sekali predicate yang kita bisa gunakan tapi disini kita bahasnya paling dasar dulu ya yaitu:

1. Relational predicate
2. Like predicates
3. Between predicates
4. Nulles predicate
5. Logical predicate

Ok jadi langsung kita bahas satu-per-satu ya mulai dari

## Relational predicate

