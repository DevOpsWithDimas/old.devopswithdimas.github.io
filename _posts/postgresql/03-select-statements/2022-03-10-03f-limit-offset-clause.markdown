---
layout: post
title: "Limit dan Offset rows"
date: 2022-03-10T14:28:18+07:00
lang: postgresql
categories:
- RDBMS
- PostgreSQL
- sql
- select
refs: 
- https://www.postgresql.org/docs/current/queries-limit.html
youtube: 
image_path: /resources/posts/postgresql/03f-limit-offset
comments: true
gist: dimMaryanto93/7ae7632f9418feb724bc431eff412a3f
catalog_key: select-statement
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang Limit dan Offset. Seperti biasa materinya kita akan bagi-bagi seperti berikut:

1. Limit clause
2. Offset clause
3. Applying limit and offset together

Ok langsung aja kita bahas materi yang pertama:

## Limit clause

Dengan `LIMIT` clause kita bisa membatasi data yang akan di tampilkan dari hasil yang di proses oleh query. Secara konsep fungsi limit jika kita gambarkan seperti berikut:

![konsep-limit]({{ page.image_path | prepend: site.baseurl }}/01-limit.png)

Penggunaan limit di PostgreSQL ada 2 cara yaitu dengan memberikan count row atau number dan menggunakan keyword `ALL`. If a limit count is given, no more than that many rows will be returned (but possibly fewer, if the query itself yields fewer rows). `LIMIT ALL` is the same as omitting the LIMIT clause, as is LIMIT with a NULL argument.

Basic format Limit clause seperti berikut:

{% highlight sql %}
SELECT select_list
FROM table_expression
[ ORDER BY ... ]
[ LIMIT { number | ALL } ]
{% endhighlight %}

When using `LIMIT`, it is important to use an `ORDER BY` clause that constrains the result rows into a unique order. Otherwise you will get an unpredictable subset of the query's rows.

Contoh penggunaannya seperti berikut:

{% gist page.gist "03f-select-limit-number.sql" %}

Jika dijalankan maka hasilnya seperti berikut:

```postgresql-console
hr=# select employee_id, first_name, salary, commission_pct
hr-# from employees
hr-# order by employee_id
hr-# limit 10;
 employee_id | first_name |  salary  | commission_pct
-------------+------------+----------+----------------
         100 | Steven     | 24000.00 |
         101 | Neena      | 17000.00 |
         102 | Lex        | 17000.00 |
         103 | Alexander  |  9000.00 |
         104 | Bruce      |  6000.00 |
         105 | David      |  4800.00 |
         106 | Valli      |  4800.00 |
         107 | Diana      |  4200.00 |
         108 | Nancy      | 12000.00 |
         109 | Daniel     |  9000.00 |
(10 rows)
```

## Offset clause

`OFFSET` says to skip that many rows before beginning to return rows. `OFFSET 0` is the same as omitting the OFFSET clause, as is `OFFSET` with a `NULL` argument. Secara konsep fungsi `OFFSET` jika kita gambarkan seperti berikut:

![konsep-offset]({{ page.image_path | prepend: site.baseurl }}/02-offset.png)

Basic format offset clause seperti berikut:

{% highlight sql %}
SELECT select_list
FROM table_expression
[ ORDER BY ... ]
[ OFFSET number ]
{% endhighlight %}

Sama halnya dengan `LIMIT`, kita membutuhkan `ORDER BY` clause untuk mendapatkan data yang predicatable.

Contoh penggunaannya seperti berikut:

{% gist page.gist "03f-select-offset-number.sql" %}

Jika dijalankan maka hasilnya seperti berikut:

```postgresql-console
hr=# select employee_id, first_name, salary, commission_pct
hr-# from employees
hr-# order by employee_id
hr-# offset 100;
 employee_id | first_name |  salary  | commission_pct
-------------+------------+----------+----------------
         200 | Jennifer   |  4400.00 |
         201 | Michael    | 13000.00 |
         202 | Pat        |  6000.00 |
         203 | Susan      |  6500.00 |
         204 | Hermann    | 10000.00 |
         205 | Shelley    | 12000.00 |
         206 | William    |  8300.00 |
(7 rows)
```

## Applying limit and offset together

If both `OFFSET` and `LIMIT` appear, then `OFFSET` rows are skipped before starting to count the `LIMIT` rows that are returned. Secara konsep fungsi `LIMIT` dan `OFFSET` jika kita gabungkan maka ilustrasinya seperti berikut:

![konsep-limit-offset]({{ page.image_path | prepend: site.baseurl }}/03-limit-offset.png)

SQL Format limit & offset clause seperti berikut:

{% highlight sql %}
SELECT select_list
FROM table_expression
[ ORDER BY ... ]
[ LIMIT { number | ALL } ] 
[ OFFSET number ]
{% endhighlight %}

Contoh penggunaannya seperti berikut:

{% gist page.gist "03f-select-limit-offset-number.sql" %}

Jika dijalankan maka hasilnya seperti berikut:

```postgresql-console
hr=# select employee_id, first_name, salary, commission_pct
hr-# from employees
hr-# order by employee_id
hr-# limit 5
hr-# offset 100;
 employee_id | first_name |  salary  | commission_pct
-------------+------------+----------+----------------
         200 | Jennifer   |  4400.00 |
         201 | Michael    | 13000.00 |
         202 | Pat        |  6000.00 |
         203 | Susan      |  6500.00 |
         204 | Hermann    | 10000.00 |
(5 rows)
```