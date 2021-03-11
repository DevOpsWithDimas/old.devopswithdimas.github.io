---
layout: post
title: "DDL - Managing Users"
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/18/admin/managing-users-and-securing-the-database.html#GUID-B20E4AFB-592E-42BD-8485-36EEDA033035
- https://docs.oracle.com/en/database/oracle/oracle-database/18/dbseg/managing-security-for-oracle-database-users.html#GUID-4C383489-6BB4-439A-8293-42F9E6191C85
youtube: 
comments: true
image_path: /resources/posts/oracle12c/018a-ddl-users
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Ketika temen-temen akan membuat Database User (Account), membutuhkan beberapa atribute seperti:

1. Username
2. Password / No Authentication 
3. Default, Temporary, Other Tablespace
4. Quota, untuk me-limit storage
5. User Profile

## Create a New User Account

Berikut adalah contoh untuk membuat user minimal atribute di Oracle database

```sql
CREATE USER <your-username> 
 IDENTIFIED BY <your-password> 
 DEFAULT TABLESPACE <your-tablespace> 
 QUOTA 10M ON users;
```