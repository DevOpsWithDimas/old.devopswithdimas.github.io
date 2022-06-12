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
2. `CASE-WHEN` expression
    1. Using `CASE-WHEN-ELSE` expression
    2. Using Nested `CASE-WHEN` expression
    3. Using `CASE-WHEN` expression in `WHERE` clause
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
    condition1 -- false --> End[ return null ]
{% endmermaid %}

Berikut adalah contoh penggunaan dalam SQL:

{% gist page.gist "04d-select-case-when.sql" %}

Jika dijalankan hasilnya seperti berikut:

```sql
hr=# select employee_id    as kode_karyawan,
       commission_pct as besar_komisi,
       case
           when commission_pct is null
               then 'Tidak memiliki komisi'
           end
from employees;
 kode_karyawan | besar_komisi |         case          
---------------+--------------+-----------------------
           100 |              | Tidak memiliki komisi
           101 |              | Tidak memiliki komisi
           102 |              | Tidak memiliki komisi
           103 |              | Tidak memiliki komisi
           104 |              | Tidak memiliki komisi
           105 |              | Tidak memiliki komisi
           145 |         0.40 | 
           146 |         0.30 | 
           147 |         0.30 | 
           148 |         0.30 | 
           149 |         0.20 | 
           150 |         0.30 | 
           151 |         0.25 | 
           152 |         0.25 | 

(107 rows)
```

## Using `CASE-WHEN-ELSE` expression

Selanjutnya kita akan membahas, `CASE-WHEN-ELSE` expression seperti berikut klo kita gambarkan secara diagram flowchart nya:

{% mermaid %}
flowchart LR
    data --> condition1{ Condition }
    condition1 -- true --> conditionOk[ return OK ]
    condition1 -- false --> condition2{ More Condition }
    condition2 -- true --> conditionOk[ return OK ]
    condition2 -- else --> End[ return Something ]
{% endmermaid %}

Jadi disini kita memiliki lebih dari 2 kondisi, dimana ke dua kondisi tersebut memiliki nilai `return OK` sedangkan selain itu (`else`) `return something`. Berikut implementasi pada query sql:

{% gist page.gist "04d-select-case-when-else.sql" %}

Jika dijalankan hasilnya seperti berikut:

```sql
hr=# select employee_id    as kode_karyawan,
hr-#        commission_pct as besar_komisi,
hr-#        case
hr-#            when commission_pct is null
hr-#                then 'Tidak memiliki komisi'
hr-#            when commission_pct >= 0.2
hr-#                then 'Memiki komisi lebih besar dari 20%'
hr-#            else 'Memiliki komisi lebih kecil dari 10%'
hr-#            end
hr-# from employees
hr-# limit 50;
 kode_karyawan | besar_komisi |                case                
---------------+--------------+------------------------------------
           100 |              | Tidak memiliki komisi
           101 |              | Tidak memiliki komisi
           102 |              | Tidak memiliki komisi
           103 |              | Tidak memiliki komisi
           104 |              | Tidak memiliki komisi
           144 |              | Tidak memiliki komisi
           145 |         0.40 | Memiki komisi lebih besar dari 20%
           146 |         0.30 | Memiki komisi lebih besar dari 20%
           147 |         0.30 | Memiki komisi lebih besar dari 20%
           148 |         0.30 | Memiki komisi lebih besar dari 20%
           149 |         0.20 | Memiki komisi lebih besar dari 20%
(50 rows)
```

## Using Nested `CASE-WHEN` expression

Selanjutnya kita akan membahas, Nested `CASE-WHEN` expression. Sama halnya seperti bahasa pemograman kita juga bisa menggunakan percabangan dalam percabangan atau istilah kerennya Nested Condition. Jika kita gambarkan flowchart-nya seperti berikut:

{% mermaid %}
flowchart LR
    data --> condition1{ Outer Condition }
    condition1 -- true --> condition2{ Inner Condition }
    condition1 -- false --> End[ return Null ]
    condition2 -- true --> conditionOk[ return OK ]
    condition2 -- else --> End[ return Something ]
{% endmermaid %}

Berikut adalah contoh implementasi SQLnya:

{% gist page.gist "04d-select-nested-case-when-else.sql" %}

Jika dijalankan hasilnya seperti berikut:

```sql
hr=# select employee_id    as kode_karyawan,
hr-#        commission_pct as besar_komisi,
hr-#        case
hr-#            when commission_pct is not null
hr-#                then
hr-#                case
hr-#                    when commission_pct <= 0.1
hr-#                        then 'Komisi sebesar 10%'
hr-#                    when commission_pct <= 0.2
hr-#                        then 'Komisi sebesar 20%'
hr-#                    when commission_pct <= 0.3
hr-#                        then 'Komisi sebesar 30%'
hr-#                    else 'Komisi lebih besar dari 30%'
hr-#                    end
hr-#            else 'Tidak memiliki komisi'
hr-#            end
hr-# from employees
hr-# limit 60;
 kode_karyawan | besar_komisi |            case             
---------------+--------------+-----------------------------
           100 |              | Tidak memiliki komisi
           101 |              | Tidak memiliki komisi
           102 |              | Tidak memiliki komisi
           103 |              | Tidak memiliki komisi
           104 |              | Tidak memiliki komisi
           105 |              | Tidak memiliki komisi
           106 |              | Tidak memiliki komisi
           145 |         0.40 | Komisi lebih besar dari 30%
           146 |         0.30 | Komisi sebesar 30%
           147 |         0.30 | Komisi sebesar 30%
           148 |         0.30 | Komisi sebesar 30%
           153 |         0.20 | Komisi sebesar 20%
           154 |         0.20 | Komisi sebesar 20%
           155 |         0.15 | Komisi sebesar 20%
           156 |         0.35 | Komisi lebih besar dari 30%
           157 |         0.35 | Komisi lebih besar dari 30%
           158 |         0.35 | Komisi lebih besar dari 30%
(60 rows)
```