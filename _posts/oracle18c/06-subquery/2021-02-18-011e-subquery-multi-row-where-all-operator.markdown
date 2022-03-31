---
layout: post
title: "ALL Operator dengan Sub Query di Oracle"
date: 2021-02-18T18:49:28+07:00
lang: oracle18c
authors:
- dimasm93
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/Using-Subqueries.html#GUID-53A705B6-0358-4E2B-92ED-A83DE83DFD20
youtube: x2rlNicGUQk
comments: true
catalog_key: sql-subquery
image_path: /resources/posts/oracle12c/
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Operator `all` digunakan untuk membandingkan data yang di cari dengan sekumpulan data yang ada di inner query. Untuk menggunakan operator `ALL` kita harus menggunkan `< ALL` dan `> ALL`. 

<!--more-->

Misalnya inner query yang akan kita gunakan adalah seperti berikut:

{% highlight sql %}
SQL> select EMPLOYEE_ID, SALARY
from EMPLOYEES
where DEPARTMENT_ID = 30
order by SALARY;

EMPLOYEE_ID     SALARY
----------- ----------
        119       2500
        118       2600
        117       2800
        116       2900
        115       3100
        114      11000

6 rows selected.
{% endhighlight %}

## `< ALL` Operator

Operator `< ALL` menampilkan data di outer query yang nilainya lebih kecil dari yang paling kecil dari inner query:

{% gist page.gist "011e-subquery-multi-row-where-lower-all.sql" %}

Berikut hasilnya:

{% highlight sql %}
        ID NAME                     SALARY JOB
---------- -------------------- ---------- ----------
       132 TJ                         2100 ST_CLERK
       128 Steven                     2200 ST_CLERK
       136 Hazel                      2200 ST_CLERK
       127 James                      2400 ST_CLERK
       135 Ki                         2400 ST_CLERK
{% endhighlight %}

Jadi nilai yang paling kecil dari inner query adalah `2500` maka bandingkan dengan lebih kecil lagi.

## `> ALL` Operator

Operator `> ALL` kebalikannya dari `< ALL`, berikut querynya:

{% gist page.gist "011e-subquery-multi-row-where-higher-all.sql" %}

Berikut hasilnya:

{% highlight sql %}
        ID NAME                     SALARY JOB
---------- -------------------- ---------- ----------
       168 Lisa                      11500 SA_REP
       147 Alberto                   12000 SA_MAN
       108 Nancy                     12008 FI_MGR
       205 Shelley                   12008 AC_MGR
       201 Michael                   13000 MK_MAN
       146 Karen                     13500 SA_MAN
       145 John                      14000 SA_MAN
       102 Lex                       17000 AD_VP
       101 Neena                     17000 AD_VP
       100 Steven                    24000 AD_PRES

10 rows selected.
{% endhighlight %}