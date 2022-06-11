---
layout: post
title: "Conditional Expressions"
lang: postgresql
authors:
- dimasm93
categories:
- RDBMS
- PostgreSQL
- sql
- select
refs: 
- https://www.postgresql.org/docs/14/functions-conditional.html
youtube: 
image_path: /resources/posts/postgresql/03j-conditional-expression
comments: true
gist: dimMaryanto93/7ae7632f9418feb724bc431eff412a3f
catalog_key: select-statement
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang Conditional Expression atau salah satu structure control yaitu percabangan pada SQL khususnya menggunakan PostgreSQL. Seperti biasa karena materinya akan lumayan panjang jadi kita bagi jadi beberapa bagian diantaranya:

1. What is Conditional Expression?
2. Using `CASE-WHEN-ELSE` expression
3. Using `COALESCE` expression
4. Using `NULLIF` expression
5. Using `GREATEST` and `LEAST` expression

Ok langsung aja kita bahas materi yang pertama

<!--more-->

## What is Conditional Expression?

Conditional statements/Expression in the SQL help you to define different logics and actions for different conditions. It allows you to perform different actions based on conditions defined within the statement. In real life, you perform many actions dependent on the outcome of some other activity or situation.

Some real-time examples of SQL case statement are:

1. If it rains tomorrow, I will plan on a road trip.
2. If flight tickets are less than $400 from my city, then I will go on vacation in Europe, else I will prefer some nearby tourist spot.

Di PostgreSQL, kita bisa menggunakan Conditional Statement/Expression dengan beberapa cara

1. Case-When-Else
2. Coalesce
3. NullIF
4. Greatest or Least

Untuk lebih detail, yukk kita bahas satu-per-satu

## Using `CASE-WHEN-ELSE` expression