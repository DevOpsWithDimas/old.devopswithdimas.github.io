---
layout: post
title: "Transaction Control Language"
date: 2019-12-29T20:07:46+07:00
lang: psql
categories:
- RDBMS
- PostgreSQL
refs: []
youtube: tQHfL3lpBz8
comments: true
gist: dimMaryanto93/62ffa0d81f3835a4e9401baf14590cd2
downloads: []
---

Transaction Control atau singkatan dari TCL yaitu perintah untuk kendali terhadap suatu perubahan data di Database contoh menginpan data secara permanent yang kita kenal sebagai `commit` dan untuk mengembalikan ke kondisi sebelumnya yaitu `rollback` dalam suatu transaksi.

<!--more-->

Fungsi utama menggunakan transaction pada Database adalah terkadang jika kita membuat aplikasi, kita tidah hanya menulis di 1 s/d 2 tabel terkadang bisa 10 bahkan ratusan tabel dalam sekali proses bisnis. Contohnya kita transfer antar bank di ATM nah jadi klo dari saldo kita udah ter-debet sedangkan di saldo si penerima tidak bertambah lalu kemana saldonya??? nah ibaratnya seperti itu jadi klo terjadi gagal transaksi maka system harus mengembalikan saldo pengirim.

Untuk Transaction Control Language terdiri dari

1. Commit
2. Rollback
3. Savepoint
