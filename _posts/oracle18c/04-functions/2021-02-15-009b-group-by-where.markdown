---
layout: post
title: "Where clause dengan Group By Function"
date: 2021-02-15T05:19:00+07:00
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/database/121/index.htm
- https://docs.oracle.com/en/bigdata/index.html
youtube: 47fk9aJcza4
comments: true
image_path: /resources/posts/oracle12c/009b-group-by-where
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Untuk filter data dengan klausa `where` di dalam `group by` secara ilustrasi bisa digambarkan seperti berikut:

![ilustrasi filter dengan where]({{ page.image_path | prepend: site.baseurl }}/konsep-group-by-where.png)

Jadi klausa dengan `whare` dia prosesnya akan melakukan filter terlebih dahulu sebelum dilakukan proses `group by`. berikut contoh kasusnya, Tampilkan jumlah karyawan yang memiliki gaji perbulan lebih sebesar sama dengan `5000` kemudian kategorikan berdasarkan `manager_id`. Berikut querynya:

{% gist page.gist "009b-group-by-where-clausa.sql" %}

Berikut hasilnya:

{% highlight sql %}
MANAGER_ID JUMLAH_KARYAWAN
---------- ---------------
       100              14
       101               4
       102               1
       103               1
       108               5
       145               6
       146               6
       147               6
       148               6
       149               6
       201               1
       205               1
    <null>               1

13 rows selected.
{% endhighlight %}

