---
layout: post
title: "Handle Null value dengan Coalesce"
date: 2021-02-11T14:52:26+07:00
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/database/121/index.htm
- https://docs.oracle.com/en/bigdata/index.html
youtube: bAV4YzM7D4w
comments: true
image_path: /resources/posts/oracle12c/
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Nilai `NULL` bukan berarti tanpa karater, begitu pula sebaliknya. Kenapa saya bilang gitu karena berikut dari data hasil query ini:

{% highlight sql %}

SQL> select
    first_name      as name,
    commission_pct  as komisi_persen,
    salary          as gaji_sebulan
from employees;

NAME                 KOMISI_PERSEN GAJI_SEBULAN
-------------------- ------------- ------------
Charles                         .1         6200
Winston                                    3200
Jean                                       3100
Martha                                     2500
Girard                                     2800
Nandita                                    4200
Alexis                                     4100
Julia                                      3400
Anthony                                    3000
Kelly                                      3800
Jennifer                                   3600

NAME                 KOMISI_PERSEN GAJI_SEBULAN
-------------------- ------------- ------------
Timothy                                    2900
Randall                                    2500
Sarah                                      4000
Britney                                    3900
Samuel                                     3200
Vance                                      2800
Alana                                      3100
Kevin                                      3000

107 rows selected.

SQL>

{% endhighlight %}

Coba anda perhatikan pada kolom `komisi_persen` yang tidak ada nilanya itu adalah `null` karena tipe datanya yaitu number, jika tipe data number tidak boleh masukan datanya string kosong. Sedangkan untuk tipe data `varchar` nah ini baru agak membigungkan untuk membedakan nilainya yang `null` dan string kosong. Ok Permasalahnya sih gak seribut itu kok. cuman gini, Saya mau menjumlahkan / menghitung berapa gaji yang harus di berikan ke karyawan (pendapatan bersih).

Kasusnya gini klo nilai `null` dikalikan berapapun pasti hasilnya `nan` atau `null` jadi solusinya gimana?, Salah satu cara untuk meng-handle nilai null yaitu dengan meggunakan fungsi `coalese` di PostgreSQL, sedangkan untuk di database engine lain seperti oracle, mysql menggunakan `NVL` ini tergantung dari speck databasenya so baca dokumentasinya dulu ya~.

{% gist page.gist "005d-select-coalesce.sql" %}

Berikut hasilnya:

```sql
NAME                 KOMISI_PERSEN GAJI_SEBULAN   GAJI_NET
-------------------- ------------- ------------ ----------
Timothy                          0         2900       2900
Randall                          0         2500       2500
Sarah                            0         4000       4000
Britney                          0         3900       3900
Samuel                           0         3200       3200
Vance                            0         2800       2800
Alana                            0         3100       3100
Kevin                            0         3000       3000
Jonathon                        .2         8600      10320
Jack                            .2         8400      10080
Kimberely                      .15         7000       8050

107 rows selected.
```