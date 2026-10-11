-------------------------------Employee Assigments---------------------------------------

--1.  Write create table syntax for empl table and Incentive table

---Table empl---

create table empl 
(
emp_id number(10) primary key,
first_name varchar(20),
last_name varchar(20),
salary number(20),
joining_date date,
department varchar(20)
);

---Table Incentives---
create table incentives
(empl_ref_id number(10),
incentive_date date,
incentive_amount number(10),
foreign key(empl_ref_id) REFERENCES empl(emp_id)
);

--2.	Write syntax for insert data into table of empl table and Incentive table

insert into empl values(1, 'John','Abraham', 1000000, '01-JAN-13', 'Banking');
insert into empl values(2,'Michael','Clarke',800000,'01-JAN-13','Insurance');
insert into empl values(3,'Roy','Thomas',700000,'01-FEB-13','Banking');
insert into empl values(4,'Tom','Jose',600000,'01-FEB-13','Insurance');
insert into empl values(5,'Jerry','Pinto',650000,'01-FEB-13','Insurance');
insert into empl values(6,'Philip','Mathew',750000,'01-JAN-13','Services');


insert into incentives values (1,'01-FEB-13',5000);
insert into incentives values (2,'01-FEB-13',3000);
insert into incentives values (3,'01-FEB-13',4000);
insert into incentives values (1,'01-JAN-13',4500);
insert into incentives values (2,'01-JAN-13',3500);

--3.	Get all empl details from the empl table
select * from empl;


--4.	Get First_Name, Last_Name from empl table
select first_name, last_name from empl;

--5.	Get First_Name from empl table using alias name “empl Name”
select first_name  empl_Name from empl;

--6.	Get First_Name from empl table in upper case
select upper(first_name) first_name from empl;

--7.	Select first 3 characters of FIRST_NAME from empl
select substr(first_name,1,3) first_name from empl;

select * from empl;

--8.	Get position of 'o' in name 'John' from empl table
select instr('John','o') from empl where first_name='John';

--9.	Get FIRST_NAME from empl table after removing white spaces from right side.
select rtrim(first_name) from empl;

--10.	Get First_Name from empl table after replacing 'o' with '$'
select translate(first_name, 'o', '$') from empl;

--11.	Get First_Name and Last_Name as single column from empl table separated by a '_'
select first_name||'-'|| last_name full_name from empl;

--12.	Get FIRST_NAME, Joiningyear, Joining Month and Joining Date from empl table
select first_name, extract(year from(joining_date)) Joining_Year, extract(month from(joining_date)) Joining_Month, extract(day from(joining_date)) Joining_date from empl;

--13.	Get all empl details from the empl table order by First_Name Ascending
select * from empl order by first_name;

--14.	Get all empl details from the empl table order by First_Name Ascending and Salary Descending?
select * from empl order by first_name, salary desc;

--15.	Get empl details from empl table whose empl name is “John”
select * from empl where first_name='Michael';

--16.	Get empl details from empl table whose empl name are “John” and “Roy”
select * from empl where first_name in('John', 'Roy');

--17.	Get empl details from empl table whose empl name are not “John” and “Roy”.
select * from empl where first_name not in('John', 'Roy');

--18.	Get empl details from empl table whose first name starts with 'J'.
select * from empl where first_name like 'J%';

--19.	Get empl details from empl table whose first name contains 'o'.
select * from empl where first_name like '%o%';

--20.	Get empl details from empl table whose first name ends with 'n'.
select * from empl where first_name like '%n';

--21.	Get empl details from empl table whose first name ends with 'n' and name contains 4 letters.
select * from empl where first_name like '____y';

--22.	Get empl details from empl table whose first name starts with 'J' and name contains 4 letters
select * from empl where first_name like 'J____';

--23.	Get empl details from empl table who’s Salary greater than 600000.
select * from empl where salary>600000;

--24.	Get empl details from empl table whose joining year is “2013”.
select * from empl where extract(year from(joining_date))='2013';

--25.	Get empl details from empl table whose joining month is “January”.
select * from empl where extract(month from(joining_date))=1;

--26.	Get empl details from empl table who joined before January 1st 2013.
select * from empl where joining_date < '01-Jan-13';

--27.	Get empl details from empl table who joined after January 31st
select * from empl where joining_date > '01-Jan-13';

--28.	Get Joining Date and Time from empl table
select to_char(joining_date, 'dd-mon-yy hh:mm:ss') from empl;

--29.	Get Joining Date, Time including milliseconds from empl table
select to_char(joining_date, 'dd-mon-yy hh:mm:ss:mmm') from empl;

