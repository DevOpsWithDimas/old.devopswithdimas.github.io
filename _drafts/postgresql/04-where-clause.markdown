---
layout: post
title: "Filtering data with WHERE clause"
lang: postgresql
categories:
- RDBMS
- PostgreSQL
- sql
- select
refs: 
- https://www.postgresql.org/docs/current/
youtube: 
image_path: /resources/posts/postgresql/04-where-clause
comments: true
gist: dimMaryanto93/7ae7632f9418feb724bc431eff412a3f
catalog_key: sql-statement
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang mem-Filter data dengan menggunakan `WHERE` clause di PostgreSQL. By default jika kita menggunakan perintah `select` itu akan menampilkan semua data pada suatu atau berberapa table. Dengan menggunakan clause WHERE kita bisa memfilter atau memilih data yang akan kita tampilkan. 

Perintah dasar untuk `WHERE` clause seperti berikut:

{% highlight sql %}
select * | column_list ...
from a_table
where search_condition
{% endhighlight %}

Dimana `search_condition` adalah any value expression (`functions`, `operators` and `predicates` ) yang mengembalikan nilai boolean. Sebagai gambaran berikut ilustrasinya:

![filter-data]({{ page.image_path | prepend: site.baseurl }}/01-consept-where-cluase.png)

Ilustrasi tersebut menggambarkan, suatu predicate atau `search_condition` yaitu menggunakan operator equal pada column `status` dengan nilai `active` maka database akan mencari nilainya `active` saja pada kolom `status`. Untuk `search_condition` tersebut biasanya di sebut dengan predicate. Ada banyak sekali predicate yang kita bisa gunakan tapi disini kita bahasnya paling dasar dulu ya yaitu:

1. Relational predicate
2. Like predicates
3. Between predicates
4. Nulless predicate
5. Logical predicate
6. Pattern-matching predicate

Ok kita bahas satu-per-satu ya, mulai dari relational predicate

## Relational predicate

Relational predicates pada dasarnya adalah [comparison operators]({% post_url postgresql/03-select-statements/2022-02-28-03b-sql-operators %}#comparation-operators) yaitu

1. Equal (`=`)
2. Not Equals (`!=` or `<>`)
3. Less than or equal to (`<` or `<=`)
4. Greater then or equal to (`>` or `>=`)

Contoh penggunaannya seperti berikut:

{% gist page.gist "04-select-where-relation-eq.sql" %}

Contoh lainnya seperti berikut:

{% gist page.gist "04-select-where-relation-greater-than.sql" %}

Jika dijalankan maka hasilnya seperti berikut:

```postgresql-console
hr=# select employee_id, first_name, last_name, email, phone_number, job_id, salary
hr-# from employees
hr-# where salary >= 20000;
 employee_id | first_name | last_name | email | phone_number | job_id  |  salary
-------------+------------+-----------+-------+--------------+---------+----------
         100 | Steven     | King      | SKING | 515.123.4567 | AD_PRES | 24000.00
(1 row)
```

Nah jadi kita kita perhatikan dari hasil query tersebut, kita memfilter menggunakan operator `>=` atau lebih besar sama dengan hasilnya tidak ada yang salarnya lebih kecil dari kita definisikan yaitu `20_000`.