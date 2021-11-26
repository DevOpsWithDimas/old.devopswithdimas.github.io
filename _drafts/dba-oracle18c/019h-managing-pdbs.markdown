---
layout: post
title: "Managing PDBs dan Application Containers"
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/18/multi/creating-pdbs.html#GUID-9A250D93-5B3B-4643-BE85-F32CC7B0E413
- https://oracle-base.com/articles/12c/multitenant-startup-and-shutdown-cdb-and-pdb-12cr1
youtube: 
comments: true
catalog_key: design-db
image_path: /resources/posts/oracle12c/019a-managing-pdbs
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Sebagai Database Administrator (DBA), kita bisa membuat `PLUGGABLE DATABASE` (PDBs) dalam CDB seperti pada Architecture Multitenant Environment berikut:

![architecture multitenant environment](https://docs.oracle.com/en/database/oracle/oracle-database/18/multi/img/admin112.png)

Untuk melihat informasi pdb yang tersedia pada system, berikut adalah caranya:

```sql
bash-4.2# su oracle
[oracle@89f865b61452 /]$ sqlplus / as sysdba

SQL*Plus: Release 18.0.0.0.0 - Production on Sun Mar 21 12:31:48 2021
Version 18.4.0.0.0

Copyright (c) 1982, 2018, Oracle.  All rights reserved.


Connected to:
Oracle Database 18c Express Edition Release 18.0.0.0.0 - Production
Version 18.4.0.0.0

SQL> select sys_context('userenv', 'con_name')
from dual;

SYS_CONTEXT('USERENV','CON_NAME')
----------------------------------
CDB$ROOT

SQL> col con_id format a3
SQL> col pdb_name format a10
SQL> col status format a8SQL>

SQL> select con_id, pdb_name, status
from dba_pdbs;

    CON_ID PDB_NAME   STATUS
---------- ---------- --------
########## XEPDB1     NORMAL
########## PDB$SEED   NORMAL

SQL> col name format a20
SQL> col open_mode format a20

SQL> select name, open_mode
from v$pdbs;

NAME                 OPEN_MODE
-------------------- --------------------
PDB$SEED             READ ONLY
XEPDB1               READ WRITE
```

## Creating a PDB from Scratch

Untuk membuat PDB dalam sebuah CDB, kita memerlukan file PDB seed `PDB$SEED`. Yang perlu di ingat di Oracle Database 18 XE hanya di perbolehkan 3 PDBs yang terkoneksi include `PDB$SEED` dan `XEPDB1`. Untuk membuatnya berikut adalah perintahnya:

{% gist page.gist "019a-pdb-create.sql" %}

Setelah pdb created, kita blum bisa access databasenya. kita perlu activekan dulu dengan perintah berikut:

{% gist page.gist "019a-pdb-enabled-disable.sql" %}

Jika di jalankan maka seperti berikut hasilnya:

```sql
su oracle
[oracle@89f865b61452 /]$ sqlplus / as sysdba

SQL*Plus: Release 18.0.0.0.0 - Production on Sun Mar 21 12:31:48 2021
Version 18.4.0.0.0

Copyright (c) 1982, 2018, Oracle.  All rights reserved.

Connected to:
Oracle Database 18c Express Edition Release 18.0.0.0.0 - Production
Version 18.4.0.0.0

SQL> CREATE PLUGGABLE DATABASE ecommerce_pdb
    ADMIN USER pdb_admin IDENTIFIED BY passwordnyaTokoOnline2021 ROLES = (DBA)
    PATH_PREFIX = '/opt/oracle/oradata/'
    STORAGE (MAXSIZE 2 G MAX_SHARED_TEMP_SIZE 256M)
    FILE_NAME_CONVERT = ('/opt/oracle/oradata/XE/pdbseed','/opt/oracle/oradata/XE/ecommerce_pdb/')
    DEFAULT TABLESPACE data
        DATAFILE '/opt/oracle/oradata/XE/ecommerce_pdb/data_01.dbf' SIZE 25 M AUTOEXTEND ON MAXSIZE 512 M
    TEMPFILE REUSE;

Pluggable database created.

SQL> -- for enabled
alter pluggable database ecommerce_pdb
    open READ WRITE;

PDB altered.

SQL> col con_id format a10
SQL> col pdb_name format a10
SQL> col status format a8

SQL> select con_id, pdb_name, status
from dba_pdbs;

    CON_ID PDB_NAME   STATUS
---------- ---------- --------
########## XEPDB1     NORMAL
########## PDB$SEED   NORMAL
########## ECOMMERCE_ NORMAL
           PDB

SQL> col name format a20
SQL> col open_mode format a20

SQL> select name, open_mode
from v$pdbs;

NAME                 OPEN_MODE
-------------------- --------------------
PDB$SEED             READ ONLY
XEPDB1               READ WRITE
ECOMMERCE_PDB        READ WRITE

SQL>
```

Dengan seperti itu kita bisa login menggunakan 

1. PDB Name => `ecommerce_pdb`
2. Username => `pdb_admin` 
3. Password => `passwordnyaTokoOnline2021` 

Seperti berikut:

```sql
bash> sqlplus pdb_admin/passwordnyaTokoOnline2021@ecommerce_pdb

SQL*Plus: Release 18.0.0.0.0 - Production on Sun Mar 21 12:31:48 2021
Version 18.4.0.0.0

Copyright (c) 1982, 2018, Oracle.  All rights reserved.


Connected to:
Oracle Database 18c Express Edition Release 18.0.0.0.0 - Production
Version 18.4.0.0.0

SQL> select sys_context('userenv', 'con_name')
from dual;

SYS_CONTEXT('USERENV','CON_NAME')
---------------------------------
ECOMMERCE_PDB        

SQL> create user catalog identified by catalog2021
default tablespace data
quota 10 m on data
account unlock;

SQL> grant connect, resource, RESTRICTED SESSION 
  to catalog;
```

Penjelasan dari membuat plugedable database diatabase, seperti berikut:

1. Perintah `ADMIN USER pdb_admin IDENTIFIED BY your-password ROLES = (DBA)` artinya kita akan membuat user dengan nama `pdb_admin` yang digunakan untuk me-manage database tersebut
2. Perintah `PATH_PREFIX = '/opt/oracle/oradata/'` adalah dimana lokasi data di simpan
3. Perintah `STORAGE (MAXSIZE 2 G MAX_SHARED_TEMP_SIZE 256M)` artinya kita hanya bisa menggunakan database tidak boleh lebih dari 2GB
4. Perintah `FILE_NAME_CONVERT = ('/opt/oracle/oradata/XE/pdbseed','/opt/oracle/oradata/XE/ecommerce_pdb/')` artinya kita melakukan clone dari file `/opt/oracle/oradata/XE/pdbseed` yang akan di jadikan database baru. **Lokasi file seed pdb berbeda setiap OS please check dokumentasi**
5. Perintah `DATAFILE '/opt/oracle/oradata/XE/ecommerce_pdb/data_01.dbf'` artinya filenya akan ditulis di lokasi tertentu


**Notes**, Jika tidak bisa konek lewat SQL*Plus kita perlu tambahkan config pada `$ORACLE_HOME/network/admin/tnsnames.ora` seperti berikut:

{% highlight config %}
ECOMMERCE_PDB =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = 0.0.0.0)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = ECOMMERCE_PDB)
    )
  )
{% endhighlight %}

## Drop pluged-in Database (PDBs)

Untuk menghapus, kita harus close dulu databasenya jika statusnya masih open, dengan perintah seperti berikut:

{% gist page.gist "019a-pdb-disabled.sql" %}

Kemudian 

{% gist page.gist "019a-pdb-drop" %}