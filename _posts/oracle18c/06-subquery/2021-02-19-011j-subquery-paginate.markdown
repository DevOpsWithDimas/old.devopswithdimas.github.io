---
layout: post
title: "Paginate dengan Sub Query di Oracle versi lama"
date: 2021-02-19T20:33:44+07:00
lang: oracle18c
authors:
- dimasm93
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/database/121/index.htm
youtube: HZQQ9BxYR_o
comments: true
catalog_key: sql-subquery
image_path: /resources/posts/oracle12c/011j-subquery-with-clause
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Di Oracle 11g kebawah, kita gak bisa menggunakan `fetch` dan `offset` biasanya jadi kita gunakan sub query, berikut adalah implementasinya:

{% gist page.gist "011j-subquery-paginate.sql" %}

Berikut hasilnya:

{% highlight sql %}
Enter value for start: 20
Enter value for page: 3
Enter value for limit: 10

EMPLOYEE_ID FIRST_NAME               SALARY JOB_ID
----------- -------------------- ---------- ----------
        111 Ismael                     7700 FI_ACCOUNT
        112 Jose Manuel                7800 FI_ACCOUNT
        113 Luis                       6900 FI_ACCOUNT
        114 Den                       11000 PU_MAN
        115 Alexander                  3100 PU_CLERK
        116 Shelli                     2900 PU_CLERK
        117 Sigal                      2800 PU_CLERK
        118 Guy                        2600 PU_CLERK
        119 Karen                      2500 PU_CLERK
        120 Matthew                    8000 ST_MAN

10 rows selected.
{% endhighlight %}

Jadi disini kita menggunakan subtitution variable dengan menggunakan `&variable_name` jadi sekara logica operasi nya hasilnya `no between (20 + 1) and (3 * 10)` jadi menampilkan data dari `20` sampe `30`