---
layout: post
title: "One To One Relationship Tables"
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
youtube: 
comments: true
image_path: /resources/posts/oracle12c/019a-mapping-one-to-one
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---


{% gist page.gist "019a-onetoone-mapping.sql" %}

Jadi pada dasarnya one-to-one mapping ini, kita gak bisa menggunakan `id` yang sudah ada pada tabel sebrangnya untuk digunakan lagi, Sebagai contoh seperti berikut:

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

SQL>
SQL> update sellers set
  2  alamat_id = 'ibox'
  3  where id = 4;
update sellers set
*
ERROR at line 1:
ORA-00001: unique constraint (TOKO_ONLINE.UQ_SALER_ADDRESS) violated

SQL>
```