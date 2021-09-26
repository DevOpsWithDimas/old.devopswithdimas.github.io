---
layout: post
title: "Auditing Specific Activities with Fine-Grained Auditing"
date: 2021-03-20T17:24:21+07:00
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/18/dbseg/configuring-audit-policies.html#GUID-B706FF6F-13A6-4944-AFCB-29971F5076FD
youtube: 
comments: true
catalog_key: ddl-user-management
image_path: /resources/posts/oracle12c/018k-audit-fine-grained
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Fine-Grained Audition yaitu policies yang di tujukan secara specifik kondisi untuk INSERT, UPDATE, DELETE, SELECT operation. Secara general **fine-grained audit policies adalah user-defined sql predicate pada suatu tabel untuk selective audition**.

## Syntax Fine-Grained Audit Policy

Syntax untuk membuat FGA Policy, seperti berikut:

{% highlight sql %}
DBMS_FGA.ADD_POLICY(
   object_schema      IN  VARCHAR2 DEFAULT NULL 
   object_name        IN  VARCHAR2,
   policy_name        IN  VARCHAR2, 
   audit_condition    IN  VARCHAR2 DEFAULT NULL, 
   audit_column       IN  VARCHAR2 DEFAULT NULL 
   handler_schema     IN  VARCHAR2 DEFAULT NULL, 
   handler_module     IN  VARCHAR2 DEFAULT NULL, 
   enable             IN  BOOLEAN DEFAULT TRUE, 
   statement_types    IN  VARCHAR2 DEFAULT SELECT,
   audit_trail        IN  BINARY_INTEGER DEFAULT NULL, 
   audit_column_opts  IN  BINARY_INTEGER DEFAULT ANY_COLUMNS, 
   policy_owner       IN  VARCHAR2 DEFAULT NULL);
{% endhighlight %}

Syntax untuk enable/disble FGA Policy, seperti berikut:

{% highlight sql %}
-- for disable a fga policy
DBMS_FGA.DISABLE_POLICY(
   object_schema  VARCHAR2, 
   object_name    VARCHAR2, 
   policy_name    VARCHAR2); 

-- for enable a fga policy
DBMS_FGA.ENABLE_POLICY(
   object_schema  VARCHAR2, 
   object_name    VARCHAR2, 
   policy_name    VARCHAR2,
   enable         BOOLEAN);
{% endhighlight %}

Syntax untuk menhapus FGA Policy, seperti berikut:

{% highlight sql %}
DBMS_FGA.DROP_POLICY(
   object_schema  VARCHAR2, 
   object_name    VARCHAR2, 
   policy_name    IVARCHAR2);
{% endhighlight %}


## Implementasi Fine-grained Audit Policy

Contoh kasusnya, disini kita akan melakukan audit terhadap columns `salary` dan `commission_pct` pada table `employees` dalam schema `hr` yang memiliki `salary >= 10000`. Seperti berikut penggunaanya:

{% gist page.gist "018l-fga-create.sql" %}

Untuk melihat informasi suatu policy FGA, kita bisa lihat di Data Dictionary View Seperti berikut

{% gist page.gist "018l-fga-dictionary-view-policy.sql" %}

Untuk melihat record audit, kita bisa check di Data Dictionary View seperti berikut:

{% gist page.gist "018l-fga-dictionary-view-record.sql" %}

Jika di jalankan maka hasilnya seperti berikut:

