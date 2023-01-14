---
layout: post
title: "Getting started with Transaction Control (TCL)"
lang: postgresql
authors:
- dimasm93
categories:
- RDBMS
- PostgreSQL
- SQL
- TCL
refs: 
- https://www.postgresql.org/docs/current/
youtube: 
image_path: /resources/posts/postgresql/06a-basic-tcl
comments: true
gist: dimMaryanto93/7ae7632f9418feb724bc431eff412a3f
catalog_key: dml-statement
downloads: []
---

Hai semuanya, sekarang kita akan membahas tentang Transaction Language Control atau singkatanya TCL, dimana transaction control ini adalah salah satu feature di Relational Database Management System (RDBMS) yang secara umum digunakan untuk mengelompokan sekumpulan query yang akan dikirimkan ke database server secara atomic, consistent, isolated dan durable. 

Untuk lebih jelasnya, yuk kita bahas secara lebih detail. Adapun materi yang akan kita bahas kali ini adalah

1. Default Transaction Control behavior
2. Using Commit clause
3. Using Rollback clause
4. Using Savepoint clause
5. When you update data using diffrent sessions
6. Transaction isolation

Ok tanpa berlama-lama yuk langsung aja kita bahas materi yang pertama:

<!--more-->

## Default Transaction Control behavior

A PostgreSQL transaction is **atomic**, **consistent**, **isolated**, and **durable**. These properties are often referred to as ACID:

1. Atomicity guarantees that the transaction completes in an all-or-nothing manner.
2. Consistency ensures the change to data written to the database must be valid and follow predefined rules.
3. Isolation determines how transaction integrity is visible to other transactions.
4. Durability makes sure that transactions that have been committed will be stored in the database permanently.

By default PostgreSQL using auto-commit every single query executed by database atau setiap 1 query yang kita jalankan di database server PostgreSQL maka akan automatis di commit.