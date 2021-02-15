---
layout: post
title: "Please be carefull using natural join di Oracle"
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

Jika ke dua table yang di join tidak memiliki kondisi (natural join) dan tidak memiliki relasi antara column `primary key` dan `foreign key` maka Oracle akan menghasilkan Cartesian Product.

Cartesian Product yaitu Oracle akan menggabungkan data setiap baris dalam sebuah table dari semua table. contohnya klo kita punya table `departments` berisi `10 baris` dan table `countries` berisi `10 baris` maka akan menghasilkan `100 baris`

berikut contohnya:

{% highlight sql %}
SQL> select count(*) as count_departments
from DEPARTMENTS;

COUNT_DEPARTMENTS
-----------------
               27

SQL> select count(*) as count_countries
from COUNTRIES;

COUNT_COUNTRIES
---------------
             25

SQL> select count(*)
from DEPARTMENTS dep
         natural join COUNTRIES loc;

  COUNT(*)
----------
       675

SQL> select dep.DEPARTMENT_ID       as dep_id,
       dep.DEPARTMENT_NAME          as dep_name,
       country.COUNTRY_ID           as country_id,
       country.COUNTRY_NAME         as country_name
from DEPARTMENTS dep
         natural join COUNTRIES country;

    DEP_ID DEP_NAME                       CO COUNTRY_NAME
---------- ------------------------------ -- ----------------------------------------
       270 Payroll                        NL Netherlands
       270 Payroll                        SG Singapore
       270 Payroll                        UK United Kingdom
       270 Payroll                        US United States of America
       270 Payroll                        ZM Zambia
       270 Payroll                        ZW Zimbabwe
        10 Administration                 AR Argentina
        10 Administration                 AU Australia
        10 Administration                 BE Belgium

675 rows selected.
{% endhighlight %}