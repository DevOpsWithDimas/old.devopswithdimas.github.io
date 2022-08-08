---
layout: post
title: "WITH Queries (Common Table Expressions)"
lang: postgresql
authors:
- dimasm93
categories:
- RDBMS
- PostgreSQL
- sql
- select
refs: 
- https://www.postgresql.org/docs/14/queries-with.html
youtube: 
image_path: /resources/posts/postgresql/03l-with-queries
comments: true
gist: dimMaryanto93/7ae7632f9418feb724bc431eff412a3f
catalog_key: select-statement
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang Common Table Expression yaitu menggunakan `WITH` Queries pada PostgreSQL. Karena pembahasan kali ini akan lumayan panjang jadi kita akan bagi-bagi menjadi beberapa bagian diataranya:

1. Select in WITH
2. More details using Select in WITH
3. Recursive Queries
4. Search order
5. Cycle Detection
6. Common Table Expression Materialization

Ok langsung aja kita bahas materi yang pertama

<!--more-->

## Select in WITH

The `WITH` query provides a way to write auxiliary statements for use in a larger query. It helps in breaking down complicated and large queries into simpler forms, which are easily readable. These statements often referred to as Common Table Expressions or CTEs, can be thought of as defining temporary tables that exist just for one query.

The `WITH` query being CTE query, is particularly useful when subquery is executed multiple times. It is equally helpful in place of temporary tables. It computes the aggregation once and allows us to reference it by its name (may be multiple times) in the queries.

The basic syntax of `WITH` Query is 

{% highlight sql %}
WITH <named_query> as (
    select ...
    from ...
    [where ...]
)
select ...
from ... | <named_query>
[where ... | <named_query>]
{% endhighlight %}

Where `<named_query>` equal to temporary table with given named. The `<named_query>` can be the same as existing table name and will take precedence. You can use data-modifying statements (`INSERT`, `UPDATE` or `DELETE`) in WITH. This allows you to perform several different operations in the same query.

Berikut adalah contoh implementasi querynya:

{% gist page.gist "04f-simple-with-query.sql" %}

Jika dijalankan hasilnya seperti berikut:

```sql
hr=# with get_emp_in_dep_hundred as (
hr(#     select *
hr(#     from employees
hr(#     where department_id = 100
hr(# )
hr-# select employee_id, first_name, salary, commission_pct
hr-# from get_emp_in_dep_hundred
hr-# limit 5;

 employee_id | first_name  |  salary  | commission_pct 
-------------+-------------+----------+----------------
         108 | Nancy       | 12000.00 |               
         109 | Daniel      |  9000.00 |               
         110 | John        |  8200.00 |               
         111 | Ismael      |  7700.00 |               
         112 | Jose Manuel |  7800.00 |               
(5 rows)
```

## More details using Select in WITH

Sepertinya telah saya jelaskan di section sebelumnya, The `WITH` Query pada dasarnya digunakan untuk mem-breakdown complicated queries menjadi lebih simple. berikut contohnya:

{% gist page.gist "04f-complex-with-query.sql" %}

which displays top 10 employees salary and filter by department location in `US` or `UK`. jika dijalankan hasilnya seperti berikut:

```sql
hr=# with top10_salaries as
hr-#          (
hr(#              select employee_id, first_name, salary, department_id
hr(#              from employees
hr(#              where salary >= 10000
hr(#              order by salary desc
hr(#              limit 10),
hr-#      department_uk_us as
hr-#          (
hr(#              select distinct department_id as dep_id
hr(#              from departments
hr(#                       natural join locations
hr(#              where country_id in ('UK', 'US')
hr(#          )
hr-# select *
hr-# from top10_salaries
hr-# where department_id in (select dep_id from department_uk_us);

 employee_id | first_name |  salary  | department_id 
-------------+------------+----------+---------------
         100 | Steven     | 24000.00 |            90
         102 | Lex        | 17000.00 |            90
         101 | Neena      | 17000.00 |            90
         145 | John       | 14000.00 |            80
         146 | Karen      | 13500.00 |            80
         205 | Shelley    | 12000.00 |           110
         108 | Nancy      | 12000.00 |           100
         147 | Alberto    | 12000.00 |            80
         168 | Lisa       | 11500.00 |            80
(9 rows)
```

