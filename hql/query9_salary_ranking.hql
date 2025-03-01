-- Task 3.9: Rank employees within each department based on salary
INSERT OVERWRITE DIRECTORY '/output/query9'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
SELECT emp_id, name, age, job_role, salary, project, join_date, department,
       RANK() OVER (PARTITION BY department ORDER BY salary DESC) as salary_rank
FROM employees;