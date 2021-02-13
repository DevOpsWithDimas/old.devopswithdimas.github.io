---
layout: post
title: "009a-character-function"
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/Single-Row-Functions.html#GUID-06062705-1EC8-44ED-89B8-0F0573B74EA2
youtube: 
comments: true
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
{:.bordered .striped}

Untuk lebih lengkapnya lagi bisa check [dokumentasi](https://www.postgresql.org/docs/9.1/functions-string.html)

Berikut adalah contoh salah satu penggunaannya, saya mau memformat data karyawan `first_name` di jadikan huruf kapital, sedangkan untuk `last_name` saya mau hitung jumlahnya berapa, gabungkan column `first_name` dan `last_name`. Berikut querynya:

{% gist page.gist "008a-single-row-function-string.sql" %}

Berikut hasilnya:

```postgresql-console
 kode | nama_depan_kapital | nama_belakang | jumlah |   nama_lengkap   
------+--------------------+---------------+--------+------------------
  100 | STEVEN             | King          |      4 | Steven King
  101 | NEENA              | Kochhar       |      7 | Neena Kochhar
  102 | LEX                | De Haan       |      7 | Lex De Haan
  103 | ALEXANDER          | Hunold        |      6 | Alexander Hunold
  104 | BRUCE              | Ernst         |      5 | Bruce Ernst
  105 | DAVID              | Austin        |      6 | David Austin
  106 | VALLI              | Pataballa     |      9 | Valli Pataballa
  107 | DIANA              | Lorentz       |      7 | Diana Lorentz
  108 | NANCY              | Greenberg     |      9 | Nancy Greenberg
  109 | DANIEL             | Faviet        |      6 | Daniel Faviet
(10 rows)
```

