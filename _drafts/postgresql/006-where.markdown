---
layout: post
title: "Filtering data dengan where klausa di SQL"
date: 2018-11-09T00:04:07+07:00
lang: psql
categories:
- RDBMS
- PostgreSQL
refs: []
youtube: 4PR_UBKpooU
comments: true
image_path: /resources/posts/psql/psql-where
gist: dimMaryanto93/62ffa0d81f3835a4e9401baf14590cd2
downloads: []
---

Penggunaan klausa `where` digunakan untuk melakukan filter berdasarkan kolom dan operator tertentu contoh paling basic adalah operator `equals` atau `=`, Kasusnya saya punya beberapa nah kemudian saya cuman mau data yang ditampilkan berdasarkan criteria tertentu contohnya ilustrasi seperti berikut:

![where basic]({{ page.image_path | prepend: site.baseurl }}/konsep-where.png)

Ok, nah sekarang kita ke contoh query sqlnya. Berikut saya punya data dari table `countries` :

```sql
 country_id |       country_name       | region_id 
------------+--------------------------+-----------
 AR         | Argentina                |         2
 AU         | Australia                |         3
 BE         | Belgium                  |         1
 BR         | Brazil                   |         2
 CA         | Canada                   |         2
 CH         | Switzerland              |         1
 CN         | China                    |         3
 DE         | Germany                  |         1
 DK         | Denmark                  |         1
 EG         | Egypt                    |         4
 FR         | France                   |         1
 HK         | HongKong                 |         3
 IL         | Israel                   |         4
 IN         | India                    |         3
 IT         | Italy                    |         1
 JP         | Japan                    |         3
 KW         | Kuwait                   |         4
 MX         | Mexico                   |         2
 NG         | Nigeria                  |         4
 NL         | Netherlands              |         1
 SG         | Singapore                |         3
 UK         | United Kingdom           |         1
 US         | United States of America |         2
 ZM         | Zambia                   |         4
 ZW         | Zimbabwe                 |         4
(25 rows)
```

Sekarang saya mau menampilkan yang kolom `region_id` sama dengan `1` berikut contoh querynya:

{% gist page.gist "select-where.sql" %}

Berikut hasilnya:

```sql
 id |      name      
----+----------------
 BE | Belgium
 CH | Switzerland
 DE | Germany
 DK | Denmark
 FR | France
 IT | Italy
 NL | Netherlands
 UK | United Kingdom
(8 rows)
```

Nah sekarang tinggal anda check aja, benar gak atau sesuaikan datanya dengan data diatas klo `region_id = 1`?

## Predicates / Conditional

Predicate / Conditional ada beberapa operator yang bisa digunakan diantaranya

1. Relational Predicate
2. Like Predicate
3. Like Predicate
4. Nulless Predicate
5. Logical Statement