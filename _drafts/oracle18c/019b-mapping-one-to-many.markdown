---
layout: post
title: "One To Many Relationship Tables"
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://en.wikipedia.org/wiki/One-to-many_(data_model)
youtube: 
comments: true
image_path: /resources/posts/oracle12c/019b-onetomany
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

![erd]({{ page.image_path | prepend: site.baseurl }}/erd.jpg)

{% gist page.gist "019b-onetomany-mapping.sql" %}

Jadi untuk One To Many Relationship kita membutuhkan setidaknya 2 table (sama seperti one-to-one tanpa unique constraint pada column yang menjadi ref). Jika di jalankan maka hasilnya seperti berikut:

```sql
sqlplus toko_online/toko_online@xepdb1

SQL*Plus: Release 18.0.0.0.0 - Production on Mon Mar 22 03:03:24 2021
Version 18.4.0.0.0

Copyright (c) 1982, 2018, Oracle.  All rights reserved.

Last Successful login time: Mon Mar 22 2021 02:51:08 +00:00

Connected to:
Oracle Database 18c Express Edition Release 18.0.0.0.0 - Production
Version 18.4.0.0.0

SQL> SET LONG 20000 LONGCHUNKSIZE 20000 PAGESIZE 0 LINESIZE 1000 FEEDBACK OFF VERIFY OFF TRIMSPOOL ON;
SQL> SET PAGESIZE 14 LINESIZE 100 FEEDBACK ON VERIFY ON;

SQL> col trx_id format a2;
SQL> col cust_name format a20;
SQL> col item_name format a20;
SQL> col price_sell format a15;
SQL> col qty format a5;
SQL> col sub_total format a20;

SQL> select o.id                                       as trx_id,
       o.cust_name                                     as cust_name,
       od.item                                         as item_name,
       to_char(od.price, '999G999G999')                as price_sell,
       to_char(od.qty, '999G999')                      as qty,
       to_char((od.price * od.qty), '999G999G999G999') as sub_total
from orders o
         left join order_details od on o.id = od.order_id
order by trx_id;

TR CUST_NAME            ITEM_NAME             PRICE_SELL      QTY   SUB_TOTAL
-- -------------------- --------------------- --------------- ----- --------------------
1  Dimas Maryanto       Macbook Pro 13"        25,000,000      1          25,000,000
1  Dimas Maryanto       iPad Pro 11" (WIFI+C   15,000,000      1          15,000,000
                        elular)                                
1  Dimas Maryanto       Apple Pencil 2nd gen    2,200,000      1           2,200,000
1  Dimas Maryanto       iPhone 7 Plus (32 GB)    2,200,000     1           2,200,000
2  Muhamad Yusuf        Macbook Pro 15"        34,000,000      1          34,000,000
2  Muhamad Yusuf        iPhone 5 (24 GB)       15,000,000      1          15,000,000

6 rows selected.

SQL>                                               
```