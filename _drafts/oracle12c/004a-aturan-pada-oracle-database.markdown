---
layout: post
title: "Aturan Penulisan SQL pada Oracle Database"
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/18/sqlrf/Database-Object-Names-and-Qualifiers.html#GUID-05F1B577-C08C-4DB9-925A-8799C76ADFF4
- https://docs.oracle.com/database/121/SQLRF/sql_elements008.htm#SQLRF51129
youtube: 
comments: true
image_path: /resources/posts/oracle12c/
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Dalam Database Management System biasanya memiliki ketentuan tertentu yang biasanya terkait dengan system security, performance, optimization dan lain-lain, Khususnya di Oracle Database berikut adalah beberapa ketentuan dalam penulisan query, query performance, dan definisi sebuah object dalam Database Oracle:

1. Perintah SQL bisa ditulis dengan huruf besar dan kecil (not case sensitive)
2. Kita bisa menulis query SQL dalam satu baris atau banyak, biasanya di pisahkan dengan `;`
3. Gunakan indentasi untuk setiap klausa supaya memudahkan kita untuk membacanya.
4. Untuk pendamaan nama object dalam database biasanya ditulis **dalam bentuk CAPITAL** yang di **pisahkan dengan underscore**,  contoh `EMPLOYEES`, `EMPLOYEE_ID`, `FIRST_NAME`