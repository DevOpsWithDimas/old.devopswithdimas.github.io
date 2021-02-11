---
layout: post
title: "Operation Arithmetic di Oracle"
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/Arithmetic-Operators.html#GUID-46CD9FD8-FC94-44BA-AA62-30A16063EAAE
youtube: 
comments: true
image_path: /resources/posts/oracle12c/
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Dalam SQL, kita juga bisa melakukan operasi matematika seperti pertambahan, pengurangan, pembagian, dan perkalian. Operasi tersebut dibagi-bagi lagi menjadi beberapa tipe yaitu

1. Operasi yang bernilai bilangan,
2. Operasi yang bernilai Date

## Operasi pada bilangan

Operasi pada bilangan pada dasarnya sama seperti operasi matematika biasa, seperti berikut table operasinya:

| Operator 	|   Description     |	Example     |	Result  |
| :------- 	|   :----------     |	:------     |	:-----  |
| + 	    |   addition 	    | 2 + 3         |        5  |
| - 	    |   subtraction 	| 2 - 3         |        -1 |
| * 	    |   multiplication 	| 2 * 3         |        6  |
| / 	    |   division        | 4 / 2         |        2  |

### Contoh sederhana

Contoh penggunaan dalam SQL seperti berikut:

{% gist page.gist "005b-math-operation.sql" %}

Jika di running maka hasilnya seperti berikut:

{% highlight sql %}
    TAMBAH     KURANG       KALI       BAGI
---------- ---------- ---------- ----------
         4          0          4          1
(1 row)
{% endhighlight %}

### Contoh menggunakan data dari table

Contoh lainnya, menggunakan penjumlahan dalam table, seperti berikut:

{% gist page.gist "005b-select-math-column-operation.sql" %}

Jika dijalankan hasilnya seperti berikut:

{% highlight sql %}
FIRST_NAME               SALARY Salary in a year Salary Take Home
-------------------- ---------- ---------------- ----------------
Lisa                      11500           138000            14375
Harrison                  10000           120000            12000
Tayler                     9600           115200            11520
William                    7400            88800             8510
Elizabeth                  7300            87600             8395
Sundita                    6100            73200             6710
Ellen                     11000           132000            14300
Alyssa                     8800           105600            11000
Jonathon                   8600           103200            10320
Jack                       8400           100800            10080
Kimberely                  7000            84000             8050

107 rows selected.
{% endhighlight %}

## Operasi pada Date

Operasi matematika pada tanggal juga bisa dilakukan, diantaranya seperti berikut:

### Date

{% gist page.gist "005b-select-date-operation.sql" %}

Jika dijalankan maka hasilnya seperti berikut:

{% highlight sql %}
HARI_INI  LUSA      BESOK     JUMLAH_HARI
--------- --------- --------- -----------
11-FEB-21 09-FEB-21 12-FEB-21          15
{% endhighlight %}

### Operasi yang tidak diperbolehkan

Operasi yang tidak diperbolehkan di tanggal yaitu melakukan pertambahan antara tanggal dengan tanggal contohnya seperti berikut:

{% gist page.gist "005b-select-date-operation-cant-handle.sql" %}

Jika dijalankan maka hasilnya seperti berikut:

{% highlight sql %}
ERROR at line 1:
ORA-00975: date + date not allowed
{% endhighlight %}

