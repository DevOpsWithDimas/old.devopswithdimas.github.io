---
layout: post
title: "012a-subquery-single-row"
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/database/121/index.htm
- https://docs.oracle.com/en/bigdata/index.html
youtube: 
comments: true
image_path: /resources/posts/oracle12c/
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

| Symbol  | Keterangan  |
| :---    | :---        |
| `=`     | Melakukan perbandingan dengan nilai yang **bernilai sama** |
| `>`     | Melakukan perbandingna terhadap 2 variable apakah variable yang satu **lebih besar atau sama dengan** variable lainnya |
| `<`     | Kebalikan dari symbol `>` yaitu **lebih kecil** |

{% gist page.gist "011a-select-sub-query-where.sql" %}

Berikut hasilnya:

```postgresql-console
 nik |  nama  | gaji_sebulan 
-----+--------+--------------
 100 | Steven |     24000.00
 101 | Neena  |     17000.00
 102 | Lex    |     17000.00
 145 | John   |     14000.00
 146 | Karen  |     13500.00
(5 rows)
```
