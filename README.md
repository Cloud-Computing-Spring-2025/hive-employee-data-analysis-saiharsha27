# Hive Data Processing Tasks

This document outlines the steps to process employee and department data using Apache Hive. The project includes loading data, creating partitioned tables, and performing various analytical queries.

## Prerequisites

- Apache Hadoop and Hive installed and configured
- Input files (`employees.csv` and `departments.csv`) uploaded to HDFS

## Setup and Execution

### 1. Data Loading

First, we need to create temporary tables and load our data.

```bash
# Start Hive CLI
hive

# Execute the script to create tables and load data
hive -f create_tables.hql
```

### 2. Query Execution

Execute all the analytical queries:

```bash
# Execute all queries at once
hive -f analytical_queries.hql

# Or run individual queries
hive -f query1.hql
hive -f query2.hql
# and so on...
```

## Query Descriptions and Commands

### Task 1: Load data from CSV to temporary table

```sql
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

LOAD DATA INPATH '/path/to/employees.csv' INTO TABLE temp_employees;
```

Command:
```bash
hive -f task1_load_data.hql
```

### Task 2: Create and load partitioned table

```sql
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

SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;

INSERT OVERWRITE TABLE employees PARTITION(department)
SELECT emp_id, name, age, job_role, salary, project, join_date, department 
FROM temp_employees;
```

Command:
```bash
hive -f task2_partitioned_table.hql
```

### Task 3.1: Employees who joined after 2015

```sql
INSERT OVERWRITE DIRECTORY '/output/query1'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
SELECT * FROM employees 
WHERE year(join_date) > 2015;
```

Command:
```bash
hive -f query1_joined_after_2015.hql
```

### Task 3.2: Average salary by department

```sql
INSERT OVERWRITE DIRECTORY '/output/query2'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
SELECT department, AVG(salary) as avg_salary 
FROM employees 
GROUP BY department;
```

Command:
```bash
hive -f query2_avg_salary.hql
```

### Task 3.3: Employees on Alpha project

```sql
INSERT OVERWRITE DIRECTORY '/output/query3'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
SELECT * FROM employees 
WHERE project = 'Alpha';
```

Command:
```bash
hive -f query3_alpha_project.hql
```

### Task 3.4: Employee count by job role

```sql
INSERT OVERWRITE DIRECTORY '/output/query4'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
SELECT job_role, COUNT(*) as employee_count 
FROM employees 
GROUP BY job_role;
```

Command:
```bash
hive -f query4_count_by_role.hql
```

### Task 3.5: Employees with above-average department salary

```sql
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
```

Command:
```bash
hive -f query5_above_avg_salary.hql
```

### Task 3.6: Department with most employees

```sql
INSERT OVERWRITE DIRECTORY '/output/query6'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
SELECT department, COUNT(*) as employee_count 
FROM employees 
GROUP BY department 
ORDER BY employee_count DESC 
LIMIT 1;
```

Command:
```bash
hive -f query6_largest_department.hql
```

### Task 3.7: Exclude employees with null values

```sql
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
```

Command:
```bash
hive -f query7_exclude_nulls.hql
```

### Task 3.8: Join employees and departments

```sql
INSERT OVERWRITE DIRECTORY '/output/query8'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
SELECT e.*, d.location 
FROM employees e
JOIN departments d ON e.department = d.department_name;
```

Command:
```bash
hive -f query8_join_tables.hql
```

### Task 3.9: Rank employees by salary within department

```sql
INSERT OVERWRITE DIRECTORY '/output/query9'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
SELECT emp_id, name, age, job_role, salary, project, join_date, department,
       RANK() OVER (PARTITION BY department ORDER BY salary DESC) as salary_rank
FROM employees;
```

Command:
```bash
hive -f query9_salary_ranking.hql
```

### Task 3.10: Top 3 highest-paid employees per department

```sql
INSERT OVERWRITE DIRECTORY '/output/query10'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
SELECT *
FROM (
    SELECT emp_id, name, age, job_role, salary, project, join_date, department,
           RANK() OVER (PARTITION BY department ORDER BY salary DESC) as salary_rank
    FROM employees
) ranked_employees
WHERE salary_rank <= 3;
```

Command:
```bash
hive -f query10_top3_salaries.hql
```

## File Structure

```
project/
├── hql/
│   ├── create_tables.hql         # Task 1 & 2: Create tables and load data
│   ├── query1_joined_after_2015.hql
│   ├── query2_avg_salary.hql
│   ├── query3_alpha_project.hql
│   ├── query4_count_by_role.hql
│   ├── query5_above_avg_salary.hql
│   ├── query6_largest_department.hql
│   ├── query7_exclude_nulls.hql
│   ├── query8_join_tables.hql
│   ├── query9_salary_ranking.hql
│   └── query10_top3_salaries.hql
├── output/
│   ├── query1/
│   ├── query2/
│   ├── query3/
│   ├── query4/
│   ├── query5/
│   ├── query6/
│   ├── query7/
│   ├── query8/
│   ├── query9/
│   └── query10/
└── README.md
```

## Notes

- Ensure the HDFS paths are correct for your environment
- Adjust partition strategy based on data distribution
- For large datasets, consider adding appropriate indexing
- The output of each query is stored in a separate directory in HDFS