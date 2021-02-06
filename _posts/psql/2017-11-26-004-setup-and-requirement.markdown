---
layout: post
title: "Persiapan belajar PostgreSQL"
date: 2017-11-26T20:27:57+07:00
lang: psql
categories:
- RDBMS
- PostgreSQL
refs: []
youtube: https://www.youtube.com/watch?v=mLC3DBBboTk&list=PLV1-tdmPblvypZXSk2GC932nludT345xk&index=2
comments: true
gist: dimMaryanto93/62ffa0d81f3835a4e9401baf14590cd2
---

Setelah melakukan proses installasi _software_ PostgreSQL dan PgAdmin3 / PgAdmin4, tahap selanjutnya kita akan membuat scema atau role, berikut adalah caranya.

## Login as user `postgres`

Login sebagai postgres, yang pertama harus di ingat adalah _password_ postgres didapatkan ketika melakukan installasi software PostgreSQL. setelah itu baru bisa login sebagai user postgres dengan cara seperti berikut:

{% gist page.gist "login-postgres.bash" %}

Kemudian kita buat schema dengan perintah seperti berikut:

{% gist page.gist "create-database-hr.sql" %}

Setelah membuat user dengan _username_ `hr` dan passwornya sama dengan _username_ yaitu `hr`, tahap selanjutnya kita login sebagai user `hr`, dengan perintah seperti berikut:

## Login as user `hr`

{% highlight psql %}
psql -h localhost -U hr
{% endhighlight %}

Setelah login sebagai `hr` kemudian kita buat satu database dengan nama yang sama dengan username, dengan perintah seperti berikut:

{% gist page.gist "create-database-hr.bash" %}

Setelah database terbuat, kemudian download [file ini]({{ site.baseurl }}/resources/downloads/file/psql-schema.sql) setelah itu jalankan querynya dengan connection user `hr`.