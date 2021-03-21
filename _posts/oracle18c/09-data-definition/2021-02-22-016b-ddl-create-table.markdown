---
layout: post
title: "DDL - Membuat Tabel di Oracle"
date: 2021-02-22T14:45:26+07:00
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/CREATE-TABLE.html#GUID-F9CE0CC3-13AE-4744-A43C-EAC7A71AAAB6
youtube: 7OYr-xB2zgo
comments: true
image_path: /resources/posts/oracle12c/016b-ddl-create-table
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Tabel merupakan salah satu object di dalam database yang gunanya untuk menyimpan data, secara logical tabel di database berbentuk column dan rows jadi ibaratnya kita sedang menggunakan microsoft excel. Untuk membuat table kita perlu perintah disebut Data Definition Language atau singkatan DDL. 

## Create Table 

Perintah untuk membuat table, simplenya adalah dengan 

```sql
CREATE TABLE [schema].table_name (
    first_column <data-type> [constraints...] [default <value>],
    second_column <data-type> [constraints...] [default <value>]
);
```

Contohnya seperti berikut:

{% gist page.gist "016b-ddl-create-table.sql" %}

Setelah di execute, jika mau melihat struktur tabelnya kita bisa gunakan perintah berikut:

{% highlight sql %}
SQL> desc test_table;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 KODE                                               NUMBER(38)
 NAMA                                               VARCHAR2(50)
 TANGGAL_LAHIR                                      DATE
 SALDO                                              NUMBER(8,2)
 COMMISSION_PCT                                     FLOAT(126)
 GENDER                                             CHAR(1)
 ACTIVE                                             NUMBER(1)
 CREATED_DATE                                       TIMESTAMP(6)
{% endhighlight %}

## Clone from an other table

Selain itu juga kita bisa membuat table dengan menggunakan sub-query, atau orang-orang biasanya ngebutnya copy-table. Berikut contoh penggunaanya:

{% gist page.gist "016b-ddl-clone-table.sql" %}

Berikut hasilnya:

{% highlight sql %}
SQL> desc divisi;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 DEPARTMENT_ID                                      NUMBER(4)
 DEPARTMENT_NAME                           NOT NULL VARCHAR2(30)

SQL>
{% endhighlight %}

## Create table with default value option

Dan yang terakhir, kita juga bisa menggunakan **default value option**. artinya memberikan nilai default ketika nilainya `null`

{% gist page.gist "016b-ddl-create-table-with-default-option.sql" %}