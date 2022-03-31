---
layout: post
title: "SubQuery pada where predicates di PostgreSQL"
date: 2018-11-20T14:25:46+07:00
lang: psql
categories:
- RDBMS
- PostgreSQL
refs: []
youtube: ed7haJRjqKY
comments: true
gist: dimMaryanto93/62ffa0d81f3835a4e9401baf14590cd2
downloads: []
---

<!--more-->

{% gist page.gist "select-sub-query-where.sql" %}

Berikut hasilnya:

```postgresql-console
 nik |  nama  | gaji_sebulan 
-----+--------+--------------
 100 | Steven |     24000.00
 101 | Neena  |     17000.00
 102 | Lex    |     17000.00
 145 | John   |     14000.00
 146 | Karen  |     13500.00
(5 rows)
```

**Penempatan pada `where ...` (lanjutan) menggunakan Operator = Any**

```sql
select 
    job_id as id,
    round(
        avg(j.max_salary)
    ) as gaji_rata 
from 
    jobs j 
group by j.job_id;
```

Akan menghasilkan data berikut:

```postgresql-console
     id     | gaji_rata 
------------+-----------
 AD_VP      |     30000
 ST_MAN     |      8500
 HR_REP     |      9000
 PR_REP     |     10500
 ST_CLERK   |      5000
 FI_MGR     |     16000
 AD_PRES    |     40000
 MK_MAN     |     15000
 FI_ACCOUNT |      9000
 SA_REP     |     12000
 MK_REP     |      9000
 SH_CLERK   |      5500
 AC_ACCOUNT |      9000
 AC_MGR     |     16000
 PU_MAN     |     15000
 PU_CLERK   |      5500
 AD_ASST    |      6000
 IT_PROG    |     10000
 SA_MAN     |     20000
(19 rows)
```

{% gist page.gist "select-sub-query-eq-any.sql" %}

Berikut hasilnya:

```postgresql-console
 nik |   nama    | gaji_sebulan 
-----+-----------+--------------
 103 | Alexander |      9000.00
 104 | Bruce     |      6000.00
 108 | Nancy     |     12000.00
 109 | Daniel    |      9000.00
 147 | Alberto   |     12000.00
 149 | Eleni     |     10500.00
 150 | Peter     |     10000.00
 152 | Peter     |      9000.00
 156 | Janette   |     10000.00
 158 | Allan     |      9000.00
 162 | Clara     |     10500.00
 169 | Harrison  |     10000.00
 202 | Pat       |      6000.00
 204 | Hermann   |     10000.00
 205 | Shelley   |     12000.00
(15 rows)
```

Atau sebenarnya ini kita bisa menggunakan operator `IN`.

**Penempatan pada `where ...` (lanjutan) menggunakan Operator > Any**

```sql
select 
    round(avg(j.max_salary)) as gaji_rata 
from jobs j 
group by j.job_id
having avg(j.max_salary) < 20000;
```

Berikut hasilquerynya;

```postgresql-console
 gaji_rata 
-----------
      8500
      9000
     10500
      5000
     16000
     15000
      9000
     12000
      9000
      5500
      9000
     16000
     15000
      5500
      6000
     10000
(16 rows)
```

{% gist page.gist "select-sub-query-higher-any.sql" %}

Berikut hasilnya:

```postgresql-console
 nik |    nama     | gaji_sebulan 
-----+-------------+--------------
 100 | Steven      |     24000.00
 101 | Neena       |     17000.00
 102 | Lex         |     17000.00
 103 | Alexander   |      9000.00
 104 | Bruce       |      6000.00
 108 | Nancy       |     12000.00
 109 | Daniel      |      9000.00
 153 | Christopher |      8000.00
 154 | Nanette     |      7500.00
 155 | Oliver      |      7000.00
 ...
(58 rows)
```