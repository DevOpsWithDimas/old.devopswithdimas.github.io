---
layout: post
title: "Operasi matematika di PostgreSQL"
date: 2017-11-27T11:06:09+07:00
lang: psql
categories:
- RDBMS
- PostgreSQL
refs: []
youtube: https://www.youtube.com/watch?v=ytKK6l698Wk&list=PLV1-tdmPblvypZXSk2GC932nludT345xk&index=4
comments: true
gist: dimMaryanto93/62ffa0d81f3835a4e9401baf14590cd2
---

Dalam SQL, kita juga bisa melakukan operasi matematika seperti pertambahan, pengurangan, pembagian, dan perkalian. Operasi tersebut dibagi-bagi lagi menjadi beberapa tipe yaitu

1. Operasi yang bernilai bilangan,
2. Operasi yang bernilai Date,
3. Operasi yang bernilai karakter

## Operasi pada bilangan

Operasi pada bilangan pada dasarnya sama seperti operasi matematika biasa, seperti berikut table operasinya:

| Operator 	|   Description     |	Example     |	Result  |
| :------- 	|   :----------     |	:------     |	:-----  |
| + 	    |   addition 	    | 2 + 3         |        5  |
| - 	    |   subtraction 	| 2 - 3         |        -1 |
| * 	    |   multiplication 	| 2 * 3         |        6  |
| / 	    |   division        |	4 / 2       |        2  |
| % 	    |   modulo          | 	5 % 4       |        1  |
| ^ 	    |   exponentiation 	| 2.0 ^ 3.0     |        8  |
| ! 	    |   factorial 	    | 5 !           |       120 |
| @ 	    |   absolute value  | @ -5.0        | 	      5 |

### Contoh sederhana

Contoh penggunaan dalam SQL seperti berikut:

{% gist page.gist "select-math-operation.sql" %}

Jika di running maka hasilnya seperti berikut:

{% highlight postgresql-console %}
 jumlah | kali | bagi | pangkat 
--------+------+------+---------
      4 |    4 |    1 |       8
(1 row)
{% endhighlight %}

### Contoh menggunakan data dari table

Contoh lainnya, menggunakan penjumlahan dalam table, seperti berikut:

{% gist page.gist "select-math-column-operation.sql" %}

Jika dijalankan hasilnya seperti berikut:

{% highlight postgresql-console %}
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
{% endhighlight %}

## Operasi pada karakter

Untuk operator di string atau karakter pada dasarnya cuman ada operator concat dengan simbol `||` cara penggunaannya seperti berikut:

{% gist page.gist "select-concat-double-pipe.sql" %}

Jika di jalankan maka hasilnya sebagai berikut:

{% highlight postgresql-console %}
  nama_lengkap  
----------------
 Dimas Maryanto
(1 row)
{% endhighlight %}

## Operasi pada Date

Operasi matematika pada tanggal juga bisa dilakukan, diantaranya seperti berikut:

### Date

{% gist page.gist "select-date-operation.sql" %}

Jika dijalankan maka hasilnya seperti berikut:

{% highlight postgresql %}
    lusa    |        waktu        |   besok    | jumlah_hari_kerja 
------------+---------------------+------------+-------------------
 2017-03-26 | 2017-03-27 22:00:00 | 2017-03-29 |                15
(1 row)
{% endhighlight %}

### Timestamp

{% gist page.gist "select-timestamp-operation.sql" %}

Jika dijalankan maka hasilnya seperti berikut:

{% highlight postgresql %}
        waktu        |      deadline       |     makan_siang     
---------------------+---------------------+---------------------
 2017-03-28 03:20:00 | 2017-04-23 00:00:00 | 2017-03-02 00:09:30
(1 row)
{% endhighlight %}

### Operasi yang tidak diperbolehkan

Operasi yang tidak diperbolehkan di tanggal yaitu melakukan pertambahan antara tanggal dengan tanggal contohnya seperti berikut:

{% gist page.gist "select-date-operation-cant-handle.sql" %}

Jika dijalankan maka hasilnya seperti berikut:

{% highlight postgresql %}
No operator matches the given name and argument type(s). You might need to add explicit type casts.
{% endhighlight %}

