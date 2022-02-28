---
layout: post
title: "Overview SQL Select statements"
date: 2022-02-24T05:20:30+07:00
lang: postgresql
categories:
- RDBMS
- PostgreSQL
refs: 
- https://www.postgresql.org/docs/current/sql.html
- https://www.postgresql.org/docs/current/datatype.html
- https://www.postgresql.org/docs/current/queries-select-lists.html
youtube: 
image_path: /resources/posts/postgresql/03-overview-sql
comments: true
gist: dimMaryanto93/62ffa0d81f3835a4e9401baf14590cd2
catalog_key: sql-statement
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang SQL (Structure Query Language) untuk Select Statement menggunakan PostgreSQL. Materi yang akan di bahas diantaranya:

1. Apa itu SQL & Basic Consepts?
2. Aturan penulisan SQL di PostgreSQL
3. Data Types di PostgreSQL
4. Object schema di PostgreSQL

Ok langsung saja kita bahas materi yang pertama

## Apa itu SQL & Basic Consepts?

SQL is the standard language for Relational Database System That means it is a computer language for storing, manipulating and retrieving data stored in a relational database. All the Relational Database Management Systems (RDMS) like MySQL, MS Access, Oracle, Sybase, Informix, Postgres and SQL Server use SQL as their standard database language.

PostgreSQL is a relational database management system (RDBMS). Relation is essentially a mathematical term for table. The notion of storing data in tables is so commonplace today that it might seem inherently obvious, but there are a number of other ways of organizing databases.

Each table is a named collection of rows. Each row of a given table has the same set of named columns, and each column is of a specific data type. Whereas columns have a fixed order in each row, it is important to remember that SQL does not guarantee the order of the rows within the table in any way (although they can be explicitly sorted for display).

Tables are grouped into databases, and a collection of databases managed by a single PostgreSQL server instance constitutes a database cluster.

![database-consept]({{ page.image_path | prepend: site.baseurl }}/01-db-consepts.png)

## Aturan penulisan SQL di PostgreSQL

This chapter describes the syntax of SQL. SQL input consists of a sequence of commands. A command is composed of a sequence of tokens, terminated by a semicolon (`;`). 

A token can be a _keywords_ , an _identifier_, a _quoted identifier_, a _literal_ (or _constant_), or a _special character symbol_. Tokens are normally separated by whitespace (space, tab, newline), but need not be if there is no ambiguity (which is generally only the case if a special character is adjacent to some other token type).

For example, the following is (syntactically) valid SQL input:

{% highlight sql %}
-- to select all columns from the my_table
SELECT * FROM MY_TABLE;

-- to update all data at column a set 5 value
UPDATE MY_TABLE SET A = 5;

-- to add data to my_table
INSERT INTO MY_TABLE VALUES (3, 'hi there');
{% endhighlight %}

This is a sequence of three commands, one per line (although this is not required; more than one command can be on a line, and commands can usefully be split across lines).

Tokens such as `SELECT`, `UPDATE`, or `VALUES` in the example above are examples of keywords, that is, words that have a fixed meaning in the SQL language.

SQL identifiers and key words must begin with a letter (`a-z`, but also letters with diacritical marks and non-Latin letters) or an underscore (`_`). Subsequent characters in an identifier or key word can be letters, underscores, digits (`0-9`), or dollar signs (`$`). Note that dollar signs are not allowed in identifiers according to the letter of the SQL standard, so their use might render applications less portable. The SQL standard will not define a key word that contains digits or starts or ends with an underscore, so identifiers of this form are safe against possible conflict with future extensions of the standard.

Key words and unquoted identifiers are case insensitive. Therefore:

{% highlight sql %}
UPDATE MY_TABLE SET A = 5;
{% endhighlight %}

can equivalently be written as:

{% highlight sql %}
uPDaTE my_TabLE SeT a = 5;
{% endhighlight %}

A convention often used is to write key words in upper case and names in lower case, e.g.:

{% highlight sql %}
UPDATE my_table SET a = 5;
{% endhighlight %}

## Data Types di PostgreSQL

PostgreSQL has a rich set of native data types available to users. Users can add new types to PostgreSQL using the `CREATE TYPE` command. Basicly data types in PostgreSQL diff by

| Type          | Name                  | Alias         | Description                | 
| :---          | :---                  | :---          | :---                       | 
| Numeric       | `bigint`              | `int8`        | large-range integer        | 
|               | `integer`             | `int, int4`   | typical choice for integer |
|               | `smallint`            | `int2`        | small-range integer        | 
|               | `serial`              | `serial4`     | autoincrementing four-byte integer | 
|               | `bigserial`           | `serial8`     | autoincrementing eight-byte integer | 
|               | `decimal`             |               | user-specified precision, exact | 
|               | `numeric`             |               | user-specified precision, exact |
|               | `double precision`    | `float8`      | double precision floating-point number (8 bytes) |
| Data/Time     | `date`                |               | calendar date (year, month, day) | 
|               | `time`                |               | time of day | 
|               | `timestamp`           |               | date and time | 
| Boolean       | `boolean`             | `bool`        | logical Boolean (true/false) | 
| Character     | `character`           | `char`        | fixed-length character string | 
|               | `character varying`   | `varchar`     | variable-length character string | 
|               | `text`                |               | variable-length character string | 
|               | `uuid`                |               | universally unique identifier | 

Dan masih banyak lagi seperti

1. Binary Data Types
2. Monetary Types
3. Enumerated Types
4. Geometric Types
5. Network Address Types
6. Bit String Types
7. Text Search Types
8. XML Type
9. JSON Types
10. Arrays
11. Composite Types
12. Range Types
13. Domain Types
14. Object Identifier Types
15. Pseudo-Types

Dengan kita mengetahui tipe data yang tersedia di PostgreSQL ini, kedepannya diharapkan dapat menentukan tipe data yang tepat untuk menampikan data, memproses data, memformat data dan yang sekaligus menetukan temen-temen dalam mendesign schema database.

## Object schema di PostgreSQL

Ada banyak sekali object dalam PostgreSQL Database salah satunya adalah Table dan schema, A table in a relational database is much like a table on paper: It consists of rows and columns. The number and order of the columns is fixed, and each column has a name. The number of rows is variable — it reflects how much data is stored at a given moment. SQL does not make any guarantees about the order of the rows in a table. When a table is read, the rows will appear in an unspecified order, unless sorting is explicitly requested.

Each column has a data type. The data type constrains the set of possible values that can be assigned to a column and assigns semantics to the data stored in the column so that it can be used for computations. For instance, a column declared to be of a numerical type will not accept arbitrary text strings, and the data stored in such a column can be used for mathematical computations.

A database contains one or more named schemas, which in turn contain tables. Schemas also contain other kinds of named objects, including data types, functions, and operators.

![object-schema-table]({{ page.image_path | prepend: site.baseurl }}/02-object-schema-table.png)

By default such tables (and other objects) are automatically put into a schema named `public`. Every new database contains such a schema.


{% highlight sql %}
-- default current connection schema
SELECT * FROM MY_TABLE;

-- using public schema
SELECT * FROM public.MY_TABLE;
{% endhighlight %}