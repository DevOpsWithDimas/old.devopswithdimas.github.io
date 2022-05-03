---
layout: post
title: "Queries inside a query (subquery)"
lang: postgresql
authors:
- dimasm93
categories:
- RDBMS
- PostgreSQL
- sql
- select
refs: 
- https://www.postgresql.org/docs/14/queries-table-expressions.html#subqueries
youtube: 
image_path: /resources/posts/postgresql/03i-subquery
comments: true
gist: dimMaryanto93/7ae7632f9418feb724bc431eff412a3f
catalog_key: select-statement
downloads: []
---

Hai semuanya, setelah kita membahas tentang Joined tables tahap selanjutnya kita akan membahas tentang Queries inside a query atau lebih di kenal dengan SubQuery. Seperti biasa karena pembahasannya akan lumayan panjang jadi kita akan bagi-bagi menjadi beberapa bagian ya diantaranya:

1. What is SubQuery?
2. Using SubQuery inline view
3. Hander SubQuery from where clause
4. Correlate SubQuery
5. Pairwise SubQuery
    1. Using `IN` predicate to handle multiple values
    2. Using `ANY` & `SOME` predicate to handle multiple values
    3. Using `ALL` predicate to handler multiple values
    4. Using `EXIST` operator
6. Lateral Subqueries

<!--more-->

Materi: 

1. Topic1
2. Topic2
    1. Topic 2.a
    2. Topic 2.b
3. Topic 3
4. Topic 4