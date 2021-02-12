---
layout: post
title: "In Predicates di Oracle"
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/IN-Condition.html#GUID-C7961CB3-8F60-47E0-96EB-BDCF5DB1317C
youtube: 
comments: true
image_path: /resources/posts/oracle12c/
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

In predicate, digunakan untuk memfilter data berdasarkan daftar data tertentu, contohnya berikut kasusnya. Tampilkan data karyawan yang memiliki `job_id` = `AC_ACCOUNT`, `HR_REP`, `IT_PROG`, dan `ST_CLERK` maka berikut adalah implementasi querynya:

{% gist page.gist "006e-select-where-in-predicate.sql" %}

Maka berikut hasilnya:

{% highlight sql %}
EMPLOYEE_ID FIRST_NAME           JOB_ID         SALARY
----------- -------------------- ---------- ----------
        203 Susan                HR_REP           6500
        206 William              AC_ACCOUNT       8300
        103 Alexander            IT_PROG          9000
        104 Bruce                IT_PROG          6000
        105 David                IT_PROG          4800
        106 Valli                IT_PROG          4800
        107 Diana                IT_PROG          4200
        125 Julia                ST_CLERK         3200
        126 Irene                ST_CLERK         2700
        127 James                ST_CLERK         2400
        128 Steven               ST_CLERK         2200

27 rows selected.
{% endhighlight %}