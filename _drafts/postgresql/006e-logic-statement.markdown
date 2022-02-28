---
layout: post
title: "Logical statement di PostgreSQl"
date: 2018-11-09T20:40:12+07:00
lang: psql
categories:
- RDBMS
- PostgreSQL
refs: []
youtube: 
comments: true
gist: dimMaryanto93/62ffa0d81f3835a4e9401baf14590cd2
downloads: []
---

# AND Statement

Kasusnya saya mau mencari data karyawan yang berkerja di `department_id = 90` dan yang `manager_id = 100`, berikut querynya:

{% gist page.gist "select-where-combine-and.sql" %}

Berikut hasilnya:

```postgresql-console
 kode | nama_depan 
------+------------
  101 | Neena
  102 | Lex
(2 rows)
```

# OR Statement

Kasusnya saya mau mencari data karyawan yang memiliki `salary >= 12000` atau karyawan yang berkerja di `department_id = 90`, berikut querynya:

{% gist page.gist "select-where-combine-or.sql" %}

Berikut hasilnya:

```postgresql-console
 kode | nama_depan | gaji_bulanan 
------+------------+--------------
  100 | Steven     |     24000.00
  101 | Neena      |     17000.00
  102 | Lex        |     17000.00
  108 | Nancy      |     12000.00
  145 | John       |     14000.00
  146 | Karen      |     13500.00
  147 | Alberto    |     12000.00
  201 | Michael    |     13000.00
  205 | Shelley    |     12000.00
(9 rows)
```

# NOT Statement

Kasusnya saya mau mencari data department selain yang `department_id = 90`, berikut querynya:

{% gist page.gist "select-where-combine-not.sql" %}

Berikut hasilnya:

```postgresql-console
 kode | nama_depan  | divisi | gaji_bulanan 
------+-------------+--------+--------------
  103 | Alexander   |     60 |      9000.00
  104 | Bruce       |     60 |      6000.00
  105 | David       |     60 |      4800.00
  106 | Valli       |     60 |      4800.00
  107 | Diana       |     60 |      4200.00
  108 | Nancy       |    100 |     12000.00
  109 | Daniel      |    100 |      9000.00
  110 | John        |    100 |      8200.00
  111 | Ismael      |    100 |      7700.00
  112 | Jose Manuel |    100 |      7800.00
  113 | Luis        |    100 |      6900.00
  114 | Den         |     30 |     11000.00
  115 | Alexander   |     30 |      3100.00
  116 | Shelli      |     30 |      2900.00
  117 | Sigal       |     30 |      2800.00
  118 | Guy         |     30 |      2600.00
  119 | Karen       |     30 |      2500.00
  120 | Matthew     |     50 |      8000.00
  121 | Adam        |     50 |      8200.00
  122 | Payam       |     50 |      7900.00
  123 | Shanta      |     50 |      6500.00
(103 rows)  
```

Selain itu kita bisa kombinansikan semua logika, contoh kasusnya seperti berikut. Saya mau mancari data karyawan yang bekerja di `department_id = 100` atau yang `manager_id = 108` dan memiliki `salary >= 9000` dan yang `first_name` bukan `Daniel`. Berikut querynya:

{% gist page.gist "select-where-combine-all.sql" %}

Berikut hasilnya;

```postgresql-console
 kode | nama_depan | divisi | gaji_bulanan | manager 
------+------------+--------+--------------+---------
  108 | Nancy      |    100 |     12000.00 |     101
(1 row)
```

