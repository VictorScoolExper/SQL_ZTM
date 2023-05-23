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
SELECT d.dept_name, count(e.emp_no) AS "# of employees"
FROM employees AS e 
INNER JOIN dept_emp AS de ON de.emp_no = e.emp_no
INNER JOIN departments AS d ON de.dept_no = d.dept_no
-- WHERE e.gender = 'F'
GROUP BY d.dept_name
HAVING count(e.emp_no) > 25000; 

In certian situation you can have both a WHERE and a HAVING in the same query.
*/


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
Example1:
    SELECT col1, SUM(col2)
    FROM table
    GROUP BY col1
    UNION
    SELECT SUM(col2)
    FROM table;

Example 2: 
    SELECT col1, SUM(col2)
    FROM table
    GROUP BY col1
    UNION ALL
    SELECT SUM(col2)
    FROM table;

GROUPING SETS: A subclause of GROUP BY that allows you to define multiple groupings.
Are very similiar to UNION.


*/

