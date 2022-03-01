---
layout: post
title: "Build-in Functions in PostgreSQL"
lang: postgresql
categories:
- RDBMS
- PostgreSQL
refs: 
- https://www.postgresql.org/docs/14/functions-comparison.html#FUNCTIONS-COMPARISON-FUNC-TABLE
- https://www.postgresql.org/docs/current/functions-string.html
youtube: 
image_path: /resources/posts/postgresql/03c-sql-functions
comments: true
gist: dimMaryanto93/7ae7632f9418feb724bc431eff412a3f
catalog_key: sql-statement
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas Fuctions pada PostgreSQL, PostgreSQL provides a large number of functions for the built-in data types. Users can also define their own functions, as described in previews section but for now we explain build-in fuctions. 

ada banyak selali Fucntions, kita akan bahas beberapa yang menurut saya penting untuk di pelajari pada cource ini diantaranya:

1. String function
2. Math function
3. Data type formatting function
4. Date/Time function
5. Comparison function

Ok langsung aja kita bahas materi yang pertama

## String function

This section describes functions for examining and manipulating string values. Strings in this context include values of the types `character`, `character varying`, and `text`. Except where noted, these functions are declared to accept and return type text.

| Functions	                                                                                    |  Description      |
| :------- 	                                                                                    | :----------       |
| `substring ( string text [ FROM start integer ] [ FOR count integer ] ) → text`               | Extracts the substring of string starting at the start'th character if that is specified, and stopping after count characters if that is specified. Provide at least one of start and count. 	            |   
| `lower ( text ) → text` 	                                                                    | Converts the string to all lower case, according to the rules of the database's locale.                                                                                |  
| `upper ( text ) → text` 	                                                                    | Converts the string to all upper case, according to the rules of the database's locale.                                                                                |   
| `trim ( [ LEADING | TRAILING | BOTH ] [ FROM ] string text [, characters text ] ) → text`     | Removes the longest string containing only characters in characters (a space by default) from the start, end, or both ends (BOTH is the default) of string.          |    
| `position ( substring text IN string text ) → integer` 	                                    | Returns first starting index of the specified substring within string, or zero if it's not present.                                                                               |    
| `character_length ( text ) → integer` 	                                                    | Returns number of characters in the string.                                                                                | 
| `ascii ( text ) → integer`                                                                    | Returns the numeric code of the first character of the argument. In UTF8 encoding, returns the Unicode code point of the character. In other multibyte encodings, the argument must be an ASCII character.  | 
| `concat ( val1 "any" [, val2 "any" [, ...] ] ) → text`                                        | Concatenates the text representations of all the arguments. NULL arguments are ignored.                                                                               | 
| `initcap ( text ) → text`                                                                     | Converts the first letter of each word to upper case and the rest to lower case. Words are sequences of alphanumeric characters separated by non-alphanumeric characters.                                   | 
| `length ( text ) → integer`                                                                   | Returns the number of characters in the string.                                                                                | 
| `reverse ( text ) → text`                                                                     | Reverses the order of the characters in the string.                                                                                | 
| `substr ( string text, start integer [, count integer ] ) → text`                             | Extracts the substring of string starting at the start'th character, and extending for count characters if that is specified. (Same as substring(string from start for count).)                           | 

Berikut adalah implementasinya pada PostgreSQL:

{% gist page.gist "03c-select-string-function.sql" %}

Jika dijalankan hasilnya seperti berikut:

```postgresql-console
hr=# select  substring('Dimas Maryanto' from 1 for 3) as "substring from",
hr-#         substr('Dimas Maryanto', 1, 5) as "substr",
hr-#         lower('Ini Adalah Text BESAR dan Kecil') as "lower",
hr-#         upper('Ini Adalah Text BESAR dan Kecil') as "upper",
hr-#         initcap('Ini Adalah Text BESAR dan Kecil') as "initcamp",
hr-#         trim(both ' ' from '  ini text ada spacenya  ') as "trim both",
hr-#         trim(trailing ' ' from '  ini text ada spacenya  ') as "trim trailing",
hr-#         reverse('dimas') as "reverse",
hr-#         length('dimas maryanto') as "length",
hr-#         concat('dimasm93', ' : ', 'Dimas Maryanto') as "concat",
hr-#         ascii('D') as "ascii";
 substring from | substr |              lower              |              upper              |            initcamp             |       trim both       |      trim trailing      | reverse | length |          concat           | ascii
----------------+--------+---------------------------------+---------------------------------+---------------------------------+-----------------------+-------------------------+---------+--------+---------------------------+-------
 Dim            | Dimas  | ini adalah text besar dan kecil | INI ADALAH TEXT BESAR DAN KECIL | Ini Adalah Text Besar Dan Kecil | ini text ada spacenya |   ini text ada spacenya | samid   |     14 | dimasm93 : Dimas Maryanto |    68
(1 row)
```

## Math function

