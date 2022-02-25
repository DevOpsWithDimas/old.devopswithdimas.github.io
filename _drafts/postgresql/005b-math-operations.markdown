---
layout: post
title: "Operasi matematika di PostgreSQL"
date: 2017-11-27T11:05:10+07:00
lang: psql
categories:
- RDBMS
- PostgreSQL
refs: []
youtube: ytKK6l698Wk
comments: true
gist: dimMaryanto93/62ffa0d81f3835a4e9401baf14590cd2
downloads: []
---


## Operasi pada karakter

Untuk operator di string atau karakter pada dasarnya cuman ada operator concat dengan simbol `||` cara penggunaannya seperti berikut:

{% gist page.gist "select-concat-double-pipe.sql" %}

Jika di jalankan maka hasilnya sebagai berikut:

{% highlight postgresql-console %}
  nama_lengkap  
----------------
 Dimas Maryanto
(1 row)
{% endhighlight %}

## Operasi pada Date

Operasi matematika pada tanggal juga bisa dilakukan, diantaranya seperti berikut:

