---
layout: post
title: "Like Predicate pada klausa where di Oracle"
date: 2021-02-11T20:48:38+07:00
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/Pattern-matching-Conditions.html#GUID-0779657B-06A8-441F-90C5-044B47862A0A
youtube: fnZ5guiUohs
comments: true
catalog_key: sql-where-clause
image_path: /resources/posts/oracle12c/
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---


Operator like biasanya digunakan untuk tipe data `varchar` atau string, ada 2 expresion yang kita bisa gunakan di operator ini yaitu 

1. `_` atau underscore, digunakan untuk mewakili expresion satu karakter.
2. `%` atau persent, digunakan untuk mewakili expresion beberapa karakter.

Contoh kasus untuk expresion `%`, saya ingin mencari nama depan karyawan yang diawali oleh huruf `A`. Berikut querynya:

{% gist page.gist "006b-select-where-like-percent-el.sql" %}

Berikut hasilnya:

{% highlight sql %}
EMPLOYEE_ID LAST_NAME                 JOB_ID         SALARY
----------- ------------------------- ---------- ----------
        174 Abel                      SA_REP          11000
        166 Ande                      SA_REP           6400
        130 Atkinson                  ST_CLERK         2800
        105 Austin                    IT_PROG          4800
{% endhighlight %}

Contoh kasus untuk expresion `_`, saya ingin mencari huruf ke 2 dari kolom `job_id` di tabel `jobs` mengadung `T`. Berikut querynya:

{% gist page.gist "006b-select-where-like-underscore-el.sql" %}

Berikut hasilnya:

{% highlight sql %}
JOB_ID     JOB_TITLE
---------- -----------------------------------
ST_MAN     Stock Manager
ST_CLERK   Stock Clerk
IT_PROG    Programmer
{% endhighlight %}

Selain itu juga kita bisa menggunakan Regex Expression, menggunakan operator `regexp_like` seperti berikut querynya:

{% gist page.gist "006b-select-where-regexp_like.sql" %}

Berikut hasilnya:

{% highlight sql %}
FIRST_NAME           LAST_NAME
-------------------- -------------------------
Steven               King
Steven               Markle
Stephen              Stiles
{% endhighlight %}
