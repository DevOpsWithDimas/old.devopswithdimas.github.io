---
layout: post
title: "DDL - Menghapus table dengan DROP"
date: 2021-02-22T18:50:06+07:00
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/DROP-TABLE.html#GUID-39D89EDC-155D-4A24-837E-D45DDA757B45
youtube: 
comments: true
image_path: /resources/posts/oracle12c/
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Clause `DROP TABLE` di oracle bukan untuk menghapus tetapi untuk memindahkan table ke recylebin.

Untuk menghapus tabel ada beberapa perintah:

## Basic drop table

Untuk menghapus table secara sederhananya seperti berikut:

{% gist page.gist "016d-ddl-drop-table.sql" %}

## Cascade Options

Untuk sebagian kasus, jika table yang kita ingin kita hapus misalnya datanya masih ada relate dengan table lain maka kita gak bisa menghapus dengan cara basic drop table di atas. contohnya:

```sql
SQL> drop table departments
                *
ERROR at line 1:
ORA-02449: unique/primary keys in table referenced by foreign keys
```

{% gist page.gist "016d-ddl-drop-table-cascade.sql" %}

## Purge Options

seperti yang saya bilang di awal, bahwa perintah drop table itu memindahkan table ke recylebin. nah misalnya kalo kita mau menghapus secara permanent kita perlu option `purge`. seperti berikut contohnya:

{% gist page.gist "016d-ddl-drop-table-purge.sql" %}
