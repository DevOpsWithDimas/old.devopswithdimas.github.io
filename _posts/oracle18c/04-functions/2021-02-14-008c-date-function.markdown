---
layout: post
title: "Date & Time Single Row Function di Oracle"
date: 2021-02-14T16:18:31+07:00
lang: oracle18c
authors:
- dimasm93
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/Single-Row-Functions.html#GUID-5652DBC2-41C7-4F07-BEDD-DAF620E35F3C
youtube: D2Ifv2FSHoQ
comments: true
catalog_key: sql-functions
image_path: /resources/posts/oracle12c/
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Berikut adalah beberapa function untuk tipe data Date & Time di Oracle:

| Function              | Keterangan                                                            |
|:----------            |:----------------------------------                                    |
| `ADD_MONTHS`          | Mengembalikan tipe data tanggal dengan di tambah perameterize `int`   |
| `CURRENT_DATE`        | Mengembalikan tipe data tanggal pada session saat ini                 |
| `CURRENT_TIMESTAMP`   | Mengembalikan tipe data tanggal + time pada session saat ini          |
| `EXTRACT`             | Mengembalikan tipe data datetime berdasarkan parameter tertentu       |
| `MONTH_BETWEEN`       | Mengembalikan tipe data number dari rentang `date1` dan `date2`       |
| `NEXT_DAY`            | Mengembalikan tipe data tanggal dari first weekday setelahnya         |
| `SYSDATE`             | Mengembalikan tipe data tanggal dari System OS                        |
| `SYSTIMESTAMP`        | Mengembalikan tipe data tanggal + waktu dari system OS                |
| `TO_CHAR`             | Digunakan untuk memformat tanggal ke varchar                          |
| `TO_TIMESTAMP`        | Digunakan untuk mengconversi dari varchar ke timestamp                |
| `TO_DATE`             | Digunakan untuk mengconversi dari varchar ke date                     |

Berikut adalah contoh penggunaanya:

{% gist page.gist "008c-date-single-row-function.sql" %}

Berikut hasilnya:

{% highlight sql %}
ADD_MONTH CURRENT_D SYSDATE_F TO_CHAR_FU TO_DATE_F
--------- --------- --------- ---------- ---------
14-MAR-21 14-FEB-21 14-FEB-21 2021/02/14 14-FEB-21
{% endhighlight %}