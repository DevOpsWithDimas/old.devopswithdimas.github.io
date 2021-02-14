---
layout: post
title: "Aggregate Functions"
date: 2021-02-15T04:27:54+07:00
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/Aggregate-Functions.html#GUID-62BE676B-AF18-4E63-BD14-25206FEA0848
youtube: 
comments: true
image_path: /resources/posts/oracle12c/009-aggregate-function
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Aggregate Function bertujuan memproses semua data yang di terjemahkan menjadi satu _result row based_. berikut adalah ilustrasinya:

![group function]({{ page.image_path | prepend: site.baseurl }}/konsep-group-funcation.png)

Ada beberapa function yang kita bisa gunakan, diataranya seperti berikut:

| Function  | Keterangan                        |
|:----------|:----------------------------------|
| `AVG`     | Menghitung nilai rata             |
| `COUNT`   | Menghitung jumlah baris           |
| `MAX`     | Menghitung nilai maximum          |
| `MIN`     | Menghitung nilai minimum          |
| `SUM`     | Menjumlahkan total                |

Berikut contoh implementasinya:

{% gist page.gist "009-aggregate-functions.sql" %}

Berikut hasilnya:

{% highlight sql %}
RATA2_GAJI JML_JOB_ID_UNIQUE  COUNT_ALL MAX_SALARY MIN_SALARY MAX_HIRE_ MIN_HIRE_ SUM_SALARY
---------- ----------------- ---------- ---------- ---------- --------- --------- ----------
   6461.83                19        107      24000       2100 21-APR-08 13-JAN-01     691416
{% endhighlight %}
