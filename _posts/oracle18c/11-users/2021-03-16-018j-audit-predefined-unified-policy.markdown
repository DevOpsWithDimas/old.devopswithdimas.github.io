---
layout: post
title: "Predefined Unified Audit Policies"
date: 2021-03-16T20:20:04+07:00
lang: oracle18c
authors:
- dimasm93
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/18/dbseg/configuring-audit-policies.html#GUID-C43651C6-A35C-4EEF-BEA7-EADA408BFF67
youtube: 
comments: true
catalog_key: monitor-audit-trail
image_path: /resources/posts/oracle12c/018j-audit-predefined-unified-policy
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Oracle Database, menyediakan beberapa unified audit policies tentang User Security Settings, diantaranya

1. Logon Failures
2. Secure Options
3. Oracle Database Parameter Changes
4. User Account and Privilege Management
5. dan Masih banyak lagi... silahkan baca [disini](https://docs.oracle.com/en/database/oracle/oracle-database/18/dbseg/configuring-audit-policies.html#GUID-C43651C6-A35C-4EEF-BEA7-EADA408BFF67)

<!--more-->

## Logon Failures Predefined Unified Audit Policy

Audit `ORA_LOGON_FAILURES` melakukan tracking terhadap user yang mencoba login tetapi gagal authentication. Untuk Oracle Database 18c secara default `enabled` tetapi di versi sebelumnya belum aktif. Untuk Mengaktifkannya menggunakan perintah berikut:

{% gist page.gist "018j-audit-logon-enabled.sql" %}

## Secure Options Predefined Unified Audit Policy

Audit `ORA_SECURECONFIG` melakukan tracking terhadap perubahan user privileges, roles, dan lain-lain. Untuk Oracle Database 18c secara default statusnya `enabled` tetapi di versi sebelumnya ada beberapa yang sudah aktif dan ada juga yang belum. Berikut adalah scriptnya:

{% gist page.gist "018j-audit-secure-option.sql" %}

## Oracle Database Parameter Changes Predefined Unified Audit Policy

Audit `ORA_DATABASE_PARAMETER` melakukan tracking terhadap perubahan parameter database, perubahan database

{% gist page.gist "018j-audit-database-parameter-changes.sql" %}

## User Account and Privilege Management Predefined Unified Audit Policy

Audit `ORA_ACCOUNT_MGMT` melakukan tracking terhadap user management seperti membuat user, alter user, drop user, grant privileges dan lain-lain. Berikut adalah scriptnya:

{% gist page.gist "018j-audit-user-privileges-management.sql" %}

Berikut adalah object Unified Predefined Policy yang ada di Oracle 18c:

{% gist page.gist "018j-audit-predefined-select.sql" %}

Berikut hasilnya:

```sql
-- login as adminstration oracle user
bash-4.2# su oracle
[oracle@b0fc5cd60df4 /]$ sqlplus / as sysdba

SQL*Plus: Release 18.0.0.0.0 - Production on Tue Mar 16 12:56:43 2021
Version 18.4.0.0.0

Copyright (c) 1982, 2018, Oracle.  All rights reserved.

Connected to:
Oracle Database 18c Express Edition Release 18.0.0.0.0 - Production
Version 18.4.0.0.0

SQL> select distinct POLICY_NAME
from AUDIT_UNIFIED_POLICIES
where POLICY_NAME like 'ORA%';

POLICY_NAME
--------------------------------------------------------------------------------
ORA_DV_AUDPOL2
ORA_CIS_RECOMMENDATIONS
ORA_ACCOUNT_MGMT
ORA_DATABASE_PARAMETER
ORA_LOGON_FAILURES
ORA_DV_AUDPOL
ORA_SECURECONFIG
ORA_RAS_SESSION_MGMT
ORA_RAS_POLICY_MGMT

9 rows selected.

SQL> col user_name format a10;
SQL> col policy_name format a25;
SQL> col entity_name format a20;

SQL> select USER_NAME, POLICY_NAME, ENABLED_OPT, ENTITY_NAME, ENTITY_TYPE
from AUDIT_UNIFIED_ENABLED_POLICIES
where POLICY_NAME like 'ORA%';

USER_NAME  POLICY_NAME               ENABLED ENTITY_NAME          ENTITY_
---------- ------------------------- ------- -------------------- -------
ALL USERS  ORA_SECURECONFIG          BY      ALL USERS            USER
ALL USERS  ORA_LOGON_FAILURES        BY      ALL USERS            USER

SQL> audit policy ORA_ACCOUNT_MGMT;

SQL> select USER_NAME, POLICY_NAME
from AUDIT_UNIFIED_ENABLED_POLICIES
where POLICY_NAME like 'ORA%';

USER_NAME            POLICY_NAME
-------------------- ------------------------------
ALL USERS            ORA_LOGON_FAILURES
ALL USERS            ORA_ACCOUNT_MGMT
ALL USERS            ORA_SECURECONFIG

3 rows selected.

SQL> SET LONG 20000 LONGCHUNKSIZE 20000 PAGESIZE 0 LINESIZE 1000 FEEDBACK OFF VERIFY OFF TRIMSPOOL ON
SQL> SET PAGESIZE 14 LINESIZE 100 FEEDBACK ON VERIFY ON
SQL> col os_username format a20
SQL> col object_name format a20
SQL> col dbusername format a15
SQL> col client_program_name format a20
SQL> col action_name format a10
SQL> col sql_text format a30


SQL> select to_char(EVENT_TIMESTAMP, 'dd/MM/yy HH:mm') as executed,
       DBUSERNAME,
       ACTION_NAME,
       SQL_TEXT,
       OBJECT_NAME
from UNIFIED_AUDIT_TRAIL
where cast(EVENT_TIMESTAMP as DATE) between current_date - 1 and current_date
order by EVENT_TIMESTAMP desc
    fetch next 10 ROWS ONLY;

EXECUTED       DBUSERNAME      ACTION_NAM SQL_TEXT                       OBJECT_NAME
-------------- --------------- ---------- ------------------------------ --------------------
17/03/21 05:03 SYS             ALTER USER alter user hr identified by *  HR
                                          account unlock
17/03/21 05:03 SYSTEM          LOGON
17/03/21 05:03 SYS             LOGON

10 rows selected.
```