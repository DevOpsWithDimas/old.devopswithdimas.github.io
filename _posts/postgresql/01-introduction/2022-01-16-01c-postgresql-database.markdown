---
layout: post
title: "Overview of Object Relational Database Management System (ORDBMS)"
date: 2022-01-16T09:30:20+07:00
lang: postgresql
authors:
- dimasm93
categories:
- RDBMS
- PostgreSQL
refs: 
- https://www.postgresql.org/docs/14/
- https://en.wikipedia.org/wiki/Object%E2%80%93relational_database
youtube: 
image_path: /resources/posts/psql/01d-postgresql-database
comments: true
gist: dimMaryanto93/62ffa0d81f3835a4e9401baf14590cd2
catalog_key: introduction
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang Object Relation Management System atau singkatannya ORDBMS. Diantaranya

1. What is Object-Relational Database Management System?
2. Comparison to RDBMS

Ok langsung aja kita bahas materi yang pertama

## What is Object-Relational Database Management System?

An object–relational database (ORD), or object–relational database management system (ORDBMS), is a database management system (DBMS) similar to a relational database, but with an object-oriented database model: objects, classes and inheritance are directly supported in database schemas and in the query language. In addition, just as with pure relational systems, it supports extension of the data model with custom data types and methods.

In object–relational databases, the approach is essentially that of relational databases: the data resides in the database and is manipulated collectively with queries in a query language; at the other extreme are OODBMSes in which the database is essentially a persistent object store for software written in an object-oriented programming language, with a programming API for storing and retrieving objects, and little or no specific support for querying.

## Comparison to RDBMS

An RDBMS might commonly involve SQL statements such as these:

{% highlight sql %}
   CREATE TABLE Customers  (
       Id          CHAR(12)    NOT NULL PRIMARY KEY,
       Surname     VARCHAR(32) NOT NULL,
       FirstName   VARCHAR(32) NOT NULL,
       DOB         DATE        NOT NULL   # DOB: Date of Birth
    );
    SELECT InitCap(Surname) || ', ' || InitCap(FirstName)
      FROM Customers
     WHERE Month(DOB) = Month(getdate())
       AND Day(DOB) = Day(getdate())
{% endhighlight %}

In an object–relational database, one might see something like this, with user-defined data-types and expressions such as `BirthDay()`:

{% highlight sql %}
    CREATE TABLE Customers (
      Id           Cust_Id     NOT NULL  PRIMARY KEY,
      Name         PersonName  NOT NULL,
      DOB          DATE        NOT NULL
    );
    SELECT Formal( C.Id )
      FROM Customers C
     WHERE BirthDay ( C.DOB ) = TODAY;
{% endhighlight %}

The object–relational model can offer another advantage in that the database can make use of the relationships between data to easily collect related records.