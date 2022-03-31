---
layout: post
title: "Handle Sub Query Multiple rows Result dengan where operator"
date: 2021-02-18T17:03:14+07:00
lang: oracle18c
authors:
- dimasm93
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/Using-Subqueries.html#GUID-53A705B6-0358-4E2B-92ED-A83DE83DFD20
youtube: nEVssSopvHc
comments: true
catalog_key: sql-subquery
image_path: /resources/posts/oracle12c/
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Multi row sub-query adalah sub-query yang menghasilkan lebih dari satu row pada inner query. contohnya seperti berikut:

<!--more-->

{% highlight sql %}
SQL> select *
from EMPLOYEES
where DEPARTMENT_ID = (
    select dep.DEPARTMENT_ID
    from DEPARTMENTS dep
);  


select dep.DEPARTMENT_ID
    *
ERROR at line 4:
ORA-01427: single-row subquery returns more than one row

SQL>
{% endhighlight %}

Nah jadi untuk menghandle inner query yang menghasilkan banyak baris, berikut adalah predicates yang kita bisa gunakan:

| Operation | Keterangan    |
| :---      | :---          |
| `IN`      | Nilai pembanding sama dengan `=` tetapi kita bisa memberikan banyak nilai sebagai pembanding |
| `ANY`     | Nilai pembanding dari sekumpulan data yang ada, Operator terdiri dari `> ANY`, `< ANY` dan `= ANY` |
| `SOME`    | sama seperti `any` |
| `ALL`     | Nilai pembanding dari sekumpulan data yang ada, Operator terdiri dari `> ALL` dan `< ALL` |
| `EXIST`     | Untuk melakukan check, data pada inner query ada kemudian dibandingkan dengan outer query |

