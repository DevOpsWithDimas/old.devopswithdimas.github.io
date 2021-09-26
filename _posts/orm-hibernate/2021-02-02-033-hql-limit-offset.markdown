---
layout: post
title: "LIMIT & OFFSET dengan HQL"
date: 2021-02-02T18:09:23+07:00
lang: orm-hibernate
categories:
- Java
- ORM
- Hibernate
- PostgreSQL
refs: 
- https://docs.jboss.org/hibernate/orm/5.4/userguide/html_single/Hibernate_User_Guide.html#hql
youtube: 6_l82n1-WeE
comments: true
catalog_key: hql
gist: dimMaryanto93/e8d2abb5361e811860d6a462270f119b
image_path: /resources/posts/orm-hibernate/orm-hibernate-033
downloads: []
---

Hai pada kesempatan kali ini saya mau membahas tentang `limit` dan `offset` dengan menggunakan Hibernate Query Language (HQL). ok langsung ja berikut adalah implementasi DAO:

{% gist page.gist "HQLOffsetAndLimitDao.java" %}

Berikut adalah implementasi Unit Testing: 

{% gist page.gist "TestHQLOffsetAndLimit.java" %}

Setelah itu berikut adalah contoh data yang saya gunakan:

![select-table]({{ page.image_path | prepend: site.baseurl }}/select-tables.png)

Kemudian kita coba jalankan unit testing pada method `testOffsetData()`, maka hasilnya seperti berikut:

```bash
Feb 02, 2021 6:06:08 PM org.hibernate.engine.transaction.jta.platform.internal.JtaPlatformInitiator initiateService
INFO: HHH000490: Using JtaPlatform implementation: [org.hibernate.engine.transaction.jta.platform.internal.NoJtaPlatform]
Hibernate: 
    select
        employeepa0_.id as id1_33_,
        employeepa0_.street_address as street_a2_33_,
        employeepa0_.job_id as job_id3_33_,
        employeepa0_.manager_id as manager_6_33_,
        employeepa0_.full_name as full_nam4_33_,
        employeepa0_.salary as salary5_33_ 
    from
        parentchild.employees employeepa0_
[main] INFO com.maryanto.dimas.bootcamp.test.query.hql.TestHQLOffsetAndLimit - data: {size: 5, element: [Insan, Hari Sapto Adi, Abdul, Dea, Putri]}
[main] INFO com.maryanto.dimas.bootcamp.test.query.hql.TestHQLOffsetAndLimit - destroy hibernate session!
```

Lalu coba jalankan method `testLimitData()`, maka hasilnya seperti berikut:

```bash
Feb 02, 2021 6:07:25 PM org.hibernate.engine.transaction.jta.platform.internal.JtaPlatformInitiator initiateService
INFO: HHH000490: Using JtaPlatform implementation: [org.hibernate.engine.transaction.jta.platform.internal.NoJtaPlatform]
Hibernate: 
    select
        employeepa0_.id as id1_33_,
        employeepa0_.street_address as street_a2_33_,
        employeepa0_.job_id as job_id3_33_,
        employeepa0_.manager_id as manager_6_33_,
        employeepa0_.full_name as full_nam4_33_,
        employeepa0_.salary as salary5_33_ 
    from
        parentchild.employees employeepa0_ limit ?
[main] INFO com.maryanto.dimas.bootcamp.test.query.hql.TestHQLOffsetAndLimit - data: {size: 4, element: [Dimas Maryanto, Muhamad Yusuf, Prima, Insan]}
[main] INFO com.maryanto.dimas.bootcamp.test.query.hql.TestHQLOffsetAndLimit - destroy hibernate session!
```

dan yang terakhir coba jalankan method `testPaginate()`, maka hasilnya seperti berikut:

```bash
Feb 02, 2021 6:08:09 PM org.hibernate.engine.transaction.jta.platform.internal.JtaPlatformInitiator initiateService
INFO: HHH000490: Using JtaPlatform implementation: [org.hibernate.engine.transaction.jta.platform.internal.NoJtaPlatform]
Hibernate: 
    select
        employeepa0_.id as id1_33_,
        employeepa0_.street_address as street_a2_33_,
        employeepa0_.job_id as job_id3_33_,
        employeepa0_.manager_id as manager_6_33_,
        employeepa0_.full_name as full_nam4_33_,
        employeepa0_.salary as salary5_33_ 
    from
        parentchild.employees employeepa0_ limit ? offset ?
[main] INFO com.maryanto.dimas.bootcamp.test.query.hql.TestHQLOffsetAndLimit - data: {size: 3, element: [Abdul, Dea, Putri]}
[main] INFO com.maryanto.dimas.bootcamp.test.query.hql.TestHQLOffsetAndLimit - destroy hibernate session!
```