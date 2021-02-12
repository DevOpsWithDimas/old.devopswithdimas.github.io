---
layout: post
title: "Combine Logical pada klausa where di Oracle"
date: 2021-02-12T20:51:06+07:00
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/Logical-Conditions.html#GUID-C5E48AF2-3FF9-401D-A104-CDB5FC19E65F
youtube: 
comments: true
image_path: /resources/posts/oracle12c/
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Di SQL juga mengenal yang namanya gerbang logica, do you remember??

| operation | `true x true` | `true x false`    | `false x true`    | `false x false`   |
| :---      | :---          | :---              | :---              | :---              |
| AND       | `true`        | `false`           | `false`           | `false`           |
| OR        | `true`        | `true`            | `true`            | `false`           |


Operator logika tersebut bisa digunakan di klausa `where` statement, contoh kasusnya seperti berikut:

# AND Statement

Kasusnya saya mau mencari data karyawan yang berkerja di `department_id = 90` dan yang `manager_id = 100`, berikut querynya:

{% gist page.gist "006h-select-where-combine-and.sql" %}

Berikut hasilnya:

{% highlight sql %}
      KODE NAMA_DEPAN           DEPARTMENT_ID MANAGER_ID
---------- -------------------- ------------- ----------
       101 Neena                           90        100
       102 Lex                             90        100
{% endhighlight %}

# OR Statement

Kasusnya saya mau mencari data karyawan yang memiliki `salary >= 12000` atau karyawan yang berkerja di `department_id = 90`, berikut querynya:

{% gist page.gist "006h-select-where-combine-or.sql" %}

Berikut hasilnya:

{% highlight sql %}
      KODE NAMA_DEPAN           GAJI_BULANAN
---------- -------------------- ------------
       201 Michael                     13000
       205 Shelley                     12008
       100 Steven                      24000
       101 Neena                       17000
       102 Lex                         17000
       108 Nancy                       12008
       145 John                        14000
       146 Karen                       13500
       147 Alberto                     12000
{% endhighlight %}


Selain itu kita bisa kombinansikan semua logika, contoh kasusnya seperti berikut. Saya mau mancari data karyawan yang bekerja di `department_id = 100` atau yang `manager_id = 108` dan memiliki `salary >= 9000` dan yang `first_name` bukan `Daniel`. Berikut querynya:

{% gist page.gist "006h-select-where-combine-all.sql" %}

Berikut hasilnya:

{% highlight sql %}
      KODE NAMA_DEPAN               DIVISI GAJI_BULANAN    MANAGER
---------- -------------------- ---------- ------------ ----------
       108 Nancy                       100        12008        101
{% endhighlight %}
