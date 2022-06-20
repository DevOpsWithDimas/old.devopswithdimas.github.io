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