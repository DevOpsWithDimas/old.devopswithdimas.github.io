---
layout: post
title: "Deep dive into INSERT statement"
lang: postgresql
authors:
- dimasm93
categories:
- RDBMS
- PostgreSQL
refs: 
- https://www.postgresql.org/docs/14/sql-insert.html
youtube: 
image_path: /resources/posts/postgresql/05b-dml-insert
comments: true
gist: dimMaryanto93/7ae7632f9418feb724bc431eff412a3f
catalog_key: dml-statement
downloads: []
---

Hai semuanya, pada materi sebelumnya kita sudah membahas sedikit tentang Data Manipulation language atau di singkat DML. Nah sekarang kita akan bahas lebih detail khususnya untuk perintah INSERT statement diantaranya seperti berikut:

1. Advanced `INSERT` statement
2. Insert with specific columns and data type
3. Insert with `DEFAULT VALUE`
4. Insert single and multiple rows
5. Insert with `ON CONFLICT`
6. Insert with `OVERRIDING` keyword
7. Using with query in INSERT statement
8. Error message on insert statement

Ok tanpa berlama-lama lagi, yuuk lansung aja kita bahas materi yang pertama:

<!--more-->

## Advanced `INSERT` statement

Perintah `INSERT` yang telah kita pelajari di materi sebelumnya hanyalah simple sebetulnya secara syntax perintahnya seperti berikut:

{% highlight sql %}
[ WITH [ RECURSIVE ] with_query [, ...] ]
INSERT INTO table_name [ AS alias ] [ ( column_name [, ...] ) ]
    [ OVERRIDING { SYSTEM | USER } VALUE ]
    { DEFAULT VALUES | VALUES ( { expression | DEFAULT } [, ...] ) [, ...] | query }
    [ ON CONFLICT [ conflict_target ] conflict_action ]
    [ RETURNING * | output_expression [ [ AS ] output_name ] [, ...] ]

where conflict_target can be one of:

    ( { index_column_name | ( index_expression ) } [ COLLATE collation ] [ opclass ] [, ...] ) [ WHERE index_predicate ]
    ON CONSTRAINT constraint_name

and conflict_action is one of:

    DO NOTHING
    DO UPDATE SET { column_name = { expression | DEFAULT } |
                    ( column_name [, ...] ) = [ ROW ] ( { expression | DEFAULT } [, ...] ) |
                    ( column_name [, ...] ) = ( sub-SELECT )
                  } [, ...]
              [ WHERE condition ]
{% endhighlight %}

Nah lumayan banyak dan panjang juga ya ternyata untuk perintah insert yang kita bisa gunakan, jadi kita akan coba break down aja ya masing-masing feature

## Insert with specific columns and data type

The target column names can be listed in any order. If no list of column names is given at all, the default is all the columns of the table in their declared order; or the first `N` column names, if there are only `N` columns supplied by the VALUES clause or query. The values supplied by the `VALUES` clause or query are associated with the explicit or implicit column list left-to-right.

If the expression for any column is not of the correct data type, automatic type conversion will be attempted.

{% highlight sql %}
INSERT INTO <table_name> [ ( column_name [, ...] ) ]
    { VALUES ( { expression | DEFAULT } [, ...] ) [, ...] }
{% endhighlight %}

Sebagai contoh, saya ingin menambahkan data pada table `employees` dengan struktur table seperti berikut

```sql
hr=# \d employees
                                            Table "public.employees"
     Column     |         Type          | Collation | Nullable |                    Default                     
----------------+-----------------------+-----------+----------+------------------------------------------------
 employee_id    | integer               |           | not null | nextval('employees_employee_id_seq'::regclass)
 first_name     | character varying(20) |           |          | 
 last_name      | character varying(25) |           | not null | 
 email          | character varying(25) |           | not null | 
 phone_number   | character varying(20) |           |          | 
 job_id         | character varying(10) |           |          | 
 salary         | numeric(8,2)          |           |          | 
 commission_pct | numeric(2,2)          |           |          | 
 manager_id     | integer               |           |          | 
 department_id  | integer               |           |          | 
```

Data yang saya inputkan ke table `employees` tersebut adalah seperti berikut

| first_name    | last_name  | email    | job_id    | salary    |
| :---          | :---       | :---     | :---      | :---      |
| Dimas         | Maryanto   | DIMAS    | IT_PROG   | 15000     |

Berikut adalah querynya:

{% gist page.gist "05b-dml-insert-specific-columns.sql" %}

Jika dijalankan hasilnya seperti berikut:

```sql
hr=# INSERT INTO employees (email, first_name, last_name, job_id, salary)
hr-# values ('DIMAS', initcap('dimas'), initcap('maryanto'), upper('it_prog'), 15000);
INSERT 0 1

hr=# select * from employees where email = 'DIMAS';
 employee_id | first_name | last_name | email | phone_number | job_id  |  salary  | commission_pct | manager_id | department_id 
-------------+------------+-----------+-------+--------------+---------+----------+----------------+------------+---------------
           2 | Dimas      | Maryanto  | DIMAS |              | IT_PROG | 15000.00 |                |            |              
(1 row)
```

