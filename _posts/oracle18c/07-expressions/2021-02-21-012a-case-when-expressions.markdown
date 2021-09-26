---
layout: post
title: "Conditional Expression dengan Case When di Oracle"
date: 2021-02-21T14:43:29+07:00
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/CASE-Expressions.html#GUID-CA29B333-572B-4E1D-BA64-851FABDBAE96
youtube: qDbEn6CqtlI
comments: true
catalog_key: sql-expression
image_path: /resources/posts/oracle12c/012a-case-when-expression
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---


Di sql juga, bisa melakukan seleksi sama halnya dengan bahasa pemograman dengan `if/else` berikut contoh perintahnya:

```sql
select CASE 
        WHEN condition THEN result
        [WHEN condition then result]...
       [ELSE result] END
FROM dual;
```

Berikut contoh,

{% gist page.gist "012-select-case-when.sql" %}

Berikut hasilnya:

{% highlight sql %}
KODE_KARYAWAN KOMISI_DLM_PERCENT KOMISI_DLM_DOLAR
------------- ------------------ ---------------------
          146                 .3        4,050.00
          147                 .3        3,600.00
          148                 .3        3,300.00
          149                 .2        2,100.00
          150                 .3        3,000.00
          151                .25        2,375.00
          152                .25        2,250.00
          153                 .2        1,600.00
          180                     Tidak memiliki komisi
          181                     Tidak memiliki komisi
          182                     Tidak memiliki komisi
          183                     Tidak memiliki komisi
{% endhighlight %}
