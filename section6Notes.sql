/*
video 108
Group By

GROUP BY is summarizing or aggregating data by groups.

Why would you group?
To get in-depth information by group.

Question: What if we wanted to know how many employees worked in each department?
*/
SELECT dept_no, COUNT(emp_no)
FROM dept_emp
GROUP BY dept_no, emp_no
ORDER BY dept_no;
/*
GROUP BY
definition: splits data into groups or chunks so we can apply functions
against the group rather than the entire table.
We use GROUP BY almost exclusively with aggregate functions.
When we "GROUP BY" we apply the function per group, not on the entire data set.

THINGS TO REMEMBER:
every column not in the group-by clause must apply a function.
WHY?
to reduce all records found for the matching "GROUP" to a single record.
How does it work?
Group by utilizes a split-apply-combine strategy
*/

/*
video 110
HAVING keyword
What if i want to filter groups?

"WHERE" applies filters to individual rows
"HAVING" applies filters to a group as a whole
-- Example
*/
SELECT d.dept_name, count(e.emp_no) AS "# of employees"
FROM employees AS e 
INNER JOIN dept_emp AS de ON de.emp_no = e.emp_no
INNER JOIN departments AS d ON de.dept_no = d.dept_no
-- WHERE e.gender = 'F'
GROUP BY d.dept_name
HAVING count(e.emp_no) > 25000; 
-- In certian situation you can have both a WHERE and a HAVING in the same query.



/*
video 112
Ordering Grouped data
Note: ORDER BY always happens at the end.
*/

/*
video 113
GROUP BY Mental Map

Problem: find when the employee had his recient salary bump
SELECT emp_no, MAX(from_date)
FROM salaries
GROUP BY emp_no;
*/

/*
video 114
Grouping Sets

What if we want to combine the results of multiple groupings?
UNION allows us to do this.
or 
UNION ALL: does not remove duplicate records
*/
-- Example1:
    SELECT col1, SUM(col2)
    FROM table
    GROUP BY col1
    UNION
    SELECT SUM(col2)
    FROM table;

-- Example 2: 
    SELECT col1, SUM(col2)
    FROM table
    GROUP BY col1
    UNION ALL
    SELECT SUM(col2)
    FROM table;

-- GROUPING SETS: A subclause of GROUP BY that allows you to define multiple groupings.
-- Are very similiar to UNION.
-- Note: you can avoid writing multiple queries under certian circumstances.
-- Example: How to find what you sold on each year, month and day
SELECT EXTRACT (YEAR FROM orderdate) AS "year",
       EXTRACT (MONTH FROM orderdate) AS "month",
       EXTRACT (DAY FROM orderdate) AS "day",
       SUM(ol.quantity)
FROM orderlines AS ol
GROUP BY
    GROUPING SETS (
        -- Groups by year
        (EXTRACT (YEAR FROM orderdate)),
        (
            EXTRACT (YEAR FROM orderdate),
            EXTRACT (MONTH FROM orderdate)
        ),
        -- Groups by year, month and day
        (
            EXTRACT (YEAR FROM orderdate),
            EXTRACT (MONTH FROM orderdate),
            EXTRACT (DAY FROM orderdate)
        ),
        -- Groups by MONTH and day
        (
            EXTRACT (MONTH FROM orderdate),
            EXTRACT (DAY FROM orderdate)
        ),
        -- Groups by MONTH
        (EXTRACT (MONTH FROM orderdate)),
        -- Groups by DAY
        (EXTRACT (DAY FROM orderdate)),
        -- This last one will be the total amount of all time
        ()
    )
ORDER BY    
    EXTRACT (YEAR FROM orderdate),
    EXTRACT (MONTH FROM orderdate),
    EXTRACT (DAY FROM orderdate);
-- This will return a detailed resume of all the information on sales
-- We will apply ROLLUP which can create the combiations 
SELECT EXTRACT (YEAR FROM orderdate) AS "year",
       EXTRACT (MONTH FROM orderdate) AS "month",
       EXTRACT (DAY FROM orderdate) AS "day",
       SUM(ol.quantity)
FROM orderlines AS ol
GROUP BY
    ROLLUP (
        (EXTRACT (YEAR FROM orderdate)),
        (EXTRACT (MONTH FROM orderdate)),
        (EXTRACT (DAY FROM orderdate))
    )
ORDER BY    
    EXTRACT (YEAR FROM orderdate),
    EXTRACT (MONTH FROM orderdate),
    EXTRACT (DAY FROM orderdate);
-- END OF THE VIDEO

/*
video 116
Window What?

What we have learned so far?
- Grouping data is useful.
- Grouping happens after FROM/WHERE.
- Having is a special filter for groups.
- Grouping sets and Rollups are useful for multiple grouping in a single query.
- Grouping data is not a silver bullet.

What are we missing?
How do we apply functions against a set of rows related to the current row?
Example: Add the average to every salary so we could visually see how much
each employee is from the average?
What do we do?
We use Window Functions
*/

/*
video 117
Looking through the window

What are winow functions: 
Window functions create a new column based on function performed on a subset or "WINDOW" of the data.
Syntax of window function: NOTE: THE OVER KEY IS NECCESARY
window_function(arg1, arg2,..) OVER (
    [PARTITION BY partition_expression]
    [ORDER BY sort_expression [ASC | DESC] [NULLS {FIRST | LAST}]]
)
Note: These function take longer when executed because they run against the whole window of data
ANSWERING THE PREVIOUS QUESTION FROM video 116 (MAYBE?)
YOU CANNOT APPLY LIMIT in these function because it applies against the whole data set
*/
SELECT *, MAX(salary) OVER()
FROM salaries
WHERE salary < 70000;
-- THE END OF VIDEO

/*
video 118
PARTITION BY

PARTITION BY is used to divide rows into groups to apply the function against (optional)
*/
SELECT 
    *, 
    AVG(salary) OVER(
        PARTITION BY d.dept_name
    )
FROM salaries
JOIN dept_emp AS de USING (emp_no)
JOIN departments AS d USING (dept_no);
/*
THE END OF THE VIDEO
*/

/*
video 119
Order By Acting Strange

ORDER BY: Order the results
ORDER BY tells the window function to take into account everything before itself and itself. 
Known as framing in window function
*/
SELECT emp_no,
       COUNT(salary) OVER (
            PARTITION BY emp_no
       )
FROM salaries;
-- this causes accumalitive sums
SELECT emp_no,
       COUNT(salary) OVER (
            ORDER BY emp_no
       )
FROM salaries;
/*
THE END OF VIDEO
*/

/*
video 120
Using Framing in window function

Frame Clause: When using a frame clause in a window function we can create a sub-range or frame.
This completly changes the outcome while PARTITION BY groups.

WITHOUT ORDER BY:
By default the framing is usually all partition rows.
WITH ORDER BY:
By default the framing is usually everything before the current row and the current row.
*/
SELECT emp_no,
       salary,
       COUNT(salary) OVER (
            PARTITION BY emp_no
            ORDER BY salary
       )
FROM salaries;
-- Takes into account the whole partitions
SELECT emp_no,
       salary,
       COUNT(salary) OVER (
            PARTITION BY emp_no
            ORDER BY salary
            RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
       )
FROM salaries;
/*
THE END OF THE VIDEO
*/
