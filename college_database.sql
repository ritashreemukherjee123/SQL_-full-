CREATE DATABASE college;

USE college;

DROP TABLE student;   #For deleting/temporary deletion the existing student table

CREATE TABLE student (
     rollno INT PRIMARY KEY,
	 name VARCHAR(50),
     marks INT NOT NULL,
     grade VARCHAR(1),
     city VARCHAR(20)
);
INSERT INTO student
(rollno, name, marks, grade, city)
VALUES
(101, "anil", 78, "C", "Pune"),
(102, "bhumika", 93, "A", "Mumbai"),
(103, "chetan", 85, "B", "Mumbai"),
(104, "dhruv", 96, "A", "Delhi"),
(105, "emanuel", 12, "F", "Delhi"),
(106, "farah", 82, "B", "Delhi");

SELECT * FROM student;

#WHERE clause
SELECT name, grade FROM student
WHERE marks > 70;

#Operators with WHERE Clause
SELECT *
FROM student
WHERE marks + 10 > 90;

#Using AND & BETWEEN operators
SELECT * FROM student 
WHERE marks BETWEEN 80 AND 90;  # Ranges 80 and 90 are inclusive

SELECT * FROM student WHERE city IN ("Delhi", "Mumbai"); 
SELECT * FROM student WHERE city NOT IN ("Delhi", "Mumbai");

#ORDER BY Clause
SELECT * FROM student
ORDER BY marks ASC;  

#LIMIT Clause 
SELECT * FROM student
LIMIT 3;

#OFFSET Clause
SELECT * FROM student
LIMIT 3
OFFSET 2;   #Gives result from (n+1)th row, i.e, here, from 3rd row

#AGGREGATE functions
SELECT max(marks) FROM student;

SELECT avg(marks) FROM student;

#GROUP BY Clause
SELECT city, avg(marks)
FROM student
GROUP BY city
ORDER BY city;

#COUNT function
SELECT city, count(rollno)
FROM student 
GROUP BY city, name;

# HAVING Clause
SELECT count(name), city
FROM student
GROUP BY city
HAVING max(marks) > 90;

#GENERAL ORDER
SELECT city 
FROM student
WHERE grade = "A"
GROUP BY city
HAVING max(marks) >= 90
ORDER BY city DESC;

#SAFE MODE disabled because we are using update clause after it, which can be executed only when the safe mode is diabled. Initially, the safe mode enabled.
#For Updation and Deletion of table, we generally have to disable the safe mode, and it is session specific.
SET SQL_SAFE_UPDATES = 0;

#UPDATE Clause
UPDATE student
SET grade = "O"
WHERE grade = "A";

SELECT * FROM student;

#DELETE Clause
DELETE FROM student
WHERE marks < 33;

SELECT * FROM student;

ALTER TABLE student
ADD COLUMN age INT;

ALTER TABLE student
DROP COLUMN age;

SELECT * FROM student;

ALTER TABLE student
RENAME TO student_data;

ALTER TABLE student_data
ADD COLUMN age INT;

SELECT * FROM student_data;

ALTER TABLE student_data
MODIFY COLUMN age VARCHAR(2);

INSERT INTO student_data
(rollno, name, marks, grade, location, age)
VALUES
(107, "lina", 90, "A", "Pune", 100);   # gives error that data is too long for variable age to store, INT is fine.

ALTER TABLE student_data
DROP COLUMN age;

ALTER TABLE student_data
ADD COLUMN age INT NOT NULL DEFAULT 20;

SELECT * FROM student_data;

ALTER TABLE student_data
CHANGE COLUMN city location VARCHAR(20);

SELECT * FROM student_data;

TRUNCATE TABLE  student_data;

SELECT * FROM student_data;

INSERT INTO student_data
(rollno, name, marks, grade, location)
VALUES
(101, "anil", 78, "C", "Pune"),
(102, "bhumika", 93, "A", "Mumbai"),
(103, "chetan", 85, "B", "Mumbai"),
(104, "dhruv", 96, "A", "Delhi"),
(105, "emanuel", 12, "F", "Delhi"),
(106, "farah", 82, "B", "Delhi");

ALTER TABLE student_data
DROP COLUMN age;

ALTER TABLE student_data
ADD COLUMN age INT NOT NULL DEFAULT(21);

ALTER TABLE student_data
CHANGE COLUMN name full_name VARCHAR(50);

SET SQL_SAFE_UPDATES = 0;  #Switching off the safe mode for DELETE & UPDATE operations
DELETE FROM student_data
WHERE marks < 80;

ALTER TABLE student_data
DROP COLUMN grade;

SELECT * FROM student_data;
------------------------------------------------------------------------------------

##SUBQUERY / NESTED QUERY / INNER QUERY -----> ARE WRITTEN UNDER THREE CLAUSES:

		## A) SELECT.
        ## B) FROM.
        ## C) WHERE.
        ---------------------------------------------------
## Q1) Get names of all the students who scored more than class average.
## Step 1: Finding average of class.
## Step 2: Finding names of students with marks > avg.

SELECT AVG(marks)  ## General method
FROM student_data;

SELECT full_name, marks
FROM student_data
WHERE marks > 89.00;
-------------------------
## For (Q1), solution with "SUBQUERIES" under WHERE Clause will be:

SELECT full_name, marks
FROM student_data
WHERE marks > (SELECT AVG(marks) FROM student_data);    ## SUBQUERIES
-----------------------------------------------
##(Q2) Find the names of all students with even roll numbers.
#Step 1: Find the even roll numbers.
#Step 2: Find the names of students with even roll numbers.

##GENERAL METHOD-------------------------------
 SELECT  rollno
 FROM student_data
 WHERE rollno % 2 = 0;

SELECT full_name
FROM student_data
WHERE rollno IN (102, 104, 106);

## With subquery under WHERE-------------------

SELECT full_name, rollno
FROM student_data
WHERE rollno IN (SELECT rollno 
				FROM student_data
                WHERE rollno % 2 = 0);
                
##--------------------Subqueries under FROM Clause-----------------

## Q3) Find the maximum marks from the students of Delhi.

SELECT  MAX(marks)
FROM (SELECT * FROM student_data WHERE location = "Delhi") AS temp;

##Can also be done with:
SELECT MAX(marks)
FROM student_data
WHERE location = "Delhi";

# --------------------------MySQL view---------------------------------

CREATE VIEW view1 AS 
SELECT rollno, full_name FROM student_data;
SELECT * FROM view1;

CREATE VIEW view2 AS 
SELECT rollno, full_name, marks FROM student_data
WHERE marks > 80;
SELECT * FROM view2;

DROP  VIEW view2;

                
----------- JOINS ------------
CREATE TABLE student(
id INT PRIMARY KEY,
name VARCHAR(50)
);
INSERT INTO student(id, name)
VALUES
(101, "adam"),
(102, "bob"),
(103, "casey");

CREATE TABLE course(
id INT PRIMARY KEY,
course VARCHAR(50)
);
INSERT INTO course (id, course)
VALUES
(102, "english"),
(105, "maths"),
(103, "science"),
(107, "computer science");

SELECT * FROM student;
SELECT * FROM course;

------------ FULL JOIN ------------
SELECT * FROM student as a
LEFT JOIN course as b                ##LEFT JOIN
ON a.id = b.id
UNION                                ##UNION operation
SELECT * FROM student as a
RIGHT JOIN course as b               ##RIGHT JOIN
ON a.id = b.id;

------------ FULL EXCLUSIVE JOIN ------------
SELECT
    a.*,
    b.*
FROM
    student AS a
LEFT JOIN
    course AS b ON a.id = b.id
WHERE
    b.id IS NULL
UNION ALL
SELECT
    a.*,
    b.*
FROM
    student AS a
RIGHT JOIN
    course AS b ON a.id = b.id
WHERE
    a.id IS NULL;
---------------------------------------------------------------------------

DROP TABLE employee;

CREATE TABLE employee(
id INT PRIMARY KEY,
name VARCHAR(50),
manager_id INT
);
INSERT INTO employee
VALUES
(101, "adam", 103),
(102, "bob", 104),
(103, "casey", NULL),
(104, "donald", 103);

SELECT * FROM employee;

#--------SELF JOIN operation ON EMPLOYEE TABLE-------
SELECT * 
FROM employee AS a 
JOIN employee AS b         ##SELF JOIN ---> JOIN in MySQL8.0 Workbench
ON a.id = b.manager_id; 

SELECT a.emp_name AS manager_name, b.emp_name
FROM employee AS a 
JOIN employee AS b
ON a.id = b.manager_id;

##----------------------ALTER operation employee table-------------------------
ALTER TABLE employee
RENAME COLUMN name TO emp_name;

SELECT * FROM employee;

#------- UNION --------------------------

SELECT emp_name FROM employee
UNION
SELECT emp_name FROM employee;

#-------------------------------------------


#SAFE MODE enabled
SET SQL_SAFE_UPDATES = 1;
#-----------------------------------------------------------------------------
DROP TABLE dept;
DROP TABLE teacher;

SET SQL_SAFE_UPDATES = 0;

#FOREIGN KEY
CREATE TABLE dept(          #TABLE dept being PARENT TABLE.
id INT PRIMARY KEY,
name VARCHAR(50)
);

SELECT * FROM dept;

INSERT INTO dept
VALUES
(101, "english"),
(102, "IT");

SELECT * FROM dept;

UPDATE dept
SET id = 103
WHERE id = 102;

SELECT * FROM dept;


CREATE TABLE teacher(
id INT PRIMARY KEY,
name VARCHAR(50),
dept_id INT,
FOREIGN KEY (dept_id) REFERENCES dept(id)
ON UPDATE CASCADE
ON DELETE CASCADE
);

SELECT * FROM teacher;

INSERT INTO teacher
VALUES
(101, "Adam", 101),
(102, "Eve", 102);

SELECT * FROM teacher;

CREATE TABLE temp1 (
        id INT,
        name VARCHAR(200),
        age INT,
        city VARCHAR(200),
        PRIMARY KEY(id, name)
);

SELECT * FROM temp1;

CREATE TABLE employee(
       id INT,
       salary INT DEFAULT 25000);
       
INSERT INTO employee(id) VALUES (101);

SELECT * FROM employee;
