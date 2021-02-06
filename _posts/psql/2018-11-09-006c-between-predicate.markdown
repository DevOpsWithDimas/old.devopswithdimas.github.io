---
layout: post
title: "Between Predicate pada klausa where di PostgreSQL"
date: 2018-11-09T20:40:07+07:00
lang: psql
categories:
- RDBMS
- PostgreSQL
refs: []
youtube: https://www.youtube.com/watch?v=7MLBNM576gA&list=PLV1-tdmPblvypZXSk2GC932nludT345xk&index=8
comments: true
gist: dimMaryanto93/62ffa0d81f3835a4e9401baf14590cd2
downloads: []
---


# Operator between

Operator `BETWEEN` digunakan untuk memfilter dengan interval/rentang tertentu diantar nilai terkecil dan terbesar. contoh kasusnya, Saya mau menampilkan data yang karywan yang memiliki gaji dari `4000` s/d `6000`. Berikut querynya:

{% gist page.gist "select-where-between.sql" %}

Berikut hasilnya:

```postgresql-console
 employee_id | first_name | last_name |  email   | phone_number |  job_id  | salary  | department_id 
-------------+------------+-----------+----------+--------------+----------+---------+---------------
         104 | Bruce      | Ernst     | BERNST   | 590.423.4568 | IT_PROG  | 6000.00 |            60
         105 | David      | Austin    | DAUSTIN  | 590.423.4569 | IT_PROG  | 4800.00 |            60
         106 | Valli      | Pataballa | VPATABAL | 590.423.4560 | IT_PROG  | 4800.00 |            60
         107 | Diana      | Lorentz   | DLORENTZ | 590.423.5567 | IT_PROG  | 4200.00 |            60
         124 | Kevin      | Mourgos   | KMOURGOS | 650.123.5234 | ST_MAN   | 5800.00 |            50
         184 | Nandita    | Sarchand  | NSARCHAN | 650.509.1876 | SH_CLERK | 4200.00 |            50
         185 | Alexis     | Bull      | ABULL    | 650.509.2876 | SH_CLERK | 4100.00 |            50
         192 | Sarah      | Bell      | SBELL    | 650.501.1876 | SH_CLERK | 4000.00 |            50
         200 | Jennifer   | Whalen    | JWHALEN  | 515.123.4444 | AD_ASST  | 4400.00 |            10
         202 | Pat        | Fay       | PFAY     | 603.123.6666 | MK_REP   | 6000.00 |            20
(10 rows)
```
