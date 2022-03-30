---
layout: post
title: "Casting Build-In Data Type di Oracle"
date: 2021-02-14T20:50:29+07:00
lang: oracle18c
authors:
- dimasm93
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/CAST.html#GUID-5A70235E-1209-4281-8521-B94497AAEF75
youtube: 4uuJg9ZdvSc
comments: true
catalog_key: sql-functions
image_path: /resources/posts/oracle12c/
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Casting Build-In Data Type biasanya digunakan untuk meng-conversi tipe data ke tipe data yang lain selama compatible. Berikut adalah table conversinya:

| Destination Type      | from: `CHAR/VARCHAR2` | from: `Number`        | from: `Date`          | from: `Datetime`      |
| :---                  | :---                  | :---                  | :---                  | :---                  |
| to: `CHAR/VARCHAR2`   | :heavy_check_mark:    | :heavy_check_mark:    | :heavy_check_mark:    | :heavy_check_mark:    |
| to: `NUMBER`          | :heavy_check_mark:    | :heavy_check_mark:    | :x:                   | :x:                   |
| to: `DATE`            | :heavy_check_mark:    | :x:                   | :heavy_check_mark:    | :heavy_check_mark:    |
| to: `DATETIME`        | :heavy_check_mark:    | :x:                   | :heavy_check_mark:    | :heavy_check_mark:    |

Yang perlu di notes, beberapa tipe data memungkinkan **runtime error** karena gagal conversi. kita bisa menggunakan keyword `DEFAULT return_value ON CONVERSION ERROR`. berikut adalah contoh implementasi conversi tipe data:

{% gist page.gist "008e-cast-build-in-data-type.sql" %}

Berikut adalah hasilnya:

{% highlight sql %}
CHAR_D      CHAR_D VARCHAR_NUMBER CHAR_NUMB_ERR NUMBE DATE_VARCHAR  DATE_TIMESTAMP
------      ------ -------------- ------------- ----- ------------- ----------------------------
12-FEB-21   <null> 10             0             20    01-FEB-21     01-FEB-21 12.00.00.000000 AM
{% endhighlight %}