---
layout: post
title: "DDL - Create User Account"
date: 2021-03-11T14:21:28+07:00
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/18/admin/managing-users-and-securing-the-database.html#GUID-B20E4AFB-592E-42BD-8485-36EEDA033035
- https://docs.oracle.com/en/database/oracle/oracle-database/18/dbseg/managing-security-for-oracle-database-users.html#GUID-4C383489-6BB4-439A-8293-42F9E6191C85
- https://docs.oracle.com/en/database/oracle/oracle-database/18/dbseg/managing-security-for-oracle-database-users.html#GUID-81D0494C-E838-4DD9-AC82-B56473F98D06
- https://docs.oracle.com/en/database/oracle/oracle-database/18/dbseg/managing-security-for-oracle-database-users.html#GUID-E7CA1DB2-54E2-427D-A69A-BF53DA74FCE1
- https://docs.oracle.com/en/database/oracle/oracle-database/18/cncpt/logical-storage-structures.html#GUID-3502CA78-FBC9-4927-B455-0ECB22E53066
youtube: ggqK5JxqQ8s
comments: true
image_path: /resources/posts/oracle12c/018a-ddl-users
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Untuk membuat User Account ada beberapa aturan yang berubah semenjak Oracle Database 12c, yaitu 

1. About Common Users and Local Users
2. Create a New User Account dengan minimum database privileges 
3. Restriction ketika membuat user baru
4. Assignment of User Password
5. Default Tablespace untuk User
6. Tablespace Quota untuk User
7. Temporary Tablespace untuk User
8. Profiles untuk User

## About Common Users and Local Users

Dalam sebuah multitenant environtment terdiri dari Common users and application common (CDB), dan local users spesific ke Plugging in Database (PDB)

![plugging in database (PDB)](https://docs.oracle.com/en/database/oracle/oracle-database/18/dbseg/img/dbseg_vm_011a.png)

Secara default kita akan dibuatkan Plugging in Database ketika di install seperti berikut lognya:

```bash
Connect to Oracle Database using one of the connect strings:
     Pluggable database: sandbox.oraclexe-18c/XEPDB1
     Multitenant container database: sandbox.oraclexe-18c
Use https://localhost:5500/em to access Oracle Enterprise Manager for Oracle Database XE
oracle_1  | #########################
oracle_1  | DATABASE IS READY TO USE!
oracle_1  | #########################
[root@sandbox ~]#
```

Untuk CDB atau Root Database seperti yang kita gunakan pada saat login yaitu `XE`, sedangkan untuk PDB yang kita bisa gunakan adalah `XEPDB1` untuk setiap edition ini mungkin berbeda jadi tinggal sesuaikan saja. atau klo mau buat sendiri juga bisa, coba baca [disini](https://docs.oracle.com/en/database/oracle/oracle-database/18/dbseg/managing-security-for-oracle-database-users.html#GUID-81D0494C-E838-4DD9-AC82-B56473F98D06)

Untuk membuat user di CDB, ada beberapa aturan seperti

1. Harus connect ke CDB ROOT dan user yang digunakan granted `create user` pada system privileges
2. Nama pada user yang akan dibuat harus menggunakan prefix `c##` atau `C##` contohnya `c##hr_admin`
3. Baca lebih lanjut [disini](https://docs.oracle.com/en/database/oracle/oracle-database/18/dbseg/managing-security-for-oracle-database-users.html#GUID-E7CA1DB2-54E2-427D-A69A-BF53DA74FCE1)

Sedangkan untuk membuat Local User di PDB, seperti berikut:

1. Harus connect ke Plugging in Database dan user yang digunakan granted `create user` pada system privilegesnya
2. Kebalikan dari CDB, tidak boleh menggunakan prefix `c##` contohsnya seperti `hr_admin`
3. Baca selengkapnya [disini](https://docs.oracle.com/en/database/oracle/oracle-database/18/dbseg/managing-security-for-oracle-database-users.html#GUID-AC05DF7C-618A-4C72-9F9A-89FBDB734AD0)

## Create a New User Account dengan minimum database privileges 

Berikut adalah contoh untuk membuat user minimal atribute di Oracle database

```sql
CREATE USER <your-username> 
 IDENTIFIED BY <your-password> 
 DEFAULT TABLESPACE <your-tablespace> 
 QUOTA <number of quota> <type size of quota> ON users;
```

Setelah user terbuat, kita harus berikan ijin access menggunakan 

```sql
grant create session to <your-new-username>
```

## Restriction ketika membuat user baru

Untuk membuat user ada beberapa ketentuan seperti 

1. Uniqueness of User Names
2. Case Sensitivity for User Names
3. Tidak boleh menggunakan keywork yang sudah ada
4. Untuk penamaan username sebagikan menggunakan nama dari aplikasi yang akan dibuat sebagai contoh `sales`, `hrd`, `perputakaan` dan lain-lain.

## Assignment of User Password

Pemberian password di Oracle ada ketentuan minimumnya seperti:

1. Passwords can be at most 30 bytes long
2. Atau berikut adalah beberapa rekomendasi securing password [baca disini](https://docs.oracle.com/en/database/oracle/oracle-database/18/dbseg/keeping-your-oracle-database-secure.html#GUID-451679EB-8676-47E6-82A6-DF025FD65156)

## Default Tablespace untuk User

Tablespace yaitu logical storage container (wadah) segments. dan Segments adalah database object seperti table, index, sequences dan lain-lain yang meng-consume storage space.

![data files & tablespaces](https://docs.oracle.com/en/database/oracle/oracle-database/18/cncpt/img/cncpt037.gif)

## Tablespace Quota untuk User

Kita bisa melimit suatu storage space dalam user yang akan dibuat dengan menggunakan `TABLESPACE QUOTA` dan juga memberikan `QUOTA UNLIMITED` artinya tidak kita batas.

Setelah kita membahas semua attributenya, berikut adalah cara membuat user yang sederhana:

1. Login sebagai `system` di PDB sebagai contoh `XEPDB1`

    {% highlight bash %}
    sqlplus system/passwordnyaOracle18c@XEPDB1
    {% endhighlight %}

2. Kemudian buat user dengan perintah berikut:

    {% gist page.gist "018a-ddl-create-user.sql" %}

3. Kemudian berikan access untuk login dengan perintah berikut:

    {% gist page.gist "018a-ddl-grant-session.sql" %}

4. Kemudian coba logout dari user `system@XEPDB1`, kemudian login lagi dengan user yang baru dibuat seperti berikut:

    {% highlight bash %}
    conn toko_online/toko@XEPDB1
    {% endhighlight %}

Maka hasilnya seperti berikut:

```sql
sqlplus system/passwordnyaOracle18@XEPDB1

SQL*Plus: Release 18.0.0.0.0 - Production on Thu Mar 11 06:23:48 2021
Version 18.4.0.0.0

Copyright (c) 1982, 2018, Oracle.  All rights reserved.

Last Successful login time: Thu Mar 11 2021 05:27:01 +00:00

Connected to:
Oracle Database 18c Express Edition Release 18.0.0.0.0 - Production
Version 18.4.0.0.0

SQL> create user toko_online
    identified by toko
    default tablespace users
    quota 10 M on users
    account unlock;

User created.

SQL> grant   create session
to toko_online;

Grant succeeded.

SQL> conn toko_online/toko@XEPDB1
Connected.
SQL> select user from dual;

USER
--------------------
TOKO_ONLINE
```