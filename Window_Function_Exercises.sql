--Window Functions Exercises--

CREATE TABLE emp_info(
  emp_id INT,
  emp_name VARCHAR(50),
  department VARCHAR(50),
  salary INT,
  hire_date DATE
);

select * from emp_info;

INSERT INTO emp_info VALUES (101, 'Amit', 'HR', 40000, '15-JAN-20');
INSERT INTO emp_info VALUES (102, 'Sneha', 'HR', 45000, '10-JAN-20');
INSERT INTO emp_info VALUES (103, 'Rahul', 'HR', 45000, '23-JULY-21');

INSERT INTO emp_info VALUES (104, 'Priya', 'IT', 60000, '1-NOV-18');
INSERT INTO emp_info VALUES (105, 'Karan', 'IT', 75000, '17-SEP-17');
INSERT INTO emp_info VALUES (106, 'Neha', 'IT', 60000, '14-FEB-22');

INSERT INTO emp_info VALUES (107, 'Vikas', 'Sales', 50000, '30-JUN-20');
INSERT INTO emp_info VALUES (108, 'Anjali', 'Sales', 55000, '5-DEC-19');
INSERT INTO emp_info VALUES (109, 'Rohit', 'Sales', 50000, '18-APR-21');

INSERT INTO emp_info VALUES (110, 'Pooja', 'Finance', 65000, '22-AUG-16');
INSERT INTO emp_info VALUES (111, 'Manish', 'Finance', 70000, '19-MAY-15');
INSERT INTO emp_info VALUES (112, 'Kavita', 'Finance', 65000, '11-JAN-23');

--Display employees with a row number based on salary (highest first).

SELECT emp_id, emp_name, salary,
       ROW_NUMBER() OVER(ORDER BY salary DESC) AS row_num
FROM emp_info;


--Rank employees by salary - SKIPS THE RANKING

SELECT emp_id, emp_name, salary,
       RANK() OVER(ORDER BY salary DESC) AS rank_sal
FROM emp_info;

---DOES NOT SKIP THE RANKING
SELECT emp_id, emp_name, salary,
       DENSE_RANK() OVER(ORDER BY salary DESC) AS rank_sal
FROM emp_info;

--Rank employees department-wise.

SELECT emp_id, emp_name,
       RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS rn_dep
FROM emp_info;

--Find highest salary in each department.

SELECT *
FROM(
       SELECT emp_id, emp_name, salary,
       ROW_NUMBER() OVER(PARTITION BY department ORDER BY salary DESC) AS rn
       FROM emp_info
)t
WHERE rn = 1;

--Find 2nd highest salary in IT.

SELECT *
FROM (
     SELECT emp_id, emp_name, salary, department,
     DENSE_RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS rnk
     FROM emp_info
     WHERE department = 'IT'
)t
WHERE rnk = 2;

--Find department average salary.

SELECT DISTINCT department,
     AVG(salary) OVER(PARTITION BY department) AS avg_sal
FROM emp_info;


--Find employees earning more than department average.

SELECT emp_id, emp_name, salary
FROM (
     SELECT emp_id, emp_name, salary, department,
     AVG(salary) OVER(PARTITION BY department) AS dep_avg
     FROM emp_info
)t
WHERE salary > dep_avg;

--Find salary difference from previous employee (by hire_date).

SELECT emp_id, emp_name, salary, hire_date,
salary - LAG(salary) OVER(ORDER BY hire_date) AS sal_diff
FROM emp_info;

--Running total of salary ordered by hire_date.

SELECT emp_id, emp_name, salary,
       SUM(salary) OVER (ORDER BY hire_date) AS running_total
FROM emp_info;

--------------------------------------------------------------------------

CREATE TABLE cust_orders (
  order_id INT,
  customer_name VARCHAR(50),
  order_date DATE,
  amount INT
);


INSERT INTO cust_orders VALUES (1, 'Amit', '1-JAN-23', 2000);
INSERT INTO cust_orders VALUES (2, 'Amit', '5-JAN-23', 3000);
INSERT INTO cust_orders VALUES (3, 'Amit', '10-JAN-23', 2500);

INSERT INTO cust_orders VALUES (4, 'Sneha', '2-JAN-23', 1500);
INSERT INTO cust_orders VALUES (5, 'Sneha', '8-JAN-23', 3500);

INSERT INTO cust_orders VALUES (6, 'Rahul', '3-JAN-23', 4000);
INSERT INTO cust_orders VALUES (7, 'Rahul', '9-JAN-23', 1000);

SELECT * FROM cust_orders;

--Running total per customer.

SELECT customer_name, amount, order_date,
       SUM(amount) OVER (PARTITION BY customer_name ORDER BY order_date) AS running_total
