---
layout: post
title: "DDL - Membuat User pada Database PostgreSQL"
date: 2019-12-30T17:26:24+07:00
lang: psql
categories:
- RDBMS
- PostgreSQL
refs: 
- https://www.postgresql.org/docs/10/sql-createuser.html
youtube: NMZrpBxkfRA
comments: true
gist: dimMaryanto93/62ffa0d81f3835a4e9401baf14590cd2
downloads: []
---

Perintah ddl untuk management user authentication di PostgreSQL terdiri dari:

1. **CREATE**, untuk membuat Authentication user agar dapat mengkases Object yang terdapat di PostgreSQL.
2. **DROP**, untuk menghapus Authentication User
3. **ALTER**, untuk merubah role, password, dan lain-lain yang berkaitan tentang role user tersebut.
4. **GRANT**, untuk memberikan ijin akses terhadap object di database, contohnya klo kita punya table dalam sebuah database tetapi usernya kita gunakan tidak bisa melihat tabelnya maka kita harus meminta ijin kepada pemilik table tersebut untuk grant user kita supaya bisa baca atau tulis ke table tersebut.
5. **REVOKE**, untuk mencabut ijik akses terhadap object di dalam user tersebut;

Contoh penggunaan:

## Create

Perintah `create` digunakan Untuk membuat user yang digunakan untuk login dari Database client editor seperti `psql`, `DataGrip`, `PgAdmin`, dan lain-lain. Kita bisa menggunakan perintah:

{% gist page.gist "ddl-create-user.sql" %}

Dengan perintah tersebut kita membuat user dengan nama `role_name` dan passwordnya `your-password` hanya dapat login dan membuat database saja.

## DROP

Perintah `drop` digunakan untuk menghapus data user, kita bisa menggunakan perintah: 

{% gist page.gist "ddl-drop-user.sql" %}

dengan perintah tersebut kita menghapus user dengan username `role_name`.

## ALTER

Perintah `alter` digunakan untuk merubah role dari user tersebut contohnya merubah password

{% gist page.gist "ddl-user-alter.sql" %}

## GRANT

Perintah `grant` digunakan untuk memberikan ijin user tersebut mengkases database/table yang dimiliki oleh orang lain. Contohnya seperti berikut:

```postgresql-console
# login using user 'postgres' database 'bootcamp'
psql -h localhost -U postgres bootcamp

psql (12.1)
Type "help" for help.

# create user 
bootcamp=# create user role_name with login password 'admin';
CREATE ROLE

# show tables using user 'postgres'
bootcamp=# \d
                       List of relations
  Schema  |             Name              |   Type   |  Owner   
----------+-------------------------------+----------+----------
 bootcamp | countries                     | table    | postgres
 bootcamp | departments                   | table    | postgres
 bootcamp | departments_department_id_seq | sequence | postgres
 bootcamp | employees                     | table    | postgres
 bootcamp | employees_employee_id_seq     | sequence | postgres
 bootcamp | flyway_schema_history         | table    | postgres
 bootcamp | job_history                   | table    | postgres
 bootcamp | jobs                          | table    | postgres
 bootcamp | locations                     | table    | postgres
 bootcamp | locations_location_id_seq     | sequence | postgres
 bootcamp | regions                       | table    | postgres
 bootcamp | regions_region_id_seq         | sequence | postgres
(12 rows)

# logout
bootcamp=# \q

# login using new user 'role_name' use database 'bootcamp'
➜  ~ psql -h localhost -U role_name bootcamp
Password for user role_name: 
psql (12.1)
Type "help" for help.

# show tables using user 'role_name' in database 'bootcamp'
bootcamp=> \dt bootcamp.*
                  List of relations
  Schema  |         Name          | Type  |  Owner   
----------+-----------------------+-------+----------
 bootcamp | countries             | table | bootcamp
 bootcamp | departments           | table | bootcamp
 bootcamp | employees             | table | bootcamp
 bootcamp | flyway_schema_history | table | bootcamp
 bootcamp | job_history           | table | bootcamp
 bootcamp | jobs                  | table | bootcamp
 bootcamp | locations             | table | bootcamp
 bootcamp | regions               | table | bootcamp
(8 rows)

bootcamp=> select * from bootcamp.employees;
ERROR:  permission denied for schema bootcamp
LINE 1: select * from bootcamp.employees;
```

Untuk mengijikan melihat, menulis, dan update data ke semua table yang ada di database `bootcamp` kita berikan ijin menggunakan user superuser yaitu `postgres` seperti berikut perintahnya:

{% gist page.gist "ddl-user-grant-privileges.sql" %}

berikut hasilnya;

```postgresql-console
# login using user 'postgres' database 'bootcamp'
psql -h localhost -U postgres bootcamp

bootcamp=# grant connect on database bootcamp to role_name;
GRANT

bootcamp=# grant usage on schema bootcamp to role_name;
GRANT

bootcamp=# grant all privileges on all tables in schema bootcamp to role_name;
GRANT

bootcamp=# grant all privileges on all sequences in schema bootcamp to role_name;
GRANT


bootcamp=# \q
psql -h localhost -U role_name bootcamp
Password for user role_name: 
psql (12.1)
Type "help" for help.

bootcamp=> select * from bootcamp.employees;
 employee_id | first_name  |  last_name  |  email   |    phone_number    |   job_id   |  salary  | commission_pct | manager_id | department_id 
-------------+-------------+-------------+----------+--------------------+------------+----------+----------------+------------+---------------
         100 | Steven      | King        | SKING    | 515.123.4567       | AD_PRES    | 24000.00 |                |            |            90
         101 | Neena       | Kochhar     | NKOCHHAR | 515.123.4568       | AD_VP      | 17000.00 |                |        100 |            90
         102 | Lex         | De Haan     | LDEHAAN  | 515.123.4569       | AD_VP      | 17000.00 |                |        100 |            90
         103 | Alexander   | Hunold      | AHUNOLD  | 590.423.4567       | IT_PROG    |  9000.00 |                |        102 |            60
         104 | Bruce       | Ernst       | BERNST   | 590.423.4568       | IT_PROG    |  6000.00 |                |        103 |            60
         105 | David       | Austin      | DAUSTIN  | 590.423.4569       | IT_PROG    |  4800.00 |                |        103 |            60
         106 | Valli       | Pataballa   | VPATABAL | 590.423.4560       | IT_PROG    |  4800.00 |                |        103 |            60
(107 rows)
```