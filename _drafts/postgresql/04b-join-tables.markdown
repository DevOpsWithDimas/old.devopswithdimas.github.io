---
layout: post
title: "Joined Tables"
lang: postgresql
categories:
- RDBMS
- PostgreSQL
- sql
- select
refs: 
- https://www.postgresql.org/docs/14/queries-table-expressions.html#joined_tables
youtube: 
image_path: /resources/posts/postgresql/03h-join-tables
comments: true
gist: dimMaryanto93/7ae7632f9418feb724bc431eff412a3f
catalog_key: select-statement
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas Join Tables di PostgreSQL. A joined table is a table derived from two other (real or derived) tables according to the rules of the particular join type. Inner, outer, and cross-joins are available.

The general syntax of a joined table is

{% highlight sql %}
T1 join_type T2 [ join_condition ]
{% endhighlight %}

Joins of all types can be chained together, or nested: either or both `T1` and `T2` can be joined tables. Parentheses can be used around `JOIN` clauses to control the join order. In the absence of parentheses, `JOIN` clauses nest left-to-right.

{% mermaid %}
graph TD;
    A-->B;
    A-->C;
    B-->D;
    C-->D;
{% endmermaid %}