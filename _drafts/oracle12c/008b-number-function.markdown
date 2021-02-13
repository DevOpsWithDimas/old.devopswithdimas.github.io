---
layout: post
title: "009b-number-function"
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/Single-Row-Functions.html#GUID-AC0E8A99-5097-4147-8295-C88EAC5AA362
youtube: 
comments: true
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

```postgresql-console
 commision_pct |   gaji   | sisa_bagi |       pangkat        |       akar       
---------------+----------+-----------+----------------------+------------------
             0 | 24000.00 |         2 | 576.0000000000000000 | 7.07106781186548
             0 | 17000.00 |         2 | 289.0000000000000000 | 7.07106781186548
             0 | 17000.00 |         2 | 289.0000000000000000 | 7.07106781186548
             0 |  9000.00 |         2 |  81.0000000000000000 | 7.07106781186548
             0 |  6000.00 |         2 |  36.0000000000000000 | 7.07106781186548
             0 |  4800.00 |         2 |  23.0400000000000000 | 7.07106781186548
             0 |  4800.00 |         2 |  23.0400000000000000 | 7.07106781186548
             0 |  4200.00 |         2 |  17.6400000000000000 | 7.07106781186548
             0 | 12000.00 |         2 | 144.0000000000000000 | 7.07106781186548
             0 |  9000.00 |         2 |  81.0000000000000000 | 7.07106781186548
(10 rows)
```
