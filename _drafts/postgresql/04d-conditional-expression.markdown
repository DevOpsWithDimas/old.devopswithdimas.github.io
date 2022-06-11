---
layout: post
title: "Conditional Expressions"
lang: postgresql
authors:
- dimasm93
categories:
- RDBMS
- PostgreSQL
- sql
- select
refs: 
- https://www.postgresql.org/docs/14/functions-conditional.html
youtube: 
image_path: /resources/posts/postgresql/03j-conditional-expression
comments: true
gist: dimMaryanto93/7ae7632f9418feb724bc431eff412a3f
catalog_key: select-statement
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang Conditional Expression Seperti biasa karena materinya akan lumayan panjang jadi kita bagi jadi beberapa bagian diantaranya:

1. What is Conditional Expression?
2. Using `CASE-WHEN-ELSE` expression
3. Using `COALESCE` expression
4. Using `NULLIF` expression
5. Using `GREATEST` and `LEAST` expression

Ok langsung aja kita bahas materi yang pertama

<!--more-->

## What is Conditional Expression?

Conditional statements/Expression in the SQL help you to define different logics and actions for different conditions. It allows you to perform different actions based on conditions defined within the statement. In real life, you perform many actions dependent on the outcome of some other activity or situation.

Some real-time examples of SQL case statement are:

1. If it rains tomorrow, I will plan on a road trip.
2. If flight tickets are less than $400 from my city, then I will go on vacation in Europe, else I will prefer some nearby tourist spot.

Di PostgreSQL, kita bisa menggunakan Conditional Statement/Expression dengan beberapa cara

1. Case-When-Else
2. Coalesce
3. NullIF
4. Greatest or Least

Untuk lebih detail, yukk kita bahas satu-per-satu

## Using `CASE-WHEN-ELSE` expression

The SQL CASE expression is a generic conditional expression, similar to if/else statements in other programming languages:

{% highlight sql %}
CASE WHEN condition THEN result
     [WHEN ...]
     [ELSE result]
END
{% endhighlight %}

CASE clauses can be used wherever an expression is valid. Each **condition** is an expression that **returns a boolean result**. If the condition's result is `true`, the value of the CASE expression is the result that follows the condition, and the remainder of the CASE expression is not processed. If the condition's result is `not true`, any subsequent `WHEN` clauses are examined in the same manner. If no WHEN condition yields `true`, the value of the CASE expression is the result of the `ELSE` clause. If the `ELSE` clause is omitted and no condition is `true`, the result is `null`. 

Jika kita gambarkan secara diagram flowchart seperti berikut:

{% mermaid %}
flowchart LR
    data --> condition1{ Condition }
    condition1 -- true --> conditionOk[ return OK ]
    condition1 -- false --> condition2{ More Condition }
    condition2 -- true --> conditionOk2[ return Yes ]
    condition2 -- false --> End
{% endmermaid %}

Berikut adalah contoh penggunaan dalam SQL:

{% gist page.gist "04d-select-case-when.sql" %}

Jika dijalankan hasilnya seperti berikut:

```sql
hr=# select employee_id    as kode_karyawan,
       commission_pct as besar_komisi,
       case
           when COALESCE(commission_pct, 0) = 0
               then 'Tidak memiliki komisi'
           else
               concat('Memiliki komisi sebesar ', commission_pct)
           end        as deskripsi
from employees
limit 15;
 kode_karyawan | besar_komisi |       deskripsi
---------------+--------------+-----------------------
           100 |              | Tidak memiliki komisi
           101 |              | Tidak memiliki komisi
           102 |              | Tidak memiliki komisi
           103 |              | Tidak memiliki komisi
           104 |              | Tidak memiliki komisi
           105 |              | Tidak memiliki komisi
           106 |              | Tidak memiliki komisi
           107 |              | Tidak memiliki komisi
           108 |              | Tidak memiliki komisi
           109 |              | Tidak memiliki komisi
           110 |              | Tidak memiliki komisi
           111 |              | Tidak memiliki komisi
           112 |              | Tidak memiliki komisi
           113 |              | Tidak memiliki komisi
           114 |              | Tidak memiliki komisi
(15 rows)
```

## Using `COALESCE` expression