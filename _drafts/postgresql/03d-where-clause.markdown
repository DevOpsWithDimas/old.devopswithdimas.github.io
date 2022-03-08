---
layout: post
title: "Filtering data with WHERE clause"
lang: postgresql
categories:
- RDBMS
- PostgreSQL
- sql
- select
refs: 
- https://www.postgresql.org/docs/current/
youtube: 
image_path: /resources/posts/postgresql/03d-where-clause
comments: true
gist: dimMaryanto93/7ae7632f9418feb724bc431eff412a3f
catalog_key: sql-statement
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang mem-Filter data dengan menggunakan `WHERE` clause di PostgreSQL. By default jika kita menggunakan perintah `select` itu akan menampilkan semua data pada suatu atau berberapa table. Dengan menggunakan clause WHERE kita bisa memfilter atau memilih data yang akan kita tampilkan. 

Perintah dasar untuk `WHERE` clause seperti berikut:

{% highlight sql %}
select * | column_list ...
from a_table
where search_condition
{% endhighlight %}

Dimana `search_condition` adalah any value expression (`functions`, `operators` and `predicates` ) yang mengembalikan nilai boolean. Sebagai gambaran berikut ilustrasinya:

![filter-data]({{ page.image_path | prepend: site.baseurl }}/01-consept-where-cluase.png)

Ilustrasi tersebut menggambarkan, suatu predicate atau `search_condition` yaitu menggunakan operator equal pada column `status` dengan nilai `active` maka database akan mencari nilainya `active` saja pada kolom `status`. Untuk `search_condition` tersebut biasanya di sebut dengan predicate. Ada banyak sekali predicate yang kita bisa gunakan tapi disini kita bahasnya paling dasar dulu ya yaitu:

1. Relational predicate
2. Like predicates
3. Between predicates
4. Null predicate
5. Logical predicate
6. Regular Expression (Regex) predicate
7. Array comparision

Ok kita bahas satu-per-satu ya, mulai dari relational predicate

## Relational predicate

