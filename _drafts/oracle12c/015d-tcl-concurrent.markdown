---
layout: post
title: "TCL - Concurrent Transaction"
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/database/121/index.htm
- https://docs.oracle.com/en/bigdata/index.html
youtube: 
comments: true
image_path: /resources/posts/oracle12c/
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Oracle database merupakan RDBMS yang multi user, sehingga memungkinkan untuk paralel transactions (berinteraksi secara bersamaan) ini disebut **Concurrent Transactions**.

Misalnya seperti, coba buka dua windows sqlplus kemudian login dengan user yang sama lalu jalankan perintah berikut:

| No    | User 1   | User 2 |
| :---  | :---     | :---   |
| 1     | `select * from department where department_id in (10, 20)`| `select * from department where department_id in (10, 20)` |
| 2     | Lakukan Update `department_id = 10` set `department_name = 'Administrator'`| Lakukan Update `department_id = 20` set `department_name = 'Market'` |
| 3     | `select * from department where department_id in (10, 20)`| `select * from department where department_id in (10, 20)` |
| 4     | `commit`| `commit` |
| 5     | `select * from department where department_id in (10, 20)`| `select * from department where department_id in (10, 20)` |

Berikut hasilnya:

<div>
    <div id="termina1" class="col m12 l6">
        ### Session 1

        {% highlight sql %}
        SQL> select DEPARTMENT_ID, DEPARTMENT_NAME
        from DEPARTMENTS
        where DEPARTMENT_ID in (10, 20);

        DEPARTMENT_ID DEPARTMENT_NAME
        ------------- ------------------------------
                10 Admin
                20 Marketing

        SQL> update DEPARTMENTS set DEPARTMENT_NAME = 'Administrator'
        where DEPARTMENT_ID = 10;

        1 row updated.

        SQL> select DEPARTMENT_ID, DEPARTMENT_NAME
        from DEPARTMENTS
        where DEPARTMENT_ID in (10, 20);

        DEPARTMENT_ID DEPARTMENT_NAME
        ------------- ------------------------------
                10 Administrator
                20 Marketing

        SQL> commit;

        Commit complete.

        SQL> select DEPARTMENT_ID, DEPARTMENT_NAME
        from DEPARTMENTS
        where DEPARTMENT_ID in (10, 20);

        DEPARTMENT_ID DEPARTMENT_NAME
        ------------- ------------------------------
                10 Administrator
                20 Market
        {% endhighlight %}
    </div>

    <div id="terminal2" class="col m12 l6">
        ### Session 2

        {% highlight sql %}
        SQL> select DEPARTMENT_ID, DEPARTMENT_NAME
        from DEPARTMENTS
        where DEPARTMENT_ID in (10, 20);

        DEPARTMENT_ID DEPARTMENT_NAME
        ------------- ------------------------------
                10 Admin
                20 Marketing

        SQL> update DEPARTMENTS set DEPARTMENT_NAME = 'Market'
        where DEPARTMENT_ID = 20;

        1 row updated.

        SQL> select DEPARTMENT_ID, DEPARTMENT_NAME
        from DEPARTMENTS
        where DEPARTMENT_ID in (10, 20);

        DEPARTMENT_ID DEPARTMENT_NAME
        ------------- ------------------------------
                10 Admin
                20 Market

        SQL> commit;

        Commit complete.

        SQL> select DEPARTMENT_ID, DEPARTMENT_NAME
        from DEPARTMENTS
        where DEPARTMENT_ID in (10, 20);

        DEPARTMENT_ID DEPARTMENT_NAME
        ------------- ------------------------------
                10 Administrator
                20 Market
        {% endhighlight %}
    </div>
</div>

Jadi kesimpulannya, selama session belum di commit maka oracle akan membuat isolate transaction artinya tidak akan berpengaruh ke session lain.

