---
layout: post
title: "Build-in Operators"
date: 2022-02-28T11:11:32+07:00
lang: postgresql
authors:
- dimasm93
categories:
- RDBMS
- PostgreSQL
- sql
- select
refs: 
- https://www.postgresql.org/docs/14/
- https://www.postgresql.org/docs/14/typeconv.html
youtube: 
image_path: /resources/posts/postgresql/03b-sql-operators
comments: true
gist: dimMaryanto93/7ae7632f9418feb724bc431eff412a3f
catalog_key: select-statement
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas Operators pada PostgreSQL, PostgreSQL provides a large number of operators for the built-in data types. Users can also define their own operators, as described in previews section but for now we explain build-in operators. 

ada banyak selali Operators, kita akan bahas beberapa yang menurut saya penting untuk di pelajari pada cource ini diantaranya:

1. Math operators
2. Concate operators
3. Typecast operators
4. Logic operators
5. Comparation operators

Ok langsung aja kita bahas materi yang pertama

<!--more-->

## Math operators

Dalam SQL, kita juga bisa melakukan operasi matematika seperti pertambahan, pengurangan, pembagian, dan perkalian. Operasi tersebut dibagi-bagi lagi menjadi beberapa tipe yaitu

1. Operasi yang bernilai bilangan,
2. Operasi yang bernilai Date,
3. Operasi yang bernilai karakter

Operasi pada bilangan pada dasarnya sama seperti operasi matematika biasa, seperti berikut table operasinya:

| Operator 	  |   Description     |	Example         |	Result  |
| :------- 	  |   :----------     |	:------         |	:-----  |
| `+` 	      |   addition 	      | `2 + 3`         |       `5` |
| `-` 	      |   subtraction 	  | `2 - 3`         |      `-1` |
| `*` 	      |   multiplication  | `2 * 3`         |       `6` |
| `/` 	      |   division        |	`4 / 2`         |       `2` |
| `%` 	      |   modulo          | `5 % 4`         |       `1` |
| `^` 	      |   exponentiation  | `2.0 ^ 3.0`     |       `8` |
| `@` 	      |   absolute value  | `@ -5.0`        | 	    `5` |

Contoh penggunaan dalam SQL seperti berikut:

{% gist page.gist "03b-select-math-operator.sql" %}

Jika di running maka hasilnya seperti berikut:

```bash
 tambah | kali | bagi | pangkat | abs | mod
--------+------+------+---------+-----+-----
      4 |    4 |    1 |       8 | 5.3 |   0
(1 row)
```

Contoh lainnya, menggunakan penjumlahan dalam suatu table, seperti berikut:

{% gist page.gist "03b-select-math-column-operation.sql" %}

Jika dijalankan hasilnya seperti berikut:

```bash
 first_name  | gaji_plus 
-------------+-----------
 Steven      |  25000.00
 Neena       |  18000.00
 Lex         |  18000.00
 Bruce       |   7000.00
 Nancy       |  13000.00
 Daniel      |  10000.00
 John        |   9200.00
 Ismael      |   8700.00
 Jose Manuel |   8800.00
```

Operasi matematika pada tanggal juga bisa dilakukan, diantaranya seperti berikut:

{% gist page.gist "03b-select-math-date-operator.sql" %}

```bash
    lusa    |   besok    | kurang 2 hari |     kurang 2jam     | tambah 1 hari | durasi dalam hari |    kurang 15jam     | target harus selesai |   jam makan siang
------------+------------+---------------+---------------------+---------------+-------------------+---------------------+----------------------+---------------------
 2022-02-23 | 2022-02-26 | 2017-03-26    | 2017-03-27 22:00:00 | 2017-03-29    |                15 | 2017-03-28 03:20:00 | 2017-04-23 00:00:00  | 2017-03-02 12:19:30
(1 row)
```

## Concate operators

Apa itu concatenation?, Concatenation biasanya digunakan untuk mengkombinasikan, menyambungkan beberapa kolom dalam suatu query menjadi satu. seperti berikut ilustrasinya:

![konsep-concat]({{ page.image_path | prepend: site.baseurl }}/01-konsep-concatenation.png)

Ok misalnya saya punya struktur tabel seperti berikut:

```shell
hr=# \d employees;
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

Nah saya mau mengambil semua data dari table `employees` untuk menampilkan `kode karyawan` dan `nama depan + nama belakang` digabungkan menjadi satu kolom. Berikut adalah contoh querynya: 

{% gist page.gist "03b-select-concate-operator.sql" %}

Berikut hasilnya:

```postgresql
id  |   nama_lengkap
-----+-------------------
 100 | Steven King
 101 | Neena Kochhar
 102 | Lex De Haan
 103 | Alexander Hunold
 104 | Bruce Ernst
 105 | David Austin
 106 | Valli Pataballa
 107 | Diana Lorentz
 ....
 (107 rows)
