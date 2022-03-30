---
layout: post
title: "Sub Query Inline View di Oracle"
date: 2021-02-19T20:04:07+07:00
lang: oracle18c
authors:
- dimasm93
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/database/121/index.htm
youtube: clJyOPVaD1o
comments: true
catalog_key: sql-subquery
image_path: /resources/posts/oracle12c/011i-subquery-inline-view
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Di materi sebelumnya kita menggunakan Sub Query dengan di letakkan pada `select statement` dan `where predicates`. ada satu lagi yaitu inline view yang di letakan di `from`, 

berikut contoh penggunaanya misalnya saya mau mencari pengelompokan `salary` berdasarkan `job_id` buat ranking dari yang paling besar gajinya ke terkecil.

{% gist page.gist "011i-subquery-inline-view-ranking.sql" %}

berikut hasilnya:

{% highlight sql %}
      RANK JOB_ID     TOTAL_SALARY
---------- ---------- ------------
         1 SA_MAN            61000
         2 AD_VP             34000
         3 AD_PRES           24000
         4 MK_MAN            13000
         5 AC_MGR            12008
{% endhighlight %}

Selain itu juga kita bisa menggunakan join inline view, berikut contohnya:

{% gist page.gist "011i-subquery-inline-view-join.sql" %}

Berikut hasilnya:

{% highlight sql %}
EMPLOYEE_ID FIRST_NAME               SALARY AVG_SALARY
----------- -------------------- ---------- ----------
        101 Neena                     17000      17000
        102 Lex                       17000      17000
        115 Alexander                  3100       2780
        116 Shelli                     2900       2780
        117 Sigal                      2800       2780
        118 Guy                        2600       2780
        119 Karen                      2500       2780
        114 Den                       11000      11000
        100 Steven                    24000      24000

9 rows selected.
{% endhighlight %}