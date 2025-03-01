-- Task 1: Load data from employees.csv into a temporary Hive table
CREATE TABLE temp_employees (
    emp_id STRING,
    name STRING,
    age INT,
    job_role STRING,
    salary DOUBLE,
    project STRING,
    join_date STRING,
    department STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
TBLPROPERTIES ("skip.header.line.count"="1");

-- Load data from HDFS path
LOAD DATA INPATH '/path/to/employees.csv' INTO TABLE temp_employees;

-- Create departments table
CREATE TABLE departments (
    dept_id STRING,
    department_name STRING,
    location STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
TBLPROPERTIES ("skip.header.line.count"="1");

-- Load data from HDFS path
LOAD DATA INPATH '/path/to/departments.csv' INTO TABLE departments;

-- Task 2: Create partitioned table and load data
CREATE TABLE employees (
    emp_id STRING,
    name STRING,
    age INT,
    job_role STRING,
    salary DOUBLE,
    project STRING,
    join_date STRING
)
PARTITIONED BY (department STRING)
STORED AS TEXTFILE;

-- Enable dynamic partitioning
SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;

-- Insert data with dynamic partitioning
INSERT OVERWRITE TABLE employees PARTITION(department)
SELECT emp_id, name, age, job_role, salary, project, join_date, department 
FROM temp_employees;