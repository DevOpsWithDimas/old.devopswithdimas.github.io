---
layout: post
title: "DDL - Primary Key Constraint"
date: 2021-02-25T16:15:23+07:00
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/19/cncpt/data-integrity.html#GUID-E1033BB9-0F67-4E59-82AC-B8B572FD82BB
youtube: 
comments: true
image_path: /resources/posts/oracle12c/016k-constraint-primary-key
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Constraint **Primary Key** diterapkan pada sebuah kolom dalam table, dengan tujuan menjadikan data dalam satu baris tersebuh menjadi pegangan atau acuan karena sebuah primary key adalah gabungan dari constraint `not null` dan `unique`. Contoh penggunaanya seperti berikut:

{% gist page.gist "016k-constraint-primarykey.sql" %}

Nah dari data di atas, akan lebih mudah jika kita menggunakan kolom `product_no` untuk mendapatkan informasi contohnya untuk menghapus data dengan nama `Apple Macbook Pro 13"` jadi querynya seperti berikut:

```sql
delete from products where product_no = 1;
```

## Composite primary key

Selain itu kita bisa menggunakan multiple column atau orang2 biasanya sebut composite primary key, berikut contohnya:

{% gist page.gist "016k-constraint-composite-primarykeys.sql" %}