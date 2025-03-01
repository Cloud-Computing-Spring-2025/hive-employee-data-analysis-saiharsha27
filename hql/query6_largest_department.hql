-- Task 3.6: Find the department with the highest number of employees
INSERT OVERWRITE DIRECTORY '/output/query6'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
SELECT department, COUNT(*) as employee_count 
FROM employees 
GROUP BY department 
ORDER BY employee_count DESC 
LIMIT 1;