##Library Management System SQL Project##

##  Project Objectives:-

Based on the SQL queries developed, this project aims to:

1. **Design and implement a comprehensive library database schema** with proper table relationships and constraints
2. **Perform essential CRUD operations** (Create, Read, Update, Delete) on library data
3. **Execute complex SQL queries** to extract meaningful business insights from the library data
4. **Utilize CTAS (Create Table As Select)** for creating summary tables and reports
5. **Implement data analysis** to understand library operations, member behavior, and financial metrics
6. **Demonstrate advanced SQL techniques** including joins, aggregations, subqueries, and date operations

##  Dataset Structure

### Library Management System Database Schema

First, I created the table schemas with proper relationships:

```sql
--Library management project

-- create branch table 
drop table  if exists branch;
create table branch(
				   branch_id varchar(50) primary key ,
				   manager_id varchar(50),
				   branch_address varchar(50),
				   contact_no varchar(50)
);

drop table if exists employees;
create table employees(
					   emp_id varchar(50) primary key,
					   emp_name	varchar(50),
					   position varchar(50),
					   salary int,
					   branch_id varchar(50)
);

drop table if exists books;
create table books (
					isbn varchar(50) primary key ,
					book_title varchar(75),
					category varchar(50),
					rental_price float,
					status varchar(50),
					author varchar(50),
					publisher varchar(50)
);

alter table books
alter book_title type varchar(90);

alter table books
alter rental_price type numeric(10,2);

drop table if exists members;
create table members(
					member_id varchar(50) primary key,
					member_name varchar(50),
					member_address varchar(100),
					reg_date date
);

drop table if exists issued_status;
create table issued_status(
							issued_id varchar(50) primary key,
							issued_member_id varchar (50),--fk
							issued_book_name varchar (100),
							issued_date date,
							issued_book_isbn varchar(50),--fk
							issued_emp_id varchar (50)--fk
);

drop table if exists return_status;
create table return_status(
							return_id varchar(50) primary key,
							issued_id varchar(50),
							return_book_name varchar(50),
							return_date date,
							return_book_isbn varchar(50)
);

--foreign key

ALTER TABLE issued_status
ADD CONSTRAINT fk_members
FOREIGN KEY (issued_member_id)
REFERENCES members (member_id);

ALTER TABLE issued_status
ADD CONSTRAINT fk_book
FOREIGN KEY (issued_book_isbn)
REFERENCES books (isbn);

ALTER TABLE issued_status
ADD CONSTRAINT fk_emp_id
FOREIGN KEY (issued_emp_id)
REFERENCES employees (emp_id);

ALTER TABLE employees
ADD CONSTRAINT fk_branch_id
FOREIGN KEY (branch_id)
REFERENCES branch (branch_id);

ALTER TABLE return_status
ADD CONSTRAINT fk_issued_id
FOREIGN KEY (issued_id)
REFERENCES issued_status (issued_id);
```

To connect all the tables and establish proper relationships, I used JOIN functions and formed foreign keys among tables as shown in the schema above.

##  Data Insertion

After creating the table structure, I populated the database with sample data:

```sql
INSERT INTO members(member_id, member_name, member_address, reg_date) 
VALUES
('C101', 'Alice Johnson', '123 Main St', '2021-05-15'),
('C102', 'Bob Smith', '456 Elm St', '2021-06-20'),
('C103', 'Carol Davis', '789 Oak St', '2021-07-10'),
('C104', 'Dave Wilson', '567 Pine St', '2021-08-05'),
('C105', 'Eve Brown', '890 Maple St', '2021-09-25'),
('C106', 'Frank Thomas', '234 Cedar St', '2021-10-15'),
('C107', 'Grace Taylor', '345 Walnut St', '2021-11-20'),
('C108', 'Henry Anderson', '456 Birch St', '2021-12-10'),
('C109', 'Ivy Martinez', '567 Oak St', '2022-01-05'),
('C110', 'Jack Wilson', '678 Pine St', '2022-02-25'),
('C118', 'Sam', '133 Pine St', '2024-06-01'),    
('C119', 'John', '143 Main St', '2024-05-01');

-- Insert values into each branch table
INSERT INTO branch(branch_id, manager_id, branch_address, contact_no) 
VALUES
('B001', 'E109', '123 Main St', '+919099988676'),
('B002', 'E109', '456 Elm St', '+919099988677'),
('B003', 'E109', '789 Oak St', '+919099988678'),
('B004', 'E110', '567 Pine St', '+919099988679'),
('B005', 'E110', '890 Maple St', '+919099988680');

-- Insert values into each employees table
INSERT INTO employees(emp_id, emp_name, position, salary, branch_id) 
VALUES
('E101', 'John Doe', 'Clerk', 60000.00, 'B001'),
('E102', 'Jane Smith', 'Clerk', 45000.00, 'B002'),
('E103', 'Mike Johnson', 'Librarian', 55000.00, 'B001'),
('E104', 'Emily Davis', 'Assistant', 40000.00, 'B001'),
('E105', 'Sarah Brown', 'Assistant', 42000.00, 'B001'),
('E106', 'Michelle Ramirez', 'Assistant', 43000.00, 'B001'),
('E107', 'Michael Thompson', 'Clerk', 62000.00, 'B005'),
('E108', 'Jessica Taylor', 'Clerk', 46000.00, 'B004'),
('E109', 'Daniel Anderson', 'Manager', 57000.00, 'B003'),
('E110', 'Laura Martinez', 'Manager', 41000.00, 'B005'),
('E111', 'Christopher Lee', 'Assistant', 65000.00, 'B005');

-- Inserting into books table 
INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher) 
VALUES
('978-0-553-29698-2', 'The Catcher in the Rye', 'Classic', 7.00, 'yes', 'J.D. Salinger', 'Little, Brown and Company'),
('978-0-330-25864-8', 'Animal Farm', 'Classic', 5.50, 'yes', 'George Orwell', 'Penguin Books'),
-- ... (additional book records)
('978-0-7432-7356-4', 'The Hobbit', 'Fantasy', 7.00, 'yes', 'J.R.R. Tolkien', 'Houghton Mifflin Harcourt');

-- inserting into issued table
INSERT INTO issued_status(issued_id, issued_member_id, issued_book_name, issued_date, issued_book_isbn, issued_emp_id) 
VALUES
('IS106', 'C106', 'Animal Farm', '2024-03-10', '978-0-330-25864-8', 'E104'),
('IS107', 'C107', 'One Hundred Years of Solitude', '2024-03-11', '978-0-14-118776-1', 'E104'),
-- ... (additional issued status records)
('IS140', 'C110', 'Animal Farm', '2024-04-13', '978-0-330-25864-8', 'E102');

-- inserting into return table
INSERT INTO return_status(return_id, issued_id, return_date) 
VALUES
('RS105', 'IS107', '2024-05-03'),
('RS106', 'IS108', '2024-05-05'),
-- ... (additional return status records)
('RS118', 'IS120', '2024-05-29');
```

