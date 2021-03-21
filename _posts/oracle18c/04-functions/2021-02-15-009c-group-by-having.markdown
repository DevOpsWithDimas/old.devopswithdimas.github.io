---
layout: post
title: "Having clause dengan Group By Function"
date: 2021-02-15T05:27:31+07:00
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/database/121/index.htm
- https://docs.oracle.com/en/bigdata/index.html
youtube: RR5qoOK27y4
comments: true
image_path: /resources/posts/oracle12c/009c-group-by-having
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---


Untuk filter data dengan klausa `having` di dalam `group by` secara ilustrasi bisa digambarkan seperti berikut:

![ilustrasi having]({{ page.image_path | prepend: site.baseurl }}/konsep-group-by-having.png)

contoh kasusnya seperti berikut. Tampilkan jumlah karyawan per `manager_id` kemudian filter data karyawan yang jumlahnya lebih dari sama dengan `5`. Berikut querynya:

{% gist page.gist "009c-group-by-having-clausa.sql" %}

Berikut hasilnya:

{% highlight sql %}
MANAGER_ID JUMLAH_KARYAWAN
---------- ---------------
       100              14
       101               5
       108               5
       114               5
       120               8
       121               8
       122               8
       123               8
       124               8
       145               6
       146               6
       147               6
       148               6
       149               6

14 rows selected.
{% endhighlight %}