--30.	Get difference between JOINING_DATE and INCENTIVE_DATE from empl and incentives table.
select months_between(e.joining_date,i.incentive_date) from empl e join incentives i on e.emp_id=i.empl_ref_id;

--31.	Get department, total salary with respect to a department from empl table.
select department , sum(salary) total_sal from empl
group by department;

--32.	Get department, total salary with respect to a department from empl table order by total salary descending.
select department,sum(salary) total_sal from empl
group by department
order by sum(salary) desc;

--33.	Get department, no of empls in a department, total salary with respect to a department from empl table order by total salary descending.
select department, count(*),sum(salary) total_sal from empl
group by department
order by sum(salary) desc;

--34.	Get department wise average salary from empl table order by salary ascending?
select department, avg(salary)avg_sal from empl
group by department
order by avg(salary);

--35.	Get department wise maximum salary from empl table order by salary ascending?
select department, max(salary)max_sal from empl
group by department
order by max(salary);

--36.	Get department wise minimum salary from empl table order by salary ascending?
select department, min(salary)min_sal from empl
group by department
order by min(salary);

--37.	Select no of empls joined with respect to year and month from empl table.
select count(e.emp_id), extract(year from(e.joining_date)), extract(month from(e.joining_date))
from empl e
group by extract(year from(e.joining_date)), extract(month from(e.joining_date));

--38.	Select department,total salary with respect to a department from empl table where total salary greater than 800000 order by Total_Salary descending
select department, sum(salary) total_sal from empl
having sum(salary)>800000
group by department
order by sum(salary) desc;

--39.	Select empl details from empl table if data in incentive table?
select * from empl
where emp_id in (select empl_ref_id from incentives);

--40.	Select 20 % of salary from John, 10% of Salary for Roy and for other 15 % of salary from empl table
select first_name,salary,
case first_name when 'John' then salary *0.20
when 'Roy' then salary *0.10
else salary *0.15 
end modified_sal from empl;

--41.	Select Banking as 'Bank Dept', Insurance as 'Insurance Dept' and Services as    'Services Dept' from empl table.
select case department 
       when 'Banking' then 'Bank Dept'
       when 'Insurance' then 'Insurance Dept'
       when 'Services' then 'Services Dept'
       end from empl;

--42.	Delete empl data from empl table who got incentives in incentive table

--43.	Select first_name, incentive amount from empl and incentives table for those empls who have incentives.       
select e.first_name, i.incentive_amount from empl e join incentives i on e.emp_id=i.empl_ref_id;

--44.	Select first_name, incentive amount from empl and incentives table for those empls who have incentives and incentive amount greater than 3000
select e.first_name, i.incentive_amount from empl e join incentives i on e.emp_id=i.empl_ref_id
where i.incentive_amount>3000;

--45.	Select first_name, incentive amount from empl and incentives table for all empls even if they didn't get incentives
select e.first_name, i.incentive_amount from empl e join incentives i on e.emp_id=i.empl_ref_id
union all
select first_name, null from empl where emp_id not in (select empl_ref_id from incentives);

------------------------------------------OR-------------------------------------------------------

select e.first_name, i.incentive_amount from empl e left join incentives i on e.emp_id=i.empl_ref_id;

--46.	Select first_name, incentive amount from empl and incentives table for all empls even if they didn't get incentives and set incentive amount as 0 for those empls who didn't get incentives.

select e.first_name, i.incentive_amount from empl e join incentives i on e.emp_id=i.empl_ref_id
union all
select first_name, 0 from empl where emp_id not in (select empl_ref_id from incentives);

------------------------------------------OR--------------------------------------------------------

select first_name, nvl(i.incentive_amount, 0) from empl e left join incentives i on e.emp_id=i.empl_ref_id;

--47.	Select first_name, incentive amount from empl and incentives table for all empls who got incentives using left join

select e.first_name, i.incentive_amount from empl e left join incentives i on e.emp_id=i.empl_ref_id
where i.incentive_amount is not null;

--48.	Select max incentive with respect to empl from empl and incentives table using sub query.
SELECT MAX(incentive_amount)
FROM incentives;

-------------------------------------------OR--------------------------------------------------------

SELECT incentive_amount
FROM incentives
WHERE incentive_amount > ANY (
    SELECT incentive_amount
    FROM incentives
    WHERE incentive_amount > ANY (
        SELECT incentive_amount
        FROM incentives
        WHERE incentive_amount > ANY (
            SELECT incentive_amount
            FROM incentives
            WHERE incentive_amount > ANY (
                SELECT incentive_amount
                FROM incentives
            )
        )
    )
);


