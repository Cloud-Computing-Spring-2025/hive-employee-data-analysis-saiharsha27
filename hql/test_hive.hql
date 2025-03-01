-- Create a simple test table
CREATE TABLE IF NOT EXISTS test_employees (
  id INT,
  name STRING,
  department STRING,
  salary DOUBLE
);

-- Insert some test data
INSERT INTO test_employees VALUES
  (1, 'John Doe', 'Engineering', 85000),
  (2, 'Jane Smith', 'Marketing', 75000),
  (3, 'Bob Johnson', 'Engineering', 90000),
  (4, 'Alice Brown', 'HR', 65000),
  (5, 'Charlie Davis', 'Marketing', 80000);

-- Run a simple query to verify
SELECT department, AVG(salary) as avg_salary
FROM test_employees
GROUP BY department;

-- Another simple query
SELECT * FROM test_employees
WHERE salary > 80000;

-- Clean up (optional)
-- DROP TABLE test_employees;