---
layout: post
title: "One To One Relationship Tables"
date: 2021-03-22T16:58:36+07:00
lang: oracle18c
authors:
- dimasm93
categories:
- RDBMS
- Oracle18c
refs: 
- https://en.wikipedia.org/wiki/One-to-one_(data_model)
youtube: cA6ebyjAJiw
comments: true
catalog_key: design-db
image_path: /resources/posts/oracle12c/019a-onetoone
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Dalam perancangan tabel **One-To-One Relationship** yaitu adalah salah satu dari jenis cardinality yang merujuk ke relationship diantara ke dua table. Contohnya seperti pada ERD seperti berikut:

![erd]({{ page.image_path | prepend: site.baseurl }}/erd.jpg)

Maka implementasi menggunakan Oracle Database Seperti Berikut:

{% gist page.gist "019a-onetoone-mapping.sql" %}

Jadi pada dasarnya one-to-one mapping ini, kita tidak bisa menggunakan `id` yang sudah ada pada tabel detail untuk digunakan lagi, Atau kalau di terjemahkan seperti berikut

> Dalam satu row pada tabel `seller` hanya ada satu `alamat`, dan dalam satu `alamat` ada di satu row dalam tabel `seller`

Sebagai contoh seperti berikut:

```sql
sqlplus toko_online/toko_online@xepdb1

SQL*Plus: Release 18.0.0.0.0 - Production on Sun Mar 21 23:50:54 2021
Version 18.4.0.0.0

Copyright (c) 1982, 2018, Oracle.  All rights reserved.

Last Successful login time: Sun Mar 21 2021 23:41:21 +00:00

Connected to:
Oracle Database 18c Express Edition Release 18.0.0.0.0 - Production
Version 18.4.0.0.0

SQL> col alamat_id format a20

SQL> select id, domain, alamat_id
     from sellers;


        ID DOMAIN               ALAMAT_ID
---------- -------------------- --------------------
         2 ibox.co.id           ibox
         3 nvidia.co.id
         4 msi.co.id

SQL> update sellers set
  2  alamat_id = 'ibox'
  3  where id = 4;
update sellers set
*
ERROR at line 1:
ORA-00001: unique constraint (TOKO_ONLINE.UQ_SALER_ADDRESS) violated

SQL>
```