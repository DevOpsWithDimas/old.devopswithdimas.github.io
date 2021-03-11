---
layout: post
title: "In Predicates dengan Sub Query di Oracle"
date: 2021-02-18T17:26:21+07:00
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/Using-Subqueries.html#GUID-53A705B6-0358-4E2B-92ED-A83DE83DFD20
youtube: https://www.youtube.com/watch?v=2r1A7ICkRfI&list=PLV1-tdmPblvzqS-Z57hZ_spTRtVvnYYpV&index=51
comments: true
image_path: /resources/posts/oracle12c/
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Jika di [materi sebelumnya]({% post_url oracle18c/03-where-clause/2021-02-12-006e-in-predicate %}) kita udah menggunakan predicate in sebagai sekumpulan nilai, sekarang kita bisa juga menggunakan query yang menghasilkan banyak data, contohnya seperti berikut nilai pembandingnya:

{% highlight sql %}
SQL> select min(empl.SALARY) min_salary
from EMPLOYEES empl
group by empl.MANAGER_ID
order by min_salary;  2    3    4

MIN_SALARY
----------
      2100
      2200
      2200
      2500
      2500
      2500
      4200
      4400
      5800
      6000
      6100
      6200
      6200
      6900
      7000
      7000
      8300
      9000
     24000

19 rows selected.
{% endhighlight %}

Nah sekarang misalnya saya mau cari data karyawan yang `salary` nya sama dengan daftar `minimal salary` yang dikelompokan berdasarkan `manager_id`, berikut adalah querynya:

{% gist page.gist "011c-subquery-multi-row-where-in.sql" %}

berikut hasilnya:

{% highlight sql %}
EMPLOYEE_ID FIRST_NAME               SALARY MANAGER_ID
----------- -------------------- ---------- ----------
        132 TJ                         2100        121
        136 Hazel                      2200        122
        128 Steven                     2200        120
        144 Peter                      2500        124
        191 Randall                    2500        122
        140 Joshua                     2500        123
        131 James                      2500        121
        119 Karen                      2500        114
        182 Martha                     2500        120
        107 Diana                      4200        103
        184 Nandita                    4200        121
        200 Jennifer                   4400        101
        124 Kevin                      5800        100
        104 Bruce                      6000        103
        202 Pat                        6000        201
        173 Sundita                    6100        148
        179 Charles                    6200        149
        167 Amit                       6200        147
        113 Luis                       6900        108
        155 Oliver                     7000        145
        178 Kimberely                  7000        149
        161 Sarath                     7000        146
        206 William                    8300        205
        103 Alexander                  9000        102
        109 Daniel                     9000        108
        158 Allan                      9000        146
        152 Peter                      9000        145
        100 Steven                    24000

28 rows selected.
{% endhighlight %}