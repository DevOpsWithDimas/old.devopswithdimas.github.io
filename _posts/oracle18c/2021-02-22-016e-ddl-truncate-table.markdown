---
layout: post
title: "DDL - Truncate Table"
date: 2021-02-22T19:47:47+07:00
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/TRUNCATE-TABLE.html#GUID-B76E5846-75B5-4876-98EC-439E15E4D8A4
youtube: 
comments: true
image_path: /resources/posts/oracle12c/
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Perintah `TRUNCATE TABLE` yaitu untuk menghapus semua data dari table, by default oracle akan deallocate semua space yang digunakan dalam disk. Mungkin temen-temen bingung apa bedanya dengan perintah `delete`

Yap sebetulnya sama saja tujuannya adalah menghapus data, tapi disini bedanya adalah pemakaian space setelah di `delete` atau `truncate`. contohnya seperti berikut:

{% gist page.gist "016e-ddl-truncate-table.sql" %}

Berikut hasilnya:

{% highlight sql %}
SQL> create table deleted_emp as
select *
from EMPLOYEES;
Table created.

create table TRUNCATE_EMP as
select *
from EMPLOYEES;
Table created.

SQL> analyze table deleted_emp compute statistics;

Table analyzed.

SQL> analyze table truncate_emp compute statistics;

Table analyzed.

SQL> select TABLE_NAME, NUM_ROWS, ((BLOCKS * 8192) / 1024) as kb
from user_tables
where TABLE_NAME in ('DELETED_EMP', 'TRUNCATE_EMP');

TABLE_NAME              NUM_ROWS         KB
---------------------   ---------- ----------
DELETED_EMP             107         40
TRUNCATE_EMP            107         40


SQL> delete from deleted_emp;
truncate table TRUNCATE_EMP;
107 rows deleted.

SQL>

Table truncated.

SQL> commit;

Commit complete.

SQL> analyze table deleted_emp compute statistics;
Table analyzed.

SQL> analyze table truncate_emp compute statistics;
Table analyzed.

SQL> select TABLE_NAME, NUM_ROWS, ((BLOCKS * 8192) / 1024) as kb
from user_tables
where TABLE_NAME in ('DELETED_EMP', 'TRUNCATE_EMP');

TABLE_NAME            NUM_ROWS         KB
--------------------- ---------- ----------
DELETED_EMP           0          40
TRUNCATE_EMP          0           0
{% endhighlight %}