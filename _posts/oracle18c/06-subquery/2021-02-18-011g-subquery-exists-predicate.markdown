---
layout: post
title: "Sub Query EXIST Predicates di Oracle"
date: 2021-02-18T19:23:41+07:00
lang: oracle18c
authors:
- dimasm93
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/database/121/index.htm
youtube: UOgv3xDLqUI
comments: true
catalog_key: sql-subquery
image_path: /resources/posts/oracle12c/011f-subquery-exist-predicate
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Operator `EXISTS` digunakan untuk memeriksa apakah suatu inner query menghasilkan data atau tidak, kita inner query menghasilkan data minimal 1 data maka outer query akan di jalankan karena bernilai TRUE, tetapi jika bernilai FALSE maka outer query tidak akan di jalankan. Contoh penggunaannya seperti berikut:

{% gist page.gist "011g-subquery-exist-predicate.sql" %}

Berikut hasilnya:

{% highlight sql %}
EMPLOYEE_ID FIRST_NAME               SALARY
----------- -------------------- ----------
        198 Donald                     2600
        199 Douglas                    2600
        200 Jennifer                   4400
        201 Michael                   13000
        202 Pat                        6000
        203 Susan                      6500
        204 Hermann                   10000
        205 Shelley                   12008
        206 William                    8300
        101 Neena                     17000

106 rows selected.
{% endhighlight %}

Jadi kesimpulannya adalah, dengan operator `exists` contohnya kita bisa memeriksa pegawai mana saja yang memiliki bawahan. 