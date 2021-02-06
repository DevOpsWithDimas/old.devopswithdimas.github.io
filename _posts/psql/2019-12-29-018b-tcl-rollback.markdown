---
layout: post
title: "TCL - Rollback Transaction di PostgreSQL"
date: 2019-12-29T20:09:46+07:00
lang: psql
categories:
- RDBMS
- PostgreSQL
refs: 
- https://www.postgresql.org/docs/13/sql-rollback.html
youtube: https://www.youtube.com/watch?v=tQHfL3lpBz8&list=PLV1-tdmPblvypZXSk2GC932nludT345xk&index=24
comments: true
gist: dimMaryanto93/62ffa0d81f3835a4e9401baf14590cd2
downloads: []
---

Penggunaan rollback, contohnya seperit berikut, masih di table yang sama yaitu `regions`

{% gist page.gist "tcl-rollback.sql" %}

hasilnya seperti berikut:

```postgresql-console
bootcamp=# begin;
BEGIN

bootcamp=# INSERT INTO regions (region_id ,region_name) VALUES (6, 'Asia Tenggara');
INSERT 0 1

bootcamp=# select * from regions;
 region_id |      region_name       
-----------+------------------------
         2 | Americas
         3 | Asia
         4 | Middle East and Africa
         1 | Europe
         6 | Asia Tenggara
(5 rows)

bootcamp=# rollback;
ROLLBACK

bootcamp=# select * from regions;
 region_id |      region_name       
-----------+------------------------
         2 | Americas
         3 | Asia
         4 | Middle East and Africa
         1 | Europe
(4 rows)
```