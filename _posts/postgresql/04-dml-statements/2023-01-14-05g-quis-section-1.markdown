---
layout: post
title: "Time your practice (part 3)"
date: 2023-01-14T12:36:56+07:00
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

3. Buatlah query untuk merubah nilai dari field/column `commission_pct` menjadi `10%` dari table `employees` yang memiliki `job_id = 'IT_PROG'` kecuali `employee_id = 104`, jika di tampilkan hasilnya seperti berikut:
![hasil query]({{ page.image_path | prepend: site.baseurl }}/hasil3.png)

4. Buatlah query untuk menambahkan data karyawan dengan ketentuan seperti berikut:
    1. column `fist_name` = `Dimas`
    2. column `last_name` = `Maryanto`
    3. column `email` ambil dari column `fist_name` yang dirubah menjadi hurup besar semua.
    4. column `phone_number` = `081223334444`
    5. column `job_id` = `'IT_PROG'`
    6. column `salary` ambil dari table `jobs` berdasarkan nilai tengah antara column `min_salary` dan `max_salary` berdasarkan job id karyawan tersebut.
    7. column `commission_pct` = `9%`
    8. column `department_id` diisi dengan kode department `IT`
    9. column `manager_id` diisi dengan employee yang memimpin department tersebut.

5. Buatlah query untuk menambahkan atau jika sudah ada lakukan update ke table `jobs` dengan ketentuan seperti berikut:
    1. column `job_id` = `IT_MAN`
    2. column `job_name` = `IT Project Manager`
    3. column `min_salary` diambil dari `max_salary` untuk `job_id = 'IT_PROG'`
    4. column `max_salary` diambil dari `min_salary` ditambah `15000`