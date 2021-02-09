---
layout: post
title: "Konsep User dan Schema di Oracle Database 18c"
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/19/index.html
youtube: 
comments: true
image_path: /resources/posts/oracle12c/002a-user-schema
gist: 
downloads: []
---

Database yaitu tempat untuk menyimpan data dan untuk memudahkan, membaca data, mengubah data, menghapus data secara logical berbentuk table 2D (dimensi). Object-object database terdiri

1. table
2. sequence
3. view
4. index
5. constraint
6. synonym
7. PL/SQL

Pengelompokan object-object tersebut disebut `schema` atau `user` klo di oracle. Karena di Oracle biasanya hanya terdapat 1 database banyak schema. Didalam 1 schema banyak `table`, `sequance`, `view`, dll seperti pada gambar berikut:

![user-schema]({{ page.image_path | prepend: site.baseurl }}/oracle-schema.jpg)

Digambar diatas menunjukan global database terdiri user `sys`, `system` dan `hr`. Di dalam masing-masing user atau schema memiliki  akses, membuat, memodifikasi object-object tersebut berdasarkan rolenya yang di terapkan oleh dba.

User Database Adminstrator di oracle adalah `sys`, dan `system`. Database adminstrator user ini biasanya digunakan untuk melakukan management database oracle seperti user management, management cluster, management sharding dan lain-lain. Sedangkan user `hr` adalah normal user dengan kategori management data dan struktur table.
