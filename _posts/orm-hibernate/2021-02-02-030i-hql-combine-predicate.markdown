---
layout: post
title: "Combine Predicate dengan HQL"
date: 2021-02-02T14:57:44+07:00
lang: orm-hibernate
categories:
- Java
- ORM
- Hibernate
- PostgreSQL
refs: 
- https://docs.jboss.org/hibernate/orm/5.4/userguide/html_single/Hibernate_User_Guide.html#hql-and-predicate
- https://docs.jboss.org/hibernate/orm/5.4/userguide/html_single/Hibernate_User_Guide.html#hql-or-predicate
youtube: pjQKHg4hVDU
comments: true
catalog_key: hql
image_path: /resources/posts/orm-hibernate/orm-hibernate-030i
gist: dimMaryanto93/e8d2abb5361e811860d6a462270f119b
downloads: []
---

Hai kesempatan kali ini saya mau membahas tentang Combine Predicate dengan menggunakan Hibernate Query Language (HQL). Combine predicate terdiri dari 

1. OR Predicate
2. And Predicate
3. gabungan

berikut adalah implementasi DAO:

{% gist page.gist "HQLCombinePredicateDao.java" %}

Implementasi unit testing

{% gist page.gist "TestHQLCombinePredicate.java" %}

Sebelum kita coba, berikut adalah data yang saya gunakan:

![select-tables]({{ page.image_path | prepend: site.baseurl }}/select-tables.png)

Setelah itu coba jalankan unit testing pada method `testAndOperator()`, maka hasilnya seperti berikut:

```bash
Feb 02, 2021 2:54:14 PM org.hibernate.engine.transaction.jta.platform.internal.JtaPlatformInitiator initiateService
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
    where
        employeepa0_.salary>=? 
        and employeepa0_.job_id=?
[main] INFO com.maryanto.dimas.bootcamp.test.query.hql.TestHQLCombinePredicate - data: [Muhamad Yusuf, Prima, Insan]
[main] INFO com.maryanto.dimas.bootcamp.test.query.hql.TestHQLCombinePredicate - destroy hibernate session!
```

Kemudian coba jalankan method `testOrOperator()`, maka hasilnya seperti berikut:

```bash
Feb 02, 2021 2:54:56 PM org.hibernate.engine.transaction.jta.platform.internal.JtaPlatformInitiator initiateService
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
    where
        employeepa0_.salary>=? 
        or employeepa0_.job_id=?
[main] INFO com.maryanto.dimas.bootcamp.test.query.hql.TestHQLCombinePredicate - data: [Dimas Maryanto, Muhamad Yusuf, Prima, Insan, Hari Sapto Adi, Abdul, Dea, Putri]
[main] INFO com.maryanto.dimas.bootcamp.test.query.hql.TestHQLCombinePredicate - destroy hibernate session!
```

Kemudian kita coba jalankan method `testOrAndOperator()`, maka hasilnya seperti berikut:

```bash
Feb 02, 2021 2:55:36 PM org.hibernate.engine.transaction.jta.platform.internal.JtaPlatformInitiator initiateService
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
    where
        employeepa0_.salary>=? 
        and employeepa0_.job_id=? 
        or employeepa0_.manager_id is null
[main] INFO com.maryanto.dimas.bootcamp.test.query.hql.TestHQLCombinePredicate - data: [Muhamad Yusuf, Prima, Insan, Hari Sapto Adi, Dea, Putri]
[main] INFO com.maryanto.dimas.bootcamp.test.query.hql.TestHQLCombinePredicate - destroy hibernate session!
```

Dan yang terakhir coba jalankan method `testOrAndWithPriorityOperator()`, maka hasilnya seperti berikut:

```bash
Feb 02, 2021 2:56:22 PM org.hibernate.engine.transaction.jta.platform.internal.JtaPlatformInitiator initiateService
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
    where
        employeepa0_.salary>=? 
        or employeepa0_.job_id=? 
        and (
            employeepa0_.manager_id is null
        )
[main] INFO com.maryanto.dimas.bootcamp.test.query.hql.TestHQLCombinePredicate - data: [Dimas Maryanto, Muhamad Yusuf, Prima, Insan, Hari Sapto Adi, Dea, Putri]
[main] INFO com.maryanto.dimas.bootcamp.test.query.hql.TestHQLCombinePredicate - destroy hibernate session!
```