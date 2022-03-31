---
layout: post
title: "ANY & SOME dengan Sub Query di Oracle"
date: 2021-02-18T18:14:40+07:00
lang: oracle18c
authors:
- dimasm93
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/Using-Subqueries.html#GUID-53A705B6-0358-4E2B-92ED-A83DE83DFD20
youtube: kVZvLYa-MHI
comments: true
catalog_key: sql-subquery
image_path: /resources/posts/oracle12c/
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Operator ANY digunakan untuk membandingkan data yang di cari dengan sekumpulan data yang ada pada inner query. Untuk menggunakan operator any harus di pasangkan dengan `>`, `<` dan `=`. 

<!--more-->

Misalnya inner query yang kita akan gunakan adalah seperti berikut:

{% highlight sql %}
select job_id as id, round(avg(j.max_salary)) as gaji_rata
from jobs j
group by j.job_id
having avg(j.max_salary) < 20000
order by gaji_rata;

ID          GAJI_RATA
---------- ----------
ST_CLERK         5000
FI_MGR          16000

16 rows selected.
{% endhighlight %}

## `= ANY` Operator

Untuk operator `=any` sebetulnya secara logika sama seperti `in` predicate, artinya mencari yang sama dengan sekumpulan nilai yang dihasilkan dari inner query. berikut adalah contohnya:

{% gist page.gist "011d-select-sub-query-eq-any.sql" %}

atau

{% gist page.gist "011d-select-sub-query-eq-some.sql" %}

Berikut hasilnya:

{% highlight sql %}
        ID NAME                     SALARY JOB
---------- -------------------- ---------- ----------
       202 Pat                        6000 MK_REP
       104 Bruce                      6000 IT_PROG
       109 Daniel                     9000 FI_ACCOUNT
       158 Allan                      9000 SA_REP
       152 Peter                      9000 SA_REP
       103 Alexander                  9000 IT_PROG
       169 Harrison                  10000 SA_REP
       150 Peter                     10000 SA_REP
       204 Hermann                   10000 PR_REP
       156 Janette                   10000 SA_REP
       149 Eleni                     10500 SA_MAN
       162 Clara                     10500 SA_REP
       108 Nancy                     12008 FI_MGR
       205 Shelley                   12008 AC_MGR

14 rows selected.
{% endhighlight %}

## `< ANY` Operator

Untuk operator `< ANY` tujuannya menampilkan data dari outer query yang nilainya lebih besar dari sekumpulan data yang paling besar dari inner query, berikut contohnya:

{% gist page.gist "011d-select-sub-query-lower-any.sql" %}

atau

{% gist page.gist "011d-select-sub-query-lower-some.sql" %}

Berikut hasilnya:

{% highlight sql %}
        ID NAME                     SALARY JOB
---------- -------------------- ---------- ----------
       145 John                      14000 SA_MAN
       146 Karen                     13500 SA_MAN
       201 Michael                   13000 MK_MAN
       205 Shelley                   12008 AC_MGR
       108 Nancy                     12008 FI_MGR
       147 Alberto                   12000 SA_MAN
       144 Peter                      2500 ST_CLERK
       140 Joshua                     2500 ST_CLERK
       119 Karen                      2500 PU_CLERK
       191 Randall                    2500 SH_CLERK
       131 James                      2500 ST_CLERK
       127 James                      2400 ST_CLERK
       135 Ki                         2400 ST_CLERK
       136 Hazel                      2200 ST_CLERK
       128 Steven                     2200 ST_CLERK
       132 TJ                         2100 ST_CLERK

104 rows selected.
{% endhighlight %}

Nilai dari yang paling besar pada inner query yaitu `FI_MGR, 16000` kemudian dibandingkan dengan lebih kecil.

## `> ANY` Operator

Untuk operator `> Any` ini tinggal sebaliknya saja dari `< ANY`, berikut contohnya:

{% gist page.gist "011d-select-sub-query-higher-any.sql" %}

atau

{% gist page.gist "011d-select-sub-query-higher-some.sql" %}

Berikut hasilnya:

{% highlight sql %}
        ID NAME                     SALARY JOB
---------- -------------------- ---------- ----------
       124 Kevin                      5800 ST_MAN
       202 Pat                        6000 MK_REP
       104 Bruce                      6000 IT_PROG
       173 Sundita                    6100 SA_REP
       205 Shelley                   12008 AC_MGR
       201 Michael                   13000 MK_MAN
       146 Karen                     13500 SA_MAN
       145 John                      14000 SA_MAN
       102 Lex                       17000 AD_VP
       101 Neena                     17000 AD_VP
       100 Steven                    24000 AD_PRES

58 rows selected.
{% endhighlight %}