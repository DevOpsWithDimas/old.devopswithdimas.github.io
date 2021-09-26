---
layout: post
title: "Conversion Single Row Function di Oracle"
date: 2021-02-14T17:15:37+07:00
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/Single-Row-Functions.html#GUID-0E5115DD-F906-4F04-BB70-DF62DD4BBF91
youtube: 5LGq7rjCMLk
comments: true
catalog_key: sql-functions
image_path: /resources/posts/oracle12c/
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Conversion function atau convert biasanya digunakan untuk memtransform nilai menjadi nilai lain, berikut contoh conversion function

| Function              | Keterangan                                                    |
|:----------            |:----------------------------------                            |
| `ASCII`               | Melakukan conversi dari varchar ke asciii                     |
| `ASCIISTR`            | Melakukan conversi dari ascii ke varchar                      |
| `UNISTR`              | Melakukan conversi dari Unicode string literals ke varchar    |
| `BIN_TO_NUM`          | Mengconversi dari binnary ke number / character               |
| `TO_CHAR`             | Memformat dari tipe data tertentu ke varchar                  |
| `TO_DATE`             | Memformat dari tipe data varchar ke date                      |
| `TO_NUMBER`           | Memformat dari tipe data varchar ke Number                    |
| `TO_TIMESTAMP`        | Digunakan untuk mengconversi dari varchar ke timestamp        |

Berikut adalah contoh penggunaannya:

{% gist page.gist "008d-conversion-single-row-function.sql" %}

Berikut hasilnya:

{% highlight sql %}
 ASCII_FUN ASCIISTR_FUN    UNISTR_ BINTONUM_FUN TOCHAR_DATE_FUN               TOCHAR_CURRENCY_FUN       TONUMBER_FUN TODATE_FU
---------- --------------- ------- ------------ ----------------------------- ------------------------- ------------ ---------
        97 AB\FFFD\FFFDCDE AB??CDE           14 14/FEB/2021 10:11:06          $2,000,000.00                  2000000 14-FEB-21
{% endhighlight %}