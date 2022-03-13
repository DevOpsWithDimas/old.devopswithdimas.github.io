---
layout: post
title: "Basic SQL Select statements"
date: 2022-02-24T06:05:06+07:00
lang: postgresql
categories:
- RDBMS
- PostgreSQL
- sql
- select
refs: 
- https://www.postgresql.org/docs/14/
youtube: 
image_path: /resources/posts/postgresql/03a-basic-select-statement
comments: true
gist: dimMaryanto93/7ae7632f9418feb724bc431eff412a3f
catalog_key: select-statement
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang Basic penggunaan SQL untuk Select statement pada PostgreSQL. Diantaranya yang akan kita bahas yaitu

1. Format penulisan Select statement
2. Menampilkan semua data dalam sebuah _table_
3. Menampilkan hanya beberapa _columns_ pada sebuah _table_
4. Memberikan alias pada suatu _column_
5. Menggunakan Special Characters / Escape Characters
6. Menggunakan Comments
7. Elimination of duplicate rows.

Ok langsung saja kita bahas materi yang pertama

## Format penulisan Select statement

To retrieve data from a table, the table is queried. An SQL `SELECT` statement is used to do this. The statement is divided into a select list (the part that lists the columns to be returned), a table list (the part that lists the tables from which to retrieve the data), and an optional qualification (the part that specifies any restrictions). 

{% highlight sql linenos %}
select 
     * | columns...  
from 
    table_name | tables... (separated by comma)
[where condition]
{% endhighlight %}

Contohnya di _database_ `hr` sekarang saya punya daftar _tables_ seperti berikut:

{% highlight postgresql-console %}
hr=# \dt
 public | countries    | table | hr
 public | departments  | table | hr
 public | employees    | table | hr
 public | job_history  | table | hr
 public | jobs         | table | hr
 public | locations    | table | hr
 public | regions      | table | hr
{% endhighlight %}

Jadi kita bisa pilih salah satu tabelnya contohnya `departments` maka SQL Query select statemenya seperti berikut:

{% highlight sql linenos %}
select * from departments;
{% endhighlight %}

## Menampilkan semua data dalam sebuah _table_

Untuk menampilkan semua data untuk semua column yang dipilih dalam sebuah tabel kita bisa menggunakan spesial karakter `*` (asteric / bintang) dalam perintah _select_ seperti berikut:

{% gist page.gist "03a-select-all-departments.sql" %}

Maka akan tampil datanya seperti berikut:

| dep_id | department_name     | manager_id | location_id |
| :--   | :------------        | :----      |  :--- |
|   10  | Administration       |        200 |  1700 |
|   40  | Human Resources      |        203 |  2400 |
|   50  | Shipping             |        121 |  1500 |
|   60  | IT                   |        103 |  1400 |
|   90  | Executive            |        100 |  1700 |
{:.table .striped .bordered }

## Menampilkan semua data pada beberapa _columns_ pada sebuah _table_

Selain menggunakan `*` untuk menampikan semua kolom pada tabel tersebut, kita juga bisa sebutkan nama kolomnya. Tapi yang harus kita ketahui dulu adalah nama kolomnya pada table tersebut. kita bisa menggunakan perintah seperti berikut:

```postgresql
hr=# \dt departments
 department_id   | integer               | not null default nextval('departments_department_id_seq'::regclass)
 department_name | character varying(30) | 
 manager_id      | integer               | 
 location_id     | integer               | 
```

Nah jadi kita punya column `department_id`, `department_name`, `manager_id`, dan `location_id` jadi kita bisa pilih atau semuanya seperti berikut:

{% gist page.gist "03a-select-all-columns-departments.sql" %}

Atau 

{% gist page.gist "03a-select-only-selected-columns-departments.sql" %}

Jika dijalankan maka hasilnya seperti berikut:

| department_id | department_name       |
| :--           | :------------         |
|   10          | Administration        |
|   40          | Human Resources       |
|   50          | Shipping              |
|   60          | IT                    |
|   90          | Executive             |
{:.table .striped .bordered }

## Memberikan alias pada suatu _column_

Secara _default_ kalau kita melakukan perintah `select` terhadap suatu _table_ contohnya misalnya `departments`, di _table_ `departments` terdiri dari _columns_ `department_id, department_name, manager_id, location_id` jika saya melakukan perintah `select` seperti berikut hasilnya:

