---
layout: post
title: "TCL - Savepoint di Oracle"
date: 2021-02-21T20:54:11+07:00
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/SAVEPOINT.html#GUID-78EEA746-0021-42E8-9971-3BA6DFFEE794
youtube: Tu9uF7ajGVU
comments: true
image_path: /resources/posts/oracle12c/
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Perintah `savepoint` digunakan untuk mengelompokan suatu transaksi yang panjang menjadi beberapa tahap, contohnya jika kita main game balapan atau rpg misalnya nah di dalem storynya misalkan character yang kita mainkan mati di tengah2 permainnan nah maka game akan kembali ke save terakhir nah kurang lebih seperti itu lah gunanya `savepoint`.

Untuk implementasinya, berikut adalah contoh querynya:

{% gist page.gist "015c-tcl-savepoint.sql" %}

Berikut hasilnya:

{% highlight sql %}
SQL> insert into DEPARTMENTS(DEPARTMENT_ID, DEPARTMENT_NAME, LOCATION_ID)
values (DEPARTMENTS_SEQ.nextval, 'Project Manager', 1700);

1 row created.

SQL> savepoint insert_pm;

Savepoint created.

SQL> select department_id, department_name from departments;

DEPARTMENT_ID DEPARTMENT_NAME
------------- ------------------------------
          340 Project Manager
          310 Development Operation
           10 Admin

29 rows selected.

SQL> insert into DEPARTMENTS(DEPARTMENT_ID, DEPARTMENT_NAME, LOCATION_ID)
values (DEPARTMENTS_SEQ.nextval, 'Development Operation', 1700);

savepoint insert_devops;  
1 row created.

SQL> select department_id, department_name from departments;

DEPARTMENT_ID DEPARTMENT_NAME
------------- ------------------------------
          340 Project Manager
          350 Development Operation
          310 Development Operation
           10 Admin

30 rows selected.

SQL> update DEPARTMENTS
set DEPARTMENT_NAME = 'Administrator'
where DEPARTMENT_ID = 10;

savepoint update_admin;
1 row updated.

SQL>

Savepoint created.

SQL> select department_id, department_name from departments;

DEPARTMENT_ID DEPARTMENT_NAME
------------- ------------------------------
          340 Project Manager
          350 Development Operation
          310 Development Operation
           10 Administrator

30 rows selected.

SQL> rollback to savepoint insert_pm;

Rollback complete.

SQL> select department_id, department_name from departments;

DEPARTMENT_ID DEPARTMENT_NAME
------------- ------------------------------
          340 Project Manager
          310 Development Operation
           10 Admin
 
29 rows selected.
{% endhighlight %}