Selain itu juga klo kita mau menyimpan data dengan tipe data date/timestamp misalnya pada table `job_history` seperti berikut struktur tablenya:

```sql
hr=# \d job_history
                          Table "public.job_history"
    Column     |            Type             | Collation | Nullable | Default 
---------------+-----------------------------+-----------+----------+---------
 employee_id   | integer                     |           |          | 
 start_date    | timestamp without time zone |           |          | 
 end_date      | timestamp without time zone |           |          | 
 job_id        | character varying(10)       |           |          | 
 department_id | integer                     |           |          | 
```

Maka querynya seperti berikut:

{% gist page.gist "05b-dml-insert-specific-datatype.sql" %}

Jika dijalankan hasilnya seperti berikut:

```sql
hr=# INSERT INTO job_history (employee_id, start_date, job_id) 
hr-# VALUES (2, '2016-07-15', 'IT_PROG');
INSERT 0 1

hr=# select * from job_history where employee_id = 2;
 employee_id |     start_date      | end_date | job_id  | department_id 
-------------+---------------------+----------+---------+---------------
           2 | 2016-07-15 00:00:00 |          | IT_PROG |              
(1 row)
```

## Insert with `DEFAULT VALUE`

All columns will be filled with their default values, as if `DEFAULT` were explicitly specified for each column. (An `OVERRIDING` clause is not permitted in this form.)

Each column not present in the explicit or implicit column list will be filled with a default value, either its declared default value or `null` if there is none.

Sebagai contoh kita akan edit struktur table `employees` pada columnn `salary` dengan menambahkan default value dengan query seperti berikut:

{% highlight sql %}
alter table employees
alter column salary SET default 0;
{% endhighlight %}

Nah sekarang kita lihat struktur tablenya seperti berikut:

```sql
hr=# \d employees
                                            Table "public.employees"
     Column     |         Type          | Collation | Nullable |                    Default                     
----------------+-----------------------+-----------+----------+------------------------------------------------
 employee_id    | integer               |           | not null | nextval('employees_employee_id_seq'::regclass)
 first_name     | character varying(20) |           |          | 
 last_name      | character varying(25) |           | not null | 
 email          | character varying(25) |           | not null | 
 phone_number   | character varying(20) |           |          | 
 job_id         | character varying(10) |           |          | 
 salary         | numeric(8,2)          |           |          | 0
 commission_pct | numeric(2,2)          |           |          | 
 manager_id     | integer               |           |          | 
 department_id  | integer               |           |          | 
```

Kemudian jika kita lakukan insert data dengan query seperti berikut:

{% gist page.gist "05b-dml-insert-no-specify-salary-column.sql" %}

Jika di jalankan hasilnya seperti berikut:

```sql
hr=# INSERT INTO employees (email, first_name, last_name, job_id)
hr-# values ('YUSUF', initcap('Muhamad'), initcap('yusuf'), upper('it_prog'));
INSERT 0 1

hr=# select * from employees where email = 'YUSUF';
 employee_id | first_name | last_name | email | phone_number | job_id  | salary | commission_pct | manager_id | department_id 
-------------+------------+-----------+-------+--------------+---------+--------+----------------+------------+---------------
           3 | Muhamad    | Yusuf     | YUSUF |              | IT_PROG |   0.00 |                |            |              
(1 row)
```

Kemudian jika kita specify column `salary` tetapi jika kita kasih nilai `null` dengan query seperti berikut:

{% gist page.gist "05b-dml-insert-null-value-salary.sql" %}

Jika dijalankan hasilnya seperti berikut:

```sql
hr=# INSERT INTO employees (email, first_name, last_name, job_id, salary)
hr-# values ('PURWADI', initcap('muhamad'), initcap('purwadi'), upper('it_prog'), null);
INSERT 0 1

hr=# select * from employees where email = 'PURWADI';
 employee_id | first_name | last_name |  email  | phone_number | job_id  | salary | commission_pct | manager_id | department_id 
-------------+------------+-----------+---------+--------------+---------+--------+----------------+------------+---------------
           4 | Muhamad    | Purwadi   | PURWADI |              | IT_PROG |        |                |            |              
(1 row)
```

Kemudian bagaimana jika kita mau menggunakan nilai defaultnya jika kita specify column tersebut, kita bisa gunakan keyword `DEFAULT` seperti berikut:

{% gist page.gist "05b-dml-insert-using-default-value.sql" %}

Jika dijalankan hasilnya seperti berikut:

```sql
hr=# INSERT INTO employees (email, first_name, last_name, job_id, salary)
hr-# values ('JUNAEDI', null, initcap('junaedi'), upper('it_prog'), DEFAULT);
INSERT 0 1

hr=# select * from employees where email  = 'JUNAEDI';
 employee_id | first_name | last_name |  email  | phone_number | job_id  | salary | commission_pct | manager_id | department_id 
-------------+------------+-----------+---------+--------------+---------+--------+----------------+------------+---------------
           5 |            | Junaedi   | JUNAEDI |              | IT_PROG |   0.00 |                |            |              
(1 row)
```

## Insert single and multiple rows

`INSERT` statement is inserts new rows into a table. One can insert one or more rows specified by value expressions, or zero or more rows resulting from a query.