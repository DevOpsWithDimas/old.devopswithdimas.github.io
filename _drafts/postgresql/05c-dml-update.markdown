---
layout: post
title: "Deep dive into UPDATE Statement"
lang: postgresql
authors:
- dimasm93
categories:
- RDBMS
- PostgreSQL
- SQL
- DML
refs: 
- https://www.postgresql.org/docs/14/sql-update.html
youtube: 
image_path: /resources/posts/postgresql/05c-dml-update
comments: true
gist: dimMaryanto93/7ae7632f9418feb724bc431eff412a3f
catalog_key: dml-statement
downloads: []
---

Hai semuanya, setelah kita membahas Insert Statement perintah selanjutnya yang kita perlu perlajari adalah merubah data pada suatu tabel dengan menggunakan perintah `UPDATE` statement. Seperti yang temen-temen telah pelajari Perintah `UPDATE` statement yang telah bahas sebelumnya masih hal yang simple, sebetulnya secara syntax perintahnya seperti berikut:

{% highlight sql %}
[ WITH [ RECURSIVE ] with_query [, ...] ]
UPDATE [ ONLY ] table_name [ * ] [ [ AS ] alias ]
    SET { column_name = { expression | DEFAULT } |
          ( column_name [, ...] ) = [ ROW ] ( { expression | DEFAULT } [, ...] ) |
          ( column_name [, ...] ) = ( sub-SELECT )
        } [, ...]
    [ FROM from_item [, ...] ]
    [ WHERE condition | WHERE CURRENT OF cursor_name ]
    [ RETURNING * | output_expression [ [ AS ] output_name ] [, ...] ]
{% endhighlight %}

Nah jadi jika kita perhatikan ada beberapa clause yang kita bisa digunakan diantaranya:

1. UPDATE using `DEFAULT` value clause
2. UPDATE using sub-SELECT clause
3. UPDATE using column-list syntax
4. UPDATE using `WITH` clause
5. UPDATE using `FROM` clause
6. UPDATE using `RETURNING` clause
7. Eerror message on update statement

Nah jadi akan lebih enak jika kita break-down untuk pembahasanya masing-masing feature tersebut.

<!--more-->

## UPDATE using `DEFAULT` value clause

Sama halnya dengan perintah insert pada materi sebelumnya, jika kita memiliki struktur tabel yang menggunakan `DEFAULT VALUE` pada kolomnya jadi kita bisa menggunakan keywoard `DEFAULT` pada `SET` clause seperti berikut syntaxnya:

