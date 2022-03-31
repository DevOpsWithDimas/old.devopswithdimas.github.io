---
layout: post
title: "Sub Query single row result dengan where clause"
date: 2021-02-18T07:30:34+07:00
lang: oracle18c
authors:
- dimasm93
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/database/121/index.htm
- https://docs.oracle.com/en/bigdata/index.html
youtube: SIOv8wq-icc
comments: true
catalog_key: sql-subquery
image_path: /resources/posts/oracle12c/
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Sub Query dengan single row result di `where` clause, pada dasarnya kita bisa menggunakan operator seperti

1. Relational Comparison predicate
2. Like Predicates
3. Between Predicates
4. Not Predicates

<!--more-->

Berikut, adalah contoh penggunaan sub query dengan relational comparison predicate.

{% gist page.gist "011a-select-sub-query-where.sql" %}

Berikut hasilnya:

{% highlight sql %}
       NIK NAMA                 GAJI_SEBULAN
---------- -------------------- ------------
       100 Steven                      24000
       101 Neena                       17000
       102 Lex                         17000
       145 John                        14000
       146 Karen                       13500

5 rows selected.
{% endhighlight %}