```sql
bash> sqlplus system/passwordnyaOracle18@XEPDB1

SQL*Plus: Release 18.0.0.0.0 - Production on Sat Mar 20 09:58:05 2021
Version 18.4.0.0.0

Copyright (c) 1982, 2018, Oracle.  All rights reserved.

Last Successful login time: Sat Mar 20 2021 09:31:10 +00:00

Connected to:
Oracle Database 18c Express Edition Release 18.0.0.0.0 - Production
Version 18.4.0.0.0

SQL> begin
    DBMS_FGA.ADD_POLICY(
            object_schema => 'HR',
            object_name => 'EMPLOYEES',
            policy_name => 'FGA_UPDATE_HR_EMPLOYEES_ON_DEP_IN',
            audit_column => 'SALARY, COMMISSION_PCT',
            audit_condition => 'SALARY >= 10000',
            enable => true,
            statement_types => 'UPDATE'
        );
end;
/

SQL> col object_schema format a5
SQL> col object_name format a20
SQL> col policy_owner format a10
SQL> col policy_name format a20
SQL> col policy_text format a20
SQL> col policy_column format a20

SQL> SET LONG 20000 LONGCHUNKSIZE 20000 PAGESIZE 0 LINESIZE 1000 FEEDBACK OFF VERIFY OFF TRIMSPOOL ON
SQL> SET PAGESIZE 14 LINESIZE 100 FEEDBACK ON VERIFY ON

SQL> select OBJECT_SCHEMA, OBJECT_NAME, POLICY_OWNER, POLICY_NAME, POLICY_TEXT, ENABLED
from dba_audit_policies;

OBJEC OBJECT_NAME          POLICY_OWN POLICY_NAME          POLICY_TEXT          ENA
----- -------------------- ---------- -------------------- -------------------- ---
HR    EMPLOYEES            SYSTEM     FGA_UPDATE_HR_EMPLOY SALARY >= 10000      YES
                                      EES_ON_DEP_IN


1 row selected.

SQL> conn toko_online/toko_online@XEPDB1
Connected.

SQL> update hr.EMPLOYEES
set SALARY         = 22500,
    COMMISSION_PCT = 0.1
where EMPLOYEE_ID in (100, 115);

2 rows updated.

SQL> commit;

Commit complete.

SQL> update hr.EMPLOYEES
set SALARY         = 6500,
    COMMISSION_PCT = 0.1
where EMPLOYEE_ID = 160;

1 row updated.

SQL> commit;

SQL> conn system/passworndyaOracle18@XEPDB1

SQL> col object_schema format a5
SQL> col object_name format a20
SQL> col policy_owner format a10
SQL> col policy_name format a20
SQL> col policy_text format a20
SQL> col policy_column format a20
SQL> col sql_text format a30
SQL> col db_user format a10
SQL> SET LONG 20000 LONGCHUNKSIZE 20000 PAGESIZE 0 LINESIZE 1000 FEEDBACK OFF VERIFY OFF TRIMSPOOL ON
SQL> SET PAGESIZE 14 LINESIZE 100 FEEDBACK ON VERIFY ON

SQL> select TIMESTAMP, DB_USER, OBJECT_SCHEMA, OBJECT_NAME, POLICY_NAME, SQL_TEXT, STATEMENT_TYPE
from CDB_FGA_AUDIT_TRAIL
where DB_USER = 'TOKO_ONLINE'
order by TIMESTAMP desc;

TIMESTAMP DB_USER     OBJEC OBJECT_NAME          POLICY_NAME          SQL_TEXT                       STATEME
--------- ----------- ----- -------------------- -------------------- ------------------------------ -------
20-MAR-21 TOKO_ONLINE HR    EMPLOYEES            FGA_UPDATE_HR_EMPLOY update hr.EMPLOYEES             UPDATE
                                                 EES_ON_DEP_IN        set SALARY         = 22500,
                                                                         COMMISSION_PCT = 0.1
                                                                      where EMPLOYEE_ID in (100, 115)
1 row selected.

SQL>
```

## Management Fine-grained Audit Policy

Fine-Grained Audit Policy tidak dapat di modifikasi, untuk merubahnya kita perlu hapus dulu kemudian buat lagi. berikut adalah perintah untuk meng-hapusnya:

{% gist page.gist "018l-fga-drop.sql" %}

Selain itu juga kita bisa non-active / disable policynya dengan menggunakan perintah berikut:

{% gist page.gist "018l-fga-disable.sql" %}

Untuk mengaktifkanya kembali, kita bisa menggunakan perintah berikut:

{% gist page.gist "018l-fga-enable.sql" %}