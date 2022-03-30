---
layout: post
title: "Between Predicate pada klausa where di Oracle"
date: 2021-02-12T19:28:41+07:00
lang: oracle18c
authors:
- dimasm93
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/BETWEEN-Condition.html#GUID-868A7C9D-EDF9-44E7-91B5-C3F69E503CCB
youtube: JcviFusRNuE
comments: true
catalog_key: sql-where-clause
image_path: /resources/posts/oracle12c/
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---


Operator `BETWEEN` digunakan untuk memfilter dengan interval/rentang tertentu diantar nilai terkecil dan terbesar. Untuk predicate between ini bisa digunakan untuk beberapa tipe data yaitu:

1. Number
2. Date
3. Character

## Number

contoh kasusnya, Saya mau menampilkan data yang karywan yang memiliki gaji dari `4000` s/d `6000`. Berikut querynya:

{% gist page.gist "006c-select-where-between-number.sql" %}

Berikut hasilnya:

{% highlight sql %}
EMPLOYEE_ID FIRST_NAME               SALARY DEPARTMENT_ID
----------- -------------------- ---------- -------------
        200 Jennifer                   4400            10
        202 Pat                        6000            20
        104 Bruce                      6000            60
        105 David                      4800            60
        106 Valli                      4800            60
        107 Diana                      4200            60
        124 Kevin                      5800            50
        184 Nandita                    4200            50
        185 Alexis                     4100            50
        192 Sarah                      4000            50

10 rows selected.
{% endhighlight %}

## Date

contoh kasusnya, Saya mau menampilkan data yang karywan yang tanggal join dari `2018-01-01` s/d `2018-12-31`, berikut contoh querynya:

{% gist page.gist "006c-select-where-between-date.sql" %}

Berikut hasilnya:

{% highlight sql %}
EMPLOYEE_ID FIRST_NAME               SALARY HIRE_DATE DEPARTMENT_ID
----------- -------------------- ---------- --------- -------------
        199 Douglas                    2600 13-JAN-08            50
        128 Steven                     2200 08-MAR-08            50
        136 Hazel                      2200 06-FEB-08            50
        149 Eleni                     10500 29-JAN-08            80
        164 Mattea                     7200 24-JAN-08            80
        165 David                      6800 23-FEB-08            80
        166 Sundar                     6400 24-MAR-08            80
        167 Amit                       6200 21-APR-08            80
        173 Sundita                    6100 21-APR-08            80
        179 Charles                    6200 04-JAN-08            80
        183 Girard                     2800 03-FEB-08            50
{% endhighlight %}

## Char

contoh kasusnya, Saya mau menampilkan data yang karywan yang nama depan di huruf ke 2nya dari character `a` s/d `i`. Berikut contoh querynya :

{% gist page.gist "006c-select-where-between-char.sql" %}

Berikut hasilnya:

{% highlight sql %}
EMPLOYEE_ID FIRST_NAME           FIRS     SALARY HIRE_DATE DEPARTMENT_ID
----------- -------------------- ---- ---------- --------- -------------
        200 Jennifer             e          4400 17-SEP-03            10
        201 Michael              i         13000 17-FEB-04            20
        202 Pat                  a          6000 17-AUG-05            20
        204 Hermann              e         10000 07-JUN-02            70
        205 Shelley              h         12008 07-JUN-02           110
        206 William              i          8300 07-JUN-02           110
        101 Neena                e         17000 21-SEP-05            90
        102 Lex                  e         17000 13-JAN-01            90
        105 David                a          4800 25-JUN-05            60
        106 Valli                a          4800 05-FEB-06            60
        107 Diana                i          4200 07-FEB-07            60

66 rows selected.
{% endhighlight %}