-------------------------------Assignement 4--------------------------------------------

select * from hr.employees;
select * from hr.countries;
select * from hr.departments;
select * from hr.jobs;
select * from hr.job_history;
select * from hr.locations;
select * from hr.regions;

--Q1: Write a query to display the Full name only those employees whose first name start with �S� character.
SELECT employee_id,(substr(first_name,1,1))||'.'||last_name Full_Name,salary,hire_date
FROM hr.employees
WHERE first_name like 'S%';

--Q2. Find the highest, lowest, sum, and average salary of all employees. Label the columns Maximum
--Minimum, Sum, and Average, respectively. Round your results to the nearest whole number. 

SELECT round(max(salary)) highest,
round(min(salary)) lowest,
round(sum(salary)) sum,
round(avg(salary)) avg
FROM hr.employees;

--Q3. Display following output .
--Employee Details
--------------------------------------------------------------------------------------
--King earns $24,000.00 monthly but wants $72,000.00.
--Kochhar earns $20,000.00 monthly but wants $60,000.00.
--De Haan earns $17,000.00 monthly but wants $51,000.00.
--Hunold earns $9,000.00 monthly but wants $27,000.00.
--Ernst earns $6,000.00 monthly but wants $18,000.00.
--Austin earns $4,800.00 monthly but wants $14,400.00.


SELECT last_name||' '||'earns'||to_char(salary,'$99999.00')||' '||'but wants'||' '||(to_char(salary*3,'$99999.00'))
FROM hr.employees;

--Q4. Determine the number of managers without listing them. Label the column  Number of Managers 
--Hint: Use the MANAGER_ID column to determine the number of managers. 
SELECT count(manager_id) number_of_managers
FROM hr.employees;

--Q5. Find the difference between the highest and lowest salaries. Label the column DIFFERENCE
SELECT max(salary)-min(salary) difference
FROM hr.employees;

--Q6. Display how many employees joined in each month
--Hint: Grouping by month and count the employees .use TO_CHAR functions also
SELECT to_char(hire_date,'Month')month,count(employee_id)
FROM hr.employees
group by to_char(hire_date,'Month')
order by month;

--Q7. Display employee id , full name of employees and their hire date only those employees that has greater than 10 year experience in company.
SELECT employee_id,first_name||' '||last_name Full_name,hire_date
FROM hr.employees
WHERE (to_char(hire_date)<sysdate-365*10);


--Q8. Write a query to multiply  salary to commission and calculate the average salary of employees.
--Hint: Commission column contain null values
SELECT AVG(salary * NVL(commission_pct, 0)) AS avg_salary
FROM hr.employees;


--Q9.Write a query to display department_id and number of manager under the particular department exclude the null department.
--Hint: Grouping on department id
SELECT department_id,count(manager_id)
FROM hr.departments
WHERE department_id is not null
group by department_id;


--Q10.Display job title and number of employees working those job and number of manager they perform job.
SELECT count(employee_id),count(manager_id),j.job_title
FROM hr.employees e,hr.jobs j
WHERE e.job_id=j.job_id and manager_id is not null
group by j.job_title;

--Q11. Display employee full name and pad both side asterisk sing 10 time . Example 
SELECT '**********' || first_name || ' ' || last_name || '**********' AS employee_details
FROM hr.employees;

--Q12. Display following output. (Hint: Use Months_between Function)
--Employee Id Last _name  Weeks Months  Year
--100 King  24  166 14
--101 Kochhar 20  139 12
--102 De Haan 28  195 16
--103 Hunold  19  136 11
--104 Ernst 17  119 10
--105 Austin  20  142 12

SELECT employee_id,last_name,hire_date,round(months_between(sysdate,hire_date)/7) weeks,
round(months_between(sysdate,hire_date)) months,
round(months_between(sysdate,hire_date)/12) years
FROM hr.employees;

------------------------------------------------------------------------------------

--Q1. Write a query to generate following output.

SELECT employee_id,first_name||' '||last_name Full_name,email,salary
FROM hr.employees;

--Q2.Write a query to display job_id and number of manager under particular job. Show only those jobs that have more than one manager.
SELECT job_id,count(manager_id)
from hr.employees 
where manager_id>1
group by job_id;

--Q3. Display the country name and number of employees those working in particular city that count of employee is greater than 30.
--(Hint: Using Equijoin and Group by )

SELECT count(employee_id),c.country_name
FROM hr.employees e,hr.departments d,hr.locations l,hr.countries c
WHERE e.department_id=d.department_id 
AND d.location_id=l.location_id
AND l.country_id=c.country_id
group by c.country_name
HAVING count(employee_id)>30;

--Q4. Display cities name and number of departments present those cities. And exculde departments there are no any employees.
SELECT l.city,count(d.department_id)
from hr.employees e,hr.departments d,hr.locations l
WHERE e.department_id=d.department_id 
AND d.location_id=l.location_id
AND employee_id is not null
group by l.city

--Q5. Display the salary range and number of employees how are salary in between of range. 
--(Hint : Job_Grade table , Equijoin , Group by )



--Q6. Display Year list and number of Employees join in particular year.
--(Hint: Group by and To_Char Function)

SELECT to_char(hire_date,'yyyy'),count(employee_id)
FROM hr.employees
group by to_char(hire_date,'yyyy')
order by 1;


--Q7. Display Manager_id , Manager Full Name and Under number of employees only those managers 
--who have more than 5 employees under working. Result sort by manager_ID


















