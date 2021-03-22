---
layout: post
title: "Perancangan / Design Table (Relationship)"
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/index.html
- https://www.xplenty.com/blog/complete-guide-to-database-schema-design-guide/
youtube: 
comments: true
image_path: /resources/posts/oracle12c/018-database-mappings
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Suatu Database yang sifatnya Relational intinya memiliki banyak table dalam Schema yang saling ber-relasi, Sebelum membuat table ada baiknya atau penting sekali untuk membuat perancangan / design table seperti structure tabel, relation mapping dan lain-lain.

## Importance of Database Schema Design

Database digunakan untuk menyimpan semua data yang dibutuhkan oleh software application atau system, ini penting karena setidaknya database harus bisa menghandle downtime `0.01% of 100%`. 

Masalah downtime ini bisa macam-macam penyebabnya salah satunya adalah **Salah dalam perancangan / design object database** seperti Strutur Table yang tidak normal, ini bisa menyebabkan membengkaknya storage system karena nilai redudansi yang gak bisa di tolerir. 

## What to do in Database Design
