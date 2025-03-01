-- Task 3.3: Identify employees working on the 'Alpha' project
INSERT OVERWRITE DIRECTORY '/output/query3'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
SELECT * FROM employees 
WHERE project = 'Alpha';