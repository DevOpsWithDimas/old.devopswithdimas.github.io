---
layout: post
title: "Transaction Locking di Oracle"
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

Untuk mendukung concurrent transaction, database oracle senantiasa menjamin bahwa data yang pada suatu tabel selalu valid. Hal ini dilakukan oleh oracle dengan makanisme Lock. Oracle menerapkan row-level lock pada setiap perintah modifikasi data jadi setiap ada perintah update atau delete pada suatu tabel akan dicheck dulu ada transaksi yang menggunakan tabel tersebut atau tidak. Berikut ilustrasinya:

| No    | User 1   | User 2 |
| :---  | :---     | :---   |
| 1     | `select * from department where department_id in (10, 20)`| `select * from department where department_id in (10, 20)` |
| 2     | Lakukan Update `department_id = 10` set `department_name = 'Administrator'`| Lalukan sama dengan session 1 |
| 3     | `select * from department where department_id in (10, 20)`| hang nunggu transaksi session 1 selesai |
| 4     | `commit`| - |
| 5     | `select * from department where department_id in (10, 20)`| `select * from department where department_id in (10, 20)` |
