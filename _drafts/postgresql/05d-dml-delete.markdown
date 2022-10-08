---
layout: post
title: "Deep dive into DELETE statement"
lang: postgresql
authors:
- dimasm93
categories:
- RDBMS
- PostgreSQL
- SQL
- DML
refs: 
- https://www.postgresql.org/docs/14/sql-delete.html
youtube: 
image_path: /resources/posts/postgresql/05d-dml-update
comments: true
gist: dimMaryanto93/7ae7632f9418feb724bc431eff412a3f
catalog_key: dml-statement
downloads: []
---

Hai semuanya, Setelah kita membahas tentang Update statement perintah selanjutnya yang kita perlu perlajari untuk menghapus data pada suatu tabel yaitu `DELETE` statement. Terkiat perintah delete yang temen-temen telah pelajari sebelumnya hanya sekilas saja sebetulnya secara mendetail perintah delete seperti berikut:

{% highlight sql %}
[ WITH [ RECURSIVE ] with_query [, ...] ]
DELETE FROM [ ONLY ] table_name [ * ] [ [ AS ] alias ]
    [ USING from_item [, ...] ]
    [ WHERE condition | WHERE CURRENT OF cursor_name ]
    [ RETURNING * | output_expression [ [ AS ] output_name ] [, ...] ]
{% endhighlight %}

Jika temen-temen perhatikan ada beberapa feature dan yang kita bisa gunakan seperti:

1. Delete with `USING from_item` clause
2. Delete using `RETURNING`
3. Delete using WITH queries

Ok tanpa berlama-lama jadi lansung aja bahas materi yang pertama:

<!--more-->

## Delete with `USING from_item` clause 

There are two ways to delete rows in a table using information contained in other tables in the database: using sub-selects, or specifying additional tables in the `USING` clause. Which technique is more appropriate depends on the specific circumstances.

A table expression allowing columns from other tables to appear in the WHERE condition. This uses the same syntax as the `FROM` clause of a `SELECT` statement; for example, an alias for the table name can be specified. Do not repeat the target table as a `from_item` unless you wish to set up a self-join (in which case it must appear with an alias in the from_item). The syntax is:

{% highlight sql %}
DELETE FROM table_name [ [ AS ] alias ]
    [ USING from_item [, ...] ]
    [ WHERE condition ]
{% endhighlight %}

Contoh implementasinya, misalnya saya mau menghapus data karyawan yang pernah bekerja sebagai `ST_CLERK` maka querynya seperti berikut:

{% gist page.gist "05d-dml-delete-using-from_item.sql" %}

Jika dijalankan hasilnya seperti berikut:

```sql
hr=# select employee_id, start_date, department_id, job_id
hr-# from job_history
hr-# where job_id = 'ST_CLERK';
 employee_id |     start_date      | department_id |  job_id
-------------+---------------------+---------------+----------
         114 | 1998-03-24 00:00:00 |            50 | ST_CLERK
         122 | 1999-01-01 00:00:00 |            50 | ST_CLERK
(2 rows)

hr=# delete
hr-# from employees emp
hr-#     using job_history old
hr-# where old.job_id = 'ST_CLERK'
hr-#   and emp.employee_id = old.employee_id;
DELETE 2

hr=# select employee_id, first_name
hr-# from employees
hr-# where employee_id in (114, 122);
 employee_id | first_name
-------------+------------
(0 rows)
```

Pada query tersebut akan sama jika kita menggunakan sub-query seperti berikut:

{% gist page.gist "05d-dml-delete-where-sub-query.sql" %}

## Delete using `RETURNING`

If the `DELETE` command contains a `RETURNING` clause, the result will be similar to that of a `SELECT` statement containing the columns and values defined in the `RETURNING` list, computed over the row(s) deleted by the command. The syntax is:

{% highlight sql %}
DELETE FROM table_name [ [ AS ] alias ]
    [ WHERE condition ]
    [ RETURNING * | output_expression [ [ AS ] output_name ] [, ...] ]
{% endhighlight %}

Sebagai contoh, saya ingin menghapus data pada tabel `countries` untuk `country_id` sama dengan `ZM` dan `ZW` kemudian tampilan data selengkapnya seperti berikut:

{% gist page.gist "05d-dml-dml-returning.sql" %}

Jika dijalankan hasilnya seperti berikut:

```sql
hr=# DELETE FROM countries
hr-# WHERE country_id in ('ZM', 'ZW')
hr-# RETURNING *;
 country_id | country_name | region_id
------------+--------------+-----------
 ZM         | Zambia       |         4
 ZW         | Zimbabwe     |         4
(2 rows)

DELETE 2
```

## Delete using WITH queries

Seperti halnya pada Insert, Update pada Delete statement juga kita bisa menggunakan WITH Query yang berfungsi memecah query yang akan di gunakan pada perintah tersebut. The syntax is:

{% highlight sql %}
[ WITH [ RECURSIVE ] with_query [, ...] ]
DELETE FROM [ ONLY ] table_name [ * ] [ [ AS ] alias ]
    [ WHERE condition | WHERE CURRENT OF cursor_name ]
{% endhighlight %}

Contoh implementasinya, saya akan menghapus data karyawan yang sudah mulai kerja dari `1995-01-01` dari tabel `job_history` maka querynya seperti berikut:

{% gist page.gist "05d-dml-delete-with-query.sql" %}

Jika dilankan maka hasilnya seperti berikut:

```sql
hr=# select distinct employee_id
hr-#     from job_history
hr-#     where start_date > '1995-01-01';
 employee_id
-------------
         176
         114
         201
         122
(4 rows)

hr=# WITH history_emp_from_dep as (
hr(#     select distinct employee_id
hr(#     from job_history
hr(#     where start_date > '1995-01-01'
hr(# )
hr-# DELETE
hr-# FROM employees emp
hr-#     USING history_emp_from_dep history
hr-# where emp.employee_id = history.employee_id
hr-# RETURNING *;
 employee_id | first_name | last_name |  email   |    phone_number    | job_id |  salary  | commission_pct | manager_id | department_id | employee_id
-------------+------------+-----------+----------+--------------------+--------+----------+----------------+------------+---------------+-------------
         176 | Jonathon   | Taylor    | JTAYLOR  | 011.44.1644.429265 | SA_REP |  8600.00 |           0.20 |        149 |            80 |         176
         201 | Michael    | Hartstein | MHARTSTE | 515.123.5555       | MK_MAN | 13000.00 |                |        100 |            20 |         201
(2 rows)

DELETE 2
```