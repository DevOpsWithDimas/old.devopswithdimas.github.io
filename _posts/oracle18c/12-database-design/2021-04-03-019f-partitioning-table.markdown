---
layout: post
title: "Partitioning Table (Very Large Databases)"
date: 2021-04-03T11:59:24+07:00
lang: oracle18c
authors:
- dimasm93
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/18/vldbg/partition-intro.html#GUID-FBA59FA7-7F42-4039-96D1-ACEC71A07DD5
- https://docs.oracle.com/en/database/oracle/oracle-database/18/vldbg/partition-create-tables-indexes.html#GUID-D3E92FD8-5FE4-4CEA-9CB8-CC9277A74429
- https://docs.oracle.com/en/database/oracle/oracle-database/18/vldbg/view-info-partition-tables-indexes.html#GUID-2D424638-511C-4CC3-9BDE-53FFB1686ECD
youtube: b27gwC7loeA
comments: true
catalog_key: design-db
image_path: /resources/posts/oracle12c/019f-partitioned-table
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Enterprice Applications khususnya data warehouse, biasanya memeliki jumlah datanya sangat besar bisa sampai ribuan gigabtypes atau bahkan sampai satuan terabytes data. Dari data sebanyak itu biasanya performa database akan semakin lambat dalam melakukan membaca (select) dan menulis (insert, update, dan delete). Salah satu pemecahan masalahnya yaitu dengan Database Scaling menggunakan Partitioning.

Partitioning yaitu membagi Object Stored Database seperti (table, dan index) menjadi bagian yang kecil dan more manageable pieces. Contoh ilustrasinya seperti berikut

