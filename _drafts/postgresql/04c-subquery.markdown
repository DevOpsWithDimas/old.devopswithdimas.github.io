---
layout: post
title: "Queries inside a query (subquery)"
lang: postgresql
authors:
- dimasm93
categories:
- RDBMS
- PostgreSQL
- sql
- select
refs: 
- https://www.postgresql.org/docs/14/queries-table-expressions.html#subqueries
- https://postgresql.org/docs/current/functions-subquery.html
youtube: 
image_path: /resources/posts/postgresql/04c-subquery
comments: true
gist: dimMaryanto93/7ae7632f9418feb724bc431eff412a3f
catalog_key: select-statement
downloads: []
---

Hai semuanya, setelah kita membahas tentang Joined tables tahap selanjutnya kita akan membahas tentang Queries inside a query atau lebih di kenal dengan SubQuery. Seperti biasa karena pembahasannya akan lumayan panjang jadi kita akan bagi-bagi menjadi beberapa bagian ya diantaranya:

1. What is SubQuery?
2. Using SubQuery specified in column_list
3. Correlate SubQuery
4. Using SubQuery inline view
5. Lateral Subqueries
6. SubQuery as predicate in where clause

OK langsung aja kita ke pembahasan yang pertama

<!--more-->

## What is SubQuery?

A subquery is a query nested inside another query such as `SELECT`, `INSERT`, `DELETE` and `UPDATE`. In this article, we are focusing on the `SELECT` statement only.

Subquery in select statement can appear into `select`, `from` and `where` clause, The basic syntax of subquery look like:

{% highlight sql %}
select select_column_list, (single_row_subquery_expression)
from from_tables [, (multi_columns_subquery_expression)]
where column_name operator (single_column_subquery_expression)
{% endhighlight %}

Dimana `single_row_subquery_expression` adalah suatu query yang biasanya menghasilkan data 1 row dan 1 column contohnya:

{% highlight sql %}
select avg(salary)
from employees;
{% endhighlight %} 

Kemudian untuk `multiple_columns_subquery_expression` adalah suatu query yang bisa menghasilkan banyak data dan banyak column contohnya:

{% highlight sql %}
select employee_id, first_name, last_name
from employees;
{% endhighlight %} 

dan yang terakhir untuk `single_column_subquery_expression` adalah suatu query yang bisa menghasilkan banyak data dan hanya 1 column saja contohnya:

{% highlight sql %}
select salary
from employees;
{% endhighlight %} 

PostgreSQL executes the query that contains a subquery in the following sequence:

1. executes the subquery.
2. gets the result and passes it to the outer query.
3. executes the outer query.

Untuk lebih detailnya seperti ilustrasi seperti berikut:

![subquery-execution-process]({{ page.image_path | prepend: site.baseurl }}/01-subquery-structure.png)

## Using SubQuery specified in `select_column_list`

SubQuery yang paling umum pada Select statement, di letakan pada column_list dan where clause. Kali ini kita bahas dulu untuk SubQuery pada column_list. The basic query form is

{% highlight sql %}
select select_column_list, [(single_row_subquery_expression), ...]
from from_tables
[where ...]
{% endhighlight %}

For example

{% gist page.gist "04c-subquery-select-column-list.sql" %}

Jika dijalankan maka hasilnya seperti berikut:

```shell
hr=# SELECT j.job_title,
hr-#        (SELECT min(h.start_date)::date FROM job_history h) as start_join
hr-# FROM jobs j;
            job_title            | start_join
---------------------------------+------------
 President                       | 1987-09-17
 Administration Vice President   | 1987-09-17
 Administration Assistant        | 1987-09-17
 Finance Manager                 | 1987-09-17
 Accountant                      | 1987-09-17
 Accounting Manager              | 1987-09-17
 Public Accountant               | 1987-09-17
 Sales Manager                   | 1987-09-17
 Sales Representative            | 1987-09-17
 Purchasing Manager              | 1987-09-17
 Purchasing Clerk                | 1987-09-17
 Stock Manager                   | 1987-09-17
 Stock Clerk                     | 1987-09-17
 Shipping Clerk                  | 1987-09-17
 Programmer                      | 1987-09-17
 Marketing Manager               | 1987-09-17
 Marketing Representative        | 1987-09-17
 Human Resources Representative  | 1987-09-17
 Public Relations Representative | 1987-09-17
(19 rows)
```

