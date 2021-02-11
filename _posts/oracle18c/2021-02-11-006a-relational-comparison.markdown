---
layout: post
title: "Comparison Predicate pada klausa where di Oracle"
date: 2021-02-11T20:26:16+07:00
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/Comparison-Conditions.html#GUID-828576BF-E606-4EA6-B94B-BFF48B67F927
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
| `^=`                          | Melakukan perbandingan dengan nilai yang **bernilai tidak sama** |
| `<>`                          | Melakukan perbandingan dengan nilai yang **bernilai tidak sama** |
| `>`                           | Melakukan perbandingan terhadap 2 variable apakah variable yang satu **lebih besar** dari variable lainnya |
| `>=`                          | Melakukan perbandingna terhadap 2 variable apakah variable yang satu **lebih besar atau sama dengan** variable lainnya |
| `<`                           | Kebalikan dari symbol `>` yaitu **lebih kecil** |
| `<=`                          | Kebalikan dari symbol `>=` yaitu **lebih kecil atau sama dengan** |

Ok sekarang kita bahas satu persatu operator-operator yang telah saya jabarkan diatas untuk memperjelas dan cara bagimana contoh kasusnya.

# Operator equals

Berikut contoh kasus, untuk mencari data pegawai dengan kode yang sama dengan `100` berikut querynya:

{% gist page.gist "006a-select-where-eq.sql" %}

Berikut ini hasilnya:

{% highlight sql %}
EMPLOYEE_ID LAST_NAME                     SALARY
----------- ------------------------- ----------
        100 King                           24000
{% endhighlight %}

# Operator not equals

Berikut contoh kasus, untuk mencari data pegawai dengan jabatan yang bukan merupakan `IT_PROG`. berikut querynya:

Menggunakan operator `<>`

{% gist page.gist "006a-select-where-not-same.sql" %}

Menggunakan operator `!=`

{% gist page.gist "006a-select-where-not-eq.sql" %}

Menggunakan operator `^=`

{% gist page.gist "006a-select-where-not-inequality.sql" %}

Berikut ini hasilnya:

{% highlight sql %}
EMPLOYEE_ID EMAIL                     JOB_ID         SALARY
----------- ------------------------- ---------- ----------
        198 DOCONNEL                  SH_CLERK         2600
        199 DGRANT                    SH_CLERK         2600
        200 JWHALEN                   AD_ASST          4400
        201 MHARTSTE                  MK_MAN          13000
        202 PFAY                      MK_REP           6000
        203 SMAVRIS                   HR_REP           6500
        204 HBAER                     PR_REP          10000
        205 SHIGGINS                  AC_MGR          12008
        206 WGIETZ                    AC_ACCOUNT       8300
        100 SKING                     AD_PRES         24000
        101 NKOCHHAR                  AD_VP           17000

107 rows selected.
{% endhighligth %}

# Operator more than

Berikut contoh kasus, untuk mencari data pegawai dengan gaji yang lebih besar dari `12000`. berikut querynya:

{% gist page.gist "006a-select-where-higher.sql" %}

Berikut hasilnya:

{% highlight sql %}
EMPLOYEE_ID FIRST_NAME           PHONE_NUMBER         JOB_ID         SALARY
----------- -------------------- -------------------- ---------- ----------
        201 Michael              515.123.5555         MK_MAN          13000
        205 Shelley              515.123.8080         AC_MGR          12008
        100 Steven               515.123.4567         AD_PRES         24000
        101 Neena                515.123.4568         AD_VP           17000
        102 Lex                  515.123.4569         AD_VP           17000
        108 Nancy                515.124.4569         FI_MGR          12008
        145 John                 011.44.1344.429268   SA_MAN          14000
        146 Karen                011.44.1344.467268   SA_MAN          13500

8 rows selected.
{% endhighlight %}

# Operator bigger equals to

Berikut contoh kasus, untuk mencari data pegawai dengan gaji yang lebih besar dari `24000`. in case gaji `24000` adalah gaji paling besar jika di cari dengan menggunakan operator `>` maka hasilnya `(0 rows)` berikut querynya:

{% gist page.gist "006a-select-where-higher-than.sql" %}

Berikut hasilnya:

{% highlight sql %}
EMPLOYEE_ID FIRST_NAME           PHONE_NUMBER         JOB_ID         SALARY
----------- -------------------- -------------------- ---------- ----------
        201 Michael              515.123.5555         MK_MAN          13000
        205 Shelley              515.123.8080         AC_MGR          12008
        100 Steven               515.123.4567         AD_PRES         24000
        101 Neena                515.123.4568         AD_VP           17000
        102 Lex                  515.123.4569         AD_VP           17000
        108 Nancy                515.124.4569         FI_MGR          12008
        145 John                 011.44.1344.429268   SA_MAN          14000
        146 Karen                011.44.1344.467268   SA_MAN          13500
        147 Alberto              011.44.1344.429278   SA_MAN          12000

9 rows selected.
{% endhighlight %}

# Operator less then & smaller equal to

Untuk operator `<` dan `<=` ini kurang lebih sama seperti operator `>` hanya kebalikannya saja yaitu yang lebih kecil.
