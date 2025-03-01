-- Task 3.8: Join the employees and departments tables
INSERT OVERWRITE DIRECTORY '/output/query8'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
SELECT e.*, d.location 
FROM employees e
JOIN departments d ON e.department = d.department_name;