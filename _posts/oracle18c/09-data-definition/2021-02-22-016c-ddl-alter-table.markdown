---
layout: post
title: "DDL - Merubah struktur table"
date: 2021-02-22T15:21:08+07:00
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/RENAME.html#GUID-573347CE-3EB8-42E5-B4D5-EF71CA06FAFC
youtube: https://www.youtube.com/watch?v=DL38CZIDr9M&list=PLV1-tdmPblvzqS-Z57hZ_spTRtVvnYYpV&index=76
comments: true
image_path: /resources/posts/oracle12c/
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Perintah ALTER table, digunakan untuk memodifikasi strukur object pada table contohnya 

## Pada Table

1. Merubah nama tabel
    {% gist page.gist "016c-ddl-rename-table.sql" %}

## Pada column

1. Menambahkan kolom 
    {% gist page.gist "016c-ddl-add-column.sql" %}
2. Menghapus kolom
    {% gist page.gist "016c-ddl-drop-column.sql" %}
3. Merubah tipe data
    {% gist page.gist "016c-ddl-change-data-type.sql" %}
4. Mengubah nama kolom
    {% gist page.gist "016c-ddl-rename-column.sql" %}

## Default value options

1. Merubah default value
    {% gist page.gist "016c-ddl-modif-default-value.sql" %}

## Pada Constraint

Nanti akan di bahas pada materi selanjutnya.

