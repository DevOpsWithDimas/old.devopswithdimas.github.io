---
layout: post
title: "Klausa having dan where dalam select"
date: 2018-11-12T15:58:05+07:00
lang: psql
categories:
- RDBMS
- PostgreSQL
refs: []
youtube: jf6O6g0MaZc
comments: true
image_path: /resources/posts/psql/psql-group-by
gist: dimMaryanto93/62ffa0d81f3835a4e9401baf14590cd2
downloads: []
---

Untuk filter data dengan klausa `where` di dalam `group by` secara ilustrasi bisa digambarkan seperti berikut:

![ilustrasi filter dengan where]({{ page.image_path | prepend: site.baseurl }}/konsep-group-by-where.png)

Jadi klausa dengan `whare` dia prosesnya akan melakukan filter terlebih dahulu sebelum dilakukan proses `group by`. berikut contoh kasusnya, Tampilkan jumlah karyawan yang memiliki gaji perbulan lebih sebesar sama dengan `5000` kemudian kategorikan berdasarkan `manager_id`. Berikut querynya:

{% gist page.gist "select-filter-where-group-by.sql" %}

Berikut hasilnya:

```postgresql_console
 manager_id | jumlah_karyawan 
------------+-----------------
        100 |              14
        101 |               4
        102 |               1
        103 |               1
        108 |               5
        145 |               6
        146 |               6
        147 |               6
        148 |               6
        149 |               6
        201 |               1
        205 |               1
            |               1
(13 rows)
```

Sekarang, bagaimana jika saya mau filternya setelah di `group by` maka gunakan `having` berikut ilustrasinya:

![ilustrasi having]({{ page.image_path | prepend: site.baseurl }}/konsep-group-by-having.png)

contoh kasusnya seperti berikut. Tampilkan jumlah karyawan per `manager_id` kemudian filter data karyawan yang jumlahnya lebih dari sama dengan `5`. Berikut querynya:

{% gist page.gist "select-filter-having-group-by.sql" %}

Berikut hasilnya:

```postgresql-console
 manager_id | jumlah_karyawan 
------------+-----------------
        100 |              14
        101 |               5
        108 |               5
        114 |               5
        120 |               8
        121 |               8
        122 |               8
        123 |               8
        124 |               8
        145 |               6
        146 |               6
        147 |               6
        148 |               6
        149 |               6
(14 rows)
```

Selain itu juga kita gunakan filter `having` dan `whare` secara bersamaan contohnya seperti berikut:

{% gist page.gist "select-filter-having-and-where-group-by.sql" %}

Berikut hasilnya:

```postgresql-console
 manager_id | jumlah_karyawan 
------------+-----------------
        100 |              14
        108 |               5
        145 |               6
        146 |               6
        147 |               6
        148 |               6
        149 |               6
(7 rows)
```