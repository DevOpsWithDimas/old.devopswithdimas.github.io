---
layout: post
title: "DDL - Enabled & Disabled Constraints"
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/constraint.html#GUID-1055EA97-BA6F-4764-A15F-1024FD5B6DFE
youtube: 
comments: true
image_path: /resources/posts/oracle12c/016n-disable-enable-constraints
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Sometime kita perlu me-disable constraint secara temporary untuk mempercepat proses seperti:

1. Batch insert operation, 
2. Load data dalam jumlah yang besar 
3. Import & Export semua data dalam table. 

Melakukan disabled constraint akan _improve performance operation_ khususnya pada data _warehouse configuration_.