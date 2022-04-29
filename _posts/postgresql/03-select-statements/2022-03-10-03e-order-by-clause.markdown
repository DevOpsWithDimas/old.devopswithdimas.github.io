---
layout: post
title: "Sorting rows using ORDER BY clause"
date: 2022-03-10T04:37:48+07:00
lang: postgresql
authors:
- dimasm93
categories:
- RDBMS
- PostgreSQL
- sql
- select
refs: 
- https://www.postgresql.org/docs/14/queries-order.html
youtube: 
image_path: /resources/posts/postgresql/03e-order-by-clause
comments: true
gist: dimMaryanto93/7ae7632f9418feb724bc431eff412a3f
catalog_key: select-statement
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang Sorting rows menggunakan `ORDER BY` clause. Adapun materinya kita akan bagi menjadi 

1. Basic usage of `ORDER BY` clause
2. The sort expression
3. Using multiple columns to sort
4. Choose Null value show at first or last?

Ok langsung aja kita bahas materi yang pertama

<!--more-->

## Basic usage of ORDER BY clause

After a query has produced an output table (after the select list has been processed) it can optionally be sorted. If sorting is not chosen, the rows will be returned in an unspecified order. The actual order in that case will depend on the scan and join plan types and the order on disk, but it must not be relied on. A particular output ordering can only be guaranteed if the sort step is explicitly chosen.

The `ORDER BY` clause specifies the sort order:

{% highlight sql %}
SELECT select_list
FROM table_expression
ORDER BY sort_expression [ASC | DESC]
{% endhighlight %}

The sort expression can be any expression that would be valid in the query's select list. The expression can be followed by an optional `ASC` or `DESC` keyword to set the sort direction to ascending or descending. `ASC` order is the default. Ascending order puts smaller values first, where “smaller” is defined in terms of the `< operator`. Similarly, descending order is determined with the `> operator`. An example is:

{% highlight sql %}
SELECT a, b as x FROM table1 ORDER BY a;
{% endhighlight %}

Contoh penggunaannya seperti berikut:

{% gist page.gist "03e-select-order-by-a-column.sql" %}

Contoh lainnya seperti berikut:

{% gist page.gist "03e-select-order-by-a-column-desc.sql" %}

Jika dijalankan maka hasilnya seperti berikut:

```shell
hr=# select location_id, department_id, department_name
hr-# from departments
hr-# order by location_id;
 location_id | department_id |   department_name
-------------+---------------+----------------------
        1400 |            60 | IT
        1500 |            50 | Shipping
        1700 |            30 | Purchasing
        1700 |           270 | Payroll
        1700 |            10 | Administration
        1700 |           230 | IT Helpdesk
        1800 |            20 | Marketing
        2400 |            40 | Human Resources
        2500 |            80 | Sales
        2700 |            70 | Public Relations
(28 rows)
```

## The sort expression

A sort_expression can also be the column label or number of an output column, as in:

{% highlight sql %}
SELECT a, b, a + b as x FROM table1 ORDER BY x;
SELECT a, b, a + b as x FROM table1 ORDER BY 1;
{% endhighlight %}

Note that an output column name has to stand alone, that is, it cannot be used in an expression — for example, this is not correct:

{% highlight sql %}
SELECT a, b, a + b as x FROM table1 ORDER BY x + b;
{% endhighlight %}

This restriction is made to reduce ambiguity. There is still ambiguity if an ORDER BY item is a simple name that could match either an output column name or a column from the table expression.

`ORDER BY` can be applied to the result of a `UNION`, `INTERSECT`, or `EXCEPT` combination, but in this case it is only permitted to sort by output column names or numbers, not by expressions.

Contoh penggunaannya seperti berikut:

{% gist page.gist "03e-select-order-by-column-number.sql" %}

Jika dijalankan maka hasilnya seperti berikut:

```shell
hr=# select location_id, department_id, department_name
hr-# from departments
hr-# order by 2;
 location_id | department_id |   department_name
-------------+---------------+----------------------
        1700 |            10 | Administration
        1800 |            20 | Marketing
        1700 |            30 | Purchasing
        2400 |            40 | Human Resources
        1500 |            50 | Shipping
        1400 |            60 | IT
        2700 |            70 | Public Relations
        2500 |            80 | Sales
        1700 |            90 | Executive
        1700 |           100 | Finance
        1700 |           260 | Recruiting
        1700 |           270 | Payroll
        1700 |           300 | System Analis
(28 rows)
```

## Using multiple columns to sort

`ORDER BY` clause can be more than one expression the later values are used to sort rows that are equal according to the earlier values.

{% highlight sql %}
SELECT select_list
FROM table_expression
ORDER BY    
    sort_expression1 [ASC | DESC]
    [, sort_expression2 [ASC | DESC] ...]
{% endhighlight %}

Note that the ordering options are considered independently for each sort column. For example `ORDER BY x, y DESC` means `ORDER BY x ASC, y DESC`, which is not the same as `ORDER BY x DESC, y DESC`.

Contoh penggunaannya seperti berikut:

{% gist page.gist "03e-select-order-by-columns.sql" %}

Jika dijalankan maka hasilnya seperti berikut:

```shell
hr=# select location_id, department_id, department_name
hr-# from departments
hr-# order by 
    location_id asc, 
    department_id desc;
 location_id | department_id |   department_name
-------------+---------------+----------------------
        1400 |            60 | IT
        1500 |            50 | Shipping
        1700 |           170 | Manufacturing
        1700 |           160 | Benefits
        1700 |           150 | Shareholder Services
        1700 |           140 | Control And Credit
        1700 |           130 | Corporate Tax
        1700 |           120 | Treasury
        1700 |           110 | Accounting
        1700 |           100 | Finance
        1700 |            90 | Executive
        1700 |            30 | Purchasing
        1700 |            10 | Administration
        1800 |            20 | Marketing
        2400 |            40 | Human Resources
        2500 |            80 | Sales
(28 rows)
```

## Choose Null value show at first or last?

The `NULLS FIRST` and `NULLS LAST` options can be used to determine whether nulls appear before or after non-null values in the sort ordering. By default, `null` values sort as if larger than any non-null value; that is, `NULLS FIRST` is the default for DESC order, and `NULLS LAST` otherwise.

{% highlight sql %}
SELECT select_list
FROM table_expression
ORDER BY    
    sort_expression1 [ASC | DESC] [NULLS { FIRST | LAST }]
    [, sort_expression2 [ASC | DESC] [NULLS { FIRST | LAST }] ...]
{% endhighlight %}

Contoh penggunaannya seperti berikut:

{% gist page.gist "03e-select-order-by-with-null.sql" %}

Jika dijalankan maka hasilnya seperti berikut:

```shell
hr=# select employee_id, first_name, salary, commission_pct
hr-# from employees
hr-# order by
hr-#   salary desc,
hr-#   commission_pct asc nulls first;
 employee_id | first_name  |  salary  | commission_pct
-------------+-------------+----------+----------------
         100 | Steven      | 24000.00 |
         102 | Lex         | 17000.00 |
         101 | Neena       | 17000.00 |
         145 | John        | 14000.00 |           0.40
         146 | Karen       | 13500.00 |           0.30
         201 | Michael     | 13000.00 |
         205 | Shelley     | 12000.00 |
         108 | Nancy       | 12000.00 |
         147 | Alberto     | 12000.00 |           0.30
         168 | Lisa        | 11500.00 |           0.25
         114 | Den         | 11000.00 |
         174 | Ellen       | 11000.00 |           0.30
         148 | Gerald      | 11000.00 |           0.30
(107 rows)
```