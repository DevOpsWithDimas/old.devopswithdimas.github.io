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
- https://www.postgresql.org/docs/current/queries-table-expressions.html#QUERIES-GROUP
- https://www.postgresql.org/docs/current/functions-aggregate.html
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