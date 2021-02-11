---
layout: post
title: "Menghilangkan nilai redundansi dengan klausa Distinct"
date: 2021-02-11T19:48:11+07:00
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


Klause `distinct` digunakan untuk meng-eliminasi atau menghilankan nilai yang duplikat atau sama dalam suatu baris, contoh kasusnya saya mau mengambil data semua `job_id` yang terdaftar pada tabel `employees` secara unique, bagaimana cara ambil datanya? Jika menggunakan perintah berikut:


{% highlight sql %}
SQL> select job_id from employees;

JOB_ID
----------
AC_ACCOUNT
AC_MGR
AD_ASST
AD_PRES
AD_VP
AD_VP
FI_ACCOUNT
FI_ACCOUNT
FI_ACCOUNT
FI_ACCOUNT
FI_ACCOUNT

JOB_ID
----------
FI_MGR
HR_REP
IT_PROG
IT_PROG
IT_PROG
IT_PROG
IT_PROG
MK_MAN
MK_REP
PR_REP
PU_CLERK

JOB_ID
----------
PU_CLERK
PU_CLERK
PU_CLERK
PU_CLERK
PU_MAN
ST_MAN
ST_MAN
ST_MAN
ST_MAN
ST_MAN

107 rows selected.
{% endhighlight %}

Dari hasil query yang didapatkan udah benar tetapi data yang tampilkan tidak unique. kurang lebih ada `(107 rows)` sedangkan data master `jobs` jumlahnya tidak melibihi itu. Nah sekarang jika kita menggunakan klausa `distinct` seperti berikut:

{% gist page.gist "005e-select-distinct-column.sql" %}

Berikut hasilnya:

{% highlight sql %}
JOB_ID
----------
AC_ACCOUNT
AC_MGR
AD_ASST
AD_PRES
AD_VP
FI_ACCOUNT
FI_MGR
HR_REP
IT_PROG
MK_MAN
MK_REP
PR_REP
PU_CLERK
PU_MAN
SA_MAN
SA_REP
SH_CLERK
ST_CLERK
ST_MAN

19 rows selected.
{% endhighlight %}

Jadi kesimpulannya adalah dengan menggunakan klausa `distinct` ini kita bisa meng-eleminasi data yang redudansi. Nilai distinct ini juga bisa digunakan untuk multple column berikut contoh penggunaan

{% gist page.gist "005e-select-distinct-multiple-columns.sql" %}

Berikut hasilnya:

{% highlight sql %}
SQL> select distinct job_id, salary
from employees;

JOB_ID         SALARY
---------- ----------
AC_ACCOUNT       8300
AC_MGR          12008
AD_ASST          4400
AD_PRES         24000
SA_MAN          10500
SA_MAN          11000
SA_MAN          12000
SA_MAN          13500
SA_MAN          14000
SA_REP           6100
SA_REP           6200
SA_REP           9500
SA_REP           9600
SA_REP          10000
SA_REP          10500
SA_REP          11000
SA_REP          11500
SH_CLERK         2500
SH_CLERK         2600
SH_CLERK         2800
SH_CLERK         2900
SH_CLERK         3000
ST_MAN           5800
ST_MAN           6500
ST_MAN           7900
ST_MAN           8000
ST_MAN           8200

82 rows selected.
{% endhighlight %}