---
layout: post
title: "Pagination dengan fetch dan offset"
date: 2021-02-21T15:49:17+07:00
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/img_text/row_limiting_clause.html
- https://www.oracletutorial.com/oracle-basics/oracle-fetch/
youtube: 6xbixjzTQlw
comments: true
image_path: /resources/posts/oracle12c/013-fetch-offset
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Untuk membuat pagination di Oracle Database versi 12c ke atas atau lebih baru, kita bisa menggunakan `fetch` dan `offset` seperti berikut ilustrasinya:

![limit offset]({{ page.image_path | prepend: site.baseurl }}/konsep-limit-offset.png)

Sebagai contoh disini kita akan menggunakan data pada tabel `employees` dengan jumlah data

{% highlight sql %}
select count(*) row_count
from employees;

 ROW_COUNT
----------
       107
{% endhighlight %}

## Fetch data

Di oracle limit data dengan fetch bisa menggunakan jumlah `rows` dan `percent`

{% gist page.gist "013a-fetch-first-rows-only.sql" %}

Query tersebut biasanya digunakan untuk ranking atau `first result`, selain itu juga kita bisa menggunakan `next result` seperti berikut:

{% gist page.gist "013a-fetch-next-rows-only.sql" %}

Berikut hasilnya:

{% highlight sql %}
EMPLOYEE_ID FIRST_NAME               SALARY
----------- -------------------- ----------
        100 Steven                    24000
        101 Neena                     17000
        102 Lex                       17000
        103 Alexander                  9000
        104 Bruce                      6000
{% endhighlight %}

## Offset data

Untuk melakukan skip data kita juga bisa menggunakan `offset` seperti berikut

{% gist page.gist "013b-offset-rows.sql" %}

Berikut hasilnya:

{% highlight sql %}
EMPLOYEE_ID FIRST_NAME               SALARY
----------- -------------------- ----------
        200 Jennifer                   4400
        201 Michael                   13000
        202 Pat                        6000
        203 Susan                      6500
        204 Hermann                   10000
        205 Shelley                   12008
        206 William                    8300

7 rows selected.
{% endhighlight %}

## Limit & Skip

Untuk membuat pagination kita membutuhkan `fetch` dan `offset` misalnya seperti berikut:

{% gist page.gist "013c-pagination-fetch-offset.sql" %}

Berikut outputnya:

{% highlight sql %}
Enter value for offset: 100
Enter value for limit: 5
old   4: offset &offset rows fetch first &limit rows only
new   4: offset 100 rows fetch first 5 rows only

EMPLOYEE_ID FIRST_NAME               SALARY
----------- -------------------- ----------
        200 Jennifer                   4400
        201 Michael                   13000
        202 Pat                        6000
        203 Susan                      6500
        204 Hermann                   10000

SQL> /

Enter value for offset: 105
Enter value for limit: 5
old   4: offset &offset rows fetch first &limit rows only
new   4: offset 105 rows fetch first 5 rows only

EMPLOYEE_ID FIRST_NAME               SALARY
----------- -------------------- ----------
        205 Shelley                   12008
        206 William                    8300
{% endhighlight %}