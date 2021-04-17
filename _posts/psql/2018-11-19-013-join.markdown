---
layout: post
title: "Menggabungkan data dari beberapa tabel dengan Join"
date: 2018-11-19T20:58:17+07:00
lang: psql
categories:
- RDBMS
- PostgreSQL
refs: []
youtube: aewpT6Y6_yk
comments: true
image_path: /resources/posts/psql/psql-join
gist: dimMaryanto93/62ffa0d81f3835a4e9401baf14590cd2
downloads: []
---

Klausa `join` pada dasarnya untuk menghubungkan tabel yang terpisah menjadi satu berdasarkan `foreign key` contoh ilustrasinya seperti berikut:

![ilustrasi join]({{ page.image_path | prepend: site.baseurl }}/join-tables.png)

Perintah join bisa di lakukan dengan beberapa cara yaitu

1. Natural JOIN
2. Inner JOIN
3. Outter JOIN
4. Self JOIN