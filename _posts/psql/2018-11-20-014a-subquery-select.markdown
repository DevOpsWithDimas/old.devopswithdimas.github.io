---
layout: post
title: "SubQuery pada select statement di PostgreSQL"
date: 2018-11-20T14:25:45+07:00
lang: psql
categories:
- RDBMS
- PostgreSQL
refs: []
youtube: https://www.youtube.com/watch?v=ed7haJRjqKY&list=PLV1-tdmPblvypZXSk2GC932nludT345xk&index=21
comments: true
gist: dimMaryanto93/62ffa0d81f3835a4e9401baf14590cd2
downloads: []
---


{% gist page.gist "select-sub-query.sql" %}

Berikut hasilnya:

```postgresql-console
 nik |   nama    |            jabatan            | minimun_salary 
-----+-----------+-------------------------------+----------------
 100 | Steven    | President                     |          20000
 101 | Neena     | Administration Vice President |          15000
 102 | Lex       | Administration Vice President |          15000
 103 | Alexander | Programmer                    |           4000
 104 | Bruce     | Programmer                    |           4000
 105 | David     | Programmer                    |           4000
 106 | Valli     | Programmer                    |           4000
 107 | Diana     | Programmer                    |           4000
 108 | Nancy     | Finance Manager               |           8200
 109 | Daniel    | Accountant                    |           4200
(10 rows)
```