---
layout: post
title: "Inner Join di PostgreSQL"
date: 2018-11-20T10:50:33+07:00
lang: psql
categories:
- RDBMS
- PostgreSQL
refs: []
youtube: GmUPKx353TI
comments: true
gist: dimMaryanto93/62ffa0d81f3835a4e9401baf14590cd2
downloads: []
---

Selain menggunakan `Natural join` kita bisa menggunakan klausa `on` dan juga `where` atau lebih dikenal dengan **Inner JOIN**. Dengan menggunakan klausa `on` atau `whare` kita bisa bebas menentukan column mana yang akan di relasikan contohnya seperti berikut:

<!--more-->

Contoh kasusnya, saya mau mencari data setiap department dan tampilkan siapa nama managernya. Berikut querynya:

**Menggunakan klausa `on`**

{% gist page.gist "select-inner-join-on.sql" %}

**Menggunakan klausa `where`**

{% gist page.gist "select-join-inner-where.sql" %}

Berikut hasilnya:

```postgresq-console
 kode |   nama_divisi    | kode_manager |   nama_manager    
------+------------------+--------------+-------------------
   10 | Administration   |          200 | Jennifer Whalen
   20 | Marketing        |          201 | Michael Hartstein
   30 | Purchasing       |          114 | Den Raphaely
   40 | Human Resources  |          203 | Susan Mavris
   50 | Shipping         |          121 | Adam Fripp
   60 | IT               |          103 | Alexander Hunold
   70 | Public Relations |          204 | Hermann Baer
   80 | Sales            |          145 | John Russell
   90 | Executive        |          100 | Steven King
  100 | Finance          |          108 | Nancy Greenberg
  110 | Accounting       |          205 | Shelley Higgins
(11 rows)
```