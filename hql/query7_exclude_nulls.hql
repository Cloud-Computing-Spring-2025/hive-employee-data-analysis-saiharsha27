-- Task 3.7: Check for employees with null values in any column and exclude them from analysis
INSERT OVERWRITE DIRECTORY '/output/query7'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
SELECT * FROM employees 
WHERE emp_id IS NOT NULL 
AND name IS NOT NULL 
AND age IS NOT NULL 
AND job_role IS NOT NULL 
AND salary IS NOT NULL 
AND project IS NOT NULL 
AND join_date IS NOT NULL 
AND department IS NOT NULL;