Selain itu juga kita bisa membuat two auxiliary statements named `employees_in_dep_90` and `top3_salaries` dimana the output of `employees_in_dep_90` digunakan pada `top3_salaries`. seperti berikut querynya:

{% gist page.gist "04f-auxiliary-with-query.sql" %}

Jika dijalankan hasilnya seperti berikut:

```sql
hr=# with employees_in_dep_90 as
hr-#          (
hr(#              select *
hr(#              from employees
hr(#              where department_id in (90, 100, 110)
hr(#          ),
hr-#      top3_salaries as
hr-#          (
hr(#              select employee_id, first_name, salary
hr(#              from employees_in_dep_90
hr(#              order by salary desc
hr(#              limit 3
hr(#          )
hr-# select *
hr-# from top3_salaries;
 employee_id | first_name |  salary  
-------------+------------+----------
         100 | Steven     | 24000.00
         102 | Lex        | 17000.00
         101 | Neena      | 17000.00
(3 rows)
```

Nah bagaimana? lebih mudah untuk di baca khan dibandingkan kita membuat dengan nested SUB-QUERY.

## Recursive Queries

The optional `RECURSIVE` modifier changes `WITH` from a mere syntactic convenience into a feature that accomplishes things not otherwise possible in standard SQL. Using `RECURSIVE`, a `WITH` query can refer to its own output. A very simple example is this query to sum the integers from `1` through `100`:

{% highlight sql %}
WITH RECURSIVE t(n) AS (
    VALUES (1)
  UNION ALL
    SELECT n+1 FROM t WHERE n < 100
)
SELECT sum(n) FROM t;
{% endhighlight %}

The general form of a recursive WITH query is always a non-recursive term, then UNION (or UNION ALL), then a recursive term, where only the recursive term can contain a reference to the query's own output. Such a query is executed as follows:

1. Evaluate the non-recursive term. For UNION (but not UNION ALL), discard duplicate rows. Include all remaining rows in the result of the recursive query, and also place them in a temporary working table.

2. So long as the working table is not empty, repeat these steps:
    1. Evaluate the recursive term, substituting the current contents of the working table for the recursive self-reference. For UNION (but not UNION ALL), discard duplicate rows and rows that duplicate any previous result row. Include all remaining rows in the result of the recursive query, and also place them in a temporary intermediate table.
    2. Replace the contents of the working table with the contents of the intermediate table, then empty the intermediate table.

Recursive queries are typically used to deal with hierarchical or tree-structured data. A usefull example is this query to find all the direct and indirect sub-employees of a manager, given only a table that show immediate includes:

{% gist page.gist "04f-with-query-recursive.sql" %}

Jika dijalankan hasilnya seperti berikut:

```sql
hr=# with recursive managed_by(manager_id, employee_id, first_name) as
hr-#      (
hr(#          select our_manager.manager_id,
hr(#                 our_manager.employee_id,
hr(#                 our_manager.first_name
hr(#          from employees our_manager
hr(#          where employee_id = 101
hr(#          UNION ALL
hr(#          select emp.manager_id,
hr(#                 emp.employee_id,
hr(#                 emp.first_name
hr(#          from employees emp
hr(#                   join managed_by man on (emp.manager_id = man.employee_id)
hr(#      )
hr-# select employee_id,
hr-#        first_name,
hr-#        manager_id
hr-# from managed_by;

 employee_id | first_name  | manager_id 
-------------+-------------+------------
         101 | Neena       |        100
         108 | Nancy       |        101
         200 | Jennifer    |        101
         203 | Susan       |        101
         204 | Hermann     |        101
         205 | Shelley     |        101
         109 | Daniel      |        108
         110 | John        |        108
         111 | Ismael      |        108
         112 | Jose Manuel |        108
         113 | Luis        |        108
         206 | William     |        205
(12 rows)
```

## Search order

