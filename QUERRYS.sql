select * from books;
select * from branch;
select * from employees;
select * from issued_status;
select * from members;
select * from return_status;

--Project Question
-- Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 
-- 'Harper Lee', 'J.B. Lippincott & Co.')"


insert into books
values(
'978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 
'Harper Lee', 'J.B. Lippincott & Co'
);

select * from books 
where rental_price = 6.00;

-- Task 2: Update an Existing Member's Address

select * from members;

update  members
set member_address = '125 Main St'
where member_id = 'C101';


-- Task 3: Delete a Record from the Issued Status Table -- 
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

SELECT * FROM ISSUED_STATUS;
DELETE FROM ISSUED_STATUS
WHERE ISSUED_ID = 'IS121';

-- Task 4: Retrieve All Books Issued by a Specific Employee -- 
-- Objective: Select all books issued by the employee with emp_id = 'E101'.


SELECT * FROM EMPLOYEES;
SELECT * FROM ISSUED_STATUS;

select * from issued_status
where issued_emp_id = 'E101';

or 

SELECT e.emp_name , i.issued_book_name from employees as e
join issued_status as i 
on e.emp_id = i.issued_emp_id
where e.emp_id = 'E101';

-- Task 5: List Members Who Have Issued More Than One Book -- 
-- Objective: Use GROUP BY to find members who have issued more than one book.

SELECT * FROM MEMBERS;
SELECT * FROM ISSUED_STATUS;


SELECT COUNT(M.MEMBER_ID) AS NO_OF_MEMBERS , M.MEMBER_NAME FROM MEMBERS AS M
JOIN ISSUED_STATUS AS I 
ON M.MEMBER_ID = I .ISSUED_MEMBER_ID
GROUP BY M.MEMBER_ID 
HAVING  COUNT(M.MEMBER_ID) >1
ORDER BY NO_OF_MEMBERS;


--CTAS
-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - 
-- each book and total book_issued_cOUNt**


SELECT * FROM BOOKS;
SELECT * FROM ISSUED_STATUS;

create table book_counts as
SELECT COUNT(i.issued_id) AS TOTAL_ISSUED , b.book_title , b.isbn from books as b
join issued_status as i
on b.isbn =i.issued_book_isbn
group by b.book_title,b.isbn;

select * from book_counts;

 -- Data Analysis & Findings
-- Task 7. Retrieve All Books in a Specific Category:

select book_title , category from books
group by category , book_title
order by category;

-- Task 8: Find Total Rental Income by Category:

select * from books;
select * from issued_status;

select b.category , sum(b.rental_price)as total_price , count(*) from books as b
join issued_status as i
on b.isbn = i.issued_book_isbn
group by category
order by total_price desc;

-- Task 9 : List Members Who Registered in the Last 180 Days:
select * from members;
select current_date;

SELECT * 
FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days';

-- Task 10 :List Employees with Their Branch Manager's Name and their branch details:
select * from branch;
select * from employees;

select
e1.*, b.manager_id ,e2.emp_name as manager_name
from employees as e1
join branch as b
on b.branch_id = e1.branch_id
join employees as e2
on b.manager_id = e2.emp_id;


-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold 7usd:

create table books_price_greater_than_seven as
select * from books
where rental_price > 7.00;

select * from books_price_greater_than_seven;

-- Task 12: Retrieve the List of Books Not Yet Returned

select * from return_status;
select * from issued_status;

select i.issued_book_name , i.issued_id, from issued_status as i 
left join return_status as r
on i.issued_id = r.issued_id
where r.issued_id is null;

-- Task 13: Identify Members with Overdue Books Write a query to identify members who have overdue books 
-- (assume a 30-day return period). 
-- Display the member's_id, member's name, book title, issue date, and days overdue.


--member==inssued==return
--condition bo0ks are not returned

select * from books;
select * from issued_status;
select * from return_status;
select * from members;


select current_date;

select 
 i.issued_member_id,
    m.member_name,
    b.book_title,
    i.issued_date,
	current_date - i.issued_date as overdues_date
from members as m
join issued_status as i
on i.issued_member_id = m.member_id
join books as b
on i.issued_book_isbn = b.isbn
left join return_status as r
on i.issued_id =r.issued_id
where r.return_id is null
 and current_date - i.issued_date > 30;




