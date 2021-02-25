---
layout: post
title: "DDL - Foreign Key Constraint"
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/19/cncpt/data-integrity.html#GUID-7CD73D16-EA1A-4AA8-AA7D-4288557395B8
youtube: 
comments: true
image_path: /resources/posts/oracle12c/016l-constraint-foreign-key
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Constraint **Foreign keys** dapat diterapkan pada sebuah kolom dengan table, dengan tujuan memvalidasi apakan nilai yang di entry terdaftar pada column di table acuannya. Contoh penggunaanya seperti berikut:

```sql
CREATE TABLE sellers (
    seller_id integer primary key,
    seller_name character varying(60) not null,
    seller_address character varying(255) 
)

CREATE TABLE products (
    product_id integer primary key,
    product_name text NOT NULL,
    product_price_sell numeric not null check(price >= 1)
    seller_id integer not null
);

ALTER TABLE products
ADD CONSTRAINT fk_seller_product FOREIGN KEY (seller_id)
REFERENCES sellers(seller_id) ON UPDATE CASCADE ON DELETE CASCADE;
```

Nah jadi dari 2 table tersebut saling berrelasi dengan menggunakan foreign key `salles_id` pada table `products`. Misalnya saya punya data sebagai berikut:

| Sales ID  | Sales Name            | Sales Address |
|-----------|-----------------------|---------------|
| 1         | Dimas Maryanto        | Bandung       |
| 2         | Muhamad Yusuf         | Jakarta       |

Jadi dengan data tersebut kita hanya dapat menyimpan data ke table `products` dengan mengeset nilai `salles_id` yang tersedia di table `sellers`, jika kita menginput data diluar dari data yang tersedia maka akan terkena validasi constraint foreign key. Contohnya entry data yang salah seperti berikut:

```sql
-- error kena validasi
insert into products (product_no, name, price, salles_id)
values (1, 'Apple Ipad Pro 11" 2018', 15000000, 3);
```
