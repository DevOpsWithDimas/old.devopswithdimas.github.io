---
layout: post
title: "DDL - Management Tabel di PostgreSQL"
date: 2019-12-31T16:07:16+07:00
lang: psql
categories:
- RDBMS
- PostgreSQL
refs: 
- https://www.postgresql.org/docs/8.4/ddl-basics.html
youtube: 15aBbkvbHZ8
comments: true
gist: dimMaryanto93/62ffa0d81f3835a4e9401baf14590cd2
downloads: []
---

Data Definition Lanagement pada Table, pada dasarnya terbagi menjadi seperti berikut:

1. CREATE
2. DROP
3. ALTER

<!--more-->

Tapi sebelum kita membahas tentang membuat table, saya juga mau bahas dulu tipe data di PostgreSQL. Tipe data pada kolom terdiri dari 4 kategori yaitu

|                   | Data Type                         | Descriptions  |
|-------------------|-----------------------------------|---------------|
| 1.Char            | - `char`                          |               |
|                   | - `character varying(n)`          | karaketer yang ditentukan max length-nya yaitu `255` |
|                   | - `text`                          |               |
|-------------------|-----------------------------------|---------------|
| 2.Number          | - `integer`                       | range `-2_147_483_648 to +2_147_483_647`|
|                   | - `bigint`                        | range `-9_223_372_036_854_775_808 to +9_223_372_036_854_775_807` |
|                   | - `decimal`                       | dapat mengimpan nilai pecahan, termasuk jika nilainya berupa mata uang contohnya rupiah atau dolar.|
|                   | - `numberic`                      |               |
|                   | - `double precision`              | dapat menyimpan nilai pecahan |
|                   | - `serial`                        | autoincrementing integer `1 to 2_147_483_647` |
|                   | - `bigserial`                     | large autoincrementing integer `1 to 9_223_372_036_854_775_807` |
|-------------------|-----------------------------------|---------------|
| 3.Date & Time     | - `date`                          |               |
|                   | - `timestamp`                     |               |
|-------------------|-----------------------------------|---------------|
| 5.Dan lain-lain   | - `boolean`                       | hanya bernilai `true` atau `false` |
|                   | - [Other Data Type in PostgreSQL](https://www.postgresql.org/docs/9.5/datatype.html) | |

Ok, nah sekarang kita balik lagi ketopic utama yaitu Data Definition Language pada Table di PostgreSQL.

## Create Table

Perintah DDL **Create** pada Table di database Postgresql, initnya adalah untuk membuat table dalam Schema di Database. Berikut adalah contoh perintanya:


```sql
CREATE TABLE [your_schema].your_table_name (
    first_column <data-type> [constraints...] [default <value>],
    second_column <data-type> [constraints...] [default <value>]
);
```

Contoh penggunaanya:

```sql
create table test_table (
    id                  serial                  primary key,
    first_name          character varying(60)   not null,
    birtdate            date                    not null,
    is_active           boolean                             default false,
    balance             decimal                 not null    default 0,
    created_datetime    datetime                not null    default now()
);
```

## Drop Table

Perintah **DROP** table, digunakan untuk menghapus table yang ada di dalam schema di Database tertentu. Berikut adalah perintahnya:

```sql
DROP TABLE [IF EXISTS] your_table_name [CASCADE | RESTRICT];
```

## Alter Table

Perintah ALTER table, digunakan untuk memodifikasi strukur object pada table contohnya 

1. Menambahkan kolom 
```sql
ALTER TABLE <table-name> ADD COLUMN <column-name> <data-type>
```
2. Menghapus kolom
```sql
ALTER TABLE <table-name> DROP COLUMN <column-name>
```
3. Menambahkan constraint
```sql
ALTER TABLE <table-name> ADD <constraint>
```
4. Mengghapus constraint
```sql
ALTER TABLE <table-name> DROP CONSTRAINT <constraint-name>
```
5. Merubah default value
```sql
ALTER TABLE <table-name> ALTER COLUMN <column-name> SET DEFAULT <new-default-value>;
```
6. Merubah tipe data
```sql
ALTER TABLE <table-name> ALTER COLUMN <column-name> TYPE <data-type>;
```
7. Mengubah nama kolom
```sql
ALTER TABLE <table-name> RENAME COLUMN <old-column-name> TO <new-column-name>;
```
8. Merubah nana tabel
```sql
ALTER TABLE <old-table-name> RENAME TO <new-table-name>;
```