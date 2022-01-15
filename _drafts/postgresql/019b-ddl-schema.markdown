---
layout: post
title: "DDL - Management schema di PostgreSQL"
date: 2019-12-31T14:16:53+07:00
lang: psql
categories:
- RDBMS
- PostgreSQL
refs: 
- https://www.postgresql.org/docs/12/ddl-schemas.html
youtube: NMZrpBxkfRA
comments: true
image_path: /resources/posts/psql/psql-schema
gist: dimMaryanto93/62ffa0d81f3835a4e9401baf14590cd2
downloads: []
---

Schema pada Database PostgreSQL terdiri dari beberapa object yang diurutkan berdasarkan level seperti berikut:

1. Database
2. Schema
3. Tables, Sequences, Funcations dan lain-lain.

Jika saya gambarkan maka seperti berikut ilustrasinya:

![database schema]({{ page.image_path | prepend: site.baseurl }}/postgresql-schema.png)

Jadi di postgresql itu, ketika kita membuat **Database** dan secara otomatis kita akan memiliki schema `public`, penggunaan schema biasanya untuk memisahkan object berdasarkan tujuan tertentu misalnya kita punya schema users yang isinya tentang user management, kemudian misalnya kita punya schema product disuatu bank misalnya isinya table tabungan, kredit, deposito dan lain-lain. 

Selain itu juga fungsinya schema pada database ibaratnya sebagai folder di sistem operasi yang isinya sangat terorganisasi yang berdapak pencarian object akan memudahkan kita sebagai developer untuk mencari object yang kita cari.


## DDL untuk Database

Perintah DDL untuk management Database pada dasarnya hanya terbagi menjadi 2 yaitu

1. CREATE
2. DROP

### Create Database

Perintah **CREATE** pada database, digunakan untuk membuat database baru dengan perintah seperti berikut:

```sql
CREATE DATABASE your_database_name WITH OWNER your_user;
```

### Drop Database

Perintah **DROP** pada database, digunakan untuk menghapus database yang ada dengan perintah seperti berikut:

```sql
DROP DATABASE your_database_name;
```

## DDL untuk Schema

Perintah ddl untuk management Schema dalam database pada dasarnya hanya terbagi menjadi 2 yaitu

1. CREATE
2. DROP

### Create Schema

Perintah **CREATE** pada schema, digunakan untuk membuat schema baru dalam database dengan perintah seperti berikut:

```sql
CREATE SCEHAMA your_schema;
```

### Drop Schema

Perintah DROP pada schema, digunakan untuk menghapus schema dalam database dengan perintah seperti berikut:

```sql
DROP SCHEME IF EXISTS your_schema;
```