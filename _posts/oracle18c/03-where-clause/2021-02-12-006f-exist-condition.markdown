---
layout: post
title: "Exists Condition pada klausa where di Oracle"
date: 2021-02-12T20:06:51+07:00
lang: oracle18c
authors:
- dimasm93
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/EXISTS-Condition.html#GUID-20259A83-C42B-4E0D-8DF4-9A2A66ACA8E7
youtube: U_48PcoIhd0
comments: true
catalog_key: sql-where-clause
image_path: /resources/posts/oracle12c/006f-exist-condition
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Exists Condition biasanya digunakan untuk melakukan check data query 1 dan query 2 (subquery) memiliki nilai maka menampilkan query 1. berikut contoh implementasinya:

{% gist page.gist "006f-exists-condition.sql" %}

berikut hasilnya:

{% highlight sql %}
EMPLOYEE_ID FIRST_NAME           DEPARTMENT_ID
----------- -------------------- -------------
        198 Donald                          50
        199 Douglas                         50
        200 Jennifer                        10
        201 Michael                         20
        202 Pat                             20
        203 Susan                           40
        204 Hermann                         70
        205 Shelley                        110
        206 William                        110
        100 Steven                          90
        101 Neena                           90

106 rows selected.
{% endhighlight %}