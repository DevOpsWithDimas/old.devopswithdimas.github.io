---
layout: post
title: "Using thirdparty Editor untuk PostgreSQL Server"
lang: postgresql
categories:
- RDBMS
- PostgreSQL
refs: 
- https://www.postgresql.org/docs/current/
youtube: 
image_path: /resources/posts/psql/02c-usage-3rd-party-editors
comments: true
gist: dimMaryanto93/62ffa0d81f3835a4e9401baf14590cd2
catalog_key: getting-started
downloads: []
---

Hai semuanya, Di materi kali ini kita akan membahas Third Party Editor yang bisa digunakan untuk berkomunikasi dengan PostgreSQL Server. Sepertinya kita ketahui ya PostgreSQL Server menggunakan TCP/IP dan Unix socket untuk berkomunikasi antara client dan server. Selain menggunakan aplikasi client bawaan, kita juga bisa menggunakan Aplikasi 3rd Party seperti 

1. [Navicate](https://www.navicat.com/en/products/navicat-for-postgresql)
2. [Jetbraint DataGrip](https://www.jetbrains.com/datagrip/)
3. [DBeaver](https://dbeaver.io)
4. [HeidiSQL](https://www.heidisql.com)
5. Dan masih banyak sekali editor lainnya

Nah jadi temen-temen bisa pilih salah satu dari 3rd party editor tersebut kalau mau pakai. Untuk saya sendiri biasanya menggunakan Editor [IntelliJ IDEA](https://www.jetbrains.com/idea/) buatnnya Jetbraint yang Ultimate.

Jadi di cource ini, kita akan menggunakan IntelliJ IDEA ya. Adapun pembahasannya kali ini kita akan setup environmentnya dulu mulai:

1. Connection to PostgreSQL Server
2. Run a Query
3. Export/Import
4. Show Diagram ERD from existing tables

Ok langsung aja kita ke pembahasan yang pertama

## Connection to PostgreSQL Server