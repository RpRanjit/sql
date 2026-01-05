-- %  =  any # characters, __ = one character

--Find any client's who are an LLC

SELECT *
FROM client
WHERE client_name LIKE '%LLC';

--find any branch suppliers who are in the label business

SELECT *
FROM branch_supplier
WHERE supplier_name LIKE '% Label%';

--find any employee born in october
SELECT * 
FROM employee
WHERE birth_date LIKE '____-10-%';

SELECT * FROM employee WHERE MONTH(birth_date) = 10;

--Find any clients who are schools
SELECT * FROM client WHERE client_name LIKE ('%school')