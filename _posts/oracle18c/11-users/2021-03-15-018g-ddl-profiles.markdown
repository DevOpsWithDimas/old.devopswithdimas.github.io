---
layout: post
title: "DDL - Managing Resource & Password dengan Profiles"
date: 2021-03-15T08:47:39+07:00
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/18/dbseg/managing-security-for-oracle-database-users.html#GUID-967DDBF5-0F22-411B-B291-96594CA0E646
- https://docs.oracle.com/en/database/oracle/oracle-database/18/dbseg/managing-security-for-oracle-database-users.html#GUID-BB24B5D4-096E-4448-BC0F-4B126515220A
- https://docs.oracle.com/en/database/oracle/oracle-database/18/dbseg/configuring-authentication.html#GUID-CF1A8C33-5342-4257-AE8F-CF0BA437F65C
youtube: 
comments: true
image_path: /resources/posts/oracle12c/018g-profiles
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Profile yaitu sekumpulan Resource System (KERNEL) dan Password Management yang diterapkan ke pada User Database. User Account secara default memiliki profile `DEFAULT` dimana profile tersebut kita bisa liat di [Static Data Dictionary View](https://docs.oracle.com/en/database/oracle/oracle-database/18/dbseg/managing-security-for-oracle-database-users.html#GUID-E97D53DC-BA9E-4F2C-B4C8-A450500234BE__BABGJFHJ) yang berkaitan dengan User dan Profiles

```sql
sqlplus system/passwordnyaOracle18@XEPDB1

SQL*Plus: Release 18.0.0.0.0 - Production on Mon Mar 15 00:19:57 2021
Version 18.4.0.0.0

Copyright (c) 1982, 2018, Oracle.  All rights reserved.

Last Successful login time: Sun Mar 14 2021 23:21:03 +00:00

Connected to:
Oracle Database 18c Express Edition Release 18.0.0.0.0 - Production
Version 18.4.0.0.0

SQL> select *
from DBA_PROFILES
order by PROFILE;

+----------------+-------------------------+-------------+---------------------------+------+---------+--------+
|PROFILE         |RESOURCE_NAME            |RESOURCE_TYPE|LIMIT                      |COMMON|INHERITED|IMPLICIT|
+----------------+-------------------------+-------------+---------------------------+------+---------+--------+
|DEFAULT         |COMPOSITE_LIMIT          |KERNEL       |UNLIMITED                  |NO    |NO       |NO      |
|DEFAULT         |SESSIONS_PER_USER        |KERNEL       |UNLIMITED                  |NO    |NO       |NO      |
|DEFAULT         |INACTIVE_ACCOUNT_TIME    |PASSWORD     |UNLIMITED                  |NO    |NO       |NO      |
|DEFAULT         |PASSWORD_GRACE_TIME      |PASSWORD     |7                          |NO    |NO       |NO      |
|DEFAULT         |PASSWORD_LOCK_TIME       |PASSWORD     |1                          |NO    |NO       |NO      |
|DEFAULT         |PASSWORD_VERIFY_FUNCTION |PASSWORD     |NULL                       |NO    |NO       |NO      |
|DEFAULT         |PASSWORD_REUSE_MAX       |PASSWORD     |UNLIMITED                  |NO    |NO       |NO      |
|DEFAULT         |PASSWORD_REUSE_TIME      |PASSWORD     |UNLIMITED                  |NO    |NO       |NO      |
|DEFAULT         |PASSWORD_LIFE_TIME       |PASSWORD     |UNLIMITED                  |NO    |NO       |NO      |
|DEFAULT         |FAILED_LOGIN_ATTEMPTS    |PASSWORD     |10                         |NO    |NO       |NO      |
|DEFAULT         |PRIVATE_SGA              |KERNEL       |UNLIMITED                  |NO    |NO       |NO      |
|DEFAULT         |CONNECT_TIME             |KERNEL       |UNLIMITED                  |NO    |NO       |NO      |
|DEFAULT         |IDLE_TIME                |KERNEL       |UNLIMITED                  |NO    |NO       |NO      |
|DEFAULT         |LOGICAL_READS_PER_CALL   |KERNEL       |UNLIMITED                  |NO    |NO       |NO      |
|DEFAULT         |LOGICAL_READS_PER_SESSION|KERNEL       |UNLIMITED                  |NO    |NO       |NO      |
|DEFAULT         |CPU_PER_CALL             |KERNEL       |UNLIMITED                  |NO    |NO       |NO      |
|DEFAULT         |CPU_PER_SESSION          |KERNEL       |UNLIMITED                  |NO    |NO       |NO      |
|ORA_STIG_PROFILE|COMPOSITE_LIMIT          |KERNEL       |DEFAULT                    |NO    |NO       |NO      |
|ORA_STIG_PROFILE|INACTIVE_ACCOUNT_TIME    |PASSWORD     |35                         |NO    |NO       |NO      |
|ORA_STIG_PROFILE|PASSWORD_LOCK_TIME       |PASSWORD     |UNLIMITED                  |NO    |NO       |NO      |
|ORA_STIG_PROFILE|PASSWORD_VERIFY_FUNCTION |PASSWORD     |ORA12C_STIG_VERIFY_FUNCTION|NO    |NO       |NO      |
|ORA_STIG_PROFILE|PASSWORD_REUSE_MAX       |PASSWORD     |10                         |NO    |NO       |NO      |
|ORA_STIG_PROFILE|PASSWORD_REUSE_TIME      |PASSWORD     |365                        |NO    |NO       |NO      |
|ORA_STIG_PROFILE|PASSWORD_LIFE_TIME       |PASSWORD     |60                         |NO    |NO       |NO      |
|ORA_STIG_PROFILE|FAILED_LOGIN_ATTEMPTS    |PASSWORD     |3                          |NO    |NO       |NO      |
|ORA_STIG_PROFILE|PRIVATE_SGA              |KERNEL       |DEFAULT                    |NO    |NO       |NO      |
|ORA_STIG_PROFILE|CONNECT_TIME             |KERNEL       |DEFAULT                    |NO    |NO       |NO      |
|ORA_STIG_PROFILE|IDLE_TIME                |KERNEL       |15                         |NO    |NO       |NO      |
|ORA_STIG_PROFILE|LOGICAL_READS_PER_CALL   |KERNEL       |DEFAULT                    |NO    |NO       |NO      |
|ORA_STIG_PROFILE|LOGICAL_READS_PER_SESSION|KERNEL       |DEFAULT                    |NO    |NO       |NO      |
|ORA_STIG_PROFILE|CPU_PER_CALL             |KERNEL       |DEFAULT                    |NO    |NO       |NO      |
|ORA_STIG_PROFILE|CPU_PER_SESSION          |KERNEL       |DEFAULT                    |NO    |NO       |NO      |
|ORA_STIG_PROFILE|SESSIONS_PER_USER        |KERNEL       |DEFAULT                    |NO    |NO       |NO      |
|ORA_STIG_PROFILE|PASSWORD_GRACE_TIME      |PASSWORD     |5                          |NO    |NO       |NO      |
+----------------+-------------------------+-------------+---------------------------+------+---------+--------+

SQL> select USERNAME, PROFILE, ACCOUNT_STATUS, AUTHENTICATION_TYPE
from DBA_USERS
where USERNAME in ('SYSTEM', 'HR', 'SALES', 'OFFICES');

+--------+-------+--------------+-------------------+
|USERNAME|PROFILE|ACCOUNT_STATUS|AUTHENTICATION_TYPE|
+--------+-------+--------------+-------------------+
|SYSTEM  |DEFAULT|OPEN          |PASSWORD           |
|OFFICES |DEFAULT|OPEN          |PASSWORD           |
|HR      |DEFAULT|OPEN          |PASSWORD           |
|SALES   |DEFAULT|OPEN          |PASSWORD           |
+--------+-------+--------------+-------------------+
```

## Resource Limit

Resource Limit digunakan untuk menentukan jumlah Resouce System yang tersedia dan kemudian membatasinya. Resource Limit sangat berguna untuk system yang besar dan Multi Users.

Database Administrator bisa me-manage resource limit yang nantinya akan di terapkan ke User Database, Ada beberapa jenis, tentang System Resouces dan limit yaitu

1. Limit to the User Session Level
2. Limit to the Database Call Level
3. Limit to CPU Time
4. Limit to Local Read (I/O)
5. Limit to Other Resources

detailnya bisa di check [disini](https://docs.oracle.com/en/database/oracle/oracle-database/18/dbseg/managing-security-for-oracle-database-users.html#GUID-B99465E3-FA95-419E-AC47-6A72F6D4E691)

## Authentication

Authentication yaitu melakukan verifikasi identity dari user account. Oracle Database memiliki build-in password protection yang digunakan untuk User Account diantaranya

1. Password Encription
2. Password complexity checking
3. Preventing password from being broken
4. Enforced case sensitivity for password
5. Passwords hashed using the 12c password version

detailnya bisa di check [disini](https://docs.oracle.com/en/database/oracle/oracle-database/18/dbseg/configuring-authentication.html#GUID-F589A896-D775-4828-89F8-6A2BBEA413FE)

## Password Complexity checking

Complexity verification check untuk melakukan check password yang di input cukup kuat dengan criteria tertentu. Untuk criterianya diantaranya ada build-in verification dan custome verification

1. Minimum Complexity
2. `verify_function_11G`, detailnya check [disini](https://docs.oracle.com/en/database/oracle/oracle-database/18/dbseg/configuring-authentication.html#GUID-02A1B034-4EB3-4CC2-B7C8-1811581D3DE1)
3. `ora12c_verify_function`, detailnya check [disini](https://docs.oracle.com/en/database/oracle/oracle-database/18/dbseg/configuring-authentication.html#GUID-F09749BF-2881-4EE5-B59D-041E4796BAC4)
4. `ora12c_strong_verify_function`, detailnya check [disini](https://docs.oracle.com/en/database/oracle/oracle-database/18/dbseg/configuring-authentication.html#GUID-1168CD4D-659E-432D-9CB7-F5733129657D)
5. `ora12c_stig_verify_function`, detailnya check [disini](https://docs.oracle.com/en/database/oracle/oracle-database/18/dbseg/configuring-authentication.html#GUID-C215C4D6-C106-44E7-BE09-26D15415C67B)
6. [PL/SQL Custome Function](https://docs.oracle.com/en/database/oracle/oracle-database/18/dbseg/configuring-authentication.html#GUID-38B80221-55AE-4928-9AC0-4CAFFD5A4E96)

## Membuat profile baru

Berikut adalah contoh membuat profile baru, dan menerapakan ke user:

{% gist page.gist "018g-profile-new.sql" %}

jika dijalankan, maka hasilnya seperti berikut:

```sql
sqlplus system/passwordnyaOracle18@XEPDB1

SQL*Plus: Release 18.0.0.0.0 - Production on Mon Mar 15 01:27:52 2021
Version 18.4.0.0.0

Copyright (c) 1982, 2018, Oracle.  All rights reserved.

Last Successful login time: Mon Mar 15 2021 00:26:34 +00:00

Connected to:
Oracle Database 18c Express Edition Release 18.0.0.0.0 - Production
Version 18.4.0.0.0

SQL> CREATE PROFILE secure_profile LIMIT
    SESSIONS_PER_USER 1
    IDLE_TIME 30
    CONNECT_TIME 600
    password_life_time 1
    password_reuse_max 3
    FAILED_LOGIN_ATTEMPTS 3
    PASSWORD_VERIFY_FUNCTION ora12c_verify_function;

Profile created.

SQL> create user dimas
    identified by &securePassword
    default tablespace users
    quota 10 m on users
    profile secure_profile;
Enter value for securepassword: dimas
old   2:     identified by &securePassword
new   2:     identified by dimas
create user dimas
*
ERROR at line 1:
ORA-28003: password verification for the specified password failed
ORA-20000: password length less than 8 bytes


SQL> /
Enter value for securepassword: DimasMaryanto
old   2:     identified by &securePassword
new   2:     identified by DimasMaryanto
create user dimas
*
ERROR at line 1:
ORA-28003: password verification for the specified password failed
ORA-20000: password must contain 1 or more digits


SQL> /
Enter value for securepassword: DimasMaryanto2021
old   2:     identified by &securePassword
new   2:     identified by DimasMaryanto2021
create user dimas
*
ERROR at line 1:
ORA-28003: password verification for the specified password failed
ORA-20000: password must contain 1 or more special characters


SQL> /
Enter value for securepassword: DimasMaryanto@2021
old   2:     identified by &securePassword
new   2:     identified by DimasMaryanto@2021
    identified by DimasMaryanto@2021
                               *
ERROR at line 2:
ORA-00922: missing or invalid option


SQL> /
Enter value for securepassword: DimasMaryanto$2021
old   2:     identified by &securePassword
new   2:     identified by DimasMaryanto$2021
create user dimas
*
ERROR at line 1:
ORA-28003: password verification for the specified password failed
ORA-20000: password contains the user name


SQL> /
Enter value for securepassword: NOLAN$n64
old   2:     identified by &securePassword
new   2:     identified by NOLAN$n64

User created.

SQL> grant connect to dimas;

Grant succeeded.

-- >> Schenario Password failed 3x
SQL> conn dimas/NOLANn63@XEPDB1
ERROR:
ORA-01017: invalid username/password; logon denied


Warning: You are no longer connected to ORACLE.
SQL> conn dimas/NOLANn63@XEPDB1
ERROR:
ORA-01017: invalid username/password; logon denied


SQL> conn dimas/NOLANn63@XEPDB1
ERROR:
ORA-01017: invalid username/password; logon denied


SQL> conn dimas/NOLANn63@XEPDB1
ERROR:
ORA-28000: The account is locked.

-- >> Schenario Multiple Session
SQL> conn system/passwordnyaOracle18@XEPDB1
Connected.

SQL> alter user dimas
identified by NOLAN$n605
account unlock ;  2    3

User altered.

SQL> connect dimas/NOLAN$n605@XEPDB1
Connected.

-- buka terminal baru
sqlplus dimas/NOLAN$n605@XEPDB1

SQL*Plus: Release 18.0.0.0.0 - Production on Mon Mar 15 01:43:42 2021
Version 18.4.0.0.0

Copyright (c) 1982, 2018, Oracle.  All rights reserved.

ERROR:
ORA-02391: exceeded simultaneous SESSIONS_PER_USER limit
```

## Merubah profile

Untuk melakukan perubahan property dari profile, kita bisa menggunakan dengan perintah `ALTER PROFILE` seperti berikut:

{% gist page.gist "018g-profile-alter-profile.sql" %}

## Menggunakan profile yang sudah ada

Untuk mengunakan profile yang sudah ada, kita bisa menggunakan perintah `ALTER USER` seperti berikut:

{% gist page.gist "018g-profile-alter-user.sql" %}

Jika di jalankan, maka hasilnya seperti berikut:

```sql
sqlplus system/passwordnyaOracle18@XEPDB1

SQL*Plus: Release 18.0.0.0.0 - Production on Mon Mar 15 01:45:41 2021
Version 18.4.0.0.0

Copyright (c) 1982, 2018, Oracle.  All rights reserved.

Last Successful login time: Mon Mar 15 2021 01:41:09 +00:00

Connected to:
Oracle Database 18c Express Edition Release 18.0.0.0.0 - Production
Version 18.4.0.0.0

SQL> alter user SALES
    profile ora_stig_profile;

User altered.
```

## Menghapus profile

Untuk menghapus profile, kita bisa menggunakan perintah `DROP`. berikut adalah penggunaanya:

{% gist page.gist "018g-profile-drop.sql" %}

Untuk `DEFAULT` Profile tidak boleh dihapus ya.