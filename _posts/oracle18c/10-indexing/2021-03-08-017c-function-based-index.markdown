---
layout: post
title: "Index - Function-Based"
date: 2021-03-08T14:55:25+07:00
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/19/cncpt/indexes-and-index-organized-tables.html#GUID-9AD7651D-0F0D-4FC6-A984-5845F0224EE6
youtube: 
comments: true
image_path: /resources/posts/oracle12c/017b-fuction-index
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Sebuah function-based index digunakan untuk menyimpan nilai ke index dari hasil perhitungan suatu function atau expression dari satu atau beberapa column. Function based index bisa berupa **B-Tree Index** dan juga **Bitmap Index**

Function based index biasanya digunakan ketika sql statement yang kita panggil menggunakan arithmetic expression, user-defined PL/SQL function, package dan object lainnya.

Contoh sederhanya seperti berikut:

{% gist page.gist "017c-select-function-for-index.sql" %}

Maka kita bisa membuat indexnya seperti berikut:

{% gist page.gist "017c-index-function-arithmetic.sql" %}