##  SQL Queries and Analysis

I performed 13 comprehensive SQL queries to analyze the library data:

### Task 1: Create a New Book Record
```sql
insert into books
values(
'978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 
'Harper Lee', 'J.B. Lippincott & Co'
);
```

### Task 2: Update an Existing Member's Address
```sql
update members
set member_address = '125 Main St'
where member_id = 'C101';
```

### Task 3: Delete a Record from the Issued Status Table
```sql
DELETE FROM ISSUED_STATUS
WHERE ISSUED_ID = 'IS121';
```

### Task 4: Retrieve All Books Issued by a Specific Employee
```sql
select * from issued_status
where issued_emp_id = 'E101';
```

### Task 5: List Members Who Have Issued More Than One Book
```sql
SELECT COUNT(M.MEMBER_ID) AS NO_OF_MEMBERS , M.MEMBER_NAME FROM MEMBERS AS M
JOIN ISSUED_STATUS AS I 
ON M.MEMBER_ID = I.ISSUED_MEMBER_ID
GROUP BY M.MEMBER_ID 
HAVING COUNT(M.MEMBER_ID) >1
ORDER BY NO_OF_MEMBERS;
```

### Task 6: Create Summary Tables Using CTAS
```sql
create table book_counts as
SELECT COUNT(i.issued_id) AS TOTAL_ISSUED , b.book_title , b.isbn from books as b
join issued_status as i
on b.isbn = i.issued_book_isbn
group by b.book_title,b.isbn;
```

### Task 7: Retrieve All Books in a Specific Category
```sql
select book_title , category from books
group by category , book_title
order by category;
```

### Task 8: Find Total Rental Income by Category
```sql
select b.category , sum(b.rental_price)as total_price , count(*) from books as b
join issued_status as i
on b.isbn = i.issued_book_isbn
group by category
order by total_price desc;
```

### Task 9: List Members Who Registered in the Last 180 Days
```sql
SELECT * 
FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days';
```

### Task 10: List Employees with Their Branch Manager's Name and Branch Details
```sql
select
e1.*, b.manager_id , e2.emp_name as manager_name
from employees as e1
join branch as b
on b.branch_id = e1.branch_id
join employees as e2
on b.manager_id = e2.emp_id;
```

### Task 11: Create a Table of Books with Rental Price Above $7
```sql
create table books_price_greater_than_seven as
select * from books
where rental_price > 7.00;
```

### Task 12: Retrieve the List of Books Not Yet Returned
```sql
select i.issued_book_name , i.issued_id from issued_status as i 
left join return_status as r
on i.issued_id = r.issued_id
where r.issued_id is null;
```

### Task 13: Identify Members with Overdue Books
```sql
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
on i.issued_id = r.issued_id
where r.return_id is null
 and current_date - i.issued_date > 30;
```

##  Findings, Report and Conclusion

### Key Findings

1. **Database Structure Success**: Successfully designed and implemented a normalized database with 6 interconnected tables
2. **Data Integrity**: Established proper foreign key relationships ensuring referential integrity
3. **Operational Insights**: 
   - Identified active members and their borrowing patterns
   - Tracked book availability and return status
   - Calculated rental revenue by category
   - Monitored employee performance in book processing

4. **Business Intelligence**:
   - Classic books generate significant rental income
   - Several members have multiple active book issuances
   - Overdue book tracking helps in library management
   - Branch-wise employee and manager relationships are clearly established

### Project Achievements

 **Complete Database Design** with proper normalization  
 **Successful Data Population** with realistic sample data  
 **Comprehensive CRUD Operations** demonstrated  
 **Advanced SQL Techniques** including CTAS, JOINs, and aggregations  
 **Business-Relevant Queries** providing actionable insights  
 **Data Analysis Capabilities** for library management decisions  

### Conclusion

This Library Management System SQL Project successfully demonstrates the application of database design principles and SQL querying techniques to solve real-world business problems. The project showcases:

- **Technical Proficiency** in SQL database design and implementation
- **Analytical Skills** through meaningful data analysis and reporting
- **Problem-Solving Approach** by addressing practical library management challenges
- **Scalable Architecture** that can be extended with additional features

