---
layout: post
title: "Null-Related Single Row Function"
date: 2021-02-14T22:08:50+07:00
lang: oracle18c
authors:
- dimasm93
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/Single-Row-Functions.html#GUID-C4201DFA-90C5-46DA-B528-0B6D4E8C647A
youtube: R3C4VoDcIBo
comments: true
catalog_key: sql-functions
image_path: /resources/posts/oracle12c/
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Null Related Function pada dasarnya function yang digunakan untuk mengandle nilai `null` dengan ketentuan tertentu, berikut adalah function yang kita bisa gunakan di oracle

<!--more-->

| Function      | Keterangan                         |
|:----------    |:---------------------------------- |
| `COALESCE`    | Mengembalikan hasil pertama yang tidak null dari sebuah argument |
| `LNNVL`       | Include `null` value ketika di bandingkan dengan argument |
| `NANVL`       | Digunakan untuk menghandle floating point bersifat `NaN` atau `infinity` |
| `NULLIF`      |  Jika `arg1` dan `arg2` bernilai sama maka kembalikan nilai `null` tetepi jika beda kembalikan `arg1`|
| `NVL`         | Check `arg1` jika null kembalikan `arg2` |
| `NVL2`        | Check `arg1` jika tidak null kembalikan `arg2` tetapi jik null kebalikan `arg3` |

Berikut adalah contoh penggunaanya:

{% gist page.gist "008f-null-related-function.sql" %}

Berikut adalah hasilnya:

{% highlight sql %}
    EMP_ID NAME                 COMMISSION_PCT MANAGER_ID               SALARY     INCOME
---------- -------------------- -------------- -----------              ---------- ----------
       155 Oliver                          .15 145                      7000        7000.15
       163 Danielle                        .15 147                      9500        9500.15
       164 Mattea                           .1 147                      7200        7200.1
       181 Jean                              0 120                      3100        3100
       182 Martha                            0 120                      2500        2500
       183 Girard                            0 120                      2800        2800
       100 Steven                            0 Tidak Memiliki Manager   24000       24000

83 rows selected.
{% endhighlight %}