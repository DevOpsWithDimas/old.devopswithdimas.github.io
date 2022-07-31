---
layout: post
title: "WITH Queries (Common Table Expressions)"
lang: postgresql
authors:
- dimasm93
categories:
- RDBMS
- PostgreSQL
- sql
- select
refs: 
- https://www.postgresql.org/docs/14/queries-with.html
youtube: 
image_path: /resources/posts/postgresql/03l-with-queries
comments: true
gist: dimMaryanto93/7ae7632f9418feb724bc431eff412a3f
catalog_key: select-statement
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang Common Table Expression yaitu menggunakan `WITH` Queries pada PostgreSQL. 

The `WITH` query provides a way to write auxiliary statements for use in a larger query. It helps in breaking down complicated and large queries into simpler forms, which are easily readable. These statements often referred to as Common Table Expressions or CTEs, can be thought of as defining temporary tables that exist just for one query.

Each auxiliary statement in a `WITH` clause can be a `SELECT`, `INSERT`, `UPDATE`, or `DELETE`; and the `WITH` clause itself is attached to a primary statement that can also be a `SELECT`, `INSERT`, `UPDATE`, or `DELETE`. Untuk pembahasan kali ini karena akan lumayan panjang jadi kita akan bagi-bagi menjadi beberapa bagian diataranya:

1. Select in WITH
2. More Advanced Select in WITH
3. Recursive Queries
4. Search order
5. Cycle Detection
6. Common Table Expression Materialization

Ok langsung aja kita bahas materi yang pertama

<!--more-->

## Select in WITH

The basic value of `SELECT` in WITH is to break down complicated queries into simpler parts. An example is:

{% highlight sql %}
WITH query_name as ( query1 ), ...
SELECT ...
FROM ...
{% endhighlight %}