---
layout: post
title: "Overview of PostgreSQL Database"
date: 2022-01-15T21:22:25+07:00
lang: psql
categories:
- RDBMS
- PostgreSQL
refs: 
- https://www.postgresql.org/docs/14/intro-whatis.html
- https://www.postgresql.org/docs/14/history.html
youtube: 
image_path: /resources/posts/psql/02-what-postgresql
comments: true
gist: dimMaryanto93/62ffa0d81f3835a4e9401baf14590cd2
catalog_key: introduction
downloads: []
---

Hai semuanya, di materi pertama kali ini kita akan membahas tentang Pengatar untuk Belajar PostgreSQL, Diantaranya

1. What is PostgreSQL?
2. History of PostgreSQL

Ok langsung aja kita bahas ke materi yang pertama yaitu

## What is PostgreSQL?

PostgreSQL is an object-relational database management system (ORDBMS) based on `POSTGRES`,` Version 4.2`, developed at the University of California at Berkeley Computer Science Department. POSTGRES pioneered many concepts that only became available in some commercial database systems much later.

PostgreSQL is an open-source descendant of this original Berkeley code. It supports a large part of the SQL standard and offers many modern features:

1. complex queries
2. foreign keys
3. triggers
4. updatable views
5. transactional integrity
6. multiversion concurrency control

Also, PostgreSQL can be extended by the user in many ways, for example by adding new

1. data types
2. functions
3. operators
4. aggregate functions
5. index methods
6. procedural languages

And because of the liberal license, PostgreSQL can be used, modified, and distributed by anyone free of charge for any purpose, be it private, commercial, or academic.

## History of PostgreSQL

The POSTGRES project, led by Professor Michael Stonebraker, was sponsored by the Defense Advanced Research Projects Agency (DARPA), the Army Research Office (ARO), the National Science Foundation (NSF), and ESL, Inc. The implementation of POSTGRES began in 1986. The initial concepts for the system were presented in [ston86](https://www.postgresql.org/docs/14/biblio.html#STON86), and the definition of the initial data model appeared in [rowe87](https://www.postgresql.org/docs/14/biblio.html#ROWE87). The design of the rule system at that time was described in [ston87a](https://www.postgresql.org/docs/14/biblio.html#STON87A). The rationale and architecture of the storage manager were detailed in [ston87b](https://www.postgresql.org/docs/14/biblio.html#STON87B).

POSTGRES has been used to implement many different research and production applications. These include: a financial data analysis system, a jet engine performance monitoring package, an asteroid tracking database, a medical information database, and several geographic information systems. POSTGRES has also been used as an educational tool at several universities. Finally, Illustra Information Technologies (later merged into [Informix](https://www.ibm.com/analytics/informix), which is now owned by [IBM](https://www.ibm.com/)) picked up the code and commercialized it. In late 1992, POSTGRES became the primary data manager for the Sequoia 2000 scientific computing project.

In 1994, Andrew Yu and Jolly Chen added an SQL language interpreter to POSTGRES. Under a new name, Postgres95 was subsequently released to the web to find its own way in the world as an open-source descendant of the original POSTGRES Berkeley code. 

Postgres95 code was completely ANSI C and trimmed in size by 25%. Many internal changes improved performance and maintainability. Postgres95 release 1.0.x ran about 30–50% faster on the Wisconsin Benchmark compared to POSTGRES, Version 4.2.

By 1996, it became clear that the name “Postgres95” would not stand the test of time. We chose a new name, PostgreSQL, to reflect the relationship between the original POSTGRES and the more recent versions with SQL capability. At the same time, we set the version numbering to start at 6.0, putting the numbers back into the sequence originally begun by the Berkeley POSTGRES project.

Many people continue to refer to PostgreSQL as “Postgres” (now rarely in all capital letters) because of tradition or because it is easier to pronounce. This usage is widely accepted as a nickname or alias.

