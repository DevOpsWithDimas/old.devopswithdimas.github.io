---
layout: post
title: "Sub Query Correlate di Oracle"
date: 2021-02-18T19:06:30+07:00
lang: oracle18c
authors:
- dimasm93
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/Using-Subqueries.html#GUID-53A705B6-0358-4E2B-92ED-A83DE83DFD20
youtube: JKwIjV4bPlw
comments: true
catalog_key: sql-subquery
image_path: /resources/posts/oracle12c/
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Sub Query akan memproses inner query terlebih dahulu kemudian outer query, Sub Query Correlate ini berbeda jadi outer query akan di proses terlebih dahulu baru inner query.

<!--more-->

Berikut adalah contoh penggunaan correlate query:

{% gist page.gist "011f-subquery-correlate.sql" %}

Berikut hasilnya:

{% highlight sql %}
EMPLOYEE_ID FIRST_NAME               SALARY DEPARTMENT_ID
----------- -------------------- ---------- -------------
        200 Jennifer                   4400            10
        201 Michael                   13000            20
        202 Pat                        6000            20
        114 Den                       11000            30
        115 Alexander                  3100            30
        116 Shelli                     2900            30
        117 Sigal                      2800            30
        118 Guy                        2600            30
        119 Karen                      2500            30

9 rows selected.
{% endhighlight %}