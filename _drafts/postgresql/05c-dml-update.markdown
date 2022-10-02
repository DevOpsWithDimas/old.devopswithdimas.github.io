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

1. UPDATE with `DEFAULT` value clause
2. UPDATE with sub-SELECT clause
3. `WITH` clause
4. UPDATE with `FROM` statement
5. UPDATE with `RETURNING` statement
7. Eerror message on update statement

Nah jadi akan lebih enak jika kita break-down untuk pembahasanya masing-masing feature tersebut.

<!--more-->

## UPDATE with `DEFAULT` value clause

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