---
layout: post
title: "Group Function di PostgreSQL"
date: 2018-11-10T20:50:22+07:00
lang: psql
categories:
- RDBMS
- PostgreSQL
refs: 
- https://www.postgresql.org/docs/9.5/functions-aggregate.html
youtube: z5mIVHXBEeE
comments: true
image_path: /resources/posts/psql/psql-group-by
gist: dimMaryanto93/62ffa0d81f3835a4e9401baf14590cd2
downloads: []
---

Pada dasarnya group function, akan memproses banyak data kemudian menterjemahkannya menjadi satu result seperti berikut ilustrasinya:

![group function]({{ page.image_path | prepend: site.baseurl }}/konsep-group-funcation.png)

Ada beberapa function yang kita bisa gunakan, diataranya seperti berikut:

| Function  | Keterangan                        |
|:----------|:----------------------------------|
| `AVG()`   | Menghitung nilai rata             |
| `COUNT()` | Menghitung jumlah baris           |
| `MAX()`   | Menghitung nilai maximum          |
| `MIN()`   | Menghitung nilai minimum          |
| `SUM()`   | Menjumlahkan total                |

Lebih lengkapnya bisa baca dokumentasi [agregate function](https://www.postgresql.org/docs/9.5/functions-aggregate.html). Dan berikut contoh implementasinya:

{% gist page.gist "select-group-function.sql" %}

Berikut hasilnya:

```postgresql-console
 rata2_gaji | jml_baris | max_salary | min_salary | total_salary 
------------+-----------+------------+------------+--------------
    6461.68 |       107 |   24000.00 |    2100.00 |    691400.00
(1 row)
```