When computing a tree traversal using a recursive query, you might want to order the results in either depth-first or breadth-first order. This can be done by computing an ordering column alongside the other data columns and using that to sort the results at the end. Note that this does not actually control in which order the query evaluation visits the rows; that is as always in SQL implementation-dependent. This approach merely provides a convenient way to order the results afterwards.

To create a depth-first order, we compute for each result row an array of rows that we have visited so far. For example, consider the following query that searches a table tree using a `link` field:

{% highlight sql %}
WITH RECURSIVE search_tree(... , path) AS (
    SELECT ... , ARRAY[t.column]
    FROM tree t
  UNION ALL
    SELECT ... , path || t.column
    FROM tree t, search_tree st
    WHERE t.id = st.link
)
SELECT * FROM search_tree ORDER BY path;
{% endhighlight %}

Here the code:

{% gist page.gist "04f-with-query-sortable.sql" %}

Jika dijalankan hasilnya seperti berikut:

```sql
hr=# with recursive managed_by(manager_id, employee_id, first_name, path) as
hr-#      (
hr(#          select our_manager.manager_id,
hr(#                 our_manager.employee_id,
hr(#                 our_manager.first_name,
hr(#                 array [our_manager.first_name]
hr(#          from employees our_manager
hr(#          where employee_id = 101
hr(#          UNION ALL
hr(#          select emp.manager_id,
hr(#                 emp.employee_id,
hr(#                 emp.first_name,
hr(#                 array [emp.first_name]
hr(#          from employees emp
hr(#                   join managed_by man on (emp.manager_id = man.employee_id)
hr(#      )
hr-# select employee_id, first_name, manager_id
hr-# from managed_by
hr-# order by path desc;
 employee_id | first_name  | manager_id 
-------------+-------------+------------
         206 | William     |        205
         203 | Susan       |        101
         205 | Shelley     |        101
         101 | Neena       |        100
         108 | Nancy       |        101
         113 | Luis        |        108
         112 | Jose Manuel |        108
         110 | John        |        108
         200 | Jennifer    |        101
         111 | Ismael      |        108
         204 | Hermann     |        101
         109 | Daniel      |        108
(12 rows)
```

Atau selain itu juga kita bisa multiple column order dengan with query recursive seperti berikut:

{% gist page.gist "04f-with-query-sortable-multi-columns.sql" %}

Jika dijalankan hasilnya seperti berikut:

```sql
hr=# with recursive managed_by(manager_id, employee_id, first_name, salary, department_id, path) as
hr-#      (
hr(#          select our_manager.manager_id,
hr(#                 our_manager.employee_id,
hr(#                 our_manager.first_name,
hr(#                 our_manager.salary,
hr(#                 our_manager.department_id,
hr(#                 array [ROW (our_manager.department_id, our_manager.salary)]
hr(#          from employees our_manager
hr(#          where employee_id = 101
hr(#          UNION ALL
hr(#          select emp.manager_id,
hr(#                 emp.employee_id,
hr(#                 emp.first_name,
hr(#                 emp.salary,
hr(#                 emp.department_id,
hr(#                 array [ROW (emp.department_id, emp.salary)]
hr(#          from employees emp
hr(#                   join managed_by man on (emp.manager_id = man.employee_id)
hr(#      )
hr-# select employee_id, first_name, manager_id, department_id, salary
hr-# from managed_by
hr-# order by path desc;
 employee_id | first_name  | manager_id | department_id |  salary  
-------------+-------------+------------+---------------+----------
         205 | Shelley     |        101 |           110 | 12000.00
         206 | William     |        205 |           110 |  8300.00
         108 | Nancy       |        101 |           100 | 12000.00
         109 | Daniel      |        108 |           100 |  9000.00
         110 | John        |        108 |           100 |  8200.00
         112 | Jose Manuel |        108 |           100 |  7800.00
         111 | Ismael      |        108 |           100 |  7700.00
         113 | Luis        |        108 |           100 |  6900.00
         101 | Neena       |        100 |            90 | 17000.00
         204 | Hermann     |        101 |            70 | 10000.00
         203 | Susan       |        101 |            40 |  6500.00
         200 | Jennifer    |        101 |            10 |  4400.00
(12 rows)
```
