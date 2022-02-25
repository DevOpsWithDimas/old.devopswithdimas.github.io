---
layout: post
title: "PostgreSQL Operators"
lang: postgresql
categories:
- RDBMS
- PostgreSQL
refs: 
- https://www.postgresql.org/docs/current/
youtube: 
image_path: /resources/posts/postgresql/03b-sql-operators
comments: true
gist: dimMaryanto93/7ae7632f9418feb724bc431eff412a3f
catalog_key: sql-statement
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas Operators pada PostgreSQL, Operators sendiri ada beberapa seperti:

1. Math operators
2. Concate operators
3. Comparation operators
4. Logic operators
5. Typecast operators
6. Range containment operators

Ok langsung aja kita bahas materi yang pertama

## Math operators

Dalam SQL, kita juga bisa melakukan operasi matematika seperti pertambahan, pengurangan, pembagian, dan perkalian. Operasi tersebut dibagi-bagi lagi menjadi beberapa tipe yaitu

1. Operasi yang bernilai bilangan,
2. Operasi yang bernilai Date,
3. Operasi yang bernilai karakter

Operasi pada bilangan pada dasarnya sama seperti operasi matematika biasa, seperti berikut table operasinya:

| Operator 	  |   Description     |	Example         |	Result  |
| :------- 	  |   :----------     |	:------         |	:-----  |
| `+` 	      |   addition 	      | `2 + 3`         |       `5` |
| `-` 	      |   subtraction 	  | `2 - 3`         |      `-1` |
| `*` 	      |   multiplication  | `2 * 3`         |       `6` |
| `/` 	      |   division        |	`4 / 2`         |       `2` |
| `%` 	      |   modulo          | `5 % 4`         |       `1` |
| `^` 	      |   exponentiation  | `2.0 ^ 3.0`     |       `8` |
| `@` 	      |   absolute value  | `@ -5.0`        | 	    `5` |

Contoh penggunaan dalam SQL seperti berikut:

{% gist page.gist "03b-select-math-operation.sql" %}

Jika di running maka hasilnya seperti berikut:

```bash
 tambah | kali | bagi | pangkat | abs | mod
--------+------+------+---------+-----+-----
      4 |    4 |    1 |       8 | 5.3 |   0
(1 row)
```

Contoh lainnya, menggunakan penjumlahan dalam suatu table, seperti berikut:

{% gist page.gist "03b-select-math-column-operation.sql" %}

Jika dijalankan hasilnya seperti berikut:

```bash
 first_name  | gaji_plus 
-------------+-----------
 Steven      |  25000.00
 Neena       |  18000.00
 Lex         |  18000.00
 Bruce       |   7000.00
 Nancy       |  13000.00
 Daniel      |  10000.00
 John        |   9200.00
 Ismael      |   8700.00
 Jose Manuel |   8800.00
```

Operasi matematika pada tanggal juga bisa dilakukan, diantaranya seperti berikut:

{% gist page.gist "03b-select-math-date-operation.sql" %}

```bash
    lusa    |   besok    | kurang 2 hari |     kurang 2jam     | tambah 1 hari | durasi dalam hari |    kurang 15jam     | target harus selesai |   jam makan siang
------------+------------+---------------+---------------------+---------------+-------------------+---------------------+----------------------+---------------------
 2022-02-23 | 2022-02-26 | 2017-03-26    | 2017-03-27 22:00:00 | 2017-03-29    |                15 | 2017-03-28 03:20:00 | 2017-04-23 00:00:00  | 2017-03-02 12:19:30
(1 row)
```

## Concate operators