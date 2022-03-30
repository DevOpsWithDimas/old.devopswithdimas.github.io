---
layout: post
title: "Time your practice (part 1)"
date: 2022-03-12T10:57:41+07:00
lang: postgresql
authors:
- dimasm93
categories:
- RDBMS
- PostgreSQL
- sql
- select
refs: 
- https://www.postgresql.org/docs/14/queries.html
youtube: 
image_path: /resources/posts/postgresql/03g-quis-1
comments: true
gist: dimMaryanto93/7ae7632f9418feb724bc431eff412a3f
catalog_key: select-statement
downloads: []
---

Hai semuanya di materi sebelumnya kita sudah membahas beberapa hal basic sepert SQL Select statement, build-in Functions and Operators, WHERE clause, dan limit serta offset. Untuk memahami materi sebelumnya saatnya temen-temen untuk mencoba dengan mengerjakan soal seperti berikut: 

1. Buatlah _query_ untuk menampilkan seluruh data karyawan dari **table employees** yang **diurutkan berdasarkan email** paling terakhir.
2. Buatlah _query_ untuk menampilkan data karyawan yang gajinya lebih besar `3200.00` sampai dengan `12000.00`.
3. Buatlah _query_ untuk menampilkan data karyawan yang memiliki huruf `A` diawal nama depannya.
4. Buatlah _query_ untuk menampilkan data karyawan yang memiliki kode karyawan diantaranya `103, 115, 196, 187, 102 dan 100`
5. Buatlah _query_ untuk menampilkan data karyawan yang nama belakangnya memiliki huruf kedua `u`.
6. Buatlah _query_ untuk menampilkan **kode department** apa saja yang ada di **tabel employees** secara _unique_
7. Buatlah _query_ untuk menampilkan **nama lengkap karyawan, kode jabatan, gaji setahun** dari **table employees** yang **kode manager** sama dengan `100`.
8. Buatlah _query_ untuk menampilkan **nama belakang, gaji perbulan, kode jabatan** dari **table employees** yang **tidak memiliki komisi**
9. Buatlah _query_ untuk menampilkan data karyawan **yang bukan** dari jabatan `IT_PROG` dan `SH_CLERK`.