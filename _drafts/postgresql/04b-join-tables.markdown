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

1. Basic usage of Join Tables
2. Cross join
3. Qualified join
    1. Inner Joins
    2. Left or Right Outer Joins
    3. Full Outer Joins

Ok langsung aja yuk kita bahas materi yang pertama:

<!--more-->

## Basic Join Tables

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