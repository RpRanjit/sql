
--to use union make sure they have same column and the datatypes are same
--Find the list of employee and branch names
SELECT first_name FROM employee
UNION
SELECT branch_name from branch
UNION
SELECT client_name from client;

--find a lsit of all clients & branch suppliers names

SELECT client_name, branch_id FROM client
UNION
SELECT supplier_name, branch_id from branch_supplier;
--to make it look more readable use but is give same output
SELECT client_name, client.branch_id FROM client
UNION
SELECT supplier_name, branch_supplier.branch_id from branch_supplier;

-- Find a list of all money spent or earned by the company

SELECT salary, employee.emp_id from employee
UNION
SELECT total_sales, works_with.emp_id from works_with;