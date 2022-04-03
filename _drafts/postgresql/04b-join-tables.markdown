---
layout: post
title: "Joined Tables"
lang: postgresql
authors:
- dimasm93
categories:
- RDBMS
- PostgreSQL
- sql
- select
refs: 
- https://www.postgresql.org/docs/14/queries-table-expressions.html#joined_tables
youtube: 
image_path: /resources/posts/postgresql/03h-join-tables
comments: true
gist: dimMaryanto93/7ae7632f9418feb724bc431eff412a3f
catalog_key: select-statement
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas Join Tables di PostgreSQL, Seperti biasa materinya karena akan lumayan panjang jadi kita bagi menjadi beberapa section ya diantaranya:

1. What is join tables?
2. Natural Join
3. Cross join
4. Qualified join
    1. Inner Joins
    2. Left or Right Outer Joins
    3. Full Outer Joins
    4. Self Joins
5. `join_condition` using `ON` and `WHERE` clause

Ok langsung aja yuk kita bahas materi yang pertama:

<!--more-->

## What is join tables?

A joined table is a table derived from two other (real or derived) tables according to the rules of the particular join type. Inner, outer, and cross-joins are available.

The general syntax of a joined table is

{% highlight sql %}
SELECT select_list_expression
FROM T1 join_type T2 [ join_condition ]
{% endhighlight %}

Joins of all types can be chained together, or nested: either or both `T1` and `T2` can be joined tables. 

{% mermaid %}
erDiagram
    jobs ||--o| employees : job_id
    jobs {
        int     job_id          PK  "identifier of jobs"
        string  job_title           "Job Name"
    }
    locations ||--o| employees : location_id
    locations {
        int     location_id     PK  "indentifier of location"
        string  street_address  
        string  city
        string  state
    }
    employees
    employees {
        int         employee_id     PK "identifier of employees"
        string      first_name
        string      last_name
        int         job_id          FK "assigned to job"
        int         location_id     FK "employee residence address"
    }
{% endmermaid %}

For example if you have table design look like above, join query:

{% highlight sql %}
SELECT * 
FROM employees natural join jobs;
{% endhighlight %}

## Natural Join

A natural join is a join that creates an implicit join based on the same column names in the joined tables.

The general syntax of a natural joined table is

{% highlight sql %}
SELECT select_list_expression
FROM T1 NATURAL [INNER, LEFT, RIGHT] T2;
{% endhighlight %}

Join statement can be more than once, and Parentheses can be used around `JOIN` clauses to control the join order. In the absence of parentheses, `JOIN` clauses nest left-to-right.

{% gist page.gist "04b-basic-join-tables.sql" %}

Jika dijalankan maka hasilnya seperti berikut:

```postgresql-console
hr=# SELECT emp.job_id, job.job_title, emp.employee_id, emp.first_name, loc.street_address
hr-# FROM employees emp
hr-#         natural join jobs job
hr-#         natural join locations loc
hr-# limit 10;
   job_id   |           job_title           | employee_id | first_name |    street_address
------------+-------------------------------+-------------+------------+----------------------
 AD_PRES    | President                     |         100 | Steven     | 1297 Via Cola di Rie
 AD_VP      | Administration Vice President |         101 | Neena      | 1297 Via Cola di Rie
 AD_VP      | Administration Vice President |         102 | Lex        | 1297 Via Cola di Rie
 IT_PROG    | Programmer                    |         103 | Alexander  | 1297 Via Cola di Rie
 IT_PROG    | Programmer                    |         104 | Bruce      | 1297 Via Cola di Rie
 IT_PROG    | Programmer                    |         105 | David      | 1297 Via Cola di Rie
 IT_PROG    | Programmer                    |         106 | Valli      | 1297 Via Cola di Rie
 IT_PROG    | Programmer                    |         107 | Diana      | 1297 Via Cola di Rie
 FI_MGR     | Finance Manager               |         108 | Nancy      | 1297 Via Cola di Rie
 FI_ACCOUNT | Accountant                    |         109 | Daniel     | 1297 Via Cola di Rie
(10 rows)
```

If you use the asterisk (`*`) in the `select_list`, the result will contain the following columns:

1. All the common columns, which are the columns from both tables that have the same name.
2. Every column from both tables, which is not a common column.

However, you should avoid using the **NATURAL JOIN** whenever possible because sometimes it may cause an unexpected result.

For example, See the following `customers` and `transactions` tables from the sample database:

