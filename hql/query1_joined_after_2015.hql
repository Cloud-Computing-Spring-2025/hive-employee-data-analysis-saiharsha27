-- Task 3.1: Retrieve all employees who joined after 2015
INSERT OVERWRITE DIRECTORY '/output/query1'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
SELECT * FROM employees 
WHERE year(join_date) > 2015;