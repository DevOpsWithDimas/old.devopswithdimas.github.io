---
layout: post
title: "Limit dan Offset rows"
date: 2018-11-10T11:51:27+07:00
lang: psql
categories:
- RDBMS
- PostgreSQL
refs: 
- https://www.postgresql.org/docs/9.3/queries-limit.html
youtube: 2vHlPb47eUA
comments: true
image_path: /resources/posts/psql/psql-limit-offset
gist: dimMaryanto93/62ffa0d81f3835a4e9401baf14590cd2
downloads: []
---

Untuk klausa `offset` dan `limit` ini juga sama pentingnya ketika data growing up di database. Ketika kita hit query yang datanya bisa sampe ratusan juta itu brati processor dan memori akan bekerja untuk meload semuanya. Nah untuk itu kita butuh pembatas agar pemakaian memori dan cpu dapat di maksimalkan. Berikut konsep limit dan offset:

![limit offset]({{ page.image_path | prepend: site.baseurl }}/konsep-limit-offset.png)

Dari gambar ilustrasi diatas, kita bisa simpulkan kalo klasa `limit` itu ya seperti bahasa indonesianya yaitu batas maksimum sedangkan `offset` artinya kita mulai dari bari ke.

Berikut contoh query penggunannya:

{% gist page.gist "select-limit-offset.sql" %}

Berikut hasilnya:

```postgresql-console
 kode |  nama  
------+--------
  105 | David
  106 | Valli
  107 | Diana
  108 | Nancy
  109 | Daniel
(5 rows)
```

Klausa `limit` dan `offset` bisa di run secara terpisah ya, tidak harus di pasang dua duanya, berikut querynya:

{% gist page.gist "select-limit.sql" %}

{% gist page.gist "select-offset.sql" %}

