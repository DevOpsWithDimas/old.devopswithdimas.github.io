---
layout: post
title: "Joined Tables"
date: 2022-04-03T20:18:30+07:00
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
image_path: /resources/posts/postgresql/04b-join-tables
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
5. `join_condition` expressions

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

Qualified Join ini adalah sesuai artinya join yang memiliki criteria atau condition (`join_condition`) tertentu. 

Basicly the `join_condition` is specified in the `ON` or `USING` or `WHERE` clause, or implicitly by the word `NATURAL`. The join condition determines which rows from the two source tables are considered to “match”, as explained in detail below.

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

Inner Join adalah Join table yang paling commons di gunakan untuk menggabungkan antara ke 2 tabel atau lebih. Secara konsep matematika `INNER JOIN` akan menggunakan condition yang jika T1 dan T2 bernilai sama seperti ilustrasi berikut:

![inner-join]({{ page.image_path | prepend: site.baseurl }}/01-inner-join.png)

Contohnya saya punya perancangan table seperti berikut 

{% mermaid %}
erDiagram
    jobs ||--o| employees : job_id
    jobs {
        int     job_id          PK  "identifier of jobs"
        string  job_title           "Job Name"
    }
    employees
    employees {
        int         employee_id     PK "identifier of employees"
        string      first_name
        string      last_name
        int         job_id          FK "assigned to job"
    }
{% endmermaid %}

Maka querynya seperti berikut:

{% gist page.gist "04b-join.sql" %}

Atau jiga kita bisa menggunakan lebih specify yaitu `INNER JOIN` seperti berikut:

{% gist page.gist "04b-inner-join.sql" %}

Jika dijalankan maka hasilnya seperti berikut:

```postgresql-console
hr=# SELECT emp.employee_id, emp.last_name, job.job_id, job.job_title
hr-# FROM employees emp
hr-#       inner join jobs job on (emp.job_id = job.job_id)
hr-# LIMIT 10;
 employee_id | last_name |   job_id   |           job_title
-------------+-----------+------------+-------------------------------
         100 | King      | AD_PRES    | President
         101 | Kochhar   | AD_VP      | Administration Vice President
         102 | De Haan   | AD_VP      | Administration Vice President
         103 | Hunold    | IT_PROG    | Programmer
         104 | Ernst     | IT_PROG    | Programmer
         105 | Austin    | IT_PROG    | Programmer
         106 | Pataballa | IT_PROG    | Programmer
         107 | Lorentz   | IT_PROG    | Programmer
         108 | Greenberg | FI_MGR     | Finance Manager
         109 | Faviet    | FI_ACCOUNT | Accountant
(10 rows)
```

## Qualified using Left or Right `OUTER JOIN`

Selain `INNER JOIN` terdapat `OUTER JOIN`. `OUTER JOIN` terdiri dari 2 kombinasi yaitu 

1. `LEFT OUTER JOIN` 
2. `RIGHT OUTER JOIN`

Secara konsep matematika `OUTER JOIN` jika kita ilustrasi dengan diagram venn seperti berikut:

![outer-join]({{ page.image_path | prepend: site.baseurl }}/02-outer-join.png)

Jadi position dari table pada saat join query menentukan datanya akan di tampilkan atau tidak. Misalnya disini saya punya design tabel seperti berikut:

{% mermaid %}
erDiagram
    departments 
    departments {
        int     department_id   PK  "identifier of jobs"
        string  department_name
        int     manager_id      FK  "reff to employee"
    }
    employees ||--o| departments : manager_id
    employees {
        int         employee_id     PK "identifier of employees"
        string      first_name
        string      last_name
    }
{% endmermaid %}

Berikut adalah contoh implementasi `LEFT OUTER JOIN` 

{% gist page.gist "04b-left-outer-join.sql" %}

Jika di jalankan maka hasilnya seperti berikut:

