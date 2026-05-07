DROP DATABASE IF EXISTS placement_db;
CREATE DATABASE placement_db;
USE placement_db;

-- =========================
-- TABLES
-- =========================

CREATE TABLE Admin (
    username VARCHAR(50) PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(50),
    password VARCHAR(50)
);

CREATE TABLE Company (
    c_id INT AUTO_INCREMENT PRIMARY KEY,
    c_name VARCHAR(50) NOT NULL,
    c_add VARCHAR(100),
    rec_procedure VARCHAR(100),
    date_of_arrival DATE,
    contact_no VARCHAR(15),
    package DECIMAL(5,2),
    admin_username VARCHAR(50),
    FOREIGN KEY (admin_username) REFERENCES Admin(username)
);

CREATE TABLE Student (
    rollno INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    username VARCHAR(50) UNIQUE,
    password VARCHAR(50),
    phone_no VARCHAR(15),
    personal_details TEXT,
    training_details TEXT,
    academics DECIMAL(3,2),
    c_id INT,
    admin_username VARCHAR(50),
    FOREIGN KEY (c_id) REFERENCES Company(c_id),
    FOREIGN KEY (admin_username) REFERENCES Admin(username)
);

-- =========================
-- DATA
-- =========================

INSERT INTO Admin VALUES
('admin1','Placement Officer','admin@college.com','1234');

INSERT INTO Company (c_name,c_add,rec_procedure,date_of_arrival,contact_no,package,admin_username)
VALUES
('TechSoft','Bangalore','Online Test + Interview','2026-05-10','9000000001',12,'admin1'),
('CodeWorks','Hyderabad','Coding + HR','2026-05-12','9000000002',10,'admin1'),
('DataCorp','Pune','Aptitude + Tech','2026-05-14','9000000003',8,'admin1'),
('NextGen','Delhi','Online + HR','2026-05-16','9000000004',9,'admin1'),
('InnoTech','Chennai','Tech + HR','2026-05-18','9000000005',11,'admin1'),
('Alpha Systems','Noida','Coding Round','2026-05-20','9000000006',7,'admin1'),
('Beta Solutions','Mumbai','Online Test','2026-05-22','9000000007',6,'admin1'),
('Gamma Tech','Kolkata','Interview Only','2026-05-24','9000000008',5,'admin1'),
('Delta Corp','Gurgaon','Test + HR','2026-05-26','9000000009',13,'admin1'),
('Zeta Systems','Bangalore','Coding + HR','2026-05-28','9000000010',14,'admin1');

INSERT INTO Student VALUES
(101,'Aman Sharma','aman','123','8000000001','Hostel A','DSA',8.5,1,'admin1'),
(102,'Riya Gupta','riya','123','8000000002','Hostel B','Web Dev',7.8,2,'admin1'),
(103,'Karan Mehta','karan','123','8000000003','Hostel C','ML',9.1,3,'admin1'),
(104,'Sneha Verma','sneha','123','8000000004','Hostel D','Python',6.9,NULL,'admin1'),
(105,'Arjun Singh','arjun','123','8000000005','Hostel E','Java',8.2,4,'admin1'),
(106,'Neha Kapoor','neha','123','8000000006','Hostel F','C++',7.5,NULL,'admin1'),
(107,'Rahul Khanna','rahul','123','8000000007','Hostel G','AI',9.3,5,'admin1'),
(108,'Priya Nair','priya','123','8000000008','Hostel H','DBMS',8.0,6,'admin1'),
(109,'Vikas Yadav','vikas','123','8000000009','Hostel I','Networking',7.2,NULL,'admin1'),
(110,'Anjali Desai','anjali','123','8000000010','Hostel J','Cloud',8.7,7,'admin1');

-- =========================
-- VIEW (NO NULL ISSUES)
-- =========================

CREATE VIEW Student_Placements AS
SELECT 
    s.rollno,
    s.name,
    COALESCE(c.c_name, 'Not Placed') AS company,
    COALESCE(c.package, 0) AS CTC
FROM Student s
LEFT JOIN Company c ON s.c_id = c.c_id;

-- =========================
-- PROCEDURES
-- =========================

DELIMITER $$

CREATE PROCEDURE AddStudent(
    IN r INT, IN n VARCHAR(50), IN u VARCHAR(50),
    IN p VARCHAR(50), IN ph VARCHAR(15), IN cg DECIMAL(3,2)
)
BEGIN
    INSERT INTO Student VALUES (r,n,u,p,ph,'','',cg,NULL,'admin1');
END $$

CREATE PROCEDURE AssignCompany(IN stu_roll INT, IN comp_id INT)
BEGIN
    UPDATE Student SET c_id = comp_id WHERE rollno = stu_roll;
END $$

CREATE PROCEDURE GetPlacedStudents()
BEGIN
    SELECT s.name, c.c_name, c.package
    FROM Student s JOIN Company c ON s.c_id = c.c_id;
END $$

CREATE PROCEDURE GetUnplacedStudents()
BEGIN
    SELECT name FROM Student WHERE c_id IS NULL AND name IS NOT NULL;
END $$

DELIMITER ;

-- =========================
-- TRIGGERS
-- =========================

DELIMITER $$

CREATE TRIGGER validate_cgpa
BEFORE INSERT ON Student
FOR EACH ROW
BEGIN
    IF NEW.academics < 0 OR NEW.academics > 10 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid CGPA';
    END IF;
END $$

CREATE TRIGGER validate_package
BEFORE INSERT ON Company
FOR EACH ROW
BEGIN
    IF NEW.package < 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid Package';
    END IF;
END $$

DELIMITER ;

-- =========================
-- REPORT QUERIES (CLEAN OUTPUT)
-- =========================

-- Placed Students
SELECT s.rollno, s.name AS student_name, c.c_name AS company, c.package AS CTC
FROM Student s
JOIN Company c ON s.c_id = c.c_id;

-- Unplaced Students (NO NULL)
SELECT rollno, name AS unplaced_students
FROM Student
WHERE c_id IS NULL AND name IS NOT NULL;

-- All Companies
SELECT c_id, c_name, c_add, package FROM Company;

-- Companies by CTC
SELECT c_name, package FROM Company ORDER BY package DESC;

-- Company-wise Placement Count
SELECT c.c_name, COUNT(s.rollno) AS total_students
FROM Company c
LEFT JOIN Student s ON c.c_id = s.c_id
GROUP BY c.c_name;

-- Full Report
SELECT 
    s.rollno,
    s.name,
    s.academics,
    COALESCE(c.c_name,'Not Placed') AS company,
    COALESCE(c.package,0) AS CTC
FROM Student s
LEFT JOIN Company c ON s.c_id = c.c_id;

-- Placement Summary
SELECT 
    COUNT(*) AS total_students,
    SUM(CASE WHEN c_id IS NOT NULL THEN 1 ELSE 0 END) AS placed,
    SUM(CASE WHEN c_id IS NULL THEN 1 ELSE 0 END) AS unplaced
FROM Student;

-- =========================
-- TRANSACTIONS
-- =========================

START TRANSACTION;
UPDATE Student SET academics = 9.0 WHERE rollno = 101;
COMMIT;

START TRANSACTION;
UPDATE Student SET academics = 5.0 WHERE rollno = 101;
ROLLBACK;

START TRANSACTION;
UPDATE Student SET academics = 8.5 WHERE rollno = 101;
SAVEPOINT sp1;
UPDATE Student SET academics = 6.0 WHERE rollno = 101;
ROLLBACK TO sp1;
COMMIT;