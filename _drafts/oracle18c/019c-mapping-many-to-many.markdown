---
layout: post
title: "Many To Many Relationship Tables"
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://en.wikipedia.org/wiki/Many-to-many_(data_model)
youtube: 
comments: true
image_path: /resources/posts/oracle12c/019c-manytomany
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

![erd]({{ page.image_path | prepend: site.baseurl }}/erd.jpg)

{% gist page.gist "019c-manytomany-mapping.sql" %}

Jadi untuk Many To Many Relationship ini minimal harus memiliki 2 table master (`categories`, dan `items`) dan 1 tabel penghubung (`item_categories`), Jika kita check maka hasilnya seperti berikut:

```sql
sqlplus toko_online/toko_online@xepdb1

SQL*Plus: Release 18.0.0.0.0 - Production on Mon Mar 22 02:04:31 2021
Version 18.4.0.0.0

Copyright (c) 1982, 2018, Oracle.  All rights reserved.

Last Successful login time: Mon Mar 22 2021 02:04:07 +00:00

Connected to:
Oracle Database 18c Express Edition Release 18.0.0.0.0 - Production
Version 18.4.0.0.0

SQL> col item_id format a10;
SQL> col item_name format a20;
SQL> col category_name format a20;

SQL> select i.id   as item_id,
       i.nama as item_name,
       c.nama as category_name
from items i
         left join item_categories it on i.id = it.item_id
         left join categories c on it.category_id = c.id
order by i.id;

ITEM_ID    ITEM_NAME            CATEGORY_NAME
---------- -------------------- --------------------
ipn7+      iPhone 7 Plus        Smartphone
ipp11      iPad Pro 11 inch     Smartphone
ipp11      iPad Pro 11 inch     Personal Computer
iwatch     Apple Watch 5th gen  Smartphone
mbp13-touc Macbook Pro 13 inch  Personal Computer
hbar       (Touchbar)

SQL>

SQL> col category_id format a5
SQL> col category_name format a20
SQL> col item_name format a30

SQL> select to_char(c.id) as category_id,
       c.nama        as category_name,
       i.nama        as item_name
from categories c
         left join item_categories ic on c.id = ic.category_id
         left join items i on ic.item_id = i.id
order by category_id;

CATEG CATEGORY_NAME        ITEM_NAME
----- -------------------- ------------------------------
10    Smartphone           iPhone 7 Plus
10    Smartphone           Apple Watch 5th gen
10    Smartphone           iPad Pro 11 inch
20    Personal Computer    iPad Pro 11 inch
20    Personal Computer    Macbook Pro 13 inch (Touchbar)
21    Component Computer
22    Accessories Computer

7 rows selected.
```