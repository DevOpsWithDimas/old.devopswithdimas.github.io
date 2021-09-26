---
layout: post
title: "Index - Balanced Tree (B-Tree)"
date: 2021-03-02T16:31:15+07:00
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/19/cncpt/indexes-and-index-organized-tables.html#GUID-FC93A85B-C237-4249-AD1E-FF54576ED050
youtube: SZL-PhWbmis
comments: true
catalog_key: index-table
image_path: /resources/posts/oracle12c/019a-normal-index
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

B-Tree atau singkatan dari balanced tree yaitu most commons type database index di Oracle dengan tujuan mengelompokan data berdasarkan range. Sebagai contoh misalnya kita punya index dari table `departments` pada column `department_id` ketika di buat index maka secara logical akan dibuat pengelompokan seperti berikut:

![oracle-btree-index](https://docs.oracle.com/en/database/oracle/oracle-database/19/cncpt/img/cncpt244.gif)

## Branch Block & Leaf Block

Sebuah Balance Tree (B-Tree) index ada dua block yaitu **branch block** untuk searching dan **leaf block** untuk storing values. Jadi secara logic ketika ada perintah select maka pertama masuk dari branch block lalu menuju leaf block.

Dalam root branch pada gambar diatas, terlihat pengelompokan `0 .. 40`, `41 .. 80` dan seterusnya sedangkan dibawahnya dipecah lagi, sedangkan leaf block terdiri dari deretan nilai yang dapat berpindah block satu sama lain berdasarkan kategorinya.

## Index Scans

Index Scan, jika kita menggunakan SQL Statement hanya pada column yang di index maka database akan membaca nilainya melalui index secara automatis bukan dari table. Penggunaan index scan terdiri dari:

1. [Full index scan](https://docs.oracle.com/en/database/oracle/oracle-database/19/cncpt/indexes-and-index-organized-tables.html#GUID-F8439C86-0C6A-4FA8-85C5-1D49AE590180)
2. [Fast Full index scan](https://docs.oracle.com/en/database/oracle/oracle-database/19/cncpt/indexes-and-index-organized-tables.html#GUID-2C8A7262-DEBE-4932-8EFB-64E61AD041C1)
3. [Index Range Scan](https://docs.oracle.com/en/database/oracle/oracle-database/19/cncpt/indexes-and-index-organized-tables.html#GUID-E1BD4FBF-8A6D-4EF8-8892-7B1CBFA9D5C6)
4. [Index Skip Scan](https://docs.oracle.com/en/database/oracle/oracle-database/19/cncpt/indexes-and-index-organized-tables.html#GUID-4675513E-A498-455B-A610-B70823E32A30)

## Menggunakan B-Tree Index

Untuk menggunakan balance tree indes, 

{% gist page.gist "017a-create-table-for-btree-index.sql" %}

Kemudian coba execute, dan `commit`. Setelah itu coba tampilkan total datanya seperti berikut:

```sql
SQL> select to_char(count(*), '999G999G999') data
from test_indexs;

DATA
------------
   1,070,000
SQL>
```

Sebagai contoh, kita sering melakukan query menggunakan atribute `first_name` maka kita perlu membuatkan index seperti berikut:

{% gist page.gist "017a-create-balance-tree-index.sql" %}

Selain itu juga kita bisa membuat composite index, sebagai contoh kita sering melakukan atribute `department_id` dan `salary` maka kita perlu buat index seperti berikut:

{% gist page.gist "017a-create-composite-balance-tree-index.sql" %}