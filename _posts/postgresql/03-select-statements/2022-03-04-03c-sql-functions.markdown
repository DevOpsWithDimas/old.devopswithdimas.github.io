---
layout: post
title: "Build-in Functions in PostgreSQL"
date: 2022-03-04T19:22:24+07:00
lang: postgresql
categories:
- RDBMS
- PostgreSQL
refs: 
- https://www.postgresql.org/docs/current/functions-string.html
- https://www.postgresql.org/docs/current/functions-math.html
- https://www.postgresql.org/docs/current/functions-formatting.html
- https://www.postgresql.org/docs/current/functions-datetime.html
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
3. Date/Time function
4. Nulless function
5. Data type formatting function

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

## Date/Time function

This section describes and shows the available functions for `date/time` value processing, with details appearing in the following subsections. 

| Functions	                                                |  Description        |
| :------- 	                                                | :----------         |
| `current_date → date`                                     | Current date        |
| `current_time → time with time zone`                      | Current time of day |
| `current_timestamp → timestamp with time zone`            | Current date and time (start of current transaction) |
| `now () → timestamp with time zone`                      | Current date and time (start of current transaction) |
| `extract ( field from timestamp ) → numeric`              | Get timestamp subfield |
| `isfinite ( date ) → boolean`                             | Test for finite date (not +/-infinity) |
| `age ( timestamp, timestamp ) → interval`                 | Subtract arguments, producing a “symbolic” result that uses years and months, rather than just days |
| `age ( timestamp ) → interval`                            | Subtract argument from current_date (at midnight) |

The extract function retrieves subfields such as year or hour from `date/time` values. field is an identifier or string that selects what field to extract from the source value

1. `century`
2. `day`
3. `decade`
4. `epoch`
5. `hour`
6. `milliseconds`
7. `minute`
8. `month`
9. `year`

Berikut adalah implementasi SQLnya:

{% gist page.gist "03c-select-datetime-function.sql" %}

Jika dijalankan hasilnya seperti berikut:

```postgresql-console
hr=# select  current_date tgl_sekarang,
hr-#         now() datetime_sekarang_func,
hr-#         current_timestamp as datetime_tz,
hr-#         age(timestamp '1991-03-01') as years_old,
hr-#         extract(year from current_timestamp) get_current_year,
hr-#         extract(month from current_date) get_current_month;
 tgl_sekarang |    datetime_sekarang_func     |          datetime_tz          |    years_old    | get_current_year | get_current_month
--------------+-------------------------------+-------------------------------+-----------------+------------------+-------------------
 2022-03-04   | 2022-03-04 12:04:26.070727+00 | 2022-03-04 12:04:26.070727+00 | 31 years 3 days |             2022 |                 3
(1 row)
```

## Nulless function

Function untuk menghandle nilai `null` di PostgreSQL bisa menggunakan berbagai macam cara yaitu 

1. `COALESCE(value [, ...])`
2. `NULLIF(value1, value2)`

The `COALESCE` function returns the first of its arguments that is not null. Null is returned only if all arguments are `null`. It is often used to substitute a default value for `null` values when data is retrieved for display.

The `NULLIF` function returns a null value if `value1` equals `value2`; otherwise it returns `value1`. This can be used to perform the inverse operation of the `COALESCE`

Berikut adalah implementasi SQLnya:

{% gist page.gist "03c-select-nuless-function.sql" %}

Jika dijalankan hasilnya seperti berikut:

```postgresql-console
hr=# select  COALESCE(null, 'data1', 'data2') return_data1,
hr-#         COALESCE(null, null, 'data2') return_data2,
hr-#         COALESCE(null, null, null) return_null,
hr-#         NULLIF(null, 'data1') return_null1,
hr-#         NULLIF('data1', 'data1') return_null2,
hr-#         NULLIF('data1', 'data2') return_data1;
 return_data1 | return_data2 | return_null | return_null1 | return_null2 | return_data1
--------------+--------------+-------------+--------------+--------------+--------------
 data1        | data2        |             |              |              | data1
(1 row)
```

## Data type formatting function

The PostgreSQL formatting functions provide a powerful set of tools for converting various data types (`date/time`, `integer`, `floating point`, `numeric`) to formatted `strings` and for converting from formatted strings to specific data types. These functions all follow a common calling convention: the first argument is the value to be formatted and the second argument is a template that defines the output or input format.

| Functions	                                                |  Description        |
| :------- 	                                                | :----------         |
| `to_char ( timestamp, date-patterns ) → text`                      | Converts time stamp to string according to the given format. |
| `to_char ( interval, date-patterns ) → text`                       | Converts interval to string according to the given format. |
| `to_char ( numeric_type, number-pattern ) → text`                   | Converts number to string according to the given format; available for `integer`, `bigint`, `numeric`, `real`, `double precision`. |
| `to_date ( text, date-patterns ) → date`                           | Converts string to date according to the given format. |
| `to_number ( text, number-pattern ) → numeric`                      | Converts string to numeric according to the given format. |
| `to_timestamp ( text, date-patterns ) → timestamp with time zone`  | Converts string to time stamp according to the given format. |

The `date-patterns` template patterns available for formatting date and time values.

| Pattern	|  Description              |
| :------- 	| :----------               |
| `HH`      | hour of day (`01–12`)     |
| `HH24`    | hour of day (`01–24`)     |
| `MI`      | minute (`00–59`)          |
| `SS`      | second (`00–59`)          |
| `MS`      | millisecond (`000–999`)   |
| `DD`      | day of month (`01–31`)    |
| `DAY`     | full upper case day name (blank-padded to `9 chars`)    |
| `D`       | day of the week, `Sunday` to `Saturday` |
| `MM`      | month number (`01–12`)    |
| `MON`     | abbreviated upper case month name (`3 chars` in English, localized lengths vary) |
| `YY`      | last 2 digits of year |
| `YYYY`    | year (4 or more digits) |

The `number-pattern` template patterns available for formatting numeric values.

| Pattern	        |  Description              |
| :------- 	        | :----------               |
| `9`               | digit position (can be dropped if insignificant) |
| `0`               | digit position (will not be dropped, even if insignificant) |
| `.` (period)      | decimal point |
| `,` (comma)       | group (thousands) separator |
| `L`               | currency symbol (uses locale) |
| `RN`              | Roman numeral (input between `1` and `3999`) |

Berikut adalah implementasi SQLnya:

{% gist page.gist "03c-select-formating-function.sql" %}

Jika dijalankan hasilnya seperti berikut:

```postgresql-console
hr=# select  to_char(current_date, 'DD/MON/YYYY') date_indonesia,
hr-#         to_char(current_timestamp, 'DD/MM/YYYY HH24:MM') datetime_indonesia,
hr-#         to_char(1000000, 'RpL999,999,999.00-') sejuta_rupiah,
hr-#         to_date('02/03/22', 'DD/MM/YY') format_ke_date,
hr-#         to_number('10,132,456.53', '999,999,999') format_ke_number;
 date_indonesia | datetime_indonesia |    sejuta_rupiah    | format_ke_date | format_ke_number
----------------+--------------------+---------------------+----------------+------------------
 04/MAR/2022    | 04/03/2022 11:03   | Rp    1,000,000.00- | 2022-03-02     |         10132456
(1 row)
```