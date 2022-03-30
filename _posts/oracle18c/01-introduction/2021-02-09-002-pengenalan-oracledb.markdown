---
layout: post
title: "Pengenalan Oracle Database 18c"
date: 2021-02-09T11:40:06+07:00
lang: oracle18c
authors:
- dimasm93
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/database/121/index.htm
- https://docs.oracle.com/en/bigdata/index.html
- https://db-engines.com/en/ranking
- https://en.wikipedia.org/wiki/Oracle_Database
youtube: iQHSROv3Imc
comments: true
catalog_key: introduction
image_path: /resources/posts/oracle12c/
gist: 
downloads: []
---


Pada materi kali ini, kita akan berkenalan dengan database management system (DBMS) yaitu Oracle Database. Oracle adalah database ranking #1 berdasarkan [db-engines.com](https://db-engines.com/en/ranking) saat ini (February 2021) secara beberapa tahun berturut-turut, dan juga beberapa survey engine lainnya. 

Oracle Database dibuat sejak 1980 oleh para insinyur Developer Oracle, Software oracle ada beberapa versi diantaranya

| Version               | Release Date  | End Of Support    |
| :---                  | :---          | :---              |
| Oracle Database 10g   | 2003          | February 2006     |
| Oracle Database 11g   | 2005          | April 2010        |
| Oracle Database 12c   | 2013          | -                 |
| Oracle Database 18c   | 2018          | -                 |
| Oracle Database 19c   | 2019          | -                 |
| Oracle Database 21c   | Desember 2020 | -                 |

Untuk lebih lengkapnya bisa check [disini](https://en.wikipedia.org/wiki/Oracle_Database), Yang perlu di ketahui Oracle Database ini adalah Database Commersial (Berbayar) jika temen-temen ingin tau harga dari product Oracle Product ini saya cantumkan daftar harganya [disini](https://www.oracle.com/us/corporate/pricing/technology-price-list-070617.pdf)

Etsss tapi tentang aja, buat temen-temen yang mau coba Database Oracle bisa kok tanpa bayar alias (GRATISSSS) kita bisa coba menggunakan Express Edition. Pada dasarnya Oracle ini ada beberapa edisi

1. Express Edition (paling basic)
2. Standart Edition
3. Enterprice Edition

Nah jadi kita bisa menggunakan Express Edition ya untuk mencoba belajar Oracle Database, jadi kita akan mencoba `Oracle Database 18c Express Edition`.

Nah jadi untuk Database ini khan biasanya hanya sebagai perantara untuk menyimpan, baca, ubah, dan hapus data terus bagaimana dengan support dengan Bahasa Pemograman klo mau connect ke Database Oracle apa aja yang di support?

Pada dasarnya semua bahasa pemograman support, berikut adalah beberapa connector yang di sediakan oracle

1. C / C# / C++
2. [ojdbc](https://www.oracle.com/database/technologies/appdev/jdbc.html) for Java
4. [oci-connect](https://www.php.net/manual/en/function.oci-connect.php) for PHP
5. [oci-ruby-sdk](https://github.com/oracle/oci-ruby-sdk) for Ruby
6. [npm oracledb](https://www.npmjs.com/package/oracledb) for Javascript

Selain untuk penyimpanan data, Oracle Database juga sebetulnya memiliki bahasa pemograman dalam Database Enginenya mereka dinamai dengan sebutan `Pl/SQL` atau  _Procedural Language and SQL_