---
layout: post
title: "DDL - Primary Key Constraint"
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/database/121/index.htm
youtube: 
comments: true
image_path: /resources/posts/oracle12c/016k-constraint-primary-key
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Constraint **Primary Key** diterapkan pada sebuah kolom dalam table, dengan tujuan menjadikan data dalam satu baris tersebuh menjadi pegangan atau acuan karena sebuah primary key adalah gabungan dari constraint `not null` dan `unique`. Contoh penggunaanya seperti berikut:

```sql
CREATE TABLE products (
    product_no integer primary key,
    name text NOT NULL,
    price numeric
);
```

Setelah itu misalnya kita punya data seperti berikut:

| product_no    | name                  | price         |
|---------------|-----------------------|---------------|
| 1             | Apple Macbook Pro 13" | 28_000_000    |
| 2             | Apple Ipad Pro 11"    | 15_000_000    |
| 3             | iPhone 7 Plus 36gb    | 8_999_000     |
| 4             | Apple Airpod 2        | 2_150_000     |
| 5             | Apple Pencil 2        | 2_500_000     |


Nah dari data di atas, akan lebih mudah jika kita menggunakan kolom `product_no` untuk mendapatkan informasi contohnya untuk menghapus data dengan nama `Apple Macbook Pro 13"` jadi querynya seperti berikut:

```sql
delete from products where product_no = 1;
```
