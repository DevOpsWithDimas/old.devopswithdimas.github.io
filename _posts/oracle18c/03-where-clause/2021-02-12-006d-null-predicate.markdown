---
layout: post
title: "Null Conditions pada klausa where di Oracle"
date: 2021-02-12T19:33:57+07:00
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/Null-Conditions.html#GUID-657F2BA6-5687-4A00-8C2F-57515FD2DAEB
youtube: tnxd-ebe-A8
comments: true
image_path: /resources/posts/oracle12c/
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Operator `IS NULL` digunakan untuk memfiter data yang bernilai null. Contoh kasusnya, saya mau menampilkan data karywan yang tidak memiliki manager. Berikut querynya:

{% gist page.gist "006d-select-where-is-null.sql" %}

Berikut hasilnya:

{% highlight sql %}
EMPLOYEE_ID FIRST_NAME               SALARY JOB_ID
----------- -------------------- ---------- ----------
        100 Steven                    24000 AD_PRES
{% endhighlight %}
