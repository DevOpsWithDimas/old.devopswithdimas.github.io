---
layout: post
title: "Number Single Row Function di Oracle"
date: 2021-02-13T19:49:14+07:00
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/Single-Row-Functions.html#GUID-AC0E8A99-5097-4147-8295-C88EAC5AA362
youtube: HaHA3oUe3p8
comments: true
catalog_key: sql-functions
image_path: /resources/posts/oracle12c/
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---


Ada beberapa function yang kita bisa gunakan untuk memformat number:

| Function  | Keterangan                        |
|:----------|:----------------------------------|
| `CEIL`    | Untuk pembulatan ke atas          |
| `ABS`     | Untuk nilai selalu positif        |
| `FLOOR`   | Untuk pembulatan ke bawah         |
| `MOD`     | Untuk sisa bagi                   |
| `POWER`   | Untuk pangkat                     |
| `ROUND`   | Untuk pembulatan pecahan          |
| `SQRT`    | Untuk menghitung akar             |
| `coalese` | Nilai null dengan default value   |

Berikut beberapa contoh penggunakan function di number, berikut querynya:

{% gist page.gist "008b-single-row-function-number.sql" %}

Berikut hasilnya:

{% highlight sql %}
COMMISION_PCT       GAJI  SISA_BAGI    PANGKAT       AKAR
------------- ---------- ---------- ---------- ----------
            0       2600          2       6.76 7.07106781
            0       2600          2       6.76 7.07106781
            0       4400          2      19.36 7.07106781
            0      13000          2        169 7.07106781
            0       6000          2         36 7.07106781
            0       6500          2      42.25 7.07106781
            0      10000          2        100 7.07106781
            0      12008          2 144.192064 7.07106781
            0       8300          2      68.89 7.07106781
            0      24000          2        576 7.07106781
            0      17000          2        289 7.07106781

107 rows selected.
{% endhighlight %}