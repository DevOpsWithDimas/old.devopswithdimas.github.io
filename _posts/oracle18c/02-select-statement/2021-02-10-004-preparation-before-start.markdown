---
layout: post
title: "Persiapan Sebelum mulai belajar"
date: 2021-02-10T18:04:50+07:00
lang: oracle18c
authors:
- dimasm93
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/database/121/index.htm
- https://docs.oracle.com/en/bigdata/index.html
youtube: fsX_iaMH_hM
comments: true
catalog_key: sql-select
image_path: /resources/posts/oracle12c/004-pre-start-learn
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Ok sebelum kita mulai, jadi di Oracle Database 18c XE ini secara default gak ada schema HR seperti pendahulunya yaitu Oracle Database 11g XE. jadi kita perlu execute query sendiri.

<!--more-->

## Alter Session

Pertama login as `system` dengan sqlplus, kemudian jalankan perintah berikut:

{% gist page.gist "alter-session-hr-creation.sql" %}

Maka berikut hasilnya:

```sql
SYS_CONTEXT('USERENV','CON_NAME')
--------------------------------------------------------------------------------
XEPDB1

1 row selected.
```

Kemudian, jalankan script berikut:

{% gist page.gist "hr-schema.sql" %}

Kemudian akan muncul inputan, kita isi seperti berikut:

1. specify password for HR as parameter 1: `passwordnyaHR18c`
2. specify default tablespeace for HR as parameter 2: `USERS`
3. specify temporary tablespace for HR as parameter 3: `TEMP`
4. specify log path as parameter 4: `$ORACLE_HOME/demo/schema/log`

Maka hasilnya seperti berikut:

```sql
PL/SQL procedure successfully completed.
 
User created.
 
User altered.
 
Grant succeeded.

Session altered.
PL/SQL procedure successfully completed.
```

## Test Login hr users

Coba connect dengan user `hr`, dan password untuk user `hr` adalah `passwordnyaHR18c` seperti berikut:

```sql
conn hr/passwordnyaHR18c@XE
```

Berikut hasilnya:

![hr-connection]({{ page.image_path | prepend: site.baseurl }}/hr-schema-user.png)
