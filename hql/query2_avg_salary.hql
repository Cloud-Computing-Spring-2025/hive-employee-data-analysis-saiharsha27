-- Task 3.2: Find the average salary of employees in each department
INSERT OVERWRITE DIRECTORY '/output/query2'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
SELECT department, AVG(salary) as avg_salary 
FROM employees 
GROUP BY department;