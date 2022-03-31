---
layout: post
title: "Pemberian alias pada column dan table"
date: 2021-02-11T11:45:33+07:00
lang: oracle18c
authors:
- dimasm93
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/database/121/index.htm
- https://docs.oracle.com/en/bigdata/index.html
youtube: EKqAd1Rp8AA
comments: true
catalog_key: sql-select
image_path: /resources/posts/oracle12c/
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---


Secara _default_ kalau kita melakukan perintah `select` terhadap suatu _table_ contohnya misalnya `departments`, di _table_ `departments` ada _columns_ diataranya `department_id, department_name, manager_id, location_id` jika saya melakukan perintah `select` seperti berikut:

<!--more-->

{% gist page.gist "005-select-all-departments.sql" %}

Maka secara default nama _columns_ yang ditampilkan akan sesuai dengan nama asli dari _column_ yang ada di tabel `departments` seperti berikut:

```sql
DEPARTMENT_ID DEPARTMENT_NAME                MANAGER_ID LOCATION_ID
------------- ------------------------------ ---------- -----------
           10 Administration                        200        1700
           20 Marketing                             201        1800
           30 Purchasing                            114        1700
           40 Human Resources                       203        2400
           50 Shipping                              121        1500
           60 IT                                    103        1400
           70 Public Relations                      204        2700
           80 Sales                                 145        2500
           90 Executive                             100        1700
          100 Finance                               108        1700
          110 Accounting                            205        1700

27 rows selected.
```

## Memberikan alias untuk _column_

Dengan menggunakan _column alias_ kita bisa memberikan nama kolomnya sesuai yang kita inginkan, contohnya seperti berikut:

{% gist page.gist "005a-select-alias-column-departments.sql" %}

Maka hasilnya seperti berikut:

```sql
KODE_DIVISI NAMA_DEPARTMENT                Kode Manager
----------- ------------------------------ ------------
         10 Administration                          200
         20 Marketing                               201
         30 Purchasing                              114
         40 Human Resources                         203
         50 Shipping                                121
         60 IT                                      103
         70 Public Relations                        204
         80 Sales                                   145
         90 Executive                               100
        100 Finance                                 108
        110 Accounting                              205

27 rows selected.
```

Aturan penamaan variable atau kolom alias, diantaranya:

Jika menggunakan keyword `as` dan tanpa `as`, tidak boleh menggunakan charakter khusus seperti **SPACE**, **HashTag**, **Dolar** dan lain-lain, karakter yang **diperbolehkan** yaitu **huruf, angka, dan underscore**. Ini karena dengan menggunakan _column alias_ tersebut nantinya bisa digunakan sebagai variable untuk melakukan _ordering_.