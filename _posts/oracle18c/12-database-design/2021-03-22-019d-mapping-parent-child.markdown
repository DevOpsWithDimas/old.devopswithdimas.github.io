---
layout: post
title: "Parent Childs Relationship"
date: 2021-03-22T17:36:48+07:00
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/Hierarchical-Queries.html#GUID-0118DF1D-B9A9-41EB-8556-C6E7D6A5A84E
youtube: 
comments: true
image_path: /resources/posts/oracle12c/019d-parent-child
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Dalam perancangan tabel, suatu tabel bisa merujuk ke dirinya sendiri (parent child). Berikut adalah ilustrasinya:

![erd]({{ page.image_path | prepend: site.baseurl }}/erd.jpg)

Berdasarkan ERD tersebut, berikut adalah implementasi menggunakan Oracle Database:

{% gist page.gist "019d-parentchild-mapping.sql" %}

Jadi di Parent Child Mapping ini kita bisa merelasikan ke tabel diri sendiri seperti contoh di atas. Dengan begitu menciptakan suatu Hierarchical Query seperti berikut:

```sql
sqlplus toko_online/toko_online@xepdb1

SQL*Plus: Release 18.0.0.0.0 - Production on Mon Mar 22 06:35:06 2021
Version 18.4.0.0.0

Copyright (c) 1982, 2018, Oracle.  All rights reserved.

Last Successful login time: Mon Mar 22 2021 06:26:39 +00:00

Connected to:
Oracle Database 18c Express Edition Release 18.0.0.0.0 - Production
Version 18.4.0.0.0

SQL> SET LONG 20000 LONGCHUNKSIZE 20000 PAGESIZE 0 LINESIZE 1000 FEEDBACK OFF VERIFY OFF TRIMSPOOL ON;
SQL> SET PAGESIZE 14 LINESIZE 100 FEEDBACK ON VERIFY ON;
SQL> col menu_id format a10
SQL> col menu_name format a20
SQL> col root_name format a10
SQL> col url format a30
SQL> col peringkat format a5
SQL> col is_leaf format a5
SQL> col is_cycle format a5SQL> 

SQL> select id                           as menu_id,
       nama                         as menu_name,
       connect_by_root nama         as root_name,
       sys_connect_by_path(id, '/') as url,
       to_char(LEVEL)                  peringkat,
       to_char(CONNECT_BY_ISLEAF)   as is_leaf,
       to_char(CONNECT_BY_ISCYCLE)  as is_cycle
from menu
start with parent_id is null
connect by nocycle prior id = parent_id
order siblings by nama;

MENU_ID     MENU_NAME            ROOT_NAME  URL                            PERIN IS_LE IS_CY
----------  -------------------- ---------- ------------------------------ ----- ----- -----
p           Belanja              Belanja    /p                             1     0     0

elektronik  Elektronik           Belanja    /p/elektronik                  2     1     0

komputer-l  Komputer & Laptop    Belanja    /p/komputer-laptop             2     0     0
aptop

motherboard Motherboard          Belanja    /p/komputer-laptop/motherboard 3     1     0

ram         RAM Komputer & Lapto Belanja    /p/komputer-laptop/ram         3     1     0
            p
vga         VGA Card             Belanja    /p/komputer-laptop/vga         3     1     0

tagihan     Tagihan              Tagihan    /tagihan                       1     0     0

bpjs-keten  Bayar BPJS Kesehatan Tagihan    /tagihan/bpjs-ketenagakerjaan  2     1     0
agakerjaan   & Ketenagakerjaan

pln         Beli Token & Bayar   Tagihan    /tagihan/pln                   2     1     0
            Tagihan Listrik

9 rows selected.

SQL>
```