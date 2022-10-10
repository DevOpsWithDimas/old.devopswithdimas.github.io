---
layout: post
title: "Prepared Statement in SQL"
lang: postgresql
authors:
- dimasm93
categories:
- RDBMS
- PostgreSQL
- SQL
- DML
refs: 
- https://www.postgresql.org/docs/14/sql-prepare.html
youtube: 
image_path: /resources/posts/postgresql/05e-dml-prepared-statement
comments: true
gist: dimMaryanto93/7ae7632f9418feb724bc431eff412a3f
catalog_key: dml-statement
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang Prepared Statement pada SQL, feature ini biasanya hanya bisa digunakan pada Bahasa Pemograman yang menggunakan API seperti [JDBC](https://docs.oracle.com/en/java/javase/13/docs/api/java.sql/java/sql/PreparedStatement.html) di Java, [pdo](https://www.php.net/manual/en/pdo.prepared-statements.php) di PHP dan lain-lain, Nah tetapi di PostgreSQL Database kita bisa terapkan secara directly pada query SQL baik untuk select, insert, update dan delete. Perintah sqlnya seperti berikut:

{% highlight sql %}
PREPARE name [ ( data_type [, ...] ) ] AS statement
{% endhighlight %}

Dan untuk menjalankan perintanya kita bisa menggunakan perintah seperti berikut:

{% highlight sql %}
EXPLAIN EXECUTE name(parameter_values);
{% endhighlight %}

Jadi dengan kita mendefined prepared query tersebut, kita bisa meng-execute multiple times dengan parameter yang berbeda. Pada implemetasinya kita bisa gunakan untuk:

1. Create a Prepared statement for INSERT, UPDATE, DELETE
2. Show all prepared statement
3. Remove prepared statement from a session.
4. Create input parameterized with text editor (Jetbraints Database)

Ok tanpa berlama-lama kita bahas kemateri yang pertama:

<!--more-->

## Create a Prepared statement for `INSERT`, `UPDATE`, and `DELETE`

`PREPARE` creates a prepared statement. A prepared statement is a server-side object that can be used to optimize performance. When the `PREPARE` statement is executed, the specified statement is parsed, analyzed, and rewritten. When an `EXECUTE` command is subsequently issued, the prepared statement is planned and executed. This division of labor avoids repetitive parse analysis work, while allowing the execution plan to depend on the specific parameter values supplied.

Prepared statements can take parameters: values that are substituted into the statement when it is executed. When creating the prepared statement, refer to parameters by position, using `$1`, `$2`, `$n`, etc. A corresponding list of parameter data types can optionally be specified. When a parameter's data type is not specified or is declared as `unknown`, the type is inferred from the context in which the parameter is first referenced (if possible).

Sebagai contoh, implementasinya saya mau insert data employees dengan perpared statement seperti berikut:

{% gist page.gist "05e-dml-insert-prepared-statement.sql" %}

Jika kita jalankan maka hasilnya seperti berikut:

```sql
hr=# PREPARE create_a_employee(varchar(20), varchar(25), varchar(25), varchar(20), varchar(10), numeric(2, 2), int) as
hr-#     insert into employees(first_name, last_name, email, phone_number, job_id, commission_pct, department_id)
hr-#     VALUES ($1, $2, $3, $4, $5, $6, $7)
hr-#     RETURNING employee_id, concat(first_name, ' ', last_name);
PREPARE

hr=# execute create_a_employee('Muhamad', 'Purwadi', 'purwadi', '08211777', 'AD_VP', 0.1, 90);
 employee_id |     concat
-------------+-----------------
           4 | Muhamad Purwadi
(1 row)
INSERT 0 1
hr=# execute create_a_employee('Deni', 'Sutisna', 'deni.sutisna', '08211666', 'AD_PRES', 0.2, 90);
 employee_id |    concat
-------------+--------------
           5 | Deni Sutisna
(1 row)
INSERT 0 1
```

## Show all prepared statement

Prepared statements only last for the duration of the current database session. When the session ends, the prepared statement is forgotten, so it must be recreated before being used again. This also means that a single prepared statement cannot be used by multiple simultaneous database clients; however, each client can create their own prepared statement to use. 

You can see all prepared statements available in the session by querying the `pg_prepared_statements` system view.

{% gist page.gist "05e-view-pg-prepared-statements.sql" %}

Jika kita jalankan seperti berikut:

```sql
hr=#
hr=# select * from pg_prepared_statements;
       name        |                                                     statement                                                     |         prepare_time          |                                                    parameter_types                                                    | from_sql | generic_plans | custom_plans
-------------------+-------------------------------------------------------------------------------------------------------------------+-------------------------------+-----------------------------------------------------------------------------------------------------------------------+----------+---------------+--------------
 create_a_employee | PREPARE create_a_employee(varchar(20), varchar(25), varchar(25), varchar(20), varchar(10), numeric(2, 2), int) as+| 2022-10-10 13:21:56.391275+00 | {"character varying","character varying","character varying","character varying","character varying",numeric,integer} | t        |             0 |            3
                   |     insert into employees(first_name, last_name, email, phone_number, job_id, commission_pct, department_id)     +|                               |                                                                                                                       |          |               |
                   |     VALUES ($1, $2, $3, $4, $5, $6, $7)                                                                          +|                               |                                                                                                                       |          |               |
                   |     RETURNING employee_id, concat(first_name, ' ', last_name);                                                    |                               |                                                                                                                       |          |               |
(1 row)
hr=# quit

hr=# select * from pg_prepared_statements;
 name | statement | prepare_time | parameter_types | from_sql | generic_plans | custom_plans
------+-----------+--------------+-----------------+----------+---------------+--------------
(0 rows)
```

## Remove prepared statement from a session

Prepared statements can be manually cleaned up using the `DEALLOCATE` command. `DEALLOCATE` is used to deallocate a previously prepared SQL statement. If you do not explicitly deallocate a prepared statement, it is deallocated when the session ends.

{% highlight sql %}
DEALLOCATE [ PREPARE ] { name | ALL }
{% endhighlight %}

Contohnya seperti berikut:

{% gist page.gist "05e-dml-deallocate-prepared-statement.sql" %}

Jika dijalankan hasilnya seperti berikut:

```sql
hr=# PREPARE get_employee_by_dep(integer) as
hr-#     select emp.employee_id, emp.first_name, emp.job_id, job.job_title, dep.department_id, dep.department_name
hr-#     from employees emp
hr-#              join departments dep on emp.department_id = dep.department_id
hr-#              join jobs job on emp.job_id = job.job_id
hr-#     where dep.department_id = $1;
PREPARE

hr=# execute get_employee_by_dep(90);
 employee_id | first_name | job_id  |           job_title           | department_id | department_name
-------------+------------+---------+-------------------------------+---------------+-----------------
           5 | Deni       | AD_PRES | President                     |            90 | Executive
         100 | Steven     | AD_PRES | President                     |            90 | Executive
           4 | Muhamad    | AD_VP   | Administration Vice President |            90 | Executive
         102 | Lex        | AD_VP   | Administration Vice President |            90 | Executive
         101 | Neena      | AD_VP   | Administration Vice President |            90 | Executive
           1 | Dimas      | IT_PROG | Programmer                    |            90 | Executive
(6 rows)

hr=# select name from pg_prepared_statements;
        name
---------------------
 get_employee_by_dep
(1 row)

hr=# DEALLOCATE PREPARE get_employee_by_dep;
DEALLOCATE

hr=# select name from pg_prepared_statements;
 name
------
(0 rows)
```

## Create input parameterized with text editor

Selain menggunakan `PREPARE` statement, jika kita menggunakan text editor misalnya seperti Jetbraint IntelliJ IDEA, pgAdmin 4, DBeaver dan lain. Kita juga bisa menggunakan prepared statement tetapi metodenya di handle by client. Seperti di IntelliJ IDEA menggunakan pattern `:variableName` atau `?` contohnya seperti berikut:

{% gist page.gist "05e-dml-placeholder-input-idea.sql" %}

Jika dijalankan maka akan muncul dialog seperti berikut:

![dialog placeholder]({{ page.image_path | prepend: site.baseurl }}/idea-dialog.png)