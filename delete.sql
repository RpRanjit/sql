/* While creating tables we use two characters
1. On delete set Null & 
2. On delete clascade

on 1 when we delete the row which is te foreigh key of  another table or in the same table is place Null in it while
on 2 when we delete the row everything in that row in ame table or different table whoce id/anything is lnked to that foreign dey will de delete full it */

--Delete the michale scott employee whose emp_id is 102

DELETE FROM employee
WHERE emp_id = 102;

SELECT * from employee;
SELECT * from branch;

--for cascade eg
DELETE FROM branch
WHERE branch_id = 2;

SELECT * FROM branch_supplier;