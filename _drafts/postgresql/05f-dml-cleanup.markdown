---
layout: post
title: "Cleanup Data from Table"
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