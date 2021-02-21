---
layout: post
title: "TCL - Commit Transaction di Oracle"
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/database/121/index.htm
- https://docs.oracle.com/en/bigdata/index.html
youtube: 
comments: true
image_path: /resources/posts/oracle12c/
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Di Oracle Database dari dulu sampe sekarang (18c) masih menggunakan manual commit, berbeda dengan database lainnya yang menggunakan auto commit. Nah sebelumnya kita kita melakukan insert kemudian kita close maka perubahannya akan hilang.

Berikut adalah contoh penggunaanya:

{% gist page.gist "015a-single-commit.sql" %}

Berikut hasilnya:

{% highlight sql %}
SQL> insert into DEPARTMENTS(DEPARTMENT_ID, DEPARTMENT_NAME, LOCATION_ID)
values (DEPARTMENTS_SEQ.nextval, 'Development Operation', 1700);

commit; 
1 row created.

SQL> SQL>

Commit complete.

SQL> select * from departments;

DEPARTMENT_ID DEPARTMENT_NAME                MANAGER_ID LOCATION_ID
------------- ------------------------------ ---------- -----------
          290 Development Operation                            1700

28 rows selected.
{% endhighlight %}

Selain itu juga kita bisa menggunakan block dengan `begin-end` clause seperti berikut:

{% gist page.gist "015a-tcl-block-commit.sql" %}

Berikut hasilnya:

{% highlight sql %}
SQL> begin
--     insert new record
    insert into DEPARTMENTS(DEPARTMENT_ID, DEPARTMENT_NAME, LOCATION_ID)
    values (DEPARTMENTS_SEQ.nextval, 'Development Operation', 1700);

-- update department id 10 set name = 'Admin'
    update DEPARTMENTS
    set DEPARTMENT_NAME = 'Admin'
    where DEPARTMENT_ID = 10;

--     commit query
    commit;
end;

PL/SQL procedure successfully completed.

SQL> select * from departments;

DEPARTMENT_ID DEPARTMENT_NAME                MANAGER_ID LOCATION_ID
------------- ------------------------------ ---------- -----------
          310 Development Operation                            1700
           10 Admin                                 200        1700
{% endhighlight %}