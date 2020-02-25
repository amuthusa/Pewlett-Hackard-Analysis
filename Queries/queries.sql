SELECT first_name, last_name FROM employees where 
birth_date BETWEEN '1952-01-01' AND '1955-12-31';

SELECT count(first_name) FROM employees where 
birth_date BETWEEN '1952-01-01' AND '1952-12-31';

SELECT count(first_name) FROM employees where 
birth_date BETWEEN '1953-01-01' AND '1953-12-31';

SELECT count(first_name) FROM employees where 
birth_date BETWEEN '1954-01-01' AND '1954-12-31';

SELECT count(first_name) FROM employees where 
birth_date BETWEEN '1955-01-01' AND '1955-12-31';

--Retire elligibility
SELECT first_name, last_name FROM employees where 
(birth_date BETWEEN '1952-01-01' AND '1955-12-31') AND
(hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT count(first_name) FROM employees where 
(birth_date BETWEEN '1952-01-01' AND '1955-12-31') AND
(hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT first_name, last_name 
INTO retirement_info 
FROM employees where 
(birth_date BETWEEN '1952-01-01' AND '1955-12-31') AND
(hire_date BETWEEN '1985-01-01' AND '1988-12-31');