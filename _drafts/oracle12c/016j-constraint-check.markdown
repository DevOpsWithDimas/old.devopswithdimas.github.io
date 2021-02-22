---
layout: post
title: "DDL - Check Constraint"
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/database/121/index.htm
youtube: 
comments: true
image_path: /resources/posts/oracle12c/016j-constraint-check
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Constraint **Check** dapat diterapkan pada kolom tertentu dalam sebuah table, dengan tujuan memvalidasi data yang kita entry harus sesuai dengan criteria yang diterapkan pada constraint tersebut contohnya pada kolom `price` nilai minimal lebih besar dari `0`. Contoh penggunaanya seperti berikut:

```sql
CREATE TABLE products (
    product_no integer unique,
    name text NOT NULL,
    price numeric
);

ALTER TABLE products
ADD CONSTRAINT check_price_must_be_greater_then_1 
CHECK (price >= 1);
```

Jadi dengan ddl untuk membuat table `products` seperti diatas, maka kita tidak boleh entry data pada kolom `price` dengan nilai lebih kecil dari `0` atau harus lebih besar dari `1`. Contoh dengan perintah entry yang salah seperti berikut:

```sql
insert into products (product_no, name, price)
values (1, 'Apple Ipad Pro 11" 2018', -15000000);
```

Bila di execute maka akan terjadi error: `error insert because check constraint`.