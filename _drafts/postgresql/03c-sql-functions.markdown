---
layout: post
title: "Build-in Functions in PostgreSQL"
lang: postgresql
categories:
- RDBMS
- PostgreSQL
refs: 
- https://www.postgresql.org/docs/current/functions-string.html
- https://www.postgresql.org/docs/current/functions-math.html
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

This section describes and shows the available mathematical functions for calculation. Many of these functions are provided in multiple forms with different argument types. Except where noted, any given form of a function returns the same data type as its argument(s); cross-type cases are resolved in the same way as operators.

| Functions	                                                |  Description        |
| :------- 	                                                | :----------         |
| `abs ( numeric_type ) → numeric_type`                     | Absolute value      |
| `div ( y numeric, x numeric ) → numeric`                  | Integer quotient of `y/x` (truncates towards zero) |
| `factorial ( bigint ) → numeric`                          | Factorial |
| `floor ( numeric ) → numeric`                             | Nearest integer less than or equal to argument |
| `mod ( y numeric_type, x numeric_type ) → numeric_type`   | Remainder of `y/x;` available for smallint, integer, bigint, and numeric |
| `pi ( ) → double precision`                               | Approximate value of `π` |
| `power ( a numeric, b numeric ) → numeric`                | `a` raised to the power of `b` |
| `round ( numeric ) → numeric`                             | Rounds to nearest integer. For numeric, ties are broken by rounding away from zero. |
| `sqrt ( numeric ) → numeric`                              | Square root |
| `random ( ) → double precision`                           | Returns a random value in the range `0.0 <= x < 1.0` |

Selain itu juga tersedia function lainnya seperti:

1. Trigonometric Functions
2. Hyperbolic Functions

Berikut adalah implementasi SQLnya:

{% gist page.gist "03c-select-math-function.sql" %}

Jika dijalankan hasilnya seperti berikut:

```postgresql-console
hr=# select  abs(-10) "absolut",
hr-#         div(10, 3) "division",
hr-#         mod(5, 2) "mod",
hr-#         power(2, 3) "power",
hr-#         round(5.451234, 2) "round scale2",
hr-#         round(5.43) "round",
hr-#         round(5.6) "roundup",
hr-#         floor(5.45234) "floor",
hr-#         floor(5.6) "floor2";
 absolut | division | mod | power | round scale2 | round | roundup | floor | floor2
---------+----------+-----+-------+--------------+-------+---------+-------+--------
      10 |        3 |   1 |     8 |         5.45 |     5 |       6 |     5 |      5
(1 row)
```