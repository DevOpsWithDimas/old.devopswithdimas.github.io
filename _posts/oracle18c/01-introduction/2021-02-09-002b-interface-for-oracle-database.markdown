---
layout: post
title: "Interface untuk Oracle Database"
date: 2021-02-09T14:43:51+07:00
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/database/121/index.htm
- https://docs.oracle.com/en/bigdata/index.html
- https://www.jetbrains.com/datagrip/
- https://dbeaver.io/
- https://www.oracle.com/database/technologies/appdev/sqldeveloper-landing.html
youtube: MtENXELBI6w
comments: true
image_path: /resources/posts/oracle12c/002b-interface-database
gist: 
downloads: []
---


Untuk menggunakan / mengakses object dalam database kita membutuhkan tools atau biasanya disebut interface. Interface yang kita bisa gunakan ada beberapa diantaranya software bawaan install yaitu `SQL*Plus` atau kita bisa install software seperti

1. [DataGrip](https://www.jetbrains.com/datagrip/)
2. [DBeaver](https://dbeaver.io/)
3. [SQL Developer](https://www.oracle.com/database/technologies/appdev/sqldeveloper-landing.html)
4. [sequelPro](https://www.sequelpro.com/) for mac only

![database-interaction]({{ page.image_path | prepend: site.baseurl }}/interface-database.jpg)

Jadi berdasarkan gambar di atas, cara connect ke Database Oracle melalui network via `tcp/ip` dengan menggunakan `SID` atau `Service Name` untuk mengidetifikasi ke `Database Name` atau `Database Listener` selain itu juga biasanya menggunakan authentication menggunakan user/password. 

Untuk Oracle Database Express Edition biasanya `SID` atau `Service Name` yaitu `XE` karena biasanya hanya di sediakan 1 cluster. 