```postgresql-console
hr=# SELECT dep.department_id, dep.department_name, emp.employee_id, emp.last_name
hr-# FROM departments dep
hr-#       LEFT OUTER JOIN employees emp on dep.manager_id = emp.employee_id;
 department_id |   department_name    | employee_id | last_name
---------------+----------------------+-------------+-----------
           300 | System Analis        |             |
            10 | Administration       |         200 | Whalen
            20 | Marketing            |         201 | Hartstein
            30 | Purchasing           |         114 | Raphaely
            40 | Human Resources      |         203 | Mavris
            50 | Shipping             |         121 | Fripp
            60 | IT                   |         103 | Hunold
            70 | Public Relations     |         204 | Baer
            80 | Sales                |         145 | Russell
            90 | Executive            |         100 | King
           100 | Finance              |         108 | Greenberg
           110 | Accounting           |         205 | Higgins
           120 | Treasury             |             |
           130 | Corporate Tax        |             |
           140 | Control And Credit   |             |
           150 | Shareholder Services |             |
           250 | Retail Sales         |             |
           260 | Recruiting           |             |
           270 | Payroll              |             |
(28 rows)
```

Sedangkan berikut adalah implementasi `RIGHT OUTER JOIN` dengan query yang sama seperti berikut:

{% gist page.gist "04b-right-outer-join.sql" %}

Jika dijalankan maka hasilnya seperti berikut:

```postgresql-console
hr=# SELECT dep.department_id, dep.department_name, emp.employee_id, emp.last_name
hr-# FROM departments dep
hr-#       RIGHT OUTER JOIN employees emp on dep.manager_id = emp.employee_id;
 department_id | department_name  | employee_id |  last_name
---------------+------------------+-------------+-------------
            10 | Administration   |         200 | Whalen
            20 | Marketing        |         201 | Hartstein
            30 | Purchasing       |         114 | Raphaely
            40 | Human Resources  |         203 | Mavris
            50 | Shipping         |         121 | Fripp
            60 | IT               |         103 | Hunold
            70 | Public Relations |         204 | Baer
            80 | Sales            |         145 | Russell
            90 | Executive        |         100 | King
           100 | Finance          |         108 | Greenberg
           110 | Accounting       |         205 | Higgins
               |                  |         106 | Pataballa
               |                  |         120 | Weiss
               |                  |         151 | Bernstein
               |                  |         119 | Colmenares
               |                  |         101 | Kochhar
               |                  |         137 | Ladwig
               |                  |         118 | Himuro
               |                  |         130 | Atkinson
               |                  |         144 | Vargas
(107 rows)
```

## Qualified using `FULL OUTER JOIN`

Pada `OUTER JOIN` juga terdapat `FULL OUTER JOIN` yang secara arti akan mengambil data secara keseluruhan. Secara konsep matematika `FULL OUTER JOIN` jika kita ilustrasi dengan diagram venn seperti berikut:

![full-outer-join]({{ page.image_path | prepend: site.baseurl }}/03-full-outer-join.png)

Maka imlementasi query seperti berikut:

{% gist page.gist "04b-full-outer-join.sql" %}

Jika di jalankan maka hasilnya seperti berikut:

```postgresql-console
hr=# SELECT dep.department_id, dep.department_name, emp.employee_id, emp.last_name
hr-# FROM departments dep
hr-#       FULL OUTER JOIN employees emp on dep.manager_id = emp.employee_id;
 department_id |   department_name    | employee_id |  last_name
---------------+----------------------+-------------+-------------
           300 | System Analis        |             |
            10 | Administration       |         200 | Whalen
            20 | Marketing            |         201 | Hartstein
            80 | Sales                |         145 | Russell
            90 | Executive            |         100 | King
           100 | Finance              |         108 | Greenberg
           110 | Accounting           |         205 | Higgins
           120 | Treasury             |             |
           130 | Corporate Tax        |             |
           140 | Control And Credit   |             |
           220 | NOC                  |             |
           230 | IT Helpdesk          |             |
           240 | Government Sales     |             |
           250 | Retail Sales         |             |
           260 | Recruiting           |             |
           270 | Payroll              |             |
               |                      |         106 | Pataballa
               |                      |         120 | Weiss
               |                      |         151 | Bernstein
               |                      |         183 | Geoni
               |                      |         118 | Himuro
               |                      |         130 | Atkinson
               |                      |         144 | Vargas
(124 rows)
```

## Qualified for Self `JOIN`

Self JOIN pada dasarnya Join Table seperti layaknya `INNER JOIN` dan `OUTER JOIN` hanya saja menggabungkan antara 2 tabel atau lebih yang ke referensi yang sama. 

