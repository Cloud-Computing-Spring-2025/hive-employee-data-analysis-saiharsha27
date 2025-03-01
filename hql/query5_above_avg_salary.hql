-- Task 3.5: Retrieve employees whose salary is above the average salary of their department
INSERT OVERWRITE DIRECTORY '/output/query5'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
SELECT e.* 
FROM employees e
JOIN (
    SELECT department, AVG(salary) as avg_dept_salary 
    FROM employees 
    GROUP BY department
) dept_avg ON e.department = dept_avg.department
WHERE e.salary > dept_avg.avg_dept_salary;