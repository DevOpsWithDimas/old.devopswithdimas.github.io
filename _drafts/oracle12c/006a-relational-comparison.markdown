---
layout: post
title: "006a-relational-comparison"
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

Relational Comparison pada where di PostgreSQL teridiri dari:

| Symbol                        | Keterangan  |
| :---                          | :---        |
| `=`                           | Melakukan perbandingan dengan nilai yang **bernilai sama** |
| `!=`                          | Melakukan perbandingan dengan nilai yang **bernilai tidak sama** |
| `<>`                          | Melakukan perbandingan dengan nilai yang **bernilai tidak sama** |
| `>`                           | Melakukan perbandingan terhadap 2 variable apakah variable yang satu **lebih besar** dari variable lainnya |
| `>=`                          | Melakukan perbandingna terhadap 2 variable apakah variable yang satu **lebih besar atau sama dengan** variable lainnya |
| `<`                           | Kebalikan dari symbol `>` yaitu **lebih kecil** |
| `<=`                          | Kebalikan dari symbol `>=` yaitu **lebih kecil atau sama dengan** |

Ok sekarang kita bahas satu persatu operator-operator yang telah saya jabarkan diatas untuk memperjelas dan cara bagimana contoh kasusnya.

# Operator equals

Berikut contoh kasus, untuk mencari data pegawai dengan kode yang sama dengan `100` berikut querynya:

{% gist page.gist "select-where-eq.sql" %}

Berikut ini hasilnya:

```postgresql-console
 employee_id | first_name | last_name | email | phone_number | job_id  |  salary  | 
-------------+------------+-----------+-------+--------------+---------+----------+
         100 | Steven     | King      | SKING | 515.123.4567 | AD_PRES | 24000.00 |
(1 row)
```

# Operator not equals

Berikut contoh kasus, untuk mencari data pegawai dengan jabatan yang bukan merupakan `IT_PROG`. berikut querynya:

Menggunakan operator `<>`

{% gist page.gist "select-where-not-same.sql" %}

Menggunakan operator `!=`

{% gist page.gist "select-where-not-eq.sql" %}

Berikut ini hasilnya:

```postgresql-console
 employee_id | first_name  |  last_name  |  email   |    phone_number    |   job_id   |  salary  |
-------------+-------------+-------------+----------+--------------------+------------+----------+
         100 | Steven      | King        | SKING    | 515.123.4567       | AD_PRES    | 24000.00 |
         101 | Neena       | Kochhar     | NKOCHHAR | 515.123.4568       | AD_VP      | 17000.00 |
         102 | Lex         | De Haan     | LDEHAAN  | 515.123.4569       | AD_VP      | 17000.00 |
         108 | Nancy       | Greenberg   | NGREENBE | 515.124.4569       | FI_MGR     | 12000.00 |
         109 | Daniel      | Faviet      | DFAVIET  | 515.124.4169       | FI_ACCOUNT |  9000.00 |
         110 | John        | Chen        | JCHEN    | 515.124.4269       | FI_ACCOUNT |  8200.00 |
         111 | Ismael      | Sciarra     | ISCIARRA | 515.124.4369       | FI_ACCOUNT |  7700.00 |
         112 | Jose Manuel | Urman       | JMURMAN  | 515.124.4469       | FI_ACCOUNT |  7800.00 |
         113 | Luis        | Popp        | LPOPP    | 515.124.4567       | FI_ACCOUNT |  6900.00 |
         114 | Den         | Raphaely    | DRAPHEAL | 515.127.4561       | PU_MAN     | 11000.00 |
         115 | Alexander   | Khoo        | AKHOO    | 515.127.4562       | PU_CLERK   |  3100.00 |
         116 | Shelli      | Baida       | SBAIDA   | 515.127.4563       | PU_CLERK   |  2900.00 |
         117 | Sigal       | Tobias      | STOBIAS  | 515.127.4564       | PU_CLERK   |  2800.00 |
         118 | Guy         | Himuro      | GHIMURO  | 515.127.4565       | PU_CLERK   |  2600.00 |
         119 | Karen       | Colmenares  | KCOLMENA | 515.127.4566       | PU_CLERK   |  2500.00 |
...
(102 rows)
```

# Operator more than

Berikut contoh kasus, untuk mencari data pegawai dengan gaji yang lebih besar dari `12000`. berikut querynya:

{% gist page.gist "select-where-higher.sql" %}

Berikut hasilnya:

```postgresql-console
 employee_id | first_name | last_name |  email   |    phone_number    | job_id  |  salary  
-------------+------------+-----------+----------+--------------------+---------+----------
         100 | Steven     | King      | SKING    | 515.123.4567       | AD_PRES | 24000.00
         101 | Neena      | Kochhar   | NKOCHHAR | 515.123.4568       | AD_VP   | 17000.00
         102 | Lex        | De Haan   | LDEHAAN  | 515.123.4569       | AD_VP   | 17000.00
         145 | John       | Russell   | JRUSSEL  | 011.44.1344.429268 | SA_MAN  | 14000.00
         146 | Karen      | Partners  | KPARTNER | 011.44.1344.467268 | SA_MAN  | 13500.00
         201 | Michael    | Hartstein | MHARTSTE | 515.123.5555       | MK_MAN  | 13000.00
(6 rows)
```

# Operator bigger equals to

Berikut contoh kasus, untuk mencari data pegawai dengan gaji yang lebih besar dari `24000`. in case gaji `24000` adalah gaji paling besar jika di cari dengan menggunakan operator `>` maka hasilnya `(0 rows)` berikut querynya:

{% gist page.gist "select-where-bigger-eq.sql" %}

Berikut hasilnya:

```postgresql-console
 employee_id | first_name | last_name | email | phone_number | job_id  |  salary  |
-------------+------------+-----------+-------+--------------+---------+----------+
         100 | Steven     | King      | SKING | 515.123.4567 | AD_PRES | 24000.00 |
(1 row)
```

# Operator less then & smaller equal to

Untuk operator `<` dan `<=` ini kurang lebih sama seperti operator `>` hanya kebalikannya saja yaitu yang lebih kecil.
