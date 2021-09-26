---
layout: post
title: "Auditing Activities with Unified Audit Policies"
date: 2021-03-15T21:31:22+07:00
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/18/dbseg/configuring-audit-policies.html#GUID-A215CCAF-4AFF-448A-909C-736EBDED5A8A
youtube: wsekIxClGlo
comments: true
catalog_key: monitor-audit-trail
image_path: /resources/posts/oracle12c/018i-audit-general-activity
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---


Activities yang kita bisa audit yaitu diantaranya

1. User Accounts, Roles, and Privileges
2. Object Actions
3. Application Context Value

Berikut adalah syntax untuk membuat unified audit policy

{% highlight sql %}
CREATE AUDIT POLICY policy_name
    { {privilege_audit_clause [action_audit_clause ] [role_audit_clause ]}
        | { action_audit_clause  [role_audit_clause ] } 
        | { role_audit_clause }
     }        
    [WHEN audit_condition EVALUATE PER {STATEMENT|SESSION|INSTANCE}] 
    [CONTAINER = {CURRENT | ALL}];
{% endhighlight %}

Untuk mengaktifkan audit policy, gunakan perintah seperti berikut:

{% highlight sql %}
AUDIT POLICY {policy_name} 
    [by { usernames | USERS with granted roles role_names }] 
    [WHENEVER [NOT] SUCCESSFUL];
{% endhighlight %}

Untuk me-disabled audit policy, gunakan perintah berikut:

{% highlight sql %}
noaudit POLICY {policy_name} 
    [by { usernames | USERS with granted roles role_names }] 
    [WHENEVER [NOT] SUCCESSFUL];
{% endhighlight %}

Untuk melihat bahwa, `audit policy` telah active kita bisa check di Static Data Dictionary View `AUDIT_UNIFIED_ENABLED_POLICIES`

{% highlight sql %}
select *
from AUDIT_UNIFIED_ENABLED_POLICIES;
{% endhighlight %}

## Auditing Object Action

Audit object action yaitu tracking object pada database seperti table, view, sequances dan lain-lain, Contoh penggunaanya jika mau track update statement pada table `hr.employees` seperti berikut:

{% gist page.gist "018i-audit-object-action.sql" %}

Jika di jalan maka hasilnya seperti berikut:

```sql
Bash> sqlplus system/passwordnyaOracle18@XEPDB1

SQL*Plus: Release 18.0.0.0.0 - Production on Mon Mar 15 13:02:29 2021
Version 18.4.0.0.0

Copyright (c) 1982, 2018, Oracle.  All rights reserved.

Last Successful login time: Mon Mar 15 2021 13:02:22 +00:00

Connected to:
Oracle Database 18c Express Edition Release 18.0.0.0.0 - Production
Version 18.4.0.0.0

SQL> create audit policy aud_update_hr_employees
actions update on hr.EMPLOYEES,
delete on hr.EMPLOYEES;

SQL> audit policy aud_update_hr_employees
by TOKO_ONLINE, SALES;

SQL> conn offices/project2018@XEPDB1
Connected.

SQL> update hr.employees set
commission_pct = 0.1
where employee_id = 100;

1 row updated.

SQL> commit;

Commit complete.

SQL> select employee_id, commission_pct
  2  from hr.employees
  3  where employee_id = 100;

EMPLOYEE_ID COMMISSION_PCT
----------- --------------
        100             .1

SQL> conn system/passwordnyaOracle18@XEPDB1
Connected.

SQL> select OS_USERNAME, ACTION_NAME, UNIFIED_AUDIT_POLICIES, SQL_TEXT, OBJECT_NAME, OBJECT_SCHEMA
from UNIFIED_AUDIT_TRAIL
where lower(UNIFIED_AUDIT_POLICIES) in ('aud_update_hr_employees')
order by EVENT_TIMESTAMP desc;

+-----------+-----------+-----------------------+--------------------------+-----------+----------+
|OS_USERNAME|ACTION_NAME|UNIFIED_AUDIT_POLICIES |SQL_TEXT                  |OBJECT_NAME|OBJ_SCHEMA|
+-----------+-----------+-----------------------+--------------------------+-----------+----------+
|root       |UPDATE     |AUD_UPDATE_HR_EMPLOYEES|update hr.employees set   |EMPLOYEES  |HR        |
|           |           |                       |commission_pct = 0.1      |           |          |
|           |           |                       |where employee_id = 100   |           |          |
```