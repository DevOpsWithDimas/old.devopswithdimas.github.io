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
2. Using SubQuery inline view
3. Hander SubQuery from where clause
4. Correlate SubQuery
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