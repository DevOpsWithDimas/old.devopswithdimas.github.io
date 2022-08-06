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

