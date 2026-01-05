
--Creating employee table

CREATE TABLE employee(
    emp_id INT PRIMARY KEY,
    first_name VARCHAR(20),
    last_name VARCHAR(20),
    birth_date DATE,
    sex VARCHAR(1),
    salary INT,
    supervisor_id INT,
    branch_id INT
);

--Creating branch table
CREATE TABLE branch(
    branch_id INT PRIMARY KEY,
    branch_name VARCHAR(30),
    manager_id INT,
    manager_start_date DATE,
    FOREIGN KEY(manager_id) REFERENCES employee(emp_id) ON DELETE SET NULL
);

--at first we were not able ot point foreign key in employee table because the table was not create but now we can

--altering employee table
ALTER TABLE employee 
ADD Foreign Key(branch_id) REFERENCES branch(branch_id) ON DELETE SET NULL;

ALTER TABLE employee
ADD Foreign Key(supervisor_id) REFERENCES employee(emp_id) ON DELETE SET NULL;

--Create client id
CREATE TABLE client(
    client_id INT PRIMARY KEY,
    client_name VARCHAR(30),
    branch_id INT,
    Foreign Key(branch_id) REFERENCES branch(branch_id) ON DELETE SET NULL
);

--Create worths with table
CREATE TABLE works_with(
    emp_id INT,
    client_id INT,
    total_sales INT,
    PRIMARY KEY(emp_id, client_id),
    Foreign Key(emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE,
    Foreign Key(client_id) REFERENCES client(client_id) ON DELETE CASCADE
);

--Create branch supplier table
CREATE TABLE branch_supplier(
    branch_id INT,
    supplier_name VARCHAR(30),
    suply_type VARCHAR(30),
    PRIMARY KEY(branch_id, supplier_name),
    Foreign Key(branch_id) REFERENCES branch(branch_id) ON DELETE CASCADE
);