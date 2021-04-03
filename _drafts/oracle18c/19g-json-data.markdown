---
layout: post
title: "JSON Data in Oracle Database"
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/18/adjsn/json-data.html#GUID-615A4146-6DC0-4E66-9AD0-CD74C90D208A
youtube: 
comments: true
image_path: /resources/posts/oracle12c/19g-json-data
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

JSON yaitu JavaScript Object Notation, Oracle Database sejak 10g support dengan JSON data natively. Oracle sendiri memiliki feature namanya **SODA (Simple Oracle Document Access)**.
SODA sendiri yaitu API (Application Program Interface) untuk mengakses dan juga menyimpan JSON Data ke database.

Contoh penggunaanya seperti berikut:

{% gist page.gist "019g-json-column-table.sql" %}

Untuk tipe datanya kita bisa gunakan diantaranya:

1. Varchar2, gunakan ini jika jumlah character tidak lebih dari `4000 char`
2. CLOB, gunakan `clob` jika jumlah character dari json tersebut lebih dari `4000 char`
3. BLOB, gunakan `blob` jiak jumlah character ingin lebih besar lagi dari `clob`

Untuk menapilkan datanya, kita bisa menggunakan beberapa cara yaitu 

1. Dot Notation, seperti berikut:

    {% gist page.gist "019g-select-json-dot-notation.sql" %}

2. Function `json_value`, seperti berikut:

    {% gist page.gist "019g-select-json-function.sql" %}

3. Dan masih banyak-lagi

Untuk lebih detailnya temen-temen bisa baca [disini](https://docs.oracle.com/en/database/oracle/oracle-database/18/adjsn/query-json-data.html#GUID-119E5069-77F2-45DC-B6F0-A1B312945590), atau nanti kita akan bahas pada materi `Database Object Oriented: Oracle Database 18c`