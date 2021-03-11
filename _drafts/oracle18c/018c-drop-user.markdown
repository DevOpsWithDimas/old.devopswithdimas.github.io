---
layout: post
title: "DDL - Dropping User Account"
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/18/dbseg/managing-security-for-oracle-database-users.html#GUID-D036CFC9-CDB6-4679-80F5-B9A189E463DA
youtube: 
comments: true
image_path: /resources/posts/oracle12c/018c-drop-user
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Kita juga bisa menghapus usernya dengan perintah `DROP USER` tetapi usernya yang mau kita hapus sedang logged in maka tidak bisa di hapus atau akan muncul error log seperti berikut:

```sql
ORA-01940: cannot drop a user that is currently connected
```

Kita bisa tunggu sampai user tersebut logout, atau kita bisa terminate / kill sessionnya dengan perintah berikut:

{% gist page.gist "018c-drop-user-kill-session.sql" %}

Maka hasilnya seperti berikut:

```sql
sqlplus system/passwordnyaOracle18@XEPDB1

SQL*Plus: Release 18.0.0.0.0 - Production on Thu Mar 11 12:10:13 2021
Version 18.4.0.0.0

Copyright (c) 1982, 2018, Oracle.  All rights reserved.

Last Successful login time: Thu Mar 11 2021 12:05:57 +00:00

Connected to:
Oracle Database 18c Express Edition Release 18.0.0.0.0 - Production
Version 18.4.0.0.0

SQL> select SID, SERIAL#, USERNAME
from V$SESSION
where USERNAME = 'TOKO_ONLINE';  2    3

       SID    SERIAL# USERNAME
---------- ---------- --------------------
       791      51168 TOKO_ONLINE

SQL> alter system kill session '791, 51168';

System altered.
```

Berikut di sisi user `toko_online`

```sql
sqlplus toko_online/toko@XEPDB1

SQL*Plus: Release 18.0.0.0.0 - Production on Thu Mar 11 12:13:59 2021
Version 18.4.0.0.0

Copyright (c) 1982, 2018, Oracle.  All rights reserved.


Connected to:
Oracle Database 18c Express Edition Release 18.0.0.0.0 - Production
Version 18.4.0.0.0

SQL> select 1 + 1 from dual;
select 1 + 1 from dual
*
ERROR at line 1:
ORA-00028: your session has been killed
```

Setelah itu baru bisa di hapus:

{% gist page.gist "018c-drop-user.sql" %}