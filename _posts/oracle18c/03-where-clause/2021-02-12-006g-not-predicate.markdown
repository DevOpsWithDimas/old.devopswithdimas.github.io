---
layout: post
title: "Not Predicate pada klausa where di Oracle"
date: 2021-02-12T20:34:06+07:00
lang: oracle18c
authors:
- dimasm93
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/Logical-Conditions.html#GUID-C5E48AF2-3FF9-401D-A104-CDB5FC19E65F
youtube: 51bOgjW9F1k
comments: true
catalog_key: sql-where-clause
image_path: /resources/posts/oracle12c/
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Predicate Not yaitu Negasi, jadi nilai kebalikannya contoh klo kita pake kondisi `=` => `!=`. Predicate Not ini bisa di terapkan di predicate lainnya seperti 

1. Relational Comparison 
2. Like Predicate
3. Between Predicate
4. Is Null Predicate
5. In Predicate
6. Exists Predicate
7. dan lain-lain.

## Relational Comparison

{% gist page.gist "006g-not-relationa-comparison.sql" %}

Maka berikut adalah hasilnya:

{% highlight sql %}
EMPLOYEE_ID FIRST_NAME           DEPARTMENT_ID     SALARY
----------- -------------------- ------------- ----------
        198 Donald                          50       2600
        199 Douglas                         50       2600
        200 Jennifer                        10       4400
        201 Michael                         20      13000
        202 Pat                             20       6000
        203 Susan                           40       6500
        204 Hermann                         70      10000
        205 Shelley                        110      12008
        206 William                        110       8300
        103 Alexander                       60       9000
        104 Bruce                           60       6000

103 rows selected.
{% endhighlight %}

## Like Predicate

{% gist page.gist "006g-not-like-predicate.sql" %}

Maka berikut adalah hasilnya:

{% highlight sql %}
EMPLOYEE_ID FIRST_NAME           DEPARTMENT_ID     SALARY
----------- -------------------- ------------- ----------
        198 Donald                          50       2600
        199 Douglas                         50       2600
        200 Jennifer                        10       4400
        201 Michael                         20      13000
        203 Susan                           40       6500
        204 Hermann                         70      10000
        205 Shelley                        110      12008
        206 William                        110       8300
        100 Steven                          90      24000
        101 Neena                           90      17000
        102 Lex                             90      17000

75 rows selected.
{% endhighlight %}

## Between Predicate

{% gist page.gist "006g-not-between-predicate.sql" %}

Maka berikut adalah hasilnya:

{% highlight sql %}
EMPLOYEE_ID FIRST_NAME           DEPARTMENT_ID     SALARY
----------- -------------------- ------------- ----------
        198 Donald                          50       2600
        199 Douglas                         50       2600
        201 Michael                         20      13000
        205 Shelley                        110      12008
        100 Steven                          90      24000
        101 Neena                           90      17000
        102 Lex                             90      17000
        108 Nancy                          100      12008
        115 Alexander                       30       3100
        116 Shelli                          30       2900
        117 Sigal                           30       2800

50 rows selected.
{% endhighlight %}

## IS Null Predicate

{% gist page.gist "006g-is-not-null-predicate.sql" %}

Maka berikut adalah hasilnya:

{% highlight sql %}
EMPLOYEE_ID FIRST_NAME           COMMISSION_PCT     SALARY
----------- -------------------- -------------- ----------
        145 John                             .4      14000
        146 Karen                            .3      13500
        147 Alberto                          .3      12000
        148 Gerald                           .3      11000
        149 Eleni                            .2      10500
        150 Peter                            .3      10000
        151 David                           .25       9500
        152 Peter                           .25       9000
        153 Christopher                      .2       8000
        154 Nanette                          .2       7500
        155 Oliver                          .15       7000

35 rows selected.
{% endhighlight %}

## In Predicate

{% gist page.gist "006g-not-in-predicate.sql" %}

Maka berikut adalah hasilnya:

{% highlight sql %}
EMPLOYEE_ID FIRST_NAME           DEPARTMENT_ID     SALARY
----------- -------------------- ------------- ----------
        200 Jennifer                        10       4400
        201 Michael                         20      13000
        202 Pat                             20       6000
        203 Susan                           40       6500
        204 Hermann                         70      10000
        205 Shelley                        110      12008
        206 William                        110       8300
        108 Nancy                          100      12008
        109 Daniel                         100       9000
        110 John                           100       8200
        111 Ismael                         100       7700

19 rows selected.
{% endhighlight %}

## Exists Predicate

{% gist page.gist "006g-not-exists-predicate.sql" %}

Maka berikut adalah hasilnya:

{% highlight sql %}
EMPLOYEE_ID FIRST_NAME           DEPARTMENT_ID
----------- -------------------- -------------
        178 Kimberely
{% endhighlight %}