![partitioned-tables](https://docs.oracle.com/en/database/oracle/oracle-database/18/vldbg/img/vldbg008.gif)

## Non Partitioned Table

Dalam beberapa kasus di perusahaan-perusahaan besar masih menggunakan schema design seperti berikut:

![non-partitioned-tables]({{ page.image_path | prepend: site.baseurl }}/erd-non-partitioned.png)

Dalam design schema seperti berikut, memiliki kekurangan diantaranya:

1. Kita harus pilih mau simpan ke table apa?
2. Mau ambil semua data kita harus menggunakan union
3. Data gak manageable, jika ada perubahan
4. Dan masih banyak lagi

## Partitioned Tables


Sedangkan jika menggunakan partition table berikut adalah Entity Relational Diagramnya:

![partitioned-tables]({{ page.image_path | prepend: site.baseurl }}/erd-partitioned-table.jpg)

Sebuah partitioned table memilki strategy yang terdiri dari:

1. Single Level
    1. Range Partitioning
    2. Hash Partitioning
    3. List Partitioning
2. Composite Level
3. Partitioning Extensions

Berikut adalah impementasi Partitioned Table menggunakan schenario List:

{% gist page.gist "019f-partitioned-table-list.sql" %}

Jika di jalankan, maka hasilnya seperti berikut:

```sql
sqlplus toko_online/toko_online@XEPDB1

SQL*Plus: Release 18.0.0.0.0 - Production on Sat Apr 3 03:25:50 2021
Version 18.4.0.0.0

Copyright (c) 1982, 2018, Oracle.  All rights reserved.

Last Successful login time: Sat Apr 03 2021 03:20:20 +00:00

Connected to:
Oracle Database 18c Express Edition Release 18.0.0.0.0 - Production
Version 18.4.0.0.0

SQL> create sequence test_partitioned increment by 1 start with 1;

Sequence created.

SQL> begin
    for idx in 1..100
        loop
            insert into bikes_no_partitioned(name, brand, dealer_name)
            values (sys_guid(), sys_guid(), 'ASTRA_HONDA');

            insert into bikes_no_partitioned(name, brand, dealer_name)
            values (sys_guid(), sys_guid(), 'MERDEKA_MOTOR');

            insert into bikes_no_partitioned(name, brand, dealer_name)
            values (sys_guid(), sys_guid(), 'BINTANG_REJEKI_MOTOR');
        end loop;
end; 
/

PL/SQL procedure successfully completed.

SQL> commit;

Commit complete.


SQL> explain plan FOR
select *
from bikes_no_partitioned
where dealer_name in ('ASTRA_HONDA', 'MERDEKA_MOTOR', 'ACEH_HOTOR', 'DAYA_MOTOR'); 

SQL> SET LONG 20000 LONGCHUNKSIZE 20000 PAGESIZE 0 LINESIZE 1000 FEEDBACK OFF VERIFY OFF TRIMSPOOL ON;
SQL> SET PAGESIZE 14 LINESIZE 100 FEEDBACK ON VERIFY ON;

SQL> select *
from table ( DBMS_XPLAN.DISPLAY('PLAN_TABLE') );

PLAN_TABLE_OUTPUT
----------------------------------------------------------------------------------------------------
Plan hash value: 3392068125

------------------------------------------------------------------------------------------
| Id  | Operation         | Name                 | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |                      |   200 | 46800 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| BIKES_NO_PARTITIONED |   200 | 46800 |     3   (0)| 00:00:01 |
------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

PLAN_TABLE_OUTPUT
----------------------------------------------------------------------------------------------------

   1 - filter("DEALER_NAME"='ACEH_HOTOR' OR "DEALER_NAME"='ASTRA_HONDA' OR
              "DEALER_NAME"='DAYA_MOTOR' OR "DEALER_NAME"='MERDEKA_MOTOR')

Note
-----
   - dynamic statistics used: dynamic sampling (level=2)

18 rows selected.

--- table with paritioned

SQL> create table bikes
(
    id               integer default test_partitioned.nextval not null primary key,
    name             varchar2(100)                            not null,
    brand            varchar2(50)                             not null,
    dealer_name      varchar2(50)                             not null,
    wheels           integer default 2                        not null,
    cc               integer default 125,
    machine_type     varchar2(100),
    single_seater    integer default 0,
    front_break_type varchar2(20),
    rear_break_type  varchar2(20)
) partition by list
(
    dealer_name
)
(
    partition honda values ('ASTRA_HONDA', 'MERDEKA_MOTOR', 'ACEH_HOTOR', 'DAYA_MOTOR'),
    partition kawasaki values ('CITRAKARYA_PRATANA', 'BINTA  2  NG_TERANG'),
    partition yamaha values ('JPM_RANCAEKEK', 'SURYA_PUTRA_PADALARANG', 'GERBANG_CAHAYA', 'BINTANG_REJEKI_MOTOR')
);  

Table created.

SQL> begin
    for idx in 1..100
        loop
            insert into bikes(name, brand, dealer_name)
            values (sys_guid(), sys_guid(), 'ASTRA_HONDA');

            insert into bikes(name, brand, dealer_name)
            values (sys_guid  2  (), sys_guid(), 'MERDEKA_MOTOR');

            insert into bikes(name, brand, dealer_name)
            values (sys_guid(), sys_guid(), 'BINTANG_REJEKI_MOTOR');
        end loop;
end;  
/

PL/SQL procedure successfully completed.

SQL> commit;

Commit complete.

SQL> explain plan FOR
select *
from bikes
where dealer_name in ('ASTRA_HONDA', 'MERDEKA_MOTOR', 'ACEH_HOTOR', 'DAYA_MOTOR');  2    3    4

Explained.

SQL> select *
from table ( DBMS_XPLAN.DISPLAY('PLAN_TABLE') );  2

PLAN_TABLE_OUTPUT
----------------------------------------------------------------------------------------------------
Plan hash value: 2738115083

-----------------------------------------------------------------------------------------------
| Id  | Operation             | Name  | Rows  | Bytes | Cost (%CPU)| Time     | Pstart| Pstop |
-----------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT      |       |     1 |   234 |   274   (0)| 00:00:01 |       |       |
|   1 |  PARTITION LIST INLIST|       |     1 |   234 |   274   (0)| 00:00:01 |KEY(I) |KEY(I) |
|   2 |   TABLE ACCESS FULL   | BIKES |     1 |   234 |   274   (0)| 00:00:01 |KEY(I) |KEY(I) |
-----------------------------------------------------------------------------------------------

Note

PLAN_TABLE_OUTPUT
----------------------------------------------------------------------------------------------------
-----
   - dynamic statistics used: dynamic sampling (level=2)

13 rows selected.
```

## Informasi Partition Table

Untuk melihat suatu table memeliki Partitions kita bisa menggunakan Static Dictionary View seperti berikut:

{% gist page.gist "019f-dt-partitioned-table.sql" %}

Untuk detail lebih lengkapnya silahkan baca [disini](https://docs.oracle.com/en/database/oracle/oracle-database/18/vldbg/view-info-partition-tables-indexes.html#GUID-2D424638-511C-4CC3-9BDE-53FFB1686ECD)

Untuk meteri lebih lanjutnya nanti kita akan bahas pada materi `Very Large Database: Oracle Database`