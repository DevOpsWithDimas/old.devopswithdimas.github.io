---
layout: post
title: "Deep dive into DELETE statement"
lang: postgresql
authors:
- dimasm93
categories:
- RDBMS
- PostgreSQL
- SQL
- DML
refs: 
- https://www.postgresql.org/docs/14/sql-delete.html
youtube: 
image_path: /resources/posts/postgresql/05d-dml-update
comments: true
gist: dimMaryanto93/7ae7632f9418feb724bc431eff412a3f
catalog_key: dml-statement
downloads: []
---

Hai semuanya, Setelah kita membahas tentang Update statement perintah selanjutnya yang kita perlu perlajari untuk menghapus data pada suatu tabel yaitu `DELETE` statement. Terkiat perintah delete yang temen-temen telah pelajari sebelumnya hanya sekilas saja sebetulnya secara mendetail perintah delete seperti berikut:

{% highlight sql %}
[ WITH [ RECURSIVE ] with_query [, ...] ]
DELETE FROM [ ONLY ] table_name [ * ] [ [ AS ] alias ]
    [ USING from_item [, ...] ]
    [ WHERE condition | WHERE CURRENT OF cursor_name ]
    [ RETURNING * | output_expression [ [ AS ] output_name ] [, ...] ]
{% endhighlight %}

Jika temen-temen perhatikan ada beberapa feature dan yang kita bisa gunakan seperti:

1. Delete using from_item
2. Delete using `RETURNING`
3. Delete using WITH queries

Ok tanpa berlama-lama jadi lansung aja bahas materi yang pertama:

<!--more-->

## Delete using from_item

There are two ways to delete rows in a table using information contained in other tables in the database: using sub-selects, or specifying additional tables in the `USING` clause. Which technique is more appropriate depends on the specific circumstances.