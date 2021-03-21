---
layout: post
title: "DDL - Static Data Dictionary View"
date: 2021-02-22T14:12:28+07:00
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/18/refrn/about-static-data-dictionary-views.html#GUID-10024282-6729-4C66-8679-FD653C9C7DE7
youtube: 7WILxJz2rUE
comments: true
image_path: /resources/posts/oracle12c/016a-dictionary-table
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Sebelum kita membahas lebih dalam tentang data definition language (DDL), saya mau ngebahas dulu tentang **Static Data Dictionary View**, Data Dictionary Table gak bisa di access secara langsung, tapi bisa di akses melalui dictionary view yang tujuannya adalah untuk mengetahui list object yang ada didatabase berdasarkan user tertentu.

Penamaan Static Data Dictionary view terdiri dari

| Prefix    | Description   | Contoh        |
| :---      | :---          | :---          |
| `USER_**` | Berisi informasi object yang ada user saat ini | `USER_TABLES`, `USER_OBJECTS`, dan lain-lain |
| `ALL_**`  | Berisi semua informasi object yang ada di database ini | `ALL_ALL_TABLES`, `ALL_OBJECTS`, dan lain-lain |
| `DBA_**`  | Berisi semua informasi object yang ada di user level DBA | `DBA_TABLES`, `DBA_OBJECTS`, dan lain-lain |

## DT Prefix ALL_***

Berikut adalah contoh penggunaan static data dictionary view dengan prefix `ALL_`:

{% gist page.gist "016a-dt-all.sql" %}

## DT Prefix USER_***

Berikut adalah contoh penggunaan static data dictionary view dengan prefix `USER_`;

{% gist page.gist "016a-dt-user.sql" %}

## DT Prefix DBA_***

Berikut adalah contoh penggunaan static data dictionary view dengan prefix `DBA_`, untuk menggunakan ini kita harus login sebagai user `system`, `sys` atau selevel dengan DBA.

{% gist page.gist "016a-dt-dba.sql" %}