Jika kita gambarkan Entity Relational Diagramnya seperti berikut:

{% mermaid %}
erDiagram
    employees ||--o| employees : manager_id
    employees {
        int         employee_id     PK "identifier of employees"
        string      first_name
        string      last_name
        int         manager_id      FK "manager of employee"
    }
{% endmermaid %}

Contoh kasusnya, tampilkan data karyawan berserta managernya maka querynya seperti berikut:

{% gist page.gist "04b-self-join.sql" %}

Jika dijalankan maka hasilnya seperti berikut:

```postgresql-console
hr=# SELECT  emp.employee_id "employee id",
hr-#         emp.last_name as "employee name",
hr-#         man.employee_id "manager id",
hr-#         man.last_name "manager name"
hr-# FROM employees emp
hr-#   LEFT OUTER JOIN employees man on emp.manager_id = man.employee_id
hr-# LIMIT 10;
 employee id | employee name | manager id | manager name
-------------+---------------+------------+--------------
         100 | King          |            |
         101 | Kochhar       |        100 | King
         102 | De Haan       |        100 | King
         103 | Hunold        |        102 | De Haan
         104 | Ernst         |        103 | Hunold
         105 | Austin        |        103 | Hunold
         106 | Pataballa     |        103 | Hunold
         107 | Lorentz       |        103 | Hunold
         108 | Greenberg     |        101 | Kochhar
         109 | Faviet        |        108 | Greenberg
(10 rows)
```

## `join_condition` expressions

The `ON` clause is the most general kind of join condition: it takes a Boolean value expression of the same kind as is used in a `WHERE` clause. A pair of rows from `T1` and `T2` match if the `ON` expression evaluates to `true`.

{% gist page.gist "04b-on-join-conditions.sql" %}

The `USING` clause is a shorthand that allows you to take advantage of the specific situation where both sides of the join use the same name for the joining column(s). It takes a comma-separated list of the shared column names and forms a join condition that includes an equality comparison for each one. For example, joining `T1` and `T2` with `USING (a, b)` produces the join condition `ON T1.a = T2.a AND T1.b = T2.b`.

{% gist page.gist "04b-using-join-conditions.sql" %}

Jika dijalankan hasilnya seperti berikut:

```postgresql-console
hr=# SELECT emp.employee_id, emp.last_name, job.job_id, job.job_title
hr-# FROM employees emp
hr-#       join jobs job using (job_id)
hr-# LIMIT 10;
 employee_id | last_name |   job_id   |           job_title
-------------+-----------+------------+-------------------------------
         100 | King      | AD_PRES    | President
         101 | Kochhar   | AD_VP      | Administration Vice President
         102 | De Haan   | AD_VP      | Administration Vice President
         103 | Hunold    | IT_PROG    | Programmer
         104 | Ernst     | IT_PROG    | Programmer
         105 | Austin    | IT_PROG    | Programmer
         106 | Pataballa | IT_PROG    | Programmer
         107 | Lorentz   | IT_PROG    | Programmer
         108 | Greenberg | FI_MGR     | Finance Manager
         109 | Faviet    | FI_ACCOUNT | Accountant
(10 rows)
```

Selain itu juga kita bisa menggunakan `WHERE` clause, seperti berikut:

{% gist page.gist "04b-where-join-conditions.sql" %}

Jika dijalankan hasilnya seperti berikut:

```postgresql-console
hr=# SELECT emp.employee_id, emp.last_name, job.job_id, job.job_title
hr-# FROM employees emp, jobs job
hr-# WHERE emp.job_id = job.job_id
hr-# LIMIT 10;
 employee_id | last_name |   job_id   |           job_title
-------------+-----------+------------+-------------------------------
         100 | King      | AD_PRES    | President
         101 | Kochhar   | AD_VP      | Administration Vice President
         102 | De Haan   | AD_VP      | Administration Vice President
         103 | Hunold    | IT_PROG    | Programmer
         104 | Ernst     | IT_PROG    | Programmer
         105 | Austin    | IT_PROG    | Programmer
         106 | Pataballa | IT_PROG    | Programmer
         107 | Lorentz   | IT_PROG    | Programmer
         108 | Greenberg | FI_MGR     | Finance Manager
         109 | Faviet    | FI_ACCOUNT | Accountant
(10 rows)
```