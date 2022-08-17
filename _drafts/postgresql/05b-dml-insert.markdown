---
layout: post
title: "Deep dive into INSERT statement"
lang: postgresql
authors:
- dimasm93
categories:
- RDBMS
- PostgreSQL
refs: 
- https://www.postgresql.org/docs/14/sql-insert.html
youtube: 
image_path: /resources/posts/postgresql/05b-dml-insert
comments: true
gist: dimMaryanto93/7ae7632f9418feb724bc431eff412a3f
catalog_key: dml-statement
downloads: []
---

Hai semuanya, pada materi sebelumnya kita sudah membahas sedikit tentang Data Manipulation language atau di singkat DML. Nah sekarang kita akan bahas lebih detail khususnya untuk perintah INSERT statement diantaranya seperti berikut:

1. Advanced `INSERT` statement
2. Insert with specific columns and data type
3. Insert with `DEFAULT VALUE`
4. Insert single and multiple rows
5. Insert with `ON CONFLICT`
6. Insert with `OVERRIDING` keyword
7. Using with query in INSERT statement
8. Error message on insert statement

Ok tanpa berlama-lama lagi, yuuk lansung aja kita bahas materi yang pertama:

<!--more-->

## Advanced `INSERT` statement

Perintah `INSERT` yang telah kita pelajari di materi sebelumnya hanyalah simple sebetulnya secara syntax perintahnya seperti berikut:

{% highlight sql %}
[ WITH [ RECURSIVE ] with_query [, ...] ]
INSERT INTO table_name [ AS alias ] [ ( column_name [, ...] ) ]
    [ OVERRIDING { SYSTEM | USER } VALUE ]
    { DEFAULT VALUES | VALUES ( { expression | DEFAULT } [, ...] ) [, ...] | query }
    [ ON CONFLICT [ conflict_target ] conflict_action ]
    [ RETURNING * | output_expression [ [ AS ] output_name ] [, ...] ]

where conflict_target can be one of:

    ( { index_column_name | ( index_expression ) } [ COLLATE collation ] [ opclass ] [, ...] ) [ WHERE index_predicate ]
    ON CONSTRAINT constraint_name

and conflict_action is one of:

    DO NOTHING
    DO UPDATE SET { column_name = { expression | DEFAULT } |
                    ( column_name [, ...] ) = [ ROW ] ( { expression | DEFAULT } [, ...] ) |
                    ( column_name [, ...] ) = ( sub-SELECT )
                  } [, ...]
              [ WHERE condition ]
{% endhighlight %}

`INSERT` statement is inserts new rows into a table. One can insert one or more rows specified by value expressions, or zero or more rows resulting from a query.

The target column names can be listed in any order. If no list of column names is given at all, the default is all the columns of the table in their declared order; or the first `N` column names, if there are only `N` columns supplied by the VALUES clause or query. The values supplied by the `VALUES` clause or query are associated with the explicit or implicit column list left-to-right.

Each column not present in the explicit or implicit column list will be filled with a default value, either its declared default value or `null` if there is none.

If the expression for any column is not of the correct data type, automatic type conversion will be attempted.

Ya lumayan panjang juga ya, ok kalo gitu kita break down aja ya untuk masing-masing feature dari `INSERT` statement ini

## Insert with specific columns and data type

