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
5. Pairwise SubQuery
    1. Using `IN` predicate to handle multiple values
    2. Using `ANY` & `SOME` predicate to handle multiple values
    3. Using `ALL` predicate to handler multiple values
    4. Using `EXIST` operator
6. Lateral Subqueries

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

```powershell
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
                    (SELECT column1, column2
                     FROM table2 inner
                     WHERE inner.column1 = 
                               outer.column1);
{% endhighlight %}

For example 

{% gist page.gist "04c-subquery-simple-correlate.sql" %}

Jika kita jalankan maka hasilnya seperti berikut:

```powershell
hr=# select emp.employee_id,
hr-#        emp.first_name                           employee_name,
hr-#        (select man.first_name
hr(#         from employees man
hr(#         where emp.manager_id = man.employee_id) manager_name
hr-# from employees emp
hr-# limit 10;
 employee_id | employee_name | manager_name
-------------+---------------+--------------
         100 | Steven        |
         101 | Neena         | Steven
         102 | Lex           | Steven
         103 | Alexander     | Lex
         104 | Bruce         | Alexander
         105 | David         | Alexander
         106 | Valli         | Alexander
         107 | Diana         | Alexander
         108 | Nancy         | Neena
         109 | Daniel        | Nancy
(10 rows)
```

Jika temen-temen perhatikan pada subquery dengan where clause `emp.manager_id = man.employee_id` kita menggunakan column `manager_id` pada outer query.

## Using SubQuery inline view

The subquery specified in the `FROM` clause of a query is called an inline view. Because an inline view can replace a table in a query, it is also called a derived table. Sometimes, you may hear the term subselect, which is the same meaning as the inline view.

An inline view is not a real view but a subquery in the `FROM` clause of a `SELECT` statement.