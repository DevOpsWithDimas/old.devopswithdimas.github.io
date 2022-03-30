---
layout: post
title: "DDL - System Privileges"
date: 2021-03-13T01:43:29+07:00
lang: oracle18c
authors:
- dimasm93
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/18/dbseg/configuring-privilege-and-role-authorization.html#GUID-6F401301-B5EA-482E-9615-21FD840CAF60
- https://docs.oracle.com/en/database/oracle/oracle-database/18/sqlrf/GRANT.html#GUID-20B4E2C0-A7F8-4BC8-A5E8-BE61BDC41AC3__BABEFFEE
youtube: 4WFIAwZ6oGM
comments: true
catalog_key: ddl-user-management
image_path: /resources/posts/oracle12c/018d-ddl-system-privileges
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

System Privileges yaitu hak akses untuk User Accounts me-execute Data Definition Language (DDL) Statement dan Control Statement terhadap object di Database seperti `CREATE TABLE`, `ALTER TABLE`, `CREATE SEQUENCE` dan lain-lain. Ada banyak sekali System Privileges di Oracle Database diantaranya:

1. Flashback Data Archives
2. Indexes
3. Procedures
4. Profiles
5. Roles
6. Sequences
7. Sessions
8. Tables
9. Trigger
10. Types
11. User
12. View
13. Dan masih banyak lagi untuk lebih lengkapnya bisa check [di sini](https://docs.oracle.com/en/database/oracle/oracle-database/18/sqlrf/GRANT.html#GUID-20B4E2C0-A7F8-4BC8-A5E8-BE61BDC41AC3__BABEFFEE)

Untuk mengetahui suatu user telah di berikan hak akses (privileges) tertentu kita bisa menggunakan query seperti berikut:

{% gist page.gist "018d-ddl-system-privileges-info.sql" %}

Dengan System Privileges kita bisa memberikan hak akses kepada user tersebut dan juga mencabutnya menggunakan perintah

1. `GRANT`, untuk memberikan ijin terhadap user tertentu
2. `REVOKE`, untuk mencabut ijin privileges dari user tertentu

## `GRANT` System Privileges

Untuk memberikan ijin terhadap user tertentu sebagai contoh bisa membuat table, membuat sequences, membuat view, membuat index, dan procecure maka perintahnya seperti berikut:

{% gist page.gist "018d-ddl-system-privileges-grant.sql" %}

Jika di jalankan maka hasilnya seperti berikut:

```sql
bash> sqlplus system/passwordnyaOracle18@XEPDB1

SQL*Plus: Release 18.0.0.0.0 - Production on Fri Mar 12 18:09:38 2021
Version 18.4.0.0.0

Copyright (c) 1982, 2018, Oracle.  All rights reserved.

Last Successful login time: Fri Mar 12 2021 17:14:02 +00:00

Connected to:
Oracle Database 18c Express Edition Release 18.0.0.0.0 - Production
Version 18.4.0.0.0

SQL> select *
from DBA_SYS_PRIVS
where GRANTEE = 'TOKO_ONLINE';

GRANTEE     PRIVILEGE                                ADM COM INH
----------- ---------------------------------------- --- --- ---
TOKO_ONLINE CREATE SESSION                           NO  NO  NO

SQL> conn toko_online/toko@XEPDB1
Connected.

SQL> create table test_table(
  2  id varchar2(10) not null);
create table test_table(
*
ERROR at line 1:
ORA-01031: insufficient privileges


SQL> conn system/passwordnyaOracle18@XEPDB1
Connected.

SQL> grant create table,
    create sequence,
    create any index,
    create view,
    create procedure
to TOKO_ONLINE;

Grant succeeded.

SQL> conn toko_online/toko@XEPDB1
Connected.
SQL> create table test_created(
  2  id varchar2(10) not null);

Table created.

SQL> select table_name from tabs;

TABLE_NAME
------------------------------
TEST_CREATED

SQL> conn system/passwordnyaOracle18@XEPDB1
Connected.

SQL> select * from DBA_SYS_PRIVS where GRANTEE = 'TOKO_ONLINE';

GRANTEE     PRIVILEGE                                ADM COM INH
----------- ---------------------------------------- --- --- ---
TOKO_ONLINE CREATE TABLE                             NO  NO  NO
TOKO_ONLINE CREATE VIEW                              NO  NO  NO
TOKO_ONLINE CREATE PROCEDURE                         NO  NO  NO
TOKO_ONLINE CREATE SESSION                           NO  NO  NO
TOKO_ONLINE CREATE SEQUENCE                          NO  NO  NO
TOKO_ONLINE CREATE ANY INDEX                         NO  NO  NO

6 rows selected.
```

Selain itu juga kita bisa memberikan semua hak access ke user tersebut dengan perintah seperti berikut:

{% gist page.gist "018d-ddl-system-privileges-grant-all.sql" %}

## `REVOKE` System Privileges

Selain itu juga kita bisa mencabut hak aksesnya dengan menggunakan perintah `revoke <roles, ...> from <user>`. Contohnya saya mau menghapus privileges create view berikut adalah querynya:

{% gist page.gist "018d-ddl-system-privileges-revoke.sql" %}

Jika di jalankan maka hasilnya seperti berikut:

```sql
SQL> conn system/passwordnyaOracle18@XEPDB1
Connected.

SQL> select *
from DBA_SYS_PRIVS
where GRANTEE = 'TOKO_ONLINE';

GRANTEE     PRIVILEGE                                ADM COM INH
----------- ---------------------------------------- --- --- ---
TOKO_ONLINE CREATE TABLE                             NO  NO  NO
TOKO_ONLINE CREATE VIEW                              NO  NO  NO
TOKO_ONLINE CREATE PROCEDURE                         NO  NO  NO
TOKO_ONLINE CREATE SESSION                           NO  NO  NO
TOKO_ONLINE CREATE SEQUENCE                          NO  NO  NO
TOKO_ONLINE CREATE ANY INDEX                         NO  NO  NO

6 rows selected.

SQL> revoke create view from TOKO_ONLINE;

Revoke succeeded.

SQL> select *
from DBA_SYS_PRIVS
where GRANTEE = 'TOKO_ONLINE';

GRANTEE     PRIVILEGE                                ADM COM INH
----------- ---------------------------------------- --- --- ---
TOKO_ONLINE CREATE TABLE                             NO  NO  NO
TOKO_ONLINE CREATE PROCEDURE                         NO  NO  NO
TOKO_ONLINE CREATE SEQUENCE                          NO  NO  NO
TOKO_ONLINE CREATE SESSION                           NO  NO  NO
TOKO_ONLINE CREATE ANY INDEX                         NO  NO  NO


SQL> conn toko_online/toko@XEPDB1
Connected.

SQL> create or replace view v_test_data as select * from TEST_CRATETED;
create or replace view v_test_data as select * from TEST_CRATETED
                       *
ERROR at line 1:
ORA-01031: insufficient privileges
```

Selain itu juga kita bisa cabut semua privilege-nya dengan perintah seperti berikut:

{% gist page.gist "018d-dll-system-privileges-revoke-all.sql" %}