{% highlight sql %}
UPDATE [ ONLY ] table_name [ * ] [ [ AS ] alias ]
    SET { column_name = { expression | DEFAULT }
    [ WHERE condition ]
{% endhighlight %}

Contoh implementasinya, saya ingin meng-update salary pada karyawan yang bekerja pada `department_id = 10` dengan nilai default, maka berikut adalah sql querynya:

{% gist page.gist "05c-dml-update-default-expression.sql" %}

Jika dijalankan maka hasilnya seperti berikut:

```sql
hr=# \d employees
                                            Table "public.employees"
     Column     |         Type          | Collation | Nullable |                    Default
----------------+-----------------------+-----------+----------+------------------------------------------------
 employee_id    | integer               |           | not null | nextval('employees_employee_id_seq'::regclass)
 first_name     | character varying(20) |           |          |
 last_name      | character varying(25) |           | not null |
 salary         | numeric(8,2)          |           |          | 0
....

hr=# UPDATE employees
hr-# SET salary = DEFAULT
hr-# WHERE department_id = 10;
UPDATE 1

hr=# select employee_id, first_name, salary
hr-# from employees
hr-# where department_id = 10;
 employee_id | first_name | salary
-------------+------------+--------
         200 | Jennifer   |   0.00
(1 row)
```

## UPDATE using Sub-SELECT (Sub Query) clause

Pada statement update kita bisa menggunakan sub-SELECT atau sub-query pada `SET` clause, data yang bisa di terima pada sub-SELECT bisa merupakan single-row query, corelate query maupun aggregate result. Berikut format syntaxnya:

{% highlight sql %}
UPDATE [ ONLY ] table_name [ * ] [ [ AS ] alias ]
    SET ( column_name [, ...] ) = ( sub-SELECT )
    [ WHERE condition ]
{% endhighlight %}

Contoh implementasinya, saya ingin meng-update salary karyawan yang bekerja pada `department_id = 10` dengan nilai `min_salary` pada tabel job berdasarkan jabatan karwayan tersebut. Seperti berikut querynya:

{% gist page.gist "05c-dml-update-set-sub-select.sql" %}

Jika dijalankan maka hasilnya seperti berikut:

```sql
hr=# select job_id from employees where department_id = 10;
 job_id
---------
 AD_ASST
(1 row)

hr=# select min_salary from jobs where job_id = 'AD_ASST';
 min_salary
------------
       3000
(1 row)

hr=# UPDATE employees emp
hr-# SET salary = (select min_salary from jobs job where emp.job_id = job.job_id)
hr-# WHERE department_id = 10;
UPDATE 1

hr=# select employee_id, salary
hr-# from employees
hr-# where department_id = 10;
 employee_id | salary
-------------+---------
         200 | 3000.00
(1 row)
```

## UPDATE using column-list syntax

Selain menggunakan format yang biasa, kita juga bisa menggunakan column-list pada `SET` clause, bentuk query dengan column-list seperti berikut:

{% highlight sql %}
UPDATE [ ONLY ] table_name [ * ] [ [ AS ] alias ]
    SET ( column_name [, ...] ) = ( sub-SELECT )
    [ WHERE condition ]
{% endhighlight %}

Contoh implementasinya, masih serupa dengan sebelumnya kita akan meng-update salary berserta commission_pct karyawan yang bekerja pada `department_id = 10` dengan nilai `max_salary` pada tabel `jobs` bedasarkan jabatan karyawan tersebut dan `commission_pct` sebesar `0.1`. Seperti berikut querynya:

{% gist page.gist "05c-dml-update-set-column-list.sql" %}

Jika dijalankan hasilnya seperti berikut:

```sql
hr=# select employee_id, salary, commission_pct, job_id
hr-# from employees
hr-# where department_id = 10;
 employee_id | salary  | commission_pct | job_id
-------------+---------+----------------+---------
         200 | 3000.00 |                | AD_ASST
(1 row)

hr=# select *
hr-# from jobs
hr-# where job_id = 'AD_ASST';
 job_id  |        job_title         | min_salary | max_salary
---------+--------------------------+------------+------------
 AD_ASST | Administration Assistant |       3000 |       6000
(1 row)

hr=# UPDATE employees emp
hr-# SET (salary, commission_pct) = (
hr(#     select min_salary,
hr(#            0.1 as commission_pct
hr(#     from jobs job
hr(#     where emp.job_id = job.job_id)
hr-# WHERE department_id = 10;
UPDATE 1

hr=# select employee_id, salary, commission_pct, job_id
hr-# from employees
hr-# where department_id = 10;
 employee_id | salary  | commission_pct | job_id
-------------+---------+----------------+---------
         200 | 3000.00 |           0.10 | AD_ASST
(1 row)
```

Nah jika temen-temen perhatikan, query tersebut hasilnya akan sama jika kita menggunakan query seperti berikut:

{% highlight sql %}
UPDATE employees emp
SET salary = (select min_salary from jobs job where emp.job_id = job.job_id), 
    commission_pct = 0.1
WHERE department_id = 10;
{% endhighlight %}

## UPDATE using `WITH` clause

The WITH clause allows you to specify one or more subqueries that can be referenced by name in the UPDATE query. Berikut adalah formatnya: 

{% highlight sql %}
[ WITH [ RECURSIVE ] with_query [, ...] ]
UPDATE [ ONLY ] table_name [ * ] [ [ AS ] alias ]
    SET { column_name = { expression | DEFAULT } } [, ...]
    [ WHERE condition | WHERE CURRENT OF cursor_name ]
{% endhighlight %}

Contoh implementasinya, masih serupa dengan sebelunya tapi kita akan optimalisasi dengan with clause. Maka berikut adalah querynya:

{% gist page.gist "05c-dml-update-with-clause.sql" %}

Jika dijalankan maka hasilnya seperti berikut:

```sql
hr=# select employee_id, salary, commission_pct, job_id
hr-# from employees
hr-# where department_id = 10;
 employee_id | salary  | commission_pct | job_id
-------------+---------+----------------+---------
         200 | 3000.00 |           0.10 | AD_ASST
(1 row)

hr-# UPDATE employees emp
hr-# SET (salary, commission_pct) = (
hr(#     select ds.min_salary, ds.commission_pct
hr(#     from default_salary ds
hr(#     where ds.job_id = emp.job_id)
hr-# where department_id = 10;
UPDATE 1

hr=# select employee_id, salary, commission_pct, job_id
hr-# from employees
hr-# where department_id = 10;
 employee_id | salary  | commission_pct | job_id
-------------+---------+----------------+---------
         200 | 3000.00 |           0.20 | AD_ASST
(1 row)
```

## UPDATE using `FROM` clause

Selain itu juga kita bisa menggunakan join form atau menggunakan `from` clause pada update. seperti berikut syntaxnya:

{% highlight sql %}
[ WITH [ RECURSIVE ] with_query [, ...] ]
UPDATE [ ONLY ] table_name [ * ] [ [ AS ] alias ]
    SET { column_name = { expression | DEFAULT } } [, ...]
    [ FROM from_item [, ...] ]
    [ WHERE condition | WHERE CURRENT OF cursor_name ]
{% endhighlight %}

Contoh implementasinya, masih sama dengan kasus sebelumnya hanya menggunakan `from` clause, tetapi disini jiga query yang di hasilkan pada `from` clause lebih dari satu baris biasanya akan menghasilkan unexpected results seperti berikut:

{% gist page.gist "05c-dml-update-from-clause.sql" %}

Jika dijalankan hasilnya seperti berikut:

```sql
hr=# select employee_id, salary, job_id
hr-# from employees
hr-# where department_id = 10;
 employee_id | salary  | job_id
-------------+---------+---------
         200 | 3000.00 | AD_ASST
(1 row)

hr=# UPDATE employees emp
hr-# SET salary         = min_salary,
hr-#     commission_pct = 0.1
hr-# FROM jobs job
hr-# WHERE (job.job_id = emp.job_id)
hr-#   and department_id = 10;
UPDATE 1

hr=# select employee_id, salary, commission_pct, job_id
hr-# from employees
hr-# where department_id = 10;
 employee_id | salary  | commission_pct | job_id
-------------+---------+----------------+---------
         200 | 3000.00 |           0.10 | AD_ASST
(1 row)

hr=# UPDATE employees emp
hr-# SET salary         = min_salary,
hr-#     commission_pct = 0.1
hr-# FROM jobs job
hr-# WHERE job.job_id in (10, 20)
hr-#   and department_id = 90;
ERROR:  operator does not exist: character varying = integer
LINE 5: WHERE job.job_id in (10, 20)
                         ^
HINT:  No operator matches the given name and argument types. You might need to add explicit type casts.
```