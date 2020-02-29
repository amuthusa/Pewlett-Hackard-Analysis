# Pewlett-Hackard-Analysis

## Overview:
   The goal of this project is to help Pewlett Hackard figure out the near future human resources need. Pewlett Hackard was in the Industry for a long time and they have a lot of long time employees. So in order for them to successfully run the business, they have to figure out how many employees might be needed and also plan for existing employees who might be retiring.

## Analysis:

### Step 1:
   To satisfy the current need for Pewlett Hackard the current legacy system of CSV and VBA may not be a good option. As a first step, we will migrate the data from the CSV file into a SQL Database. Having understood their CSV data we have a schema design using Entity Relationship Diagram (ERD) that would better represent the data in the SQL world ![Pewlett Hackard ERD](images/EmployeeDB.png)
   
### Step 2:
   Find the employees who are either retired or might be retiring based on age and hiring date. In Pewlett Hackward case we would classify any employee who is age 65 to 68 and with the company for 32 to 35 would be considered as employees who might be either retired or retiring soon. Knowing the data on how many employees fall under this category would help them to plan. Using a simple query and creating a table would help us to further drill down on these employees
    
   ```
   SELECT emp_no, first_name, last_name 
   INTO retirement_info 
   FROM employees where 
   (birth_date BETWEEN '1952-01-01' AND '1955-12-31') AND
   (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
   ```
   Response data can be found in the following csv ![Retirement Information](Data/retirement_info.csv)
   
   Though the above SQL gives the data we need, we might be having some of the employees still working in Pewlett Hackard. So narrowing down on current employees by depart would help them to plan much better based on skillset and experience needed. In order to get the data from the SQL, we have to join two different tables. Joining retirement_info table and dept_emp we should be able to get data with an additional filter on to_date we would get current employees. LEFT JOIN would help us to keep all the data from retirement_info and augmenting with department information from dept_emp table.
   
   ```
   SELECT ri.emp_no,
   ri.first_name,
   ri.last_name,
   de.to_date
   INTO current_emp
   FROM retirement_info as ri
   LEFT JOIN dept_emp as de
   ON ri.emp_no = de.emp_no
   WHERE de.to_date = ('9999-01-01');
   ```
   Response data can be found in the following csv ![Current Employee Data](Data/current_emp.csv)
   
   Employee information along with salary would help us to financially plan both for retirement and to hire the resource. LEFT JOIN with salaries table would get that information for getting depart information we would find the intersection of the data using INNER JOIN. The below query would help you to get employees who are either retired or on the verge of retirement along with department and their salary.
   
   ```
   SELECT e.emp_no, 
   e.first_name, 
   e.last_name,
   e.gender,
   s.salary,
   de.dept_no
   INTO emp_info
   FROM employees as e
   LEFT JOIN salaries as s
   ON e.emp_no = s.emp_no
   INNER JOIN dept_emp as de
   ON e.emp_no = de.emp_no
   where (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31') 
   AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
   AND de.to_date = ('9999-01-01');
   ```
   Response data can be found in the following csv ![Employee Information](Data/emp_info.csv)
   
   Like it is critical to plan Employee retirement we also need to plan for Managers retirement. Since we have the current employees data into current_emp find the managers would be easy by joining the current employees with dep_manager table to find the detail we need. INNER JOIN both departments and current_emp with dept_manager would get the details we need.
   
   ```
   SELECT dm.dept_no,
   d.dept_name,
   dm.emp_no,
   ce.first_name,
   ce.last_name,
   dm.from_date,
   dm.to_date
   INTO manager_info
   FROM dept_manager as dm
   INNER JOIN departments as d
   ON dm.dept_no = d.dept_no
   INNER JOIN current_emp as ce
   ON dm.emp_no = ce.emp_no;
   ```
   Response data can be found in the following csv ![Manager Information](Data/manager_info.csv)

## Challenge:

### Overview:
   Based on the above data collected the pattern that we see is around 10% of the current employees working with Pewlett Hackard. To mitigate this Pewlett Hackward started with a mentorship program where retiring employees can work as a mentor to train the new employees joining. The goal is to get the number of employees by title who are eligible for retirement and also to get employees who might be ready for a mentor program.
   
### Analysis:
   Out of 300k employees, we anticipate approximately 33k employees who are eligible for retirement, which is 10% of the workforce. It would be better if we get a big picture of a number of current employees based on title who might be eligible for retiring so that we can plan for filling those positions. Collected the current employee details in a table once we inspected we saw duplicates since employees worked in multiple departments during their tenure in Pewlett Hackard, so the first job is to get unique current employees with their title. Partitioning the data by employee number and getting the latest title would help us to plan better. In the below SQL we partitioned the data by emp_no and ordered the data by from_date to get the latest update as the first row, using row_number we could get only the first row for each employee. This would help us to get current employees, current title.
   
   ```
   SELECT emp_no,
   first_name,
   last_name,
   title,
   from_date,
   salary
   INTO unique_current_emp_details
   FROM
   (SELECT *, ROW_NUMBER(*)
    OVER 
    (PARTITION BY
     emp_no
     ORDER BY emp_no, from_date DESC
    ) rn
    FROM current_emp_details 
   ) current_emp_row_number
   WHERE rn=1;
   ```
   Response data can be found in the following csv ![Current Employees with current title](Data/unique_current_emp_details.csv)
   
   Using group by title and from_date we can get the number of employees by title and date who might be eligible employees for retiring during the same period
   
   ```
   SELECT title, 
   from_date,
   COUNT(title) FROM
   unique_current_emp_details
   GROUP BY title, from_date;
   ```
   Response data can be found in the following csv ![Current Employees count by title and date](Data/no_current_employee_by_title.csv)
   
   The second step would be to get all the current employees who would be eligible for mentoring to train the new workforce. Joining employee table, title table and filtering the data based on birth_date, to_date to narrow down only employees who are 55 and currently working with Pewlett Hackard.
   
   ```
   SELECT e.emp_no,
   e.first_name,
   e.last_name,
   e.birth_date,
   t.title,
   t.from_date,
   t.to_date
   INTO current_emp_elligible_mentor
   FROM
   employees e
   INNER JOIN title t
   ON e.emp_no = t.emp_no
   WHERE e.birth_Date BETWEEN '1965-01-01' AND '1965-12-31'
   AND t.to_date = '9999-01-01';
   ```
   Response data can be found in the following csv ![Current Employees elligible for mentoring](Data/current_employees_elligible_mentors.csv)
