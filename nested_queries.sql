--find names of all employees who have sold over 30,000 to a single client


SELECT employee.first_name, employee.last_name 
FROM employee
WHERE employee.emp_id IN (
SELECT works_with.emp_id FROM works_with
WHERE works_with.total_sales > 30000
);

--find all clients who are handled by branch that Michael Scott manages. Assume you know Michael's ID

SELECT client.client_name FROM client
WHERE client.branch_id IN( 

SELECT branch.branch_id from branch 
WHERE branch.manager_id IN(

SELECT employee.emp_id FROM employee
WHERE employee.first_name = 'Michael' AND
employee.last_name = 'Scott')

);