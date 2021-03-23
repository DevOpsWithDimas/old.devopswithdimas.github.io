---
layout: post
title: "Inherintance Mapping (OODMBS)"
date: 2021-03-23T09:47:31+07:00
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/index.html
youtube: 
comments: true
image_path: /resources/posts/oracle12c/019e-inheritance
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Oracle Database adalah salah satu database yang sudah support Object Oriented Database Management System sejak `10g`,

Dalam Object Oriented memiliki konsep seperti Pewarisan atau Inherintance. Inherintance yaitu mewariskan atribut dan property yang di miliki oleh Object super klo di Oracle menyebutnya `supertype` berikut adalah ilustrasinya

![supertype hirarchy](https://docs.oracle.com/en/database/oracle/oracle-database/18/adobj/img/adobj027.gif)

Penggunaanya biasanya untuk membuat struktur table yang sama contohnya seperti berikut:

![orm]({{ page.image_path | prepend: site.baseurl }}/orm.jpg)

Berikut adalah implementasi menggunakan Oracle Database

{% gist page.gist "019e-object-type-inherintance-mapping.sql" %}

Berikut adalah hasilnya:

```sql
sqlplus toko_online/toko_online@xepdb1

SQL*Plus: Release 18.0.0.0.0 - Production on Tue Mar 23 02:30:11 2021
Version 18.4.0.0.0

Copyright (c) 1982, 2018, Oracle.  All rights reserved.

Last Successful login time: Tue Mar 23 2021 01:58:52 +00:00

Connected to:
Oracle Database 18c Express Edition Release 18.0.0.0.0 - Production
Version 18.4.0.0.0

SQL> col type_name format a20
SQL> col typecode format a10
SQL> col final format a5
SQL> col supertype_name format a20

SQL> select TYPE_NAME, TYPECODE, FINAL, SUPERTYPE_NAME
from USER_TYPES;

TYPE_NAME            TYPECODE   FINAL SUPERTYPE_NAME
-------------------- ---------- ----- --------------------
KENDARAAN_TYPE       OBJECT     NO
MOTORCYCLE_TYPE      OBJECT     NO    KENDARAAN_TYPE
CAR_TYPE             OBJECT     NO    KENDARAAN_TYPE

SQL> col table_name format a25
SQL> col tablespace_name format a10
SQL> col status format a10
SQL> col table_type_owner format a15
SQL> col table_type format a20

SQL> SET LONG 20000 LONGCHUNKSIZE 20000 PAGESIZE 0 LINESIZE 1000 FEEDBACK OFF VERIFY OFF TRIMSPOOL ON;
SQL> SET PAGESIZE 14 LINESIZE 100 FEEDBACK ON VERIFY ON;

SQL> select TABLE_NAME, TABLESPACE_NAME, STATUS, TABLE_TYPE_OWNER, TABLE_TYPE
from USER_OBJECT_TABLES;

TABLE_NAME                TABLESPACE STATUS     TABLE_TYPE_OWNE TABLE_TYPE
------------------------- ---------- ---------- --------------- --------------------
BMW_MOTORAD               USERS      VALID      TOKO_ONLINE     MOTORCYCLE_TYPE
ASTRA_HONDA               USERS      VALID      TOKO_ONLINE     MOTORCYCLE_TYPE
HONDA_INDONESIA           USERS      VALID      TOKO_ONLINE     CAR_TYPE

3 rows selected.

SQL> col kode format a10
SQL> col name format a20
SQL> col machine_type format a20

SQL> select to_char(id) as kode, name, machine_type
from astra_honda;

KODE       NAME                 MACHINE_TYPE
---------- -------------------- --------------------
1          CBR 150-rr           DOHC 1 Cylinder
2          CBR 250-rr           DOHC 2 Cylinder

2 rows selected.

SQL>
```

## Altering object table

di Oracle Database untuk Object Table tidak boleh di alter atau di modifikasi. jika mau di modif kita alter lewat object typenya.

## Drop object table

Untuk menghapus object table, sama seperti kita menghapus table bisa dengan menggunakan perintah seperti berikut:

{% gist page.gist "019e-drop-object-table.sql" %}

## Drop object type

Untuk menghapus object type, kita bisa menggunakan perintah seperti berikut:

{% gist page.gist "019e-drop-object-type.sql" %}

Untuk pembahasan lebih lanjut, nanti kita akan bahas lebih detail di serie Object Oriented Database dengan Oracle Database.