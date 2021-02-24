---
layout: post
title: "DDL - Unqiue Constraint"
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/database/121/index.htm
youtube: 
comments: true
image_path: /resources/posts/oracle12c/016i-constraint-unique
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Constraint **Unique** diterapkan pada column tertentu dalam sebuah tabel, dengan tujuan untuk memvalidasi data yang kita entry tidak boleh sama dengan data yang telah tersedia di table pada kolom tersebut. Contoh pengguanya seperti berikut:

{% gist page.gist "016i-constraint-simple-unique.sql" %}

Jadi dengan ddl untuk membuat table diatas, maka kita tidak boleh entry data pada kolom `product_no` dengan nilai yang sama atau sudah ada di table tersebut. Contoh dengan perintah entry yang salah seperti berikut:

{% highlight sql %}
insert into test_constraint_unique (product_no, name, price)
values (1, 'Apple Macbook Pro 13" (2019)', 25000);
{% endhighlight %}

Bila di execute maka akan terjadi error: 

{% highlight sql %}
insert into test_constraint_unique (product_no, name, price)
*
ERROR at line 1:
ORA-00001: unique constraint (HR.SYS_C007465) violated
{% endhighlight %}

## Unique Constraint multiple columns

Selain itu juga Constraint unique dapat di terapkan di beberapa kolom sekaligus, contohnya seperti berikut:

{% gist page.gist "016i-constraint-multiple-unique-columns.sql" %}

Sekarang coba execute query berikut:

{% highlight sql %}
insert into test_constraint_multi_unique(product_code, product_type, product_name, price, release_date)
values (2, 'MBP13', 'Macbook Pro 13" (2019)', 24000, date '2018-03-01');
{% endhighlight %}

Maka berikut hasilnya:

{% highlight sql %}
insert into test_constraint_multi_unique(product_code, product_type, product_name, price, release_date)
*
ERROR at line 1:
ORA-00001: unique constraint (HR.UQ_PRODUCT_ID) violated
{% endhighlight %}

## Add unique constraint dengan Alter Table

Dan yang terakhir kita juga bisa menambahkan `unique constraint` dengan `alter table`, tpi jika udah ada datanya kita harus handle dulu sendiri jadi make sure ja gak ada yang sama untuk ngechecknya kita bisa pake sql group by contohnya seperti berikut:

{% highlight sql %}
SQL> select product_code, product_type, count(*) duplicate_count
from test_constraint_multi_unique
group by product_code, product_type
having count(*) >= 2;

no rows selected

{% endhighlight %}

Jika hasilnya aman seperti diatas, maka kita bisa tambahkan alter tabelnya seperti berikut:

{% gist page.gist "016i-constraint-alter-add-unique.sql" %}