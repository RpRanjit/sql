SELECT COUNT(emp_id)
FROM employee;


/* find the number of female employees born after 1970 */

SELECT COUNT(emp_id)
FROM employee
WHERE sex = 'F' and birth_date >= '1970-01-02'

/* find the average of all emloyees salaries */
SELECT AVG(salary)
FROM employee;

SELECT AVG(salary)
FROM employee
WHERE sex = 'F';

/* find the sum of all employee's salaries */
SELECT SUM(salary)
from employee;
SELECT SUM(salary)
from employee
WHERE sex= 'M';

/* find out how many males and females are there */
SELECT COUNT(sex), sex
FROM employee
GROUP BY sex;

/* find the total sales of all employee */
SELECT SUM(total_sales), client_id
FROM works_with
GROUP BY client_id;