```

## Typecast operators

SQL is a strongly typed language. That is, every data item has an associated data type which determines its behavior and allowed usage. PostgreSQL has an extensible type system that is more general and flexible than other SQL implementations.

Select the operators to be considered from the `pg_operator` system catalog. If a non-schema-qualified operator name was used (the usual case), the operators considered are those with the matching name and argument count that are visible in the current search path. 

PostgreSQL supports a CAST operator that is used to convert a value of one type to another:

{% highlight sql %}
select CAST ( expression AS target_type );
{% endhighlight %}

The following statement converts:

{% gist page.gist "03b-select-type-cast-string.sql" %}

Jika dijalankan maka hasilnya seperti berikut:

```sql
hr=# select cast ('100' as int) as string_to_int,
hr-#        cast ('10.3' as double precision) as string_to_double,
hr-#        cast ('28-FEB-2022' as date) as string_to_date,
hr-#        'dimasm' || cast (93 as varchar) as int_to_string,
hr-#        cast(0 as boolean) as int_to_boolean;
 string_to_int | string_to_double | string_to_date | int_to_string | int_to_boolean
---------------+------------------+----------------+---------------+----------------
           100 |             10.3 | 2022-02-28     | dimasm93      | f
```

## Logical operator

The usual logical operators are available:

{% highlight sql %}
boolean AND boolean → boolean
boolean OR boolean → boolean
NOT boolean → boolean
{% endhighlight %}

SQL uses a three-valued logic system with `true`, `false`, and `null`, which represents “unknown”. Observe the following truth tables:

{% gist page.gist "03b-select-logical-operator.sql" %}

Berikut hasilnya:

```bash
 AND -> true x true | AND -> true x false | AND -> false x false | AND -> null x false | AND -> null x true | OR -> true x true | OR -> true x false | OR -> false x false | OR -> null x true | OR -> null x false | NOT -> false | NOT -> null | NOT -> true
--------------------+---------------------+----------------------+---------------------+--------------------+-------------------+--------------------+---------------------+-------------------+--------------------+--------------+-------------+-------------
 t                  | f                   | f                    | f                   |                    | t                 | t                  | f                   | t                 |                    | t            |             | f
(1 row)
```

Atau kalo kita gambarin tabelnya seperti berikut untuk `AND` dan `OR` Operators:

| Operator  | true x false  | false x false | true x true   | null x true   | null x false  |
|:----------|:--------------|:--------------|:--------------| :----------   | :----------   |
| AND       | false         | false         | true          | -             | false         |
| OR        | true          | false         | true          | true          | -             |

Sedangkan berikut untuk `NOT` Operator:

| Operator  | false         | true          | null      |
|:----------|:--------------|:--------------| :-------- |
| NOT       | true          | false         | -         |

The operators `AND` and `OR` are commutative, that is, you can switch the left and right operands without affecting the result. (However, it is not guaranteed that the left operand is evaluated before the right operand.

## Comparation operators

The usual comparison operators are available, as shown in below

| Operators                         | Description               |
| :-------                          | :-----                    |
| `datatype < datatype → boolean`   | Less than                 |
| `datatype > datatype → boolean`   | Greater than              |
| `datatype <= datatype → boolean`  | Less than or equal to     |
| `datatype >= datatype → boolean`  | Greater than or equal to  |
| `datatype = datatype → boolean`   | Equal                     |
| `datatype != datatype → boolean`  | Not Equal                 |
| `datatype <> datatype → boolean`  | Not Equal                 |

These comparison operators are available for all built-in data types that have a natural ordering, including numeric, string, and date/time types. In addition, arrays, composite types, and ranges can be compared if their component data types are comparable.

There are also some comparison predicates, as shown in below. These behave much like operators, but have special syntax mandated by the SQL standard.

| Operators                                             | Description                                               | Examples                          |
| :-------                                              | :-----                                                    | :------                           |
| `IS NULL`                                             | Test whether value is null.                               | `1.5 IS NULL → f`                 |
| `IS NOT NULL`                                         | Test whether value is not null.                           | `1.5 IS NOT NULL → t`             |
| `IS TRUE/FALSE`                                       | Test whether boolean expression yields true/false.        | `NULL::boolean IS TRUE → f`       |
| `IS NOT TRUE/FALSE`                                   | Test whether boolean expression yields true/false.        | `NULL::boolean IS NOT TRUE → f`   |
| `IS UNKNOWN`                                          | Test whether boolean expression yields unknown.           | `NULL::boolean IS UNKNOWN → t`    |
| `IS NOT UNKNOWN`                                      | Test whether boolean expression yields true or false.     | `NULL::boolean IS NOT UNKNOWN → f`|
| `datatype BETWEEN datatype AND datatype → boolean`    | inclusive of the range endpoints.                         | `2 BETWEEN 1 AND 3 → t`           |
| `datatype NOT BETWEEN datatype AND datatype → boolean`| the negation of BETWEEN                                   | `2 NOT BETWEEN 1 AND 3 → f`       |

For examples:

{% gist page.gist "03b-select-comparison-operator.sql" %}

Jika dijalankan maka hasilnya seperti berikut:

```sql
hr=# select 3 > 4 as compare_less_than,
hr-#        'nilai tidak sama' <> 'nilai sama' as compare_string_no_equal,
hr-#        '28-FEB-2022'::DATE = '28-FEB-2021'::DATE as compare_date_equal, -- '28-FEB-2022'::DATE sama seperti CAST('28-FEB-2022' as date)
hr-#        2800000 IS NOT NULL as compare_not_null,
hr-#        'off'::boolean IS NOT TRUE as compare_not_true; -- 'off'::boolean sama seperti CAST('off' as boolean)
 compare_less_than | compare_string_no_equal | compare_date_equal | compare_not_null | compare_not_true
-------------------+-------------------------+--------------------+------------------+------------------
 f                 | t                       | f                  | t                | t
(1 row)
```
