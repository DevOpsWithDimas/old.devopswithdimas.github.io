---
layout: post
title: "Pengenalan Index di Oracle"
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/18/cncpt/indexes-and-index-organized-tables.html#GUID-DE7A95BC-6E4A-47EA-9FC5-B85B54F8CF41
- https://docs.oracle.com/en/database/oracle/oracle-database/18/sqlrf/CREATE-INDEX.html#GUID-1F89BBC0-825F-4215-AF71-7588E31D8BFE
youtube: 
comments: true
image_path: /resources/posts/oracle12c/017-indexes
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Sebuah index adalah optional structure yang dikaitkan ke table yang biasanya bisa mempercepat access data. Ketika kita membuat table dengan primary key by default kita otomatis akan di buatkan index b-tree berdasarkan column primary key tersebut. 

Index ada beberapa macam di Oracle, diantaranya:

1. B-Tree Index
2. Bitmap Index
3. Function-Based Index
4. Application Domain Index
5. Index-Organized Table

Sebelum kita mulai mencoba, kita siapkan dulu table dan datanya seperti berikut:

{% gist page.gist "017-preparation-indexes.sql" %}

Kemudian coba execute, dan `commit`. Setelah itu coba tampilkan total datanya seperti berikut:

```sql
SQL> select to_char(count(*), '999G999G999') data
from test_indexs;

DATA
------------
   1,070,000
SQL>
```