FROM cust_orders;

--Previous order amount.

SELECT order_id, order_date, LAG(amount) OVER(ORDER BY amount DESC)AS prev_amt
FROM cust_orders;

--Difference between current and previous order.

SELECT order_id, order_date, amount,
       amount - LAG(amount) OVER(ORDER BY order_date) AS order_diff
FROM cust_orders;


--Highest order per customer.

SELECT *
FROM (
       SELECT customer_name, order_id, order_date,
       ROW_NUMBER() OVER(PARTITION BY customer_name ORDER BY amount DESC) AS rn
       FROM cust_orders
)t
WHERE rn=1;

--Total sales per customer without GROUP BY.

SELECT customer_name, order_id, order_date,
       SUM(amount) OVER(PARTITION BY customer_name) AS total_sales
FROM cust_orders;

---Interview-Level Questions

--1. Return all employees who earn the 3rd highest distinct salary in each department.

SELECT *
FROM (
     SELECT  emp_id, emp_name, salary, department,
     DENSE_RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS rnk
     FROM emp_info
)t
WHERE rnk = 3;

--2. Employees Whose Salary Is Higher Than Their Manager’s Department Average

SELECT emp_id, emp_name, salary, department 
FROM(
       SELECT emp_id, emp_name, salary, department,
       (SUM(salary) OVER(PARTITION BY department) - salary) / (COUNT(*) OVER(PARTITION BY department) - 1) AS dep_avg_excl_sal
       FROM emp_info
)t
WHERE salary > dep_avg_excl_sal;


--3. Find Employees Who Earn More Than the Previous Hired Employee (by hire_date)

SELECT emp_id, emp_name, department, salary, hire_date
FROM (
     SELECT emp_id, emp_name, salary, department, hire_date,
     LAG(salary) OVER(ORDER BY hire_date) AS prev_hire_emp
     FROM emp_info
)t
WHERE salary > prev_hire_emp;

--4.Find Department Salary Gap

SELECT department, sal_gap
FROM (
     SELECT department,
     MAX(salary) OVER(PARTITION BY department) - MIN(salary) OVER(PARTITION BY department) AS sal_gap
     FROM emp_info
)t
WHERE sal_gap > 1000;

--5. Find Employees Whose Salary Is Above Overall Average BUT Below Department Maximum.

SELECT salary, department
FROM (
     SELECT salary, department,
     AVG(salary) OVER(PARTITION BY department) AS avg_sal,
     MAX(salary) OVER(PARTITION BY department) AS max_sal
     FROM emp_info
)t
WHERE salary > avg_sal AND salary < max_sal;

-----------------------------------------------------------------------------

--1. Customers Whose Latest Order Is Greater Than Their First Order

SELECT DISTINCT customer_name
FROM (
     SELECT customer_name,
     FIRST_VALUE(amount) OVER(PARTITION BY customer_name ORDER BY order_date) AS first_amt,
     FIRST_VALUE(amount) OVER(PARTITION BY customer_name ORDER BY order_date DESC) AS last_amt
     FROM cust_orders
)t
WHERE last_amt > first_amt;


--2. Find Customers Who Placed Orders on Consecutive Days

SELECT DISTINCT customer_name
FROM (
     SELECT customer_name, order_date,
     LAG(order_date) OVER(PARTITION BY customer_name ORDER BY order_date) AS prev_order_date
     FROM cust_orders
)t
WHERE order_date = prev_order_date + 1;

--3. Find Second Largest Order Per Customer

SELECT * 
FROM (
     SELECT order_id, customer_name, amount,
     DENSE_RANK() OVER(PARTITION BY customer_name ORDER BY amount DESC) AS rnk
     FROM cust_orders
)t
WHERE rnk = 2;

--4. Running Total Reset Condition

SELECT order_id, order_date, amount,
       SUM(amount) OVER (PARTITION BY grp ORDER BY order_date) AS running_total
FROM (
      SELECT order_id, order_date, amount,
             SUM(CASE WHEN amount > 2000 THEN 1 ELSE 0 END) OVER (ORDER BY order_date) AS grp
      FROM cust_orders
) t;


--5. Find customers whose total sales are in top 30% of all customers

SELECT customer_name, total_sales
FROM (
     SELECT customer_name,
     SUM(amount) AS total_sales,                               --Total sales per customer
     PERCENT_RANK() OVER(ORDER BY SUM(amount)) AS per_rn       --Rank customers based on total sales using Percent rank function 
     FROM cust_orders
     GROUP BY customer_name
)t
WHERE per_rn <= 0.30;                                           --Keep only top 30%













