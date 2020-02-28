SELECT ce.emp_no,
ce.first_name,
ce.last_name,
t.title,
t.from_date,
t.to_date,
s.salary
INTO current_emp_details
FROM
current_emp ce
INNER JOIN title t
ON ce.emp_no = t.emp_no
INNER JOIN salaries s
ON ce.emp_no = s.emp_no;

SELECT *
FROM
(SELECT *, COUNT(*)
 OVER 
 (PARTITION BY
  emp_no
  ) AS count
 FROM current_emp_details) current_emp_count
 WHERE current_emp_count.count >1
 ORDER BY emp_no, from_date DESC;
 
 --remove the duplicate rows based on partitioning by emp_no
 SELECT emp_no,
 first_name,
 last_name,
 title,
 from_date,
 salary
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

SELECT emp_no,
 first_name,
 last_name,
 title,
 from_date,
 salary
 INTO current_emp_details
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