Khusus untuk SubQuery pada select column_list, tidak bisa menggunakan subquery yang menghasilkan data lebih dari 1 baris, contohnya seperti berikut:

{% highlight sql %}
select j.job_title,
       (select h.start_date from job_history h)
from jobs j;
{% endhighlight %}

Maka jika di jalankan hasilnya seperti berikut:

```powershell
hr=# select j.job_title,
hr-#        (select h.start_date from job_history h)
hr-# from jobs j;
ERROR:  more than one row returned by a subquery used as an expression
```

Dan juga tidak bisa menggunakan subquery yang mehasilkan lebih dari 1 kolom, contohnya seperti berikut:

{% highlight sql %}
select j.job_title,
       (select h.start_date, h.start_date from job_history h limit 1)
from jobs j;
{% endhighlight %}

Jika di jalankan hasilnya seperti berikut:

```shell
hr=# select j.job_title,
hr-#        (select h.start_date, h.start_date from job_history h limit 1)
hr-# from jobs j;
ERROR:  subquery must return only one column
LINE 2:        (select h.start_date, h.start_date from job_history h...
               ^
```

Maka dari itu, kita harus memastikan data yang dikembalikan oleh subquery 1 row dan 1 column.

## Correlate SubQuery

Correlated subqueries are used for row-by-row processing. Each subquery is executed once for every row of the outer query.

PostgreSQL executes the query that contains a subquery in the following sequence:

1. Get a candiate row from outer query
2. executes the inner query using candidate row value
3. use value from inner query to quality or disqulity candidate row

Basic statement is:

{% highlight sql %}
SELECT column1, column2, ....
FROM table1 outer
WHERE column1 operator
                    (SELECT column3
                     FROM table2 inner
                     WHERE inner.column1 = outer.column1);
{% endhighlight %}

For example 

{% gist page.gist "04c-subquery-simple-correlate.sql" %}

Jika kita jalankan maka hasilnya seperti berikut:

```shell
hr=# select emp.employee_id,
hr-#        emp.first_name                           employee_name,
hr-#        (select man.first_name
hr(#         from employees man
hr(#         where emp.manager_id = man.employee_id) manager_name
hr-# from employees emp
hr-# where emp.manager_id is not null
hr-# limit 10;
 employee_id | employee_name | manager_name
-------------+---------------+--------------
         101 | Neena         | Steven
         102 | Lex           | Steven
         103 | Alexander     | Lex
         104 | Bruce         | Alexander
         105 | David         | Alexander
         106 | Valli         | Alexander
         107 | Diana         | Alexander
         108 | Nancy         | Neena
         109 | Daniel        | Nancy
         110 | John          | Nancy
(10 rows)
```

Jika temen-temen perhatikan pada subquery dengan where clause `emp.manager_id = man.employee_id` kita menggunakan column `manager_id` pada outer query. Dan jika kita mau ngambil data ke dua dari subquery, kita harus mendefinisikan column baru seperti berikut:

{% gist page.gist "04c-subquery-more-correlate.sql" %}

Jika dijalankan maka hasilnya seperti berikut:

```shell
hr=# select emp.employee_id,
hr-#        emp.first_name                           employee_name,
hr-#        emp.salary                               employee_salary,
hr-#        (select man.first_name
hr(#         from employees man
hr(#         where emp.manager_id = man.employee_id) manager_name,
hr-#        (select man.salary
hr(#         from employees man
hr(#         where emp.manager_id = man.employee_id) manager_salary
hr-# from employees emp
hr-# where emp.manager_id is not null
hr-# limit 10;
 employee_id | employee_name | employee_salary | manager_name | manager_salary
-------------+---------------+-----------------+--------------+----------------
         101 | Neena         |        17000.00 | Steven       |       24000.00
         102 | Lex           |        17000.00 | Steven       |       24000.00
         103 | Alexander     |         9000.00 | Lex          |       17000.00
         104 | Bruce         |         6000.00 | Alexander    |        9000.00
         105 | David         |         4800.00 | Alexander    |        9000.00
         106 | Valli         |         4800.00 | Alexander    |        9000.00
         107 | Diana         |         4200.00 | Alexander    |        9000.00
         108 | Nancy         |        12000.00 | Neena        |       17000.00
         109 | Daniel        |         9000.00 | Nancy        |       12000.00
         110 | John          |         8200.00 | Nancy        |       12000.00
(10 rows)
```

