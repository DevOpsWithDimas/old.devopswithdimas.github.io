---
layout: post
title: "Menggabungkan column dengan concatnation"
date: 2021-02-11T14:34:11+07:00
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/Concatenation-Operator.html#GUID-08C10738-706B-4290-B7CD-C279EBC90F7E
youtube: https://www.youtube.com/watch?v=Y62PlaCk3Yc&list=PLV1-tdmPblvzqS-Z57hZ_spTRtVvnYYpV&index=18
comments: true
image_path: /resources/posts/oracle12c/
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Apa itu concatenation?, Concatenation biasanya digunakan untuk mengkombinasikan, menyambungkan beberapa kolom dalam suatu query menjadi satu. 

Ok misalnya saya punya struktur tabel seperti berikut:

{% highlight sql %}
SQL> desc employees;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 EMPLOYEE_ID                               NOT NULL NUMBER(6)
 FIRST_NAME                                         VARCHAR2(20)
 LAST_NAME                                 NOT NULL VARCHAR2(25)
 EMAIL                                     NOT NULL VARCHAR2(25)
 PHONE_NUMBER                                       VARCHAR2(20)
 HIRE_DATE                                 NOT NULL DATE
 JOB_ID                                    NOT NULL VARCHAR2(10)
 SALARY                                             NUMBER(8,2)
 COMMISSION_PCT                                     NUMBER(2,2)
 MANAGER_ID                                         NUMBER(6)
 DEPARTMENT_ID                                      NUMBER(4)
{% endhighlight %}

Nah saya mau mengambil semua data dari table `employees` untuk menampilkan `kode karyawan` dan `nama depan + nama belakang` digabungkan menjadi satu kolom. Berikut adalah contoh querynya: 

{% gist page.gist "005c-select-concatenation.sql" %}

Berikut hasilnya:

{% highlight sql %}
        ID NAMA_LENGKAP
---------- ----------------------------------------------
       100 Steven King
       101 Neena Kochhar
       102 Lex De Haan
       103 Alexander Hunold
       104 Bruce Ernst
       105 David Austin
       106 Valli Pataballa
       107 Diana Lorentz
       108 Nancy Greenberg
       109 Daniel Faviet
       110 John Chen
107 rows selected.
{% endhighlight %}

Jadi kesimpulannya dengan menggunakan operator `||` kita bisa menggabunkan 2 kolom atau lebih mejadi 1 column.