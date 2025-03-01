-- Task 3.10: Find the top 3 highest-paid employees in each department
INSERT OVERWRITE DIRECTORY '/output/query10'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
SELECT *
FROM (
    SELECT emp_id, name, age, job_role, salary, project, join_date, department,
           RANK() OVER (PARTITION BY department ORDER BY salary DESC) as salary_rank
    FROM employees
) ranked_employees
WHERE salary_rank <= 3;