| dep_id | department_name     | manager_id | location_id |
| :--   | :------------        | :----      |  :--- |
|   10  | Administration       |        200 |  1700 |
|   40  | Human Resources      |        203 |  2400 |
|   50  | Shipping             |        121 |  1500 |
|   60  | IT                   |        103 |  1400 |
|   90  | Executive            |        100 |  1700 |
{:.table .striped .bordered }

Dengan menggunakan _column alias_ kita bisa memberikan nama kolomnya sesuai yang kita inginkan, Aturan penamaan variable atau kolom alias, diantaranya:

1. Menggunakan keyword `as` dan tanpa `as`, tidak boleh menggunakan charakter khusus seperti **SPACE**, **HashTag**, **Dolar** dan lain-lain, karakter yang **diperbolehkan** yaitu **huruf, angka, dan underscore**. Ini karena dengan menggunakan _column alias_ tersebut nantinya bisa digunakan sebagai variable untuk melakukan _ordering_.
2. Diapit menggunakan double quote `"`, Diperbolehkan bebas karena hanya akan di jadikan sebagai label saja.

Seperti berikut contohnya:

{% gist page.gist "03a-select-alias-column-department.sql" %}

Jika dijalankan hasilnya seperti berikut:

```postgresql
hr=# select  department_id as kode_divisi,
hr-#         department_name nama_department,
hr-#         manager_id as "Kode Manager"
hr-# from departments;
 kode_divisi |   nama_department    | Kode Manager
-------------+----------------------+--------------
         300 | System Analis        |
          10 | Administration       |          200
          20 | Marketing            |          201
          30 | Purchasing           |          114
          40 | Human Resources      |          203
          50 | Shipping             |          121
          60 | IT                   |          103
          70 | Public Relations     |          204
          80 | Sales                |          145
          90 | Executive            |          100
         100 | Finance              |          108
         110 | Accounting           |          205
         120 | Treasury             |

(28 rows)
```

## Menggunakan Special Characters / Escape Characters

Some characters that are not alphanumeric have a special meaning that is different from being an operator. Details on the usage can be found at the location where the respective syntax element is described. This section only exists to advise the existence and summarize the purposes of these characters.

1. A dollar sign (`$`) followed by digits is used to represent a positional parameter in the body of a function definition or a prepared statement. In other contexts the dollar sign can be part of an identifier or a dollar-quoted string constant.
2. Parentheses (`()`) have their usual meaning to group expressions and enforce precedence. In some cases parentheses are required as part of the fixed syntax of a particular SQL command.
3. Brackets (`[]`) are used to select the elements of an array. See Section 8.15 for more information on arrays.
4. Commas (`,`) are used in some syntactical constructs to separate the elements of a list.
5. The semicolon (`;`) terminates an SQL command. It cannot appear anywhere within a command, except within a string constant or quoted identifier.
6. The colon (`:`) is used to select “slices” from arrays. (See Section 8.15.) In certain SQL dialects (such as Embedded SQL), the colon is used to prefix variable names.
7. The asterisk (`*`) is used in some contexts to denote all the fields of a table row or composite value. It also has a special meaning when used as the argument of an aggregate function, namely that the aggregate does not require any explicit parameter.
8. The period (`.`) is used in numeric constants, and to separate schema, table, and column names.

PostgreSQL also accepts "escape" string constants, which are an extension to the SQL standard. An escape string constant is specified by writing the letter E (upper or lower case) just before the opening single quote. Within an escape string, a backslash character (\) begins a C-like backslash escape sequence, in which the combination of backslash and following character(s) represent a special byte value

| Backslash Escape  | Interpretation    |
| :---              | :---              |
| `\b`              | backspace         |
| `\f`              | form feed         |
| `\n`              | newline           |
| `\r`              | carriage return   |
| `\t`              | tab               |


For example:

{% gist page.gist "03a-select-special-characters.sql" %}

Jika di jalankan hasilnya seperti berikut:

```postgresql
hr=# select '*' bintang,
hr-#         E'()' kurung,
hr-#         E'\\' slash,
hr-#         E'baris pertama \n baris kedua' newline,
hr-#         E'awal\t setelah' tabspace;
 bintang | kurung | slash |    newline     |     tabspace
---------+--------+-------+----------------+------------------
 *       | ()     | \     | baris pertama +| awal     setelah
         |        |       |  baris kedua   |
(1 row)
```

## Menggunakan Comments

A comment is a sequence of characters beginning with double dashes and extending to the end of the line, e.g.:

{% highlight sql %}
-- This is a standard SQL comment
{% endhighlight %}

Alternatively, C-style block comments can be used:

{% highlight sql linenos %}
/* multiline comment
 * with nesting: /* nested block comment */
 */
{% endhighlight %}

where the comment begins with `/*` and extends to the matching occurrence of `*/`. These block comments nest, as specified in the SQL standard but unlike C, so that one can comment out larger blocks of code that might contain existing block comments.

A comment is removed from the input stream before further syntax analysis and is effectively replaced by whitespace.

For example:

{% gist page.gist "03a-select-with-comments.sql" %}

## Elimination of duplicate rows

After the select list has been processed, the result table can optionally be subject to the elimination of duplicate rows. The `DISTINCT` keyword is written directly after `SELECT` to specify this:

{% highlight sql %}
SELECT DISTINCT select_list ...
{% endhighlight %}

Alternatively, an arbitrary expression can determine what rows are to be considered distinct:

{% highlight sql %}
SELECT DISTINCT ON (expression [, expression ...]) select_list ...
{% endhighlight %}

Here expression is an arbitrary value expression that is evaluated for all rows. A set of rows for which all the expressions are equal are considered duplicates, and only the first row of the set is kept in the output. Note that the “first row” of a set is unpredictable unless the query is sorted on enough columns to guarantee a unique ordering of the rows arriving at the `DISTINCT` filter. (`DISTINCT ON` processing occurs after `ORDER BY` sorting.)

The `DISTINCT ON` clause is not part of the SQL standard and is sometimes considered bad style because of the potentially indeterminate nature of its results. With judicious use of `GROUP BY` and subqueries in `FROM`, this construct can be avoided, but it is often the most convenient alternative.

For examples,Saya mau memangil data dari table `employees` untuk menampilkan kolom `employee_id` dan `job_id` berikut querynya:

{% highlight sql %}
select job_id from employees;
{% endhighlight %}

Jika saya jalankan maka hasilnya seperti berikut:

```sql
hr=# select job_id from employees;

   job_id   
------------
 AD_PRES
 AD_VP
 AD_VP
 IT_PROG
 IT_PROG
 IT_PROG
 FI_MGR
 FI_ACCOUNT
 FI_ACCOUNT
 PU_CLERK
...
(107 rows)
```

Jika kita mau meng-eliminasi nilai redudansi atau supaya unique datanya kita bisa menggunakan query seperti berikut:

{% gist page.gist "03a-select-distinct.sql" %}

Jika saya jalankan maka hasilnya seperti berikut:

```sql
hr=# select distinct job_id from employees;
   job_id
------------
 SH_CLERK
 AD_VP
 SA_MAN
 PU_MAN
 IT_PROG
 ST_CLERK
 FI_MGR
 PU_CLERK
 HR_REP
 ST_MAN
 MK_MAN
 AC_MGR
 SA_REP
 AD_ASST
 PR_REP
 MK_REP
 AD_PRES
 FI_ACCOUNT
 AC_ACCOUNT
(19 rows)
```

Selain itu juga kita bisa gunakan multiple column selection untuk Distinct ini, contohnya seperti berikut:

{% gist page.gist "03a-select-distinct-multiple-columns.sql" %}

Jika dijalankan hasilnya seperti berikut:

```sql
hr=# select distinct (job_id, manager_id),
hr-#        job_id,
hr-#        manager_id
hr-# from employees;
       row        |   job_id   | manager_id
------------------+------------+------------
 (AC_ACCOUNT,205) | AC_ACCOUNT |        205
 (AC_MGR,101)     | AC_MGR     |        101
 (AD_ASST,101)    | AD_ASST    |        101
 (AD_PRES,)       | AD_PRES    |
 (AD_VP,100)      | AD_VP      |        100
 (FI_ACCOUNT,108) | FI_ACCOUNT |        108
 (FI_MGR,101)     | FI_MGR     |        101
 (HR_REP,101)     | HR_REP     |        101
 (IT_PROG,102)    | IT_PROG    |        102
 (IT_PROG,103)    | IT_PROG    |        103
 (MK_MAN,100)     | MK_MAN     |        100
 (MK_REP,201)     | MK_REP     |        201
 (PR_REP,101)     | PR_REP     |        101
 (PU_CLERK,114)   | PU_CLERK   |        114
 (PU_MAN,100)     | PU_MAN     |        100
 (SA_MAN,100)     | SA_MAN     |        100
(32 rows)
```