-- Task 3.4: Count the number of employees in each job role
INSERT OVERWRITE DIRECTORY '/output/query4'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
SELECT job_role, COUNT(*) as employee_count 
FROM employees 
GROUP BY job_role;