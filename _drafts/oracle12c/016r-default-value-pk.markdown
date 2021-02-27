---
layout: post
title: "Default value untuk Primary Key di Oracle"
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://franckpachot.medium.com/uuid-aka-guid-vs-oracle-sequence-number-ab11aa7dbfe7
- https://oracle-base.com/articles/9i/uuid-9i
youtube: 
comments: true
image_path: /resources/posts/oracle12c/016r-default-value-pk
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Kebanyakan oracle database menggunakan sequances untuk menjaga performa database di load secara lebih cepat dan less capacity storage tetepi ada beberapa problem, The most commons problem menggunakan sequances adalah

1. Sering problem ketika data migration apalagi ketika ada merging databases
2. Replication processes where duplication of the sequences occur

Untuk menghandle masalah tersebut kita bisa menggunkan UUID (Universal Unique Indetifier aka `SYS_GUID`).

{% gist page.gist "016r-create-table-sys-guid.sql" %}

Jika di running maka hasilnya seperti berikut:

```sql
SQL> select * 
from test_table_guid;

ID                               NAMA                                PRICE
-------------------------------- ------------------------------ ----------
BC503DB2213602D1E053020012AC7CDA Apple Macbook Pro 13 inch 2017 28000
BC503DB2213702D1E053020012AC7CDA Apple Macbook Pro 13 inch 2017 25000
```