{% mermaid %}
erDiagram
    customers ||--o| transactions : cust_id
    customers {
        int         cust_id          PK
        string      cust_name
        datetime    last_updated
    }
    transactions
    transactions {
        int         pay_id          PK
        string      cust_id         FK
        datetime    last_updated
    }
{% endmermaid %}

Both tables have the same `cust_id` column so you can use the NATURAL JOIN to join these tables as follows:

{% highlight sql %}
SELECT *
FROM customers NATURAL JOIN transactions;
{% endhighlight %}

But both tables also have another common column called `last_update`, which cannot be used for the join (ambiguous).

## Cross join

Cross join is For every possible combination of rows from `T1` and `T2` (i.e., a Cartesian product), the joined table will contain a row consisting of all columns in `T1` followed by all columns in `T2`. If the tables have `N` and `M` rows respectively, the joined table will have `N * M` rows.

`FROM T1 CROSS JOIN T2` is equivalent to `FROM T1 INNER JOIN T2 ON TRUE`

For example:

{% gist page.gist "04b-cross-join.sql" %}

Jika di jalankan maka hasilnya seperti berikut:

```postgresql-console
hr=# select count(*) from departments;
 count
-------
    28
(1 row)

hr=# select count(*) from jobs;
 count
-------
    19
(1 row)

hr=# SELECT dep.department_id, dep.department_name, job.job_id, job.job_title
hr-# FROM departments dep
hr-#      CROSS JOIN jobs job;
 department_id |   department_name    |   job_id   |            job_title
---------------+----------------------+------------+---------------------------------
           300 | System Analis        | AD_PRES    | President
           300 | System Analis        | AD_VP      | Administration Vice President
           300 | System Analis        | AD_ASST    | Administration Assistant
           300 | System Analis        | FI_MGR     | Finance Manager
           300 | System Analis        | FI_ACCOUNT | Accountant
           300 | System Analis        | IT_PROG    | Programmer
           300 | System Analis        | MK_MAN     | Marketing Manager
           300 | System Analis        | MK_REP     | Marketing Representative
           300 | System Analis        | HR_REP     | Human Resources Representative
           300 | System Analis        | PR_REP     | Public Relations Representative
            10 | Administration       | AD_PRES    | President
            10 | Administration       | AD_VP      | Administration Vice President
            10 | Administration       | AD_ASST    | Administration Assistant
            10 | Administration       | FI_MGR     | Finance Manager
            10 | Administration       | FI_ACCOUNT | Accountant
            10 | Administration       | AC_MGR     | Accounting Manager
            10 | Administration       | AC_ACCOUNT | Public Accountant
            10 | Administration       | SA_MAN     | Sales Manager
(532 rows)

hr=# select count(*) from departments cross join jobs;
 count
-------
   532
(1 row)
```

## Qualified Join

Qualified Join ini adalah sesuai artinya ya join yang memiliki criteria atau condition (`join_condition`). 

Basicly the `join_condition` is specified in the `ON` or `USING` clause, or implicitly by the word `NATURAL`. The join condition determines which rows from the two source tables are considered to “match”, as explained in detail below.

Qualified join terdiri dari

1. `INNER JOIN`. For each row `R1` of `T1`, the joined table has a row for each row in `T2` that satisfies the join condition with `R1`.
2. `LEFT OUTER JOIN`. First, an inner join is performed. Then, for each row in `T1` that does not satisfy the join condition with any row in `T2`, a joined row is added with `null` values in columns of `T2`. Thus, the joined table always has at least one row for each row in `T1`.
3. `RIGHT OUTER JOIN`. First, an inner join is performed. Then, for each row in `T2` that does not satisfy the join condition with any row in `T1`, a joined row is added with `null` values in columns of `T1`. This is the converse of a left join: the result table will always have a row for each row in `T2`.
4. `FULL OUTER JOIN`. First, an inner join is performed. Then, for each row in `T1` that does not satisfy the join condition with any row in `T2`, a joined row is added with `null` values in columns of `T2`. Also, for each row of `T2` that does not satisfy the join condition with any row in `T1`, a joined row with null values in the columns of `T1` is added.

The general syntax of a qualifier join table is

{% highlight sql %}
T1 { [INNER] | { LEFT | RIGHT | FULL } [OUTER] } JOIN T2 ON boolean_expression
T1 { [INNER] | { LEFT | RIGHT | FULL } [OUTER] } JOIN T2 USING ( join column list )
T1 NATURAL { [INNER] | { LEFT | RIGHT | FULL } [OUTER] } JOIN T2
{% endhighlight %}

## Qualified using `INNER JOIN`