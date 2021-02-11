---
layout: post
title: "Select Statement dalam SQL"
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/
youtube: 
comments: true
image_path: /resources/posts/oracle12c/005-select-statement
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Perintah / klausa `select` pada dasarnya adalah perintah yang dilakukan _query_ terhadap _database_ untuk mengambil atau mendapatkan data berupa baris (_rows_) dan kolom (_columns_) dalam sebuah _table_ seperti berikut:

![database-interaction]({{ page.image_path | prepend: site.baseurl }}/database-interaction.png)

Nah seperti yang kita tahu kalo dalam **sebuah _database_** bisa terdiri dari **banyak _tables_**, dalam **sebuah _table_** terdiri **banyak _rows_ dan _colums_**, dalam **satu _row_ dan _column_** terdiri dari **sebuah nilai**.

Jadi perintah _sql_ `select` memiliki format sebagai berikut:

{% highlight sql linenos %}
select 
     * | columns...  
from 
    table_name 
{% endhighlight %}

Contohnya di _schema_ `hr` sekarang saya punya daftar _tables_ seperti berikut:

## Menampilkan daftar _tables_ dalam sebuah _database_

{% gist page.gist "005-list-tables.sql" %}

berikut outputnya:

```sql
TABLE_NAME
--------------------------------------------------------------------------------
COUNTRIES
REGIONS
LOCATIONS
DEPARTMENTS
JOBS
EMPLOYEES
JOB_HISTORY

7 rows selected.
```

## Menampilkan daftar _columns_ dalam sebuah _table_
Kemudian di dalam _table_ `depertements` terdiri dari beberapa _columns_ seperti berikut:

{% gist page.gist "005-describe-table.sql" %}

Berikut outputnya: 

```sql
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 DEPARTMENT_ID                             NOT NULL NUMBER(4)
 DEPARTMENT_NAME                           NOT NULL VARCHAR2(30)
 MANAGER_ID                                         NUMBER(6)
 LOCATION_ID                                        NUMBER(4)
```

## Menampilkan semua data dalam sebuah _table_

Untuk menampilkan semua column yang dipilih dalam sebuah tabel kita bisa menggunakan spesial karakter `*` (asteric / bintang) dalam perintah _select_ seperti berikut:

{% gist page.gist "select-all-department.sql" %}

Maka akan tampil datanya seperti berikut:

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

## Menampilkan hanya beberapa _columns_

Selain menggunakan menampilkan semua kolom dengan `*`, kita juga bisa sebutkan nama kolomnya secara langsung contohnya seperti berikut:

{% gist page.gist "select-specific-columns-department.sql" %}

Maka akan tampil datanya seperti berikut:

```sql
DEPARTMENT_ID DEPARTMENT_NAME
------------- ------------------------------
           10 Administration
           20 Marketing
           30 Purchasing
           40 Human Resources
           50 Shipping
           60 IT
           70 Public Relations
           80 Sales
           90 Executive
          100 Finance
          110 Accounting

27 rows selected.
```