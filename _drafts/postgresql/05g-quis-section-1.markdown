---
layout: post
title: "Time your practice (part 3)"
lang: postgresql
authors:
- dimasm93
categories:
- RDBMS
- PostgreSQL
- SQL
- DML
refs: 
- https://www.postgresql.org/docs/current/
youtube: 
image_path: /resources/posts/postgresql/05g-quis-section-1
comments: true
gist: dimMaryanto93/7ae7632f9418feb724bc431eff412a3f
catalog_key: dml-statement
downloads: []
---

Hai semuanya di materi sebelumnya kita sudah membahas perintah Data manipulation language sepertin `INSERT`, `UPDATE`, `DELETE` beserta combinasi antara `SELECT` dan DML tersebut, nah supaya temen-temen memahami materi yang telah saya sampaikan saatnya temen-temen untuk latihan / mengerjakan soal yang saya berikan seperti berikut:

<!--more-->

1. Tambahkan data ke tabel `countries` dengan data seperti berikut
![data insert query countries]({{ page.image_path | prepend: site.baseurl }}/soal1.png)
2. Tambahkan data ke tabel `locations` dengan data seperti berikut
![data insert query locations]({{ page.image_path | prepend: site.baseurl }}/soal2.png)
3. Updatelah `commission_pct` menjadi `10%` dari table `employees` yang memiliki `job_id = 'IT_PROG'` kecuali `employee_id = 104`, jika di tampilkan hasilnya seperti berikut:
![hasil query]({{ page.image_path | prepend: site.baseurl }}/hasil3.png)