Relational predicates pada dasarnya adalah [comparison operators]({% post_url postgresql/03-select-statements/2022-02-28-03b-sql-operators %}#comparation-operators) yaitu

1. Equal (`=`)
2. Not Equals (`!=` or `<>`)
3. Less than or equal to (`<` or `<=`)
4. Greater then or equal to (`>` or `>=`)

Contoh penggunaannya seperti berikut:

{% gist page.gist "03d-select-where-relation-eq.sql" %}

Contoh lainnya seperti berikut:

{% gist page.gist "03d-select-where-relation-greater-than.sql" %}

Jika dijalankan maka hasilnya seperti berikut:

```postgresql-console
hr=# select employee_id, first_name, last_name, email, phone_number, job_id, salary
hr-# from employees
hr-# where salary >= 20000;
 employee_id | first_name | last_name | email | phone_number | job_id  |  salary
-------------+------------+-----------+-------+--------------+---------+----------
         100 | Steven     | King      | SKING | 515.123.4567 | AD_PRES | 24000.00
(1 row)
```

Nah jadi kita kita perhatikan dari hasil query tersebut, kita memfilter menggunakan operator `>=` atau lebih besar sama dengan hasilnya tidak ada yang salarnya lebih kecil dari kita definisikan yaitu `20_000`.

## Like predicates

Operator `like` biasanya digunakan untuk tipe data `string` (`varchar`, `text`), ada 2 expresion yang kita bisa gunakan di operator ini yaitu 

1. `_` atau underscore, digunakan untuk mewakili expresion satu karakter.
2. `%` atau persent, digunakan untuk mewakili expresion beberapa karakter.

Contoh kasus untuk expresion `%`, saya ingin mencari nama depan karyawan yang diawali oleh huruf `A`. Berikut querynya:

{% gist page.gist "03d-select-where-like-percent.sql" %}

Jika dijalankan hasilnya seperti berikut:

```postgresql-console
hr=# select employee_id, first_name, last_name, email, phone_number, job_id, salary
hr-# from employees
hr-# where last_name like 'A%';
 employee_id | first_name | last_name |  email   |    phone_number    |  job_id  |  salary
-------------+------------+-----------+----------+--------------------+----------+----------
         105 | David      | Austin    | DAUSTIN  | 590.423.4569       | IT_PROG  |  4800.00
         130 | Mozhe      | Atkinson  | MATKINSO | 650.124.6234       | ST_CLERK |  2800.00
         166 | Sundar     | Ande      | SANDE    | 011.44.1346.629268 | SA_REP   |  6400.00
         174 | Ellen      | Abel      | EABEL    | 011.44.1644.429267 | SA_REP   | 11000.00
(4 rows)
```

Sedangkan untuk contoh expresion `_`, saya ingin mencari huruf ke 2 dari kolom `job_id` di tabel `jobs` mengadung `t`. Berikut querynya:

{% gist page.gist "03d-select-where-like-underscore.sql" %}

Jika dijalankan hasilnya seperti berikut:

```postgresql-console
hr=# select employee_id, first_name, last_name, email, phone_number, job_id, salary
hr-# from employees
hr-# where last_name like '_t%';
 employee_id | first_name | last_name |  email   | phone_number |  job_id  | salary
-------------+------------+-----------+----------+--------------+----------+---------
         130 | Mozhe      | Atkinson  | MATKINSO | 650.124.6234 | ST_CLERK | 2800.00
         138 | Stephen    | Stiles    | SSTILES  | 650.121.2034 | ST_CLERK | 3200.00
(2 rows)
```

## Between predicates

Operator `BETWEEN` digunakan untuk memfilter dengan interval/rentang tertentu diantar nilai terkecil dan terbesar biasanya digunakan untuk tipe data seperti `number`, `date`, `time`, `datetime` serta `char`. 

Contoh kasusnya, Saya mau menampilkan data yang karywan yang memiliki gaji dari `4000` s/d `6000`. Berikut querynya:

{% gist page.gist "03d-select-where-between-number.sql" %}

Jika dijalankan hasilnya seperti berikut:

```postgresql-console
hr=# select employee_id, first_name, last_name, email, phone_number, job_id, salary
hr-# from employees
hr-# where salary between 17000 and 20000;
 employee_id | first_name | last_name |  email   | phone_number | job_id |  salary
-------------+------------+-----------+----------+--------------+--------+----------
         101 | Neena      | Kochhar   | NKOCHHAR | 515.123.4568 | AD_VP  | 17000.00
         102 | Lex        | De Haan   | LDEHAAN  | 515.123.4569 | AD_VP  | 17000.00
(2 rows)
```

Atau berikut contoh lainnya, saya mau mengambil `first_name` yang mengandung huruf `h` sampai `j` pada character ke 2. maka querynya seperti berikut:

{% gist page.gist "03d-select-where-between-char.sql" %}

Jika dijalankan hasilnya seperti berikut:

```postgresql-console
hr=# select employee_id, first_name, last_name
hr-# from employees
hr-# where substring(first_name from 2 for 1) between 'h' and 'j';
 employee_id | first_name  | last_name
-------------+-------------+-----------
         107 | Diana       | Lorentz
         116 | Shelli      | Baida
         117 | Sigal       | Tobias
         205 | Shelley     | Higgins
         206 | William     | Gietz
(18 rows)
```

## Null predicate

Operator `IS NULL` digunakan untuk memfiter data yang bernilai `null`. 

Contoh kasusnya, saya mau menampilkan data karywan yang tidak memiliki manager. Berikut querynya:

{% gist page.gist "03d-select-where-isnull.sql" %}

Jika dijalankan hasilnya seperti berikut:

```postgresql-console
hr=# select employee_id, first_name, last_name, job_id, manager_id
hr-# from employees
hr-# where manager_id is null;
 employee_id | first_name | last_name | job_id  | manager_id
-------------+------------+-----------+---------+------------
         100 | Steven     | King      | AD_PRES |
(1 row)
```

## Logical predicate

Logical predicate pada dasarnya sama seperti [logical operators]({% post_url postgresql/03-select-statements/2022-02-28-03b-sql-operators %}#logic-operators) yaitu

1. `and` operators
2. `or` operators
3. `not` operators

Kasusnya saya mau mencari data karyawan yang berkerja di `department_id = 90` dan yang `manager_id = 100` berarti kita bisa menggunakan operator `and`, berikut querynya:

{% gist page.gist "03d-select-where-logic-and.sql" %}

Jika kita jalankan maka hasilnya seperti berikut:

```postgresql-console
hr=# select employee_id, first_name, last_name, department_id, manager_id
hr-# from employees
hr-# where department_id = 90 and manager_id = 100;
 employee_id | first_name | last_name | department_id | manager_id
-------------+------------+-----------+---------------+------------
         101 | Neena      | Kochhar   |            90 |        100
         102 | Lex        | De Haan   |            90 |        100
(2 rows)
```

Dan sedangkan untuk operator `or` seperti berikut:

{% gist page.gist "03d-select-where-logic-or.sql" %}

Jika kita jalankan maka hasilnya seperti berikut:

```postgresql-console
hr=# select employee_id, first_name, last_name, department_id, manager_id
hr-# from employees
hr-# where department_id = 90 or manager_id = 100;
 employee_id | first_name | last_name | department_id | manager_id
-------------+------------+-----------+---------------+------------
         100 | Steven     | King      |            90 |
         101 | Neena      | Kochhar   |            90 |        100
         102 | Lex        | De Haan   |            90 |        100
         114 | Den        | Raphaely  |            30 |        100
         120 | Matthew    | Weiss     |            50 |        100
         121 | Adam       | Fripp     |            50 |        100
         122 | Payam      | Kaufling  |            50 |        100
         123 | Shanta     | Vollman   |            50 |        100
         124 | Kevin      | Mourgos   |            50 |        100
         145 | John       | Russell   |            80 |        100
         146 | Karen      | Partners  |            80 |        100
         147 | Alberto    | Errazuriz |            80 |        100
         148 | Gerald     | Cambrault |            80 |        100
         149 | Eleni      | Zlotkey   |            80 |        100
         201 | Michael    | Hartstein |            20 |        100
(15 rows)
```

Dan yang terakhir kita juga bisa menggunakan `not` operator seperti berikut:

{% gist page.gist "03d-select-where-logic-not.sql" %}

Jika di jalankan maka hasilnya sebagai berikut:

```postgresql-console
hr=# select employee_id, first_name, last_name, job_id, manager_id, salary
hr-# from employees
hr-# where salary not between 3000 and 20000;
 employee_id | first_name |  last_name  |  job_id  | manager_id |  salary
-------------+------------+-------------+----------+------------+----------
         100 | Steven     | King        | AD_PRES  |            | 24000.00
         116 | Shelli     | Baida       | PU_CLERK |        114 |  2900.00
         117 | Sigal      | Tobias      | PU_CLERK |        114 |  2800.00
         118 | Guy        | Himuro      | PU_CLERK |        114 |  2600.00
         119 | Karen      | Colmenares  | PU_CLERK |        114 |  2500.00
         126 | Irene      | Mikkilineni | ST_CLERK |        120 |  2700.00
         127 | James      | Landry      | ST_CLERK |        120 |  2400.00
         128 | Steven     | Markle      | ST_CLERK |        120 |  2200.00
(25 rows)
```

## Regular Expression (Regex) predicate

The `SIMILAR TO` operator returns `true` or `false` depending on whether its pattern matches the given string. It is similar to `LIKE`, except that it interprets the pattern using the SQL standard's definition of a [regular expression](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Regular_Expressions).

In addition to these facilities borrowed from `LIKE`, `SIMILAR TO` supports these pattern-matching metacharacters borrowed from `POSIX` regular expressions:

1. `|` denotes alternation (either of two alternatives).
2. `*` denotes repetition of the previous item zero or more times.
3. `+` denotes repetition of the previous item one or more times.
4. `?` denotes repetition of the previous item zero or one time.
5. `{m}` denotes repetition of the previous item exactly m times.
6. `{m,}` denotes repetition of the previous item m or more times.
7. `{m,n}` denotes repetition of the previous item at least m and not more than n times.
8. `()` can be used to group items into a single logical item.
9. `[...]` specifies a character class, just as in POSIX regular expressions.

Some examples:

{% highlight sql %}
'abc' SIMILAR TO 'abc'          true
'abc' SIMILAR TO 'a'            false
'abc' SIMILAR TO '%(b|d)%'      true
'abc' SIMILAR TO '(b|c)%'       false
'-abc-' SIMILAR TO '%\mabc\M%'  true
'xabcy' SIMILAR TO '%\mabc\M%'  false
{% endhighlight %}

Salah satu penggunaanya seperti berikut:

{% gist page.gist "03d-select-where-similar-to.sql" %}

Jika di jalankan maka hasilnya seperti berikut:

```postgresql-console
hr=# select employee_id, first_name, phone_number, job_id
hr-# from employees
hr-# where first_name similar to 'Ste(v|ph)en';
 employee_id | first_name | phone_number |  job_id
-------------+------------+--------------+----------
         100 | Steven     | 515.123.4567 | AD_PRES
         128 | Steven     | 650.124.1434 | ST_CLERK
         138 | Stephen    | 650.121.2034 | ST_CLERK
(3 rows)
```

Selain menggunakan `SIMILAR TO` Operators kita juga bisa menggunakan `POSIX` regular expression yang lebih powerfull dibadingkan `LIKE` dan `SIMILAR TO`. Many Unix tools such as `egrep`, `sed`, or `awk` use a pattern matching language that is similar to the one described here.

Some examples:

{% highlight sql %}
'abcd' ~ 'bc'     true
'abcd' ~ 'a.c'    true -- dot matches any character
'abcd' ~ 'a.*d'   true -- * repeats the preceding pattern item
'abcd' ~ '(b|x)'  true -- | means OR, parentheses group
'abcd' ~ '^a'     true -- ^ anchors to start of string
'abcd' ~ '^(b|c)' false -- would match except for anchoring
{% endhighlight %}

Salah satu penggunaanya seperti berikut:

{% gist page.gist "03d-select-where-posix.sql" %}

Jika di jalankan maka hasilnya seperti berikut:

```postgresql-console
hr=# select employee_id, first_name, phone_number, job_id
hr-# from employees
hr-# where first_name ~ '^S.*(a|v|ph)';
 employee_id | first_name |    phone_number    |  job_id
-------------+------------+--------------------+----------
         100 | Steven     | 515.123.4567       | AD_PRES
         117 | Sigal      | 515.127.4564       | PU_CLERK
         123 | Shanta     | 650.123.4234       | ST_MAN
         128 | Steven     | 650.124.1434       | ST_CLERK
         138 | Stephen    | 650.121.2034       | ST_CLERK
         161 | Sarath     | 011.44.1345.529268 | SA_REP
         166 | Sundar     | 011.44.1346.629268 | SA_REP
         173 | Sundita    | 011.44.1343.329268 | SA_REP
         192 | Sarah      | 650.501.1876       | SH_CLERK
         194 | Samuel     | 650.501.3876       | SH_CLERK
         203 | Susan      | 515.123.7777       | HR_REP
(11 rows)
```