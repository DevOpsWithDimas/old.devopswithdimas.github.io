---
layout: post
title: "DDL - Foreign Key Constraint"
date: 2021-02-25T16:55:14+07:00
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/19/cncpt/data-integrity.html#GUID-7CD73D16-EA1A-4AA8-AA7D-4288557395B8
youtube: hJG3pnsZUXg
comments: true
image_path: /resources/posts/oracle12c/016l-constraint-foreign-key
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Constraint **Foreign keys** dapat diterapkan pada sebuah kolom dengan table, dengan tujuan memvalidasi apakan nilai yang di entry terdaftar pada column di table acuannya. Contoh penggunaanya seperti berikut:

{% gist page.gist "016l-constraint-foreignkey.sql" %}

Nah jadi dari 2 table tersebut saling ber-relasi dengan menggunakan foreign key pada column `master_id` di table `test_fk_detail_table` yang mereferensi dari table `test_fk_master_table` pada column `id`. 

Jadi kita hanya dapat menyimpan data ke table `test_fk_detail_table` dengan mengeset nilai `master_id` yang tersedia di table `test_fk_master_table`, jika kita menginput data diluar dari data yang tersedia maka akan terkena validasi constraint foreign key. Contohnya entry data yang salah seperti berikut:

{% highlight sql %}
insert into test_fk_detail_table(id, first_name, master_id, salary)
values ('05', 'Muhamad Purwadi', 'ba', 9000);
{% endhighlight %}

Jika di execute maka hasilnya seperti berikut:

{% highlight sql %}
insert into test_fk_detail_table(id, first_name, master_id, salary)
*
ERROR at line 1:
ORA-02291: integrity constraint (HR.FK_DETAIL_MASTER_ID) violated - parent key
not found
{% endhighlight %}

## Menggunakan alter table

Selain pre-defined create table, kita juga bisa menambakan constraint tersebut dengan `alter table` contohnya seperti berikut:

{% gist page.gist "016l-constraint-alter-table-foreignkey.sql" %}