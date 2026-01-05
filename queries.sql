/* Finding the employees with salaray */
SELECT * 
FROM employee
ORDER BY salary;

/* Finding the employee order by sex and then name */
SELECT *  
FROM employee
ORDER BY sex, first_name, last_name;

/* finding employee for first five */
SELECT *
FROM employee
LIMIT 5;

/* find only the first name and last naem of the employees */
SELECT first_name, last_name FROM employee;
SELECT first_name AS forename, last_name AS surname FROM employee;

/* Find out all the different genders */
SELECT DISTINCT sex FROM employee;