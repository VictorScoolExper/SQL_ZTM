-- Video 55
-- Simple select all
SELECT * FROM "public"."employees";
SELECT * FROM "employees";

-- Question and answers
-- How many departments are there in the company?
SELECT * FROM "public"."departments";
-- How many times has employee 10001 had a raise?
SELECT * FROM "public"."salaries";
-- What title does 10006 have?
SELECT * FROM "public"."titles";

-- Video 56
-- Renaming employee columns 
SELECT 
    emp_no as "Employee #", 
    birth_date as "Birthday", 
    first_name as "First name" 
FROM "public"."employees";

-- Video 57
-- Concat the first and last name of the employee into one column
-- Rename the concatenated column
SELECT CONCAT(emp_no, ' ', title) FROM "public"."titles";
SELECT CONCAT(emp_no, ' is a ', title) FROM "public"."titles";
SELECT CONCAT(emp_no, ' is a ', title) AS "Employee Title" FROM "public"."titles";
-- Concatenate the first and last name of the employee into one column
-- Rename the concatenated column
SELECT 
    emp_no, 
    CONCAT(first_name, ' ', last_name) AS "full name"
FROM employees;

-- video 58
-- What is a function? A set of steps that create a single value
-- A function runs when the queries calls the functions
-- Types of function: Aggregate: add them all together, Scalar: run against each individual row of data.
-- Aggregate functions: operate on many records to produce 1 value. => produces a summary
-- Scalar (Non-aggregate): operate on each record independently.

-- video 59
-- Aggregate functions: 
-- AVG(): calculates the average of a set of values.
-- COUNT(): counts row in a specified table of view.
-- MIN(): gets the minimum value in a set of values.
-- MAX(): gets the maximum value in a set of values.
-- SUM(): calculates the sum of values.

-- Get the total number of empoyees
SELECT  count( emp_no ) FROM employees;
-- Get the highest salary available
SELECT max(salary) FROM salaries;
-- Get the total amount of salaries paid
SELECT sum(salary) FROM salaries;

-- video 61
-- Adding Comments
-- single line comments
/*
* Multi line comments
*/
-- Question: Select the employee with the name Mayumi Schueller
SELECT first_name, last_name FROM "public"."employees"
WHERE first_name = 'Mayumi' AND last_name='Schueller';
-- Question: Comment on your query what is happening
-- select statement to filter Mayumi Schueller
SELECT first_name, last_name FROM "public"."employees"
/*
filter on first name and last name to limit the amount of data returned
and focus the filtering on a sinle person
*/
WHERE first_name = 'Mayumi' AND last_name='Schueller'; -- filter here on Mayumi Schueller

-- video 62
-- Common select mistakes
-- Misspelling commands
-- Using; Instead of , or vice versa
-- Using "" Instead of ''
--  "" is for tables and '' is for text
-- Invalid column name

-- video 63
-- How to filter data
-- Question: Get a list of all females employees
SELECT first_name FROM employees
WHERE gender = 'F';

-- video 64: 
-- AND and OR
-- When using the 'AND' it does involve a hierachy
-- Order of Operations, will check so use the "()" to help filter out
-- Question: What if you want to filter on 2 first names
SELECT first_name, last_name, hire_date FROM employees
WHERE (first_name = 'Georgi' AND last_name = 'Facello' AND hire_date = '1986-06-26')
OR (first_name = 'Bezalel' AND last_name = 'Simmel');

-- video 65
-- Exercise filtering data
-- Question: How many female customers do we have from the state of oregon (OR) and New York (NY)
SELECT count(gender) FROM "public"."customers"
WHERE gender = 'F' AND (state = 'OR' OR state = 'NY');

-- video 66
-- The NOT keyword
-- You want to filter on everything but...?
-- Question: How many customers aren't 55?
SELECT count(age) FROM "public"."customers"
WHERE NOT age = 55;

/*
video 68 
Comparison Operator:
    10 > 20 : false
    10 < 20: true
    10 <= 20: true
    10 >= 9: true
    0 = 0: true
    1 != 0: true
*/
-- Question: Who over the age of 44 has an income of 100 000 or more?
SELECT * FROM "public"."customers"
WHERE age > 44 AND income >= 100000;

/*
video 70
Logical Operators
    AND: if both the boolean expressions are true then it will return results.
    OR: if any boolean expression is true then it will return results.
    NOT: if any boolean expression is not true then it will return results.

Order of operations
    FROM => WHERE => SELECT
*/

/*
video 71
Operator Precedence: A statement having multiple operators is 
evaluated based on the priority if operators.
Operator Precedence:
PARENTHESIS => MULTIPLICATION/DIVISION => NOT => AND => OR
Check out the operator precedence table to view the order of how things are executed.
*/
-- Example given: Get me state and gender where you are: a female from oregon or a female from NY
SELECT state,gender FROM customers
-- Checks first if from OR or NY then if Female
WHERE gender='F' AND (state='OR' OR state='NY');

/*
video 72
Operator Precedence 2
remember the order: PARENTHESIS => MULTIPLICATION/DIVISION => NOT => AND => OR
Note: the database management model does alot of the optimization.

Direction: If the operators have equal precedence, then the operators are evaluated
directionally, from left to right or right to left.


Priority and Direction
Always remember the following: HIGHEST to LOWEST
    1. Parenthesis
    2. Arithmetic Operators
    3. Concatenation Operators
    4. Comparison Conditions
    5. IS NULL, LIKE, NOT IN, etc.
    6. NOT
    7. AND
    8. OR
*/

/*
video 75
Checking for NULL values
What is a null? 
A NULL value is different from a zero value or a field that contains spaces.

A contentious Issue:
Null is a contentious issue no matter what opinion you have 
people may disagree

All roads lead to NULL:
No matter what you do with NULL it will always be NULL, SUBTRACT, DIVIDE, EQUAL..

*/

/*
video 76
IS keyword
How I should use "IS":
    data is: 
    Optional or Required?
    Future info?
    Rational?

The "IS" Operator: Allows you to filter on values that are NULL, NOT NULL, TRUE or FALSE.

ALWAYS CHECK FOR NULLS WHEN NECESSARY!
    1: Filter out NULLS
    2: Clean up your data (in video 77)

Example:
    SELECT name, lastName from "Student"
    WHERE lastName IS NOT NULL;

How to us the "IS" Operator:
    SELECT * FROM <table>
    -- below validates where the field is empty
    WHERE <field> = '' IS NOT FALSE;

Example 2:
    SELECT * FROM users
    -- Everyone that is not 20
    WHERE age = 20 IS FALSE;
*/


/*
video 77
ALWAYS CHECK FOR NULLS WHEN NECESSARY!
    1: Filter out NULLS (Comes from video 76)
    2: Clean up your data

NULL values Substitution:
Ability to replace Null values to operate on the data.
Coalesce allows use to do this:
    -- When the column is null replace it for empty
    SELECT coalesce(<column>, 'Empty') AS column_alias
    FROM <table/>
Coalesce returns the first NON-NULL value in a list.
Combine COALESCING
    -- It cycles through the declared columns 
    SELECT COALESCE(
        <column1>,
        <column2>,
        <column3>,
        'Empty'
    ) AS combined_columns
    FROM <table>
Example:
    -- We can also colesce when combining with other functions
    SELECT sum(coalesce(age, 20)) FROM
    "Student";
*/

/*
video 79
3 Valued Logic
Three-Valued LOGIC: Besides true and false, the result of logical expressions can also be unkown.
How three-valued logic works?: Can be true, null or false  

The SQL NUll value "Could be anything"
Nothing equals NULL not even NULL, each NULL could be different.
That's why we use "IS NULL" to check.
*/

/*
video 81
BETWEEEN AND: Shorthand to match against a range of values.
*/

/*
video 83
IN keyword
Filtering Multiple values: What if i want to find multiple values but not write endless and statements?
The IN keyword checks if a value matches any values in a list of values.
Example:
SELECT * FROM employees
WHERE emp_no IN (100001, 100006, 11008);
*/

/*
video 85
LIKE
Partial lookups: What if you don't know exactly what you're searching for?
Example: Get everyone who's name starts with 'M'
    SELECT first_name FROM employees
    WHERE first_name LIKE 'M%';

Pattern Matching: In order to use like you need to build patterns to match!
This methods works with "Pattern Wildcards", "%" meaning any number of character 
or "_" 1 character.

USE CASE TABLE:
use Case:           Meaning:
LIKE '%2'           Fields that end with 2
LIKE '%2%'          Fields that have 2 anywhere in that value
LIKE '_00%'         Fields that have 2 zero's as the second and third character and anything after
LIKE '%200%'        Fields that have 200 anywhere in the value.
LIKE '2_%_%'        Finds any values that start with 2 and are at least 3 characters in length
LIKE '2___3'         Finds any values in a five-digit number that start with 2 and end with 3

POSTGRES LIKE only does text comparison so we must cast whatever we use to text
CASTING: is the act of changing something to something else.
Example:
    CAST(salary AS text);
    or
    salary::text

ILIKE: Does CASE INSENSITIVE MATCHING
You do not have to worry if it is uppercase or lowercase.
Example:
    SELECT * FROM employees
    WHERE first_name ILIKE 'g%';
*/

/*
video 87
Dates and Timezones

GMT: Greenwich Mean Time (Time zone)
UTC: Universal Coordinate Time (Time standard)
One is a time zone
One is a time standard
What is the difference: No territories use UTC.
They share the same current time.

Why should i use UTC?
If the app becomes internation we need a standard

To see Timezone use:
SHOW TIMEZONE;
To change the timezone in UTC for that session:
SET TIME ZONE 'UTC';
*/

/*
video 88
Setting up Timezones

To set the timezone:
ALTER USER postgres SET timezone='UTC';
validate that it is UTC:
SHOW TIMEZONE;
You should get a UTC output
Now all timezones will be UTC
*/

/*
video 89
How do we format Date and Time?

Manipulating Dates?
POSTGRESQL uses formating standard ISO-8601 for dates:
A format is a way of representing a date and time.
Year-Month-DayTHours-Minutes:seconds
YYYY-MM-DDTHH:MM:SS
Example:
The plus is a timezone:
2017-08-17T12:47:16+02:00
*/

/*
video 90
Timestamps

What is a timestamp:
A Timestamp is a date with time and timezone info, which uses ISO-8601.
These are great for a way to validate where the user might be.

Example of table:
CREATE TABLE timezones (
    ts TIMESTAMP WITHOUT TIME ZONE,
    tz TIMESTAMP WITH TIME ZONE
)
Note: that "with TIME ZONE" will take into account the timezone and convert it

Timestamps or Dates?
It depends on what you're storing
*/

/*
video 90
Date Functions

POSTGRES gives us operators to help simplify dates.
Current Date:
    SELECT NOW()::date;
    SELECT CURRENT_DATE;
Formatting with modifiers:
    SELECT TO_CHAR(CURRENT_DATE, 'dd/mm/yyyy');

*/

/*
video 92
Date Difference and Casting

Difference between two date:
    -- we will get the difference between now and 1800/01/01
    SELECT now() - '1800/01/01'
Subtracting dates return days
*/

/*
video 93
Age Calculating 

Example Calculating Age from now:
    SELECT AGE(date '1800-01-01');
returns: years<>months<>days
Example Calculate age between
    SELECT AGE(date '1992/11/13', date '1800/01/01');
returns: 192 years 10 months 12 days
*/

/*
video 94
Extracting Information

Round a date:
Example with year:
    SELECT DATE_TRUNC('year', date '1992/11/13');
returns 1992-01-01
DATE TRUNC are great fro getting a range of dates since it rounds them automatically
Example with month:
    SELECT DATE_TRUNC('month', date '1992/11/13');
returns 1992-11-01
Example with day:
    SELECT DATE_TRUNC('day', date '1992/11/13);
returns 1992-11-13

DATE TRUNC are great fro getting a range of dates since it rounds them automatically
*/

/*
video 95
Interval

Interval lets us talk about time in a readable manner.

Example of Interval: Gives us the date of purchase the past 30 days
    SELECT * 
    FROM orders
    WHERE purchaseDate <= now() - interval '30 days';

Intervals can store and manipulate a period of time in years, months, days, hours, minutes, seconds, ETC
Intervals Identifiers: Years, Months, Days, Hours, Minutes
Examples:
    - INTERVAL '1 year 2 months 3 days';
    - INTERVAL '2 weeks ago';
    - INTERVAL '1 year 3 hours 20 minutes';

We can also extract interval:
Example:
    SELECT EXTRACT(year FROM INTERVAL '5 years 20 months');

Adjusting Intervals can store and manipulate a period of time in years, months, days, hours, minutes, seconds, ETC.
*/

/*
video 97
Distinct

Distinct Keywords: It Remove Duplicates values. Or gets the unique values
Distinct clause keeps one row for each group of duplicates.
How to evaluate based on the combination of columns?
SELECT
    DISTINCT <col1>,<col2>
FROM
    <table>;
*/

/*
video 99
Sorting Data

Sort data either ascending or descending by column
ORDER BY:
    SELECT * FROM CUSTOMERS
    ORDER BY <column> [ASC/DESC]
Example of multi column:
    SELECT first_name, last_name FROM employees
    ORDER BY first_name, last_name DESC;
Example of Order by length:
    SELECT * FROM customers
    ORDER BY LENGTH(name) DESC;
*/

/*
video 101
Multi Table SELECT

What if you want to combine data from multiple tables?

A join combines columns from one table with those of another.
Takes a column from one table that can map to the column of another table.
Most common approach?
Link Primary Key to FOREIGN KEY.
*/