## Using SubQuery inline view

The subquery specified in the `FROM` clause of a query is called an inline view. Because an inline view can replace a table in a query, it is also called a derived table. Sometimes, you may hear the term subselect, which is the same meaning as the inline view.

An inline view is not a real view but a subquery in the `FROM` clause of a `SELECT` statement. The basic syntax:

{% highlight sql %}
SELECT column1, column2, ....
FROM table1 outer, ( subquery_expression ) as subquery_alias, ...
{% endhighlight %}

For example:

{% gist page.gist "04c-subquery-basic-inline-view.sql" %}

Jika kita jalankan maka hasilnya seperti berikut:

```shell
hr=# select emp.employee_id, emp.first_name, emp.salary, func.rata2, func.minimun, func.maximum
hr-# from employees emp,
hr-#      (select round(avg(job.max_salary), 0) rata2,
hr(#              min(job.max_salary)           minimun,
hr(#              max(job.max_salary)           maximum
hr(#       from jobs job) as func
hr-# where emp.salary >= func.rata2;
 employee_id | first_name |  salary  | rata2 | minimun | maximum
-------------+------------+----------+-------+---------+---------
         100 | Steven     | 24000.00 | 13211 |    5000 |   40000
         101 | Neena      | 17000.00 | 13211 |    5000 |   40000
         102 | Lex        | 17000.00 | 13211 |    5000 |   40000
         145 | John       | 14000.00 | 13211 |    5000 |   40000
         146 | Karen      | 13500.00 | 13211 |    5000 |   40000
```

## Lateral SubQueries

Subqueries appearing in `FROM` can be preceded by the key word `LATERAL`. This allows them to reference columns provided by preceding FROM items. (Without `LATERAL`, each subquery is evaluated independently and so cannot cross-reference any other FROM item.) For example:

{% highlight sql %}
select emp.employee_id,
       emp.first_name,
       history.job_id,
       history.start_date
from employees emp,
     (select job.job_id, job.start_date
      from job_history job
      where emp.employee_id = job.employee_id) as history
{% endhighlight %}

Jika kita execute maka hasilnya seperti berikut:

```shell
hr=# select emp.employee_id,
hr-#        emp.first_name,
hr-#        history.job_id,
hr-#        history.start_date
hr-# from employees emp,
hr-#      (select job.job_id, job.start_date
hr(#       from job_history job
hr(#       where emp.employee_id = job.employee_id) as history;
ERROR:  invalid reference to FROM-clause entry for table "emp"
LINE 8:       where emp.employee_id = job.employee_id) as history;
                    ^
HINT:  There is an entry for table "emp", but it cannot be referenced from this part of the query.
```

A LATERAL item can appear at top level in the `FROM` list, or within a `JOIN` tree. In the latter case it can also refer to any items that are on the left-hand side of a `JOIN` that it is on the right-hand side of.

The basic syntax is:

{% highlight sql %}
SELECT column1, column2, ....
FROM table1 outer, LATERAL ( subquery_expression ) as subquery_alias, ...
{% endhighlight %}

When a `FROM` item contains `LATERAL` cross-references, evaluation proceeds as follows: for each row of the `FROM` item providing the cross-referenced column(s), or set of rows of multiple `FROM` items providing the columns, the `LATERAL` item is evaluated using that row or row set's values of the columns. The resulting row(s) are joined as usual with the rows they were computed from. This is repeated for each row or set of rows from the column source table(s).

For example:

{% gist page.gist "04c-subquery-lateral-corellate.sql" %}

Jika dijalankan hasilnya seperti berikut:

```shell
hr=# select emp.employee_id,
hr-#        emp.first_name,
hr-#        history.job_id,
hr-#        history.start_date
hr-# from employees emp,
hr-#      lateral (select job.job_id, job.start_date::date
hr(#               from job_history job
hr(#               where emp.employee_id = job.employee_id) as history
hr-# order by employee_id, job_id
hr-# ;
 employee_id | first_name |   job_id   | start_date
-------------+------------+------------+------------
         101 | Neena      | AC_ACCOUNT | 1989-09-21
         101 | Neena      | AC_MGR     | 1993-10-28
         102 | Lex        | IT_PROG    | 1993-01-13
         114 | Den        | ST_CLERK   | 1998-03-24
         122 | Payam      | ST_CLERK   | 1999-01-01
         176 | Jonathon   | SA_MAN     | 1999-01-01
         176 | Jonathon   | SA_REP     | 1998-03-24
         200 | Jennifer   | AC_ACCOUNT | 1994-07-01
         200 | Jennifer   | AD_ASST    | 1987-09-17
         201 | Michael    | MK_REP     | 1996-02-17
(10 rows)
```

Query tersebut akan sama jika kita menggunakan join seperti berikut:

{% highlight sql %}
select emp.employee_id,
       emp.first_name,
       history.job_id,
       history.start_date::date
from employees emp
         join job_history history on (emp.employee_id = history.employee_id)
order by employee_id, job_id;
{% endhighlight %}

## SubQuery as predicate in where clause

Selanjutnya kita bahas SubQuery Expression atau SubQuery yang diletakan pada `WHERE` clause dengan beberapa operators atau predicates. Basic form of SubQuery:

{% highlight sql %}
select column_list, ...
from table1, ...
where column_expression operator (subquery_expression)
{% endhighlight %}

For example usage is:

{% gist page.gist "04c-subquery-pairwaise-basic.sql" %}

Jika dijalankan hasilnya seperti berikut:

```shell
hr=# select employee_id, first_name, salary, commission_pct
hr-# from employees
hr-# where salary >= (
hr(#     select min(max_salary)
hr(#     from jobs
hr(#     where job_id = 'IT_PROG'
hr(# )
hr-# limit 10;
 employee_id | first_name |  salary  | commission_pct
-------------+------------+----------+----------------
         100 | Steven     | 24000.00 |
         101 | Neena      | 17000.00 |
         102 | Lex        | 17000.00 |
         108 | Nancy      | 12000.00 |
         114 | Den        | 11000.00 |
         145 | John       | 14000.00 |           0.40
         146 | Karen      | 13500.00 |           0.30
         147 | Alberto    | 12000.00 |           0.30
         148 | Gerald     | 11000.00 |           0.30
         149 | Eleni      | 10500.00 |           0.20
(10 rows)
```

Selain itu juga kita bisa gunakan correlate SubQuery pada `WHERE` clause seperti berikut:

{% gist page.gist "04c-subquery-pairwise-correlate.sql" %}

Jika di jalankan hasilnya seperti berikut:

```shell
hr=# select employee_id, first_name, salary, commission_pct, job_id
hr-# from employees emp
hr-# where emp.salary = (
hr(#     select avg(min_salary)
hr(#     from jobs job
hr(#     where emp.job_id = job.job_id
hr(# );
 employee_id | first_name | salary  | commission_pct |  job_id
-------------+------------+---------+----------------+----------
         119 | Karen      | 2500.00 |                | PU_CLERK
         182 | Martha     | 2500.00 |                | SH_CLERK
         191 | Randall    | 2500.00 |                | SH_CLERK
(3 rows)
```

Kemudian, untuk operator yang kita bisa gunakan dalam SubQuery as Predicate terdiri dari behavior suatu subquery resultset (Single / Multiple Rows). Diantaranya

1. Using Single-Row Comparison
2. Using `IN` predicate to handle multiple values
3. Using `EXIST` operator
4. Using `ANY` & `SOME` predicate to handle multiple values
5. Using `ALL` predicate to handler multiple values

Ok sekarang kita bahas satu-per-satu ya function tersebut.

## Using SubQuery for Single-Row Comparison

