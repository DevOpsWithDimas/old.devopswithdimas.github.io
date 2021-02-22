---
layout: post
title: "DDL - Not Null Constraint"
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/database/121/index.htm
youtube: 
comments: true
image_path: /resources/posts/oracle12c/016h-constraint-not-null
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Constraint **Not Null** diterapkan pada column tertentu dalam sebuah table, dengan tujuan untuk memvalidasi data yang kita entry tidak dapat bernilai null. Contoh penggunaanya seperti berikut:

```sql
CREATE TABLE products (
    product_no integer NOT NULL,
    name text NOT NULL,
    price numeric
);
```

Jadi dengan ddl untuk membuat table `products` seperti diatas, maka kita **harus mengisi nilai** pada kolom `product_no` dan `name`, tidak boleh `null`. Contohnya dengan perintah entry yang salah seperti berikut:

```sql
insert into products (product_no, name, price)
values (null, null, 0);
```

Bila di execute maka akan terjadi error: `error insert because constraint violence not null`
