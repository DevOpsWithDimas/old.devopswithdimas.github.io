---
layout: post
title: "SubQuery Qualifiers dengan HQL"
date: 2021-02-01T15:10:28+07:00
lang: orm-hibernate
categories:
- Java
- ORM
- Hibernate
- PostgreSQL
refs: 
- https://docs.jboss.org/hibernate/orm/5.4/userguide/html_single/Hibernate_User_Guide.html#hql-relational-comparisons
youtube: RoIBsjsFU7Q
comments: true
catalog_key: hql
image_path: /resources/posts/orm-hibernate/orm-hibernate-030g
gist: dimMaryanto93/e8d2abb5361e811860d6a462270f119b
downloads: []
---

Hai di materi kali ini saya mau membahas tantang Sub Query Qualifier, yap seperti yang kita tau klo kita juga bisa menggunakan where clause sebagai pembandingnya adalah sub query seperti halnya pada sql di [materi postgresql](). Untuk operator yang kita bisa gunakan di hibernate yaitu 

1. `IN`
2. `ANY`
3. `SOME`
4. `ALL`

Untuk operator `SOME` ini adalah synonim dengan `ANY` jadi hasilnya akan sama. Ok sekarang contohnya berikut adalah data yang saya gunakan di tabel `parentchild.employees`

![select-tables]({{ page.image_path | prepend: site.baseurl }}/select-tables.png)

Kemudian berikut adalah implementasi DAO:

{% gist page.gist "HQLSubQueryQualifierDao.java" %}

Dan berikut adalah implementasi Unit Testing:

{% gist page.gist "TestHQLSubqueryQualifier.java" %}

Kemudian coba jalankan unit testing pada method `testInOperator()`, maka hasilnya seperti berikut:

```bash
Feb 01, 2021 3:07:02 PM org.hibernate.engine.transaction.jta.platform.internal.JtaPlatformInitiator initiateService
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
        employeepa0_.salary in (
            select
                employeepa1_.salary 
            from
                parentchild.employees employeepa1_ 
            where
                employeepa1_.job_id=?
        )
[main] INFO com.maryanto.dimas.bootcamp.test.query.hql.TestHQLSubqueryQualifier - data: [Dimas Maryanto, Muhamad Yusuf, Abdul, Insan, Putri, Dea, Prima]
[main] INFO com.maryanto.dimas.bootcamp.test.query.hql.TestHQLSubqueryQualifier - destroy hibernate session!
```

Kemudian coba jalankan method `testAllOperator()`, maka hasilnya seperti berikut:

```bash
Feb 01, 2021 3:07:52 PM org.hibernate.engine.transaction.jta.platform.internal.JtaPlatformInitiator initiateService
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
        employeepa0_.salary=all (
            select
                employeepa1_.salary 
            from
                parentchild.employees employeepa1_ 
            where
                employeepa1_.job_id=?
        )
[main] INFO com.maryanto.dimas.bootcamp.test.query.hql.TestHQLSubqueryQualifier - = ALL: []
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
        employeepa0_.salary>all (
            select
                employeepa1_.salary 
            from
                parentchild.employees employeepa1_ 
            where
                employeepa1_.job_id=?
        )
[main] INFO com.maryanto.dimas.bootcamp.test.query.hql.TestHQLSubqueryQualifier - < ALL: [Hari Sapto Adi]
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
        employeepa0_.salary>all (
            select
                employeepa1_.salary 
            from
                parentchild.employees employeepa1_ 
            where
                employeepa1_.job_id=?
        )
[main] INFO com.maryanto.dimas.bootcamp.test.query.hql.TestHQLSubqueryQualifier - > ALL: [Hari Sapto Adi]
[main] INFO com.maryanto.dimas.bootcamp.test.query.hql.TestHQLSubqueryQualifier - destroy hibernate session!
```

Kemudian coba jalankan method `testAnyOperator()`, maka hasilnya seperti berikut:

```bash
Feb 01, 2021 3:08:43 PM org.hibernate.engine.transaction.jta.platform.internal.JtaPlatformInitiator initiateService
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
        employeepa0_.salary=any (
            select
                employeepa1_.salary 
            from
                parentchild.employees employeepa1_ 
            where
                employeepa1_.job_id=?
        )
[main] INFO com.maryanto.dimas.bootcamp.test.query.hql.TestHQLSubqueryQualifier - = ANY: [Dimas Maryanto, Muhamad Yusuf, Abdul, Insan, Putri, Dea, Prima]
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
        employeepa0_.salary<any (
            select
                employeepa1_.salary 
            from
                parentchild.employees employeepa1_ 
            where
                employeepa1_.job_id=?
        )
[main] INFO com.maryanto.dimas.bootcamp.test.query.hql.TestHQLSubqueryQualifier - < ANY: [Muhamad Yusuf, Abdul, Insan, Dea]
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
        employeepa0_.salary>any (
            select
                employeepa1_.salary 
            from
                parentchild.employees employeepa1_ 
            where
                employeepa1_.job_id=?
        )
[main] INFO com.maryanto.dimas.bootcamp.test.query.hql.TestHQLSubqueryQualifier - > ANY: [Dimas Maryanto, Hari Sapto Adi, Muhamad Yusuf, Insan, Putri, Dea, Prima]
[main] INFO com.maryanto.dimas.bootcamp.test.query.hql.TestHQLSubqueryQualifier - destroy hibernate session!
```

Dan yang terakhir coba jalankan method `testSomeOperator()`, maka hasilnya seperti berikut:

```bash
Feb 01, 2021 3:09:27 PM org.hibernate.engine.transaction.jta.platform.internal.JtaPlatformInitiator initiateService
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
        employeepa0_.salary=some (
            select
                employeepa1_.salary 
            from
                parentchild.employees employeepa1_ 
            where
                employeepa1_.job_id=?
        )
[main] INFO com.maryanto.dimas.bootcamp.test.query.hql.TestHQLSubqueryQualifier - = SOME: [Dimas Maryanto, Muhamad Yusuf, Abdul, Insan, Putri, Dea, Prima]
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
        employeepa0_.salary<some (
            select
                employeepa1_.salary 
            from
                parentchild.employees employeepa1_ 
            where
                employeepa1_.job_id=?
        )
[main] INFO com.maryanto.dimas.bootcamp.test.query.hql.TestHQLSubqueryQualifier - < SOME: [Muhamad Yusuf, Abdul, Insan, Dea]
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
        employeepa0_.salary>some (
            select
                employeepa1_.salary 
            from
                parentchild.employees employeepa1_ 
            where
                employeepa1_.job_id=?
        )
[main] INFO com.maryanto.dimas.bootcamp.test.query.hql.TestHQLSubqueryQualifier - > SOME: [Dimas Maryanto, Hari Sapto Adi, Muhamad Yusuf, Insan, Putri, Dea, Prima]
[main] INFO com.maryanto.dimas.bootcamp.test.query.hql.TestHQLSubqueryQualifier - destroy hibernate session!
```