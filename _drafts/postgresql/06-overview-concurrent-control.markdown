---
layout: post
title: "Overview of Concurrency Control"
lang: postgresql
authors:
- dimasm93
categories:
- RDBMS
- PostgreSQL
- SQL
- TCL
refs: 
- https://www.postgresql.org/docs/14/mvcc.html
youtube: 
image_path: /resources/posts/postgresql/06-overview-concurrent-control
comments: true
gist: dimMaryanto93/7ae7632f9418feb724bc431eff412a3f
catalog_key: dml-statement
downloads: []
---

Hai semuanya, setelah kita mempelajari perintah Select statement, dan Data Manipulation language ada satuhal lagi yang kita perlu kita pelajari yaitu Concurrent Control. Conncurrent control ini berfungsi untuk Mengatur behavior dari Database Server terkait multiple access seperti multiple query, transaction, multiple session execute at the same time on same database.

Jika pada materi sebelumnya kita hanya menggunakan simple query dan di execute secara singleton. Bagaimana jika saya memiliki contoh ilustrasi seperti berikut:

![flow-bisnis-transaction]({{ page.image_path | prepend: site.baseurl }}/bisnis-logic-transfer.png)

Jadi pada contoh kasus tersebut, kita memiliki system untuk transfer saldo dari rekening A ke rekening B. Jika kita gambarkan yang pasti kita harus melakukan beberapa query dan harus memiliki suatu mekanisme jika suatu proses tersebut gagal. Dimana query kita execute minimal adalah

1. Inquery rekening tujuan
2. Inquery saldo rekening sumber
3. Update saldo rekening A dengan menggurangi sejumlah yang di transfer
4. Update saldo rekening B dengan menambah sejumlah yang di transfer

Jika pada saat proses no 4 gagal, bisa di banyangkan apa yang terjadi???

Yup betul saldo rekening A kok berkurang tapi saldo di rekening tujuan tidak bertambah trus kemana uangnya?. maka dari itu proses tersebut harus dihandle dengan system transaction seperti `commit`, `rollback` dan lain-lain.

Nah system transaction tersebut adalah bagian dari Concurrent Control, Jadi kita akan bahas lebih detail seperti berikut:

<!--more-->

1. Transaction Isolation
2. Explicit Locking
3. Data Consistency Checks at the Application Level
4. Caveats
5. Locking and Indexes

Ok mungkin sekian dulu aja yang bisa saya sampaikan terkait materi yang akan kita bahas di materi selanjutnya.