---
layout: post
title: "Character Single Row Function di Oracle"
date: 2021-02-13T19:45:56+07:00
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/Single-Row-Functions.html#GUID-06062705-1EC8-44ED-89B8-0F0573B74EA2
youtube: D2Ifv2FSHoQ
comments: true
catalog_key: sql-functions
image_path: /resources/posts/oracle12c/
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Untuk fungsi text ini lumayan banyak, seperti berikut:

| Function  | Keterangan                        |
|:----------|:----------------------------------|
| `ASCII`   | Menformat dari charater ke asci   |
| `CHR`     | Memformat dari asci ke character  |
| `CONCAT`  | Menggabungkan 2 karakter          |
| `INITCAP` | Format awal huruf dari kata menjadi kapital |
| `LOWER`   | Format semua huruf menjadi huruf kecil | 
| `UPPER`   | Format semua huruf menjadi huruf kapital |
| `INSTR`   | Mencari posisi / index dari suatu kalimat berdasarkan parameter tertentu |
| `LENGTH`  | Menghitung jumlah karakter|
| `LPAD`    | Memformat menjadi rata kirim |
| `RPAD`    | Memformat menjadi rata kanan |
| `LTRIM`   | Memotong kalimat dari sebelah kirim berdasarkan parameter |
| `RTRIM`   | Memotong kalimat dari sebelah kanan berdasarkan parameter |
| `TRIM`    | Memotong kalimat dari 2 sisi berdasarkan parameter |
| `REPLACE` | Mengganti kalimat berdasarkan parameter |
| `SUBSTR`  | Mengambil beberapa huruf berdasarkan posisi awal dan akhir |

Untuk lebih lengkapnya lagi bisa check [dokumentasi](https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/Single-Row-Functions.html#GUID-06062705-1EC8-44ED-89B8-0F0573B74EA2)

Berikut adalah contoh salah satu penggunaannya, saya mau memformat data karyawan `first_name` di jadikan huruf kapital, sedangkan untuk `last_name` saya mau hitung jumlahnya berapa, gabungkan column `first_name` dan `last_name`. Berikut querynya:

{% gist page.gist "008a-single-row-function-string.sql" %}

Berikut hasilnya:

{% highlight sql %}
NAMA_DEPAN_KAPITAL       JUMLAH NAMA
-------------------- ---------- ----------------------------------------------
ELLEN                         4 Ellen Abel
SUNDAR                        4 Sundar Ande
MOZHE                         8 Mozhe Atkinson
DAVID                         6 David Austin
HERMANN                       4 Hermann Baer
SHELLI                        5 Shelli Baida
AMIT                          5 Amit Banda
ELIZABETH                     5 Elizabeth Bates
SARAH                         4 Sarah Bell
DAVID                         9 David Bernstein
LAURA                         6 Laura Bissot

107 rows selected.
{% endhighlight %}

