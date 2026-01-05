INSERT INTO branch VALUES(4, 'Buffalo', NULL, NULL);

--find all branches and the names of their managers
SELECT employee.emp_id, employee.first_name, branch.branch_name
FROM employee
JOIN branch
ON employee.emp_id = branch.manager_id;


SELECT employee.emp_id, employee.first_name, branch.branch_name
FROM employee
LEFT JOIN branch
ON employee.emp_id = branch.manager_id;

SELECT employee.emp_id, employee.first_name, branch.branch_name
FROM employee
RIGHT JOIN branch
ON employee.emp_id = branch.manager_id;


/* there is another join 'full outer join' which cann't be done in mySQL but is is mixture of both left and right join */