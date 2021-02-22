---
layout: post
title: "DDL - Unqiue Constraint"
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/database/121/index.htm
youtube: 
comments: true
image_path: /resources/posts/oracle12c/016i-constraint-unique
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Constraint **Unique** diterapkan pada column tertentu dalam sebuah tabel, dengan tujuan untuk memvalidasi data yang kita entry tidak boleh sama dengan data yang telah tersedia di table pada kolom tersebut. Contoh pengguanya seperti berikut:

```sql
CREATE TABLE products (
    product_no integer unique,
    name text NOT NULL,
    price numeric
);
```

Jadi dengan ddl untuk membuat table `products` seperti diatas, maka kita tidak boleh entry data pada kolom `product_no` dengan nilai yang sama atau sudah ada di table tersebut. Contoh dengan perintah entry yang salah seperti berikut:

```sql
insert into products (product_no, name, price)
values (1, 'Apple Macbook Pro 13" 2017', 28000000);

-- query ini error karena pada kolom product_no
insert into products (product_no, name, price)
values (1, 'Apple Ipad Pro 11" 2018', 15000000);
```

Bila di execute maka akan terjadi error: `error insert because constraint violence unique`.

Selain itu juga Constraint unique dapat di terapkan di beberapa kolom sekaligus, contohnya seperti berikut:

```sql
CREATE TABLE articles (
    file_name character varying(60),
    release_date date,
    author character varying(20)
);

ALTER TABLE articles
ADD CONSTRAINT uq_article_release UNIQUE (file_name, release_date);
```

Jadi berikut adalah contoh query yang error:

```sql
insert into articles (file_name, release_date, author)
values ('java-core-1', '2019-12-02', 'Dimas Maryanto');

insert into articles (file_name, release_date, author)
values ('java-core-1', null, 'Dimas Maryanto');

insert into articles (file_name, release_date, author)
values (null, '2019-12-02', 'Dimas Maryanto');

-- query ini error karena file_name dan release data sama seperti data sebelumnya
insert into articles (file_name, release_date, author)
values ('java-core-1', '2019-12-02', 'Dimas Maryanto');
```