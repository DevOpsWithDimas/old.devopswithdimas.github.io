---
layout: post
title: "Pengenalan Structural Query Language (SQL)"
lang: psql
categories:
- RDBMS
- PostgreSQL
refs: []
youtube: mLC3DBBboTk
comments: true
gist: dimMaryanto93/62ffa0d81f3835a4e9401baf14590cd2
catalog_key: introduction
downloads: []
---

Data relational yaitu salah satu konsep atau teknik _how to store the data_ dengan menggunakan _database_ atau Basis Data. _Database_ itu sebenarnya software yang bertujuan untuk memudahkan proses manipulasi data dan pencarian secara cepat dengandingkan menggunakan _file_.

Mungkin dari temen-temen masih ada yang salah kaprah antara perbedaan sistem database dengan file, yang jelas `MS. Excel` bukan merupakan _database_ tetapi _file datasource_ meskipun secara konsep terdiri dari baris dan kolom tetap saja berbeda. yang termasuk _database_ yaitu contohnya

1. PostgreSQL
2. Oracle
3. MySQL
4. MS Access dan lain-lain.

Jaman sekarang, teknologi _database_ ini ada 2 teknologi yaitu **Relational Database Management System** dan **NoSQL Database**, keduanya memiliki kelebihan dan kekurangan masing-masing. Berinteraksi dengan _database_ biasanya menggunakan _query_ untuk database yang sifatnya _relational_ menggunakan **Structured Query Language (SQL)** sedangkan untuk teknologi **NoSQL Database** sama juga menggunakan `SQL` tetapi independent dan tergantung dari bahasa _database_ yang digunakan contohnya seperti MonggoDB, Casandra dan lain-lain.

Perintah query pada dasarnya dibagi menjadi 4 yaitu,

1. _Select statement_, digunakan untuk menampilkan data dari suatu tabel di dalam database.
2. _Data Definition Language_ atau DDL, biasanya digunakan untuk membuat table atau memanipulasi tabel seperti menambah column, merubah tipe data suatu column dan lain-lain.
3. _Data Manipulation Language_ ada DML, biasaya digunakan untuk memanipulasi data seperti tambah data, ubah data, dan hapus data dalam suatu tabel di _database)
4. _Transaction Control Language_ atau TCL, biasaya digunakan untuk transaction management data di _database_ contohnya seperti melakukan _rollback_ ketika terjadi error, melakukan _commit_ dan lain-lain.