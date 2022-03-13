---
layout: post
title: "Single Row / Group functions"
lang: postgresql
categories:
- RDBMS
- PostgreSQL
- sql
- select
refs: 
- https://www.postgresql.org/docs/14/queries-table-expressions.html#QUERIES-GROUP
- https://www.postgresql.org/docs/14/functions-aggregate.html
youtube: 
image_path: /resources/posts/postgresql/04a-single-group-function
comments: true
gist: dimMaryanto93/7ae7632f9418feb724bc431eff412a3f
catalog_key: select-statement
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang Jenis dari Functions yaitu Single Row Function dan Group Functions. Karena materinya akan lumayan panjang seperti biasa kita akan bagi menjadi beberapa bagian diantaranya:

1. Using single row functions
2. Using Group / Aggregate functions
3. Using `GROUP BY` clause
4. Using `HAVING` clause
5. Different between `WHERE` and `HAVING` clause?

Ok langsung aja kita bahas materi yang pertama

## Using single row functions

Single row function is Functions return a single result row for every row of a queried table or view. 

![ilustration-single-row-func]({{ page.image_path | prepend: site.baseurl }}/01-ilustration-single-row-func.png)

Single row function yang kita bisa gunakan, ada banyak sekali sesuai dengan apa yang telah kita bahas di [artikel sebelumnya]({% post_url postgresql/03-select-statements/2022-03-04-03c-sql-functions %}) ataupun kita juga bisa menggunakan function yang kita buat sendiri. These functions can appear in select lists, WHERE clauses, With Queries and more.

Contoh penggunaannya seperti berikut:

{% gist page.gist "04a-select-single-row-func.sql" %}

Jika dijalankan maka hasilnya seperti berikut:

```postgresql-console
hr=# SELECT  UPPER(last_name) nama,
hr-#         to_char(salary, '$L999,999.00') gaji_sebulan,
hr-#         concat(first_name, ' ', last_name) as nama_lengkap
hr-# FROM employees
hr-# LIMIT 10;
   nama    | gaji_sebulan  |   nama_lengkap
-----------+---------------+------------------
 KING      | $   24,000.00 | Steven King
 KOCHHAR   | $   17,000.00 | Neena Kochhar
 DE HAAN   | $   17,000.00 | Lex De Haan
 HUNOLD    | $    9,000.00 | Alexander Hunold
 ERNST     | $    6,000.00 | Bruce Ernst
 AUSTIN    | $    4,800.00 | David Austin
 PATABALLA | $    4,800.00 | Valli Pataballa
 LORENTZ   | $    4,200.00 | Diana Lorentz
 GREENBERG | $   12,000.00 | Nancy Greenberg
 FAVIET    | $    9,000.00 | Daniel Faviet
(10 rows)
```

## Using Group / Aggregate functions

Aggregate functions compute a single result from a set of input values. Jika kita gambarkan ilustrasinya seperti berikut:

![ilustration-aggregate-function]({{ page.image_path | prepend: site.baseurl }}/02-ilustration-aggregate-func.png)

Group atau Aggregate function di bagi menjadi beberapa diantaranya:

1. General-Purpose Aggregate Functions
2. Aggregate Functions for Statistics
3. Ordered-Set Aggregate Functions
4. Hypothetical-Set Aggregate Functions
5. Grouping Operations

Untuk general purpose aggregate function berikut adalah beberapa function yang paling umum di gunakan:

| Functions	                                                |  Description        |
| :------- 	                                                | :----------         |
| `avg ( numeric ) → numeric`             | Computes the average (arithmetic mean) of all the non-null input values. |
| `bool_and ( boolean ) → boolean`        | Returns true if all non-null input values are true, otherwise false. |
| `bool_or ( boolean ) → boolean`         | Returns true if any non-null input value is true, otherwise false. |
| `count ( "any" ) → bigint`              | Computes the number of input rows in which the input value is not null. |
| `max ( any ) → same as input type`      | Computes the maximum of the non-null input values. Available for any `numeric`, `string`, `date/time`, or `enum` type, as well as `inet`, `interval`, `money`, `oid`, `pg_lsn`, `tid`, and `arrays` of any of these types. |
| `min ( any ) → same as input type`      | Computes the minimum of the non-null input values. Available for any `numeric`, `string`, `date/time`, or `enum` type, as well as `inet`, `interval`, `money`, `oid`, `pg_lsn`, `tid`, and `arrays` of any of these types. |
| `sum ( number ) → same as input type`   | Computes the sum of the non-null input values. |

Sedangkan untuk Statistic purpose berikut adalah beberapa function yang paling umum di gunakan:

| Functions	                                                |  Description        |
| :------- 	                                                | :----------         |
| `corr ( Y double , X double ) → double`                   | Computes the correlation coefficient. |
| `stddev ( numeric_type ) → double`                        | This is a historical alias for stddev_samp. |
| `variance ( numeric_type ) → double`                      | This is a historical alias for var_samp. |

Dan masih banyak lagi, Berikut adalah contoh penggunaanya di SQL:

{% gist page.gist "04a-select-aggregate-func.sql" %}

Jika dijalankan hasilnya seperti berikut:

```postgresql-console
hr=# SELECT  max(salary) max_salary,
hr-#         min(salary) min_salary,
hr-#         avg(salary) avg_salary,
hr-#         count(*) count_employees
hr-# FROM employees;
 max_salary | min_salary |      avg_salary       | count_employees
------------+------------+-----------------------+-----------------
   24000.00 |    2100.00 | 6461.6822429906542056 |             107
(1 row)
```

## Using GROUP BY clause

The `GROUP BY` clause is used to group together those rows in a table that have the same values in all the columns listed. Jika di gambarkan berikut ilustrasinya

![ilustration-group-by]({{ page.image_path | prepend: site.baseurl }}/03-ilustration-group-by.png)

Untuk basic usage seperti berikut:

{% highlight sql %}
SELECT select_list
FROM ...
[WHERE ...]
GROUP BY grouping_column_reference [, grouping_column_reference]...
{% endhighlight %}

The effect is to combine each set of rows having common values into one group row that represents all rows in the group. Berikut adalah contoh penggunaanya di SQL:

{% gist page.gist "04a-select-group-by.sql" %}

Jika dijalankan hasilnya seperti berikut:

```postgresql-console
hr=# SELECT  job_id
hr-# FROM employees
hr-# GROUP BY job_id;
   job_id
------------
 SH_CLERK
 AD_VP
 SA_MAN
 PR_REP
 MK_REP
 AD_PRES
 FI_ACCOUNT
 AC_ACCOUNT
(19 rows)
```

NOTE: Grouping without aggregate expressions effectively calculates the set of distinct values in a column.

In general, if a table is grouped, columns that are not listed in GROUP BY cannot be referenced except in aggregate expressions. An example with aggregate expressions is:

{% gist page.gist "04a-select-group-by-with-aggregate.sql" %}

Jika dijalankan hasilnya seperti berikut:

```postgresql-console
hr=# SELECT  job_id,
hr-#         count(*) count_employees_by_job,
hr-#         sum(salary) salary_group_by_job
hr-# FROM employees
hr-# GROUP BY job_id;
   job_id   | count_employees_by_job | salary_group_by_job
------------+------------------------+---------------------
 SH_CLERK   |                     20 |            64300.00
 AD_VP      |                      2 |            34000.00
 SA_MAN     |                      5 |            61000.00
 PU_MAN     |                      1 |            11000.00
 IT_PROG    |                      5 |            28800.00
 ST_CLERK   |                     20 |            55700.00
 MK_REP     |                      1 |             6000.00
 AD_PRES    |                      1 |            24000.00
 FI_ACCOUNT |                      5 |            39600.00
 AC_ACCOUNT |                      1 |             8300.00
(19 rows)
```

## Using HAVING clause

If a table has been grouped using `GROUP BY`, but only certain groups are of interest, the `HAVING` clause can be used, much like a `WHERE` clause, to eliminate groups from the result. 

The syntax is:

{% highlight sql %}
SELECT select_list 
FROM ... 
[WHERE ...] 
GROUP BY ... 
HAVING boolean_expression
{% endhighlight %}

Expressions in the `HAVING` clause can refer both to grouped expressions and to ungrouped expressions (which necessarily involve an aggregate function). Berikut adalah contoh penggunaanya di SQL:

{% gist page.gist "04a-select-group-by-with-having.sql" %}

Jika dijalankan hasilnya seperti berikut:

```postgresql-console
hr=# SELECT  job_id,
hr-#         count(*) count_employees_by_job,
hr-#         sum(salary) salary_group_by_job
hr-# FROM employees
hr-# GROUP BY job_id
hr-# HAVING count(*) >= 5;
   job_id   | count_employees_by_job | salary_group_by_job
------------+------------------------+---------------------
 SH_CLERK   |                     20 |            64300.00
 SA_MAN     |                      5 |            61000.00
 IT_PROG    |                      5 |            28800.00
 ST_CLERK   |                     20 |            55700.00
 PU_CLERK   |                      5 |            13900.00
 ST_MAN     |                      5 |            36400.00
 SA_REP     |                     30 |           250500.00
 FI_ACCOUNT |                      5 |            39600.00
(8 rows)
```

## Different between `WHERE` and `HAVING` clause?

Mungkin dari temen-temen ada yang bertanya? jika menggunakan `HAVING` clause apa bedanya dengan `WHERE` clause?

Untuk mengetahui jawabanya kita kita perhatikan ilustrasi berikut:

![ilustration-where-having-clause]({{ page.image_path | prepend: site.baseurl }}/04-ilustrasi-where-and-having-clause.png)

Jadi klausa dengan `WHERE` dia prosesnya akan melakukan filter terlebih dahulu sebelum dilakukan proses `GROUP BY` sedangkan untuk `HAVING` dia akan memfilter datanya setelah dikelompokan / grouping. Berikut adalah contoh penggunaanya di SQL:

{% gist page.gist "04a-select-group-by-with-where-and-having.sql" %}

Jika dijalankan hasilnya seperti berikut:

```postgresql-console
hr=# SELECT  job_id,
hr-#         count(*) count_employees_by_job,
hr-#         sum(salary) salary_group_by_job
hr-# FROM employees
hr-# WHERE job_id in ('FI_ACCOUNT', 'SA_MAN', 'IT_PROG', 'HR_REP', 'MK_MAN')
hr-# GROUP BY job_id
hr-# HAVING sum(salary) >= 20000;
   job_id   | count_employees_by_job | salary_group_by_job
------------+------------------------+---------------------
 SA_MAN     |                      5 |            61000.00
 IT_PROG    |                      5 |            28800.00
 FI_ACCOUNT |                      5 |            39600.00
(3 rows)
```