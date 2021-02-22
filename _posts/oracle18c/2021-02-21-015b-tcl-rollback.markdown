---
layout: post
title: "TCL - Rollback Transaction di Oracle"
date: 2021-02-21T20:26:29+07:00
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/ROLLBACK.html#GUID-94551F0C-A47F-43DE-BC68-9B1C1ED38C93
youtube: 
comments: true
image_path: /resources/posts/oracle12c/
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Penggunaan `rollback` yaitu untuk mengembalikan data atau object ke commit terakhir, contohnya seperti berikut:

{% gist page.gist "015b-tcl-rollback-single-query.sql" %}

hasilnya seperti berikut:

{% highlight sql %}
SQL> insert into DEPARTMENTS(DEPARTMENT_ID, DEPARTMENT_NAME, LOCATION_ID)
values (DEPARTMENTS_SEQ.nextval, 'Project Manager', 1700);

1 row created.

SQL> select department_id, department_name from departments 
where department_name = 'Project Manager';

DEPARTMENT_ID DEPARTMENT_NAME
------------- ------------------------------
          320 Project Manager

SQL> rollback;

Rollback complete.

SQL> select department_id, department_name from departments
  2  where department_id = 320;

no rows selected
{% endhighlight %}

Sekarang kita coba klo misalnya kita melakukan multiple query kemudian di rollback, seperti berikut:

{% gist page.gist "015b-tcl-rollback-block-querys.sql" %}

Maka berikut hasilnya:

{% highlight sql %}
SQL> begin
-- insert new record
    insert into DEPARTMENTS(DEPARTMENT_ID, DEPARTMENT_NAME, LOCATION_ID)
    values (DEPARTMENTS_SEQ.nextval, 'Development Operation', 1700);

-- update department id 10 set name = 'Admin'
    update DEPARTMENTS
    set DEPARTMENT_NAME = 'Administrator'
    where DEPARTMENT_ID = 10;
end;

PL/SQL procedure successfully completed.

SQL> select * from departments;

DEPARTMENT_ID DEPARTMENT_NAME                MANAGER_ID LOCATION_ID
------------- ------------------------------ ---------- -----------
          330 Development Operation                            1700
          310 Development Operation                            1700
           10 Administrator                         200        1700

29 rows selected.

SQL>
SQL> rollback;

Rollback complete.

SQL> select * from departments;

DEPARTMENT_ID DEPARTMENT_NAME                MANAGER_ID LOCATION_ID
------------- ------------------------------ ---------- -----------
          310 Development Operation                            1700
           10 Admin                                 200        1700
28 rows selected.

SQL>
{% endhighlight %}