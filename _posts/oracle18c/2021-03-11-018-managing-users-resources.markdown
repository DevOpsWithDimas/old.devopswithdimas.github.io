---
layout: post
title: "Managing Users and Resource di Oracle"
date: 2021-03-11T11:25:26+07:00
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/18/admin/managing-users-and-securing-the-database.html#GUID-6ECD7474-E756-4B3E-B5CF-2B92B1BCACA1
- https://docs.oracle.com/en/database/oracle/oracle-database/18/admin/getting-started-with-database-administration.html#GUID-C7B90809-E930-44BF-B836-F760B0989BB0
- https://docs.oracle.com/en/database/oracle/oracle-database/18/admin/getting-started-with-database-administration.html#GUID-10287280-C2E4-4FB1-ABF9-993327419603
youtube: 
comments: true
image_path: /resources/posts/oracle12c/
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Pada Oracle Database untuk konek ke Database perlu login menggunakan username yang telah terdaftar di System Database Oracle. Untuk mengetahui suatu account kita bisa lihat atau check di Static Data Dictionary View.

{% highlight sql %}
select * 
from ALL_USERS;
{% endhighlight %}

Berikut hasilnya:

```sql
   USER_ID USERNAME             CREATED   O
---------- -------------------- --------- -
         0 SYS                  18-OCT-18 Y
         8 AUDSYS               18-OCT-18 Y
         9 SYSTEM               18-OCT-18 Y
2147483617 SYSBACKUP            18-OCT-18 Y
2147483618 SYSDG                18-OCT-18 Y
2147483619 SYSKM                18-OCT-18 Y
2147483620 SYSRAC               18-OCT-18 Y
        13 OUTLN                18-OCT-18 Y
2147483638 XS$NULL              18-OCT-18 Y
        21 GSMADMIN_INTERNAL    18-OCT-18 Y
        22 GSMUSER              18-OCT-18 Y
        23 DIP                  18-OCT-18 Y
        34 REMOTE_SCHEDULER_AGE 18-OCT-18 Y
           NT
        35 DBSFWUSER            18-OCT-18 Y
        39 ORACLE_OCM           18-OCT-18 Y
        46 SYS$UMF              18-OCT-18 Y
        53 DBSNMP               18-OCT-18 Y
        54 APPQOSSYS            18-OCT-18 Y
        58 GSMCATUSER           18-OCT-18 Y
        59 GGSYS                18-OCT-18 Y
        61 XDB                  18-OCT-18 Y
        62 ANONYMOUS            18-OCT-18 Y
        71 WMSYS                18-OCT-18 Y
   1279990 DVSYS                18-OCT-18 Y
        80 OJVMSYS              18-OCT-18 Y
        82 CTXSYS               18-OCT-18 Y
        84 ORDSYS               18-OCT-18 Y
        85 ORDDATA              18-OCT-18 Y
        86 ORDPLUGINS           18-OCT-18 Y
        87 SI_INFORMTN_SCHEMA   18-OCT-18 Y
        88 MDSYS                18-OCT-18 Y
        91 OLAPSYS              18-OCT-18 Y
        94 MDDATA               18-OCT-18 Y
        96 LBACSYS              18-OCT-18 Y
        98 DVF                  18-OCT-18 Y
       101 HR                   11-FEB-21 Y
```

## Type Of Oracle Database User

Dari sekian banyak user dari Data Dictionary View diatas, ada beberapa kategori User di Oracle yaitu

1. Database Administrators
    
    Setiap database membutuhkan at least satu Database Administrator atau yang sering kita kenal yaitu DBA. Oracle Database bisa banyak sekali user (multi users), Tugasnya dari salah satu Database Administrator adalah melakukan management user.

2. Security Officers

    Dalam beberapa kasus, tidak hanya Database Administrator saja di Oracle bisa dibagi lagi sebagai contoh Security Officers yang bisa melakukan Management User yang lebih spesifik sebagai contoh melakukan Enrolls Users, Controls & Monitors User Access ke database dan Maintanances system security.

3. Network Administrator

    Untuk network administrator, salah satu tugasnya menjaga networking dalam Oracle Database seperti Start/Stop Service, Management Cluster, Management Sharding dan lain-lain.

4. Application Developers

    Untuk Application Developer, biasanya adalah design dan implementaion database application

5. Application Administrator

    Untuk Application Adminstrator, biasanya tugasnya adalah An Oracle Database site can assign one or more application administrators to administer a particular application.

6. Database User

    Database User adalah user account yang berinteraksi dengan database melalui application atau utilities.

## Predefined User Account

Ketika kita install Oracle Database, ini datang dengan beberapa User Secara Default yaitu 

1. Administrative Accounts

    `SYS`, `SYSTEM`, `SYSBACKUP`, `SYSDG`, `SYSKM` dan `SYSRAC` adalah Administrative Account atau (DBA)

    - `SYS`, Ketika Oracle di install, automatically semua privilages diterapkan pada account ini
    - `SYSTEM`, Ketika Oracle di install, automatically semua privileges di terapkan pada account ini dan granted `DBA` role. 
    - `SYSBACKUP, SYSDG, SYSKM & SYSRAC`, Ketika Oracle di install beberapa privileges dan role diterapkan pada user tersebut seperti untuk backup & restor, design, start-stop service dan lain-lain.

2. Sample Schema Accounts

    Selain itu juga oracle, menyediakan sample schama seperti yang telah kita gunakan di materi sebelumnya yaitu schema `HR`, `SH`, `OE`. Untuk schema `SH` dan `OE` hanya tersedia di Oracle Enterprice Edition ya.

3. Internal Accounts

    Selain itu ada beberapa juga User Account yang oracle buat untuk Oracle Database Feature atau Component yang tida bisa digunakan alias tidak bisa login.

## Summary

Jadi jika kita mau melakukan management user kita perlu account yang memiliki grant `CREATE USER`, atau dengan role `DBA` yaitu sebagai contoh `system`