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
2. Comparation operators
3. Logic operators
4. Typecast operators
5. Range containment operators

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
| `!` 	      |   factorial 	  | `5 !`           |     `120` |
| `@` 	      |   absolute value  | `@ -5.0`        | 	    `5` |