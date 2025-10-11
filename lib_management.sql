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







