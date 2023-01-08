---
layout: post
title: "Cleanup Data from Table"
date: 2023-01-08T10:49:22+07:00
lang: postgresql
authors:
- dimasm93
categories:
- RDBMS
- PostgreSQL
- SQL
- DML
refs: 
- https://www.postgresql.org/docs/14/sql-truncate.html
- https://www.postgresql.org/docs/14/sql-vacuum.html
youtube: 
image_path: /resources/posts/postgresql/05f-dml-cleanup
comments: true
gist: dimMaryanto93/7ae7632f9418feb724bc431eff412a3f
catalog_key: dml-statement
downloads: []
---

Hai semuanya, Selain `INSERT`, `UPDATE` dan `DELETE` statement ada juga beberapa task seperti cleanup data/storage pada database PostgreSQL dengan menggunakan perintah `TRUNCATE` dan `VACUUM`.

Ok jadi langsung aja kita bahas materi yang pertama:

<!--more-->

## Cleanup data of tables using `TRUNCATE`

`TRUNCATE` is a command to empty a table or set of tables. It has the same effect as an unqualified `DELETE` on each table, but since it does not actually scan the tables it is faster. Furthermore this is most useful on large tables. The syntax is:

{% highlight sql %}
TRUNCATE [ TABLE ] [ ONLY ] name [ * ] [, ... ]
    [ RESTART IDENTITY | CONTINUE IDENTITY ] [ CASCADE | RESTRICT ]
{% endhighlight %}

Before you execute this command, You must have the `TRUNCATE` privilege on a table to truncate it. 

`TRUNCATE` acquires an `ACCESS EXCLUSIVE` lock on each table it operates on, which blocks all other concurrent operations on the table. When `RESTART IDENTITY` is specified, any sequences that are to be restarted are likewise locked exclusively. If concurrent access to a table is required, then the `DELETE` command should be used instead.

`TRUNCATE` cannot be used on a table that has foreign-key references from other tables, unless all such tables are also truncated in the same command. Checking validity in such cases would require table scans, and the whole point is not to do one. The `CASCADE` option can be used to automatically include all dependent tables — but be very careful when using this option, or else you might lose data you did not intend to!

When `RESTART IDENTITY` is specified, the implied `ALTER SEQUENCE RESTART` operations are also done transactionally; that is, they will be rolled back if the surrounding transaction does not commit. Be aware that if any additional sequence operations are done on the restarted sequences before the transaction rolls back, the effects of these operations on the sequences will be rolled back, but not their effects on `currval();` that is, after the transaction `currval()` will continue to reflect the last sequence value obtained inside the failed transaction, even though the sequence itself may no longer be consistent with that.

Sebagai contoh, saya akan menghapus data table `job_history` seperti berikut perintahnya:

{% gist page.gist "05f-dml-cleanup-truncate.sql" %}

Jika dijalankan seperti berikut:

```sql
hr=# truncate job_history RESTART IDENTITY CASCADE;
TRUNCATE TABLE

hr=# select count(*)
hr-# from job_history;
 count
-------
     0
(1 row)
```

## Cleanup storage to reclaims occupied by dead tuples

VACUUM reclaims storage occupied by dead tuples. In normal PostgreSQL operation, tuples that are deleted or obsoleted by an update are not physically removed from their table; they remain present until a VACUUM is done. Therefore it's necessary to do VACUUM periodically, especially on frequently-updated tables.

{% highlight sql %}
VACUUM [ ( option [, ...] ) ] [ table_and_columns [, ...] ]
VACUUM [ FULL ] [ FREEZE ] [ VERBOSE ] [ ANALYZE ] [ table_and_columns [, ...] ]

where option can be one of:

    FULL [ boolean ]
    FREEZE [ boolean ]
    VERBOSE [ boolean ]
    ANALYZE [ boolean ]
    DISABLE_PAGE_SKIPPING [ boolean ]
    SKIP_LOCKED [ boolean ]
    INDEX_CLEANUP { AUTO | ON | OFF }
    PROCESS_TOAST [ boolean ]
    TRUNCATE [ boolean ]
    PARALLEL integer

and table_and_columns is:

    table_name [ ( column_name [, ...] ) ]
{% endhighlight %}

To vacuum a table, one must ordinarily be the table's owner or a superuser. However, database owners are allowed to vacuum all tables in their databases, except shared catalogs. (The restriction for shared catalogs means that a true database-wide VACUUM can only be performed by a superuser.) VACUUM will skip over any tables that the calling user does not have permission to vacuum.

VACUUM cannot be executed inside a transaction block.

We recommend that active production databases be vacuumed frequently (at least nightly), in order to remove dead rows. After adding or deleting a large number of rows, it might be a good idea to issue a VACUUM ANALYZE command for the affected table. This will update the system catalogs with the results of all recent changes, and allow the PostgreSQL query planner to make better choices in planning queries.

VACUUM causes a substantial increase in I/O traffic, which might cause poor performance for other active sessions. Therefore, it is sometimes advisable to use the cost-based vacuum delay feature. For parallel vacuum, each worker sleeps in proportion to the work done by that worker.

PostgreSQL includes an “autovacuum” facility which can automate routine vacuum maintenance.

To clean a single table `employees`, analyze it for the optimizer and print a detailed vacuum activity report:

{% gist page.gist "05f-dml-cleanup-vacuum.sql" %}

Jika dijalankan hasilnya seperti berikut:

```sql
hr=# VACUUM (VERBOSE, ANALYZE) employees;
INFO:  vacuuming "public.employees"
INFO:  scanned index "employees_pkey" to remove 21 row versions
DETAIL:  CPU: user: 0.00 s, system: 0.00 s, elapsed: 0.00 s
INFO:  scanned index "employees_email_key" to remove 21 row versions
DETAIL:  CPU: user: 0.00 s, system: 0.00 s, elapsed: 0.00 s
INFO:  table "employees": removed 21 dead item identifiers in 2 pages
DETAIL:  CPU: user: 0.00 s, system: 0.00 s, elapsed: 0.00 s
INFO:  index "employees_pkey" now contains 91 row versions in 2 pages
DETAIL:  21 index row versions were removed.
0 index pages were newly deleted.
0 index pages are currently deleted, of which 0 are currently reusable.
CPU: user: 0.00 s, system: 0.00 s, elapsed: 0.00 s.
INFO:  index "employees_email_key" now contains 91 row versions in 2 pages
DETAIL:  21 index row versions were removed.
0 index pages were newly deleted.
0 index pages are currently deleted, of which 0 are currently reusable.
CPU: user: 0.00 s, system: 0.00 s, elapsed: 0.00 s.
INFO:  table "employees": found 10 removable, 91 nonremovable row versions in 2 out of 2 pages
DETAIL:  0 dead row versions cannot be removed yet, oldest xmin: 762
Skipped 0 pages due to buffer pins, 0 frozen pages.
CPU: user: 0.00 s, system: 0.00 s, elapsed: 0.00 s.
INFO:  analyzing "public.employees"
INFO:  "employees": scanned 2 of 2 pages, containing 91 live rows and 0 dead rows; 91 rows in sample, 91 estimated total rows
```