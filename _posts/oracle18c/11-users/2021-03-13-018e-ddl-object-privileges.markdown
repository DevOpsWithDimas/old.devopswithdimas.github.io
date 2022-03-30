---
layout: post
title: "DDL - Object Privileges"
date: 2021-03-13T03:44:03+07:00
lang: oracle18c
authors:
- dimasm93
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/18/dbseg/configuring-privilege-and-role-authorization.html#GUID-1592480B-9EFC-4C3F-B84F-F518A5B80CF9
- https://docs.oracle.com/en/database/oracle/oracle-database/18/sqlrf/GRANT.html#GUID-20B4E2C0-A7F8-4BC8-A5E8-BE61BDC41AC3__BGBCIIEG
youtube: fNpkoWwmEi4
comments: true
catalog_key: ddl-user-management
image_path: /resources/posts/oracle12c/018e-ddl-object-privileges
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Sebuah Oject Privilege yaitu digunakan melakukan beberapa action atau perintah SQL pada object database (table, view, index) pada user/schema lain.

Berikut adalah daftar / list Object Privileges yang sering digunakan pada suatu table atau view

1. `SELECT` / `READ`, mengijikan untuk melakukan perintah select ke table tersebut
2. `INSERT`, mengijikan untuk melakukan perintah insert ke tabel tersebut
3. `UPDATE`, mengijinkan untuk melakukan perintah update data semua atau beberapa column saja pada suatu table tersebut
4. `DELETE`, mengijikan untuk melakukan perintah delete data pada table tersebut
5. `ALTER`, mengijinkan untuk memodifikasi strutur object (table atau view)
6. `INDEX`, mengijikan untuk membuat index
7. `REFERENCES`, mengijikan untuk membuat foreign key berdasarkan column pada table tersebut.
8. `DEBUG`, mengijinkan untuk melihat log jika PL/SQL di execute

Untuk lebih lengkapnya, boleh baca [disini](https://docs.oracle.com/en/database/oracle/oracle-database/18/sqlrf/GRANT.html#GUID-20B4E2C0-A7F8-4BC8-A5E8-BE61BDC41AC3__BGBCIIEG)

Jadi misalnya disini kita login sebagai user `toko_online` sekarang saya mau coba select ke tablenya `employees` dari user / schema `hr` seperti berikut:

```sql
bash> sqlplus toko_online/toko@XEPDB1

SQL*Plus: Release 18.0.0.0.0 - Production on Fri Mar 12 19:24:30 2021
Version 18.4.0.0.0

Copyright (c) 1982, 2018, Oracle.  All rights reserved.


Connected to:
Oracle Database 18c Express Edition Release 18.0.0.0.0 - Production
Version 18.4.0.0.0

SQL> select employee_id, first_name
from hr.employees;

from hr.employees
        *
ERROR at line 2:
ORA-01031: insufficient privileges
```

## `GRANT` Object Privileges

Sekarang coba login sebagai `system` kemudian jalankan perintah berikut:

{% gist page.gist "018e-ddl-object-privileges-specific.sql" %}

Sekarang coba jalankan maka, hasilnya seperti berikut:

```sql
bash> sqlplus system/passwordnyaOracle18@XEPDB1

SQL*Plus: Release 18.0.0.0.0 - Production on Fri Mar 12 20:07:05 2021
Version 18.4.0.0.0

Copyright (c) 1982, 2018, Oracle.  All rights reserved.

Last Successful login time: Fri Mar 12 2021 19:26:37 +00:00

Connected to:
Oracle Database 18c Express Edition Release 18.0.0.0.0 - Production
Version 18.4.0.0.0

SQL> grant READ, UPDATE, REFERENCES
    on hr.EMPLOYEES
    to toko_online;

Grant succeeded.

SQL> conn toko_online/toko@XEPDB1
Connected.

SQL> select employee_id, first_name
from hr.employees
where manager_id is null;

EMPLOYEE_ID FIRST_NAME
----------- --------------------
        100 Steven

SQL>
```

Selain itu juga kita bisa memberikan semua access object privileges ke user tersebut dengan perintah berikut:

{% gist page.gist "018e-ddl-object-privileges-grant-all.sql" %}

## Menampilkan informasi Object privilages

Untuk menampilkan Object Privileges apa saja yang telah di berikan kita bisa menggunakan perintah seperti berikut:

{% gist page.gist "018e-ddl-object-privileges-info.sql" %}

Maka hasilnya seperti berikut:

```sql
sqlplus system/passwordnyaOracle18@XEPDB1

SQL*Plus: Release 18.0.0.0.0 - Production on Fri Mar 12 20:12:09 2021
Version 18.4.0.0.0

Copyright (c) 1982, 2018, Oracle.  All rights reserved.

Last Successful login time: Fri Mar 12 2021 20:07:05 +00:00

Connected to:
Oracle Database 18c Express Edition Release 18.0.0.0.0 - Production
Version 18.4.0.0.0

SQL> select OWNER, TABLE_NAME, PRIVILEGE, GRANTOR
from DBA_TAB_PRIVS
where GRANTEE = 'TOKO_ONLINE'
order by TABLE_NAME, PRIVILEGE;

OWNER TABLE_NAME           PRIVILEGE            GRANT
----- -------------------- ---------------      -----
HR    DEPARTMENTS          ALTER                HR
HR    DEPARTMENTS          DEBUG                HR
HR    DEPARTMENTS          DELETE               HR
HR    DEPARTMENTS          FLASHBACK            HR
HR    DEPARTMENTS          INDEX                HR
HR    DEPARTMENTS          INSERT               HR
HR    DEPARTMENTS          ON COMMIT REFRESH    HR
HR    DEPARTMENTS          QUERY REWRITE        HR
HR    DEPARTMENTS          READ                 HR
HR    DEPARTMENTS          REFERENCES           HR
HR    DEPARTMENTS          SELECT               HR
HR    DEPARTMENTS          UPDATE               HR
HR    EMPLOYEES            READ                 HR
HR    EMPLOYEES            REFERENCES           HR
HR    EMPLOYEES            UPDATE               HR

15 rows selected.
```

## `GRANT` update specific columns

Terkadang kita hanya di perbolehkan untuk melakukan update pada beberapa kolom saja pada suatu table di schema orang lain. Berikut implementasinya:

Login sebagai `system` kemudian jalan perintah berikut:

{% gist page.gist "018e-dll-object-privileges-update-specific-column.sql" %}

Sekarang coba jalankan, maka hasilnya seperti berikut:

```sql
bash> sqlplus toko_online/toko@XEPDB1

SQL*Plus: Release 18.0.0.0.0 - Production on Fri Mar 12 20:12:09 2021
Version 18.4.0.0.0

Copyright (c) 1982, 2018, Oracle.  All rights reserved.

Last Successful login time: Fri Mar 12 2021 20:07:05 +00:00

Connected to:
Oracle Database 18c Express Edition Release 18.0.0.0.0 - Production
Version 18.4.0.0.0

SQL> update hr.EMPLOYEES
set SALARY = 25000
where EMPLOYEE_ID = 100;  2    3
update hr.EMPLOYEES
          *
ERROR at line 1:
ORA-01031: insufficient privileges

SQL> conn system/passwordnyaOracle18@XEPDB1
Connected

SQL> grant select, update (SALARY, COMMISSION_PCT) on hr.EMPLOYEES
    to toko_online;  2

Grant succeeded.

SQL> select OWNER, TABLE_NAME, PRIVILEGE, GRANTOR
from DBA_TAB_PRIVS
where GRANTEE = 'TOKO_ONLINE'
order by TABLE_NAME, PRIVILEGE;

OWNER TABLE_NAME           PRIVILEGE       GRANT
----- -------------------- --------------- -----
HR    EMPLOYEES            SELECT          HR

SQL> conn toko_online/toko@XEPDB1
Connected.

SQL> update hr.EMPLOYEES
set FIRST_NAME = 'Dimas'
where EMPLOYEE_ID = 100;
update hr.EMPLOYEES
          *
ERROR at line 1:
ORA-01031: insufficient privileges


SQL> update hr.EMPLOYEES
set SALARY = 25000
where EMPLOYEE_ID = 100;

1 row updated.
```

## `REVOKE` object privileges

Untuk mencabut hak akses dari user tersebut, kita bisa menggunakan perintah:

{% gist page.gist "018e-ddl-object-privileges-revoke.sql" %}

Atau kita juga bisa mencabut semuanya dengan perintah berikut:

{% gist page.gist "018e-ddl-object-privileges-rovoke-all.sql" %}