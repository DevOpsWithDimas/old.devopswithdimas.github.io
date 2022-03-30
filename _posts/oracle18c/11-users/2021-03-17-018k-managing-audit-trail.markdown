---
layout: post
title: "Administering the Audit Trail"
date: 2021-03-17T15:34:03+07:00
lang: oracle18c
authors:
- dimasm93
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/18/dbseg/administering-the-audit-trail.html#GUID-9F298B8A-6196-4206-A889-A7CEB0924CF1
- https://docs.oracle.com/en/database/oracle/oracle-database/18/dbseg/administering-the-audit-trail.html#GUID-1DD625ED-AC75-47E7-ADF6-1C7C93656F22
youtube: 
comments: true
catalog_key: monitor-audit-trail
image_path: /resources/posts/oracle12c/018l-managing-audit-trail
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Untuk melakukan adminstration Audit Trail, yang digunakan harus memiliki privileges `AUDIT_ADMIN` role. Untuk adminstration disini kita bisa melakukan

1. Enabled Audit Policy
2. Disabled Audit Policy
3. Archive Audit Trail
4. Purge Audit Trail (Delete Permanently)

## When are Audit Record Created?

Untuk Audit Record akan di generate automatis seketika atau juga bisa setelah execution phase dari Suatu SQL Statement, Jadi Oracle Database akan melakukan intercept bila ada SQL Statement yang sesuai dengan criteria dari Audit Policy-nya kemudian Audit Record dibuat dan disimpan ke `UNIFIED_AUDIT_TRAIL`.

## Enabled & Disabled Audit Policy

Untuk mengaktifkan audit policy, seperti yang telah kita lakukan sebelumnya yaitu kita bisa menggunakan perintah seperti berikut:

{% gist page.gist "018k-manage-audit-enabled.sql" %}

Untuk men-disable audit policy, berikut adalah perintahnya:

{% gist page.gist "018k-manage-audit-disabled.sql" %}

## Archiving the Audit Trail

Archive Audit Trail dibutuhkan untuk mencegah data yang disimpan semakin lama semakin besar (HouseKeeping Audit). 

Untuk melakukan archive sebenarnya ada banyak caranya diantarnya:

1. Traditional Operating System Audit Trail
2. Archiving the Unified and Traditional Database Audit Trails

## Purge Audit Trail

Basicly kita bisa menghapus audit trail dengan beberapa cara seperti:

1. Regularly Scheduled Basis
2. Manually Purging the Audit Trail

Kita akan bahas pake cara manual dulu ya. Jadi berikut adalah perintahnya:

{% gist page.gist "018k-manage-audit-purge-cdb.sql" %}

atau

{% gist page.gist "018k-manage-audit-purge-pdb.sql" %}

jika di jalankan maka hasilnya seperti berikut:

```sql
bash-4.2# su oracle

[oracle@cdfa8d8746fc /]$ sqlplus / as sysdba

SQL*Plus: Release 18.0.0.0.0 - Production on Wed Mar 17 08:24:13 2021
Version 18.4.0.0.0

Copyright (c) 1982, 2018, Oracle.  All rights reserved.


Connected to:
Oracle Database 18c Express Edition Release 18.0.0.0.0 - Production
Version 18.4.0.0.0

SQL> BEGIN
    DBMS_AUDIT_MGMT.CLEAN_AUDIT_TRAIL(
            AUDIT_TRAIL_TYPE => DBMS_AUDIT_MGMT.AUDIT_TRAIL_UNIFIED,
            USE_LAST_ARCH_TIMESTAMP => FALSE,
            CONTAINER => DBMS_AUDIT_MGMT.CONTAINER_ALL);
END;
/

PL/SQL procedure successfully completed.

SQL> select count(*) as row_count
from UNIFIED_AUDIT_TRAIL;

 ROW_COUNT
----------
         1

SQL>
```