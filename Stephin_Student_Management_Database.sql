-- Stephin Biji | SQL Demo Database
-- Project: Student Management & Performance Database
-- Purpose: Demonstrate relational database design, CRUD, JOINs, GROUP BY,
--          aggregate functions, filtering and reporting queries.

DROP DATABASE IF EXISTS stephin_student_db;
CREATE DATABASE stephin_student_db;
USE stephin_student_db;

-- 1. Departments
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL
);

-- 2. Students
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    email VARCHAR(120) UNIQUE,
    department_id INT,
    year_level INT NOT NULL,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- 3. Courses
CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    department_id INT,
    credits INT NOT NULL,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- 4. Enrolments
CREATE TABLE enrolments (
    enrolment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    semester VARCHAR(20) NOT NULL,
    marks DECIMAL(5,2),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- Sample departments
INSERT INTO departments VALUES
(1, 'Computer Applications'),
(2, 'Computer Science'),
(3, 'Data Science');

-- Sample students
INSERT INTO students VALUES
(101, 'Aarav Sharma', 'aarav@example.com', 1, 1),
(102, 'Diya Menon', 'diya@example.com', 1, 1),
(103, 'Rahul Nair', 'rahul@example.com', 2, 2),
(104, 'Ananya Singh', 'ananya@example.com', 3, 2),
(105, 'Vivek Kumar', 'vivek@example.com', 1, 1),
(106, 'Meera Thomas', 'meera@example.com', 3, 2);

-- Sample courses
INSERT INTO courses VALUES
(201, 'Database Management Systems', 1, 4),
(202, 'Programming in C', 1, 4),
(203, 'Web Development', 1, 3),
(204, 'Data Structures', 2, 4),
(205, 'Statistics for Data Science', 3, 4),
(206, 'Python for Data Analysis', 3, 4);

-- Sample enrolments
INSERT INTO enrolments VALUES
(1, 101, 201, 'Semester 1', 82),
(2, 101, 202, 'Semester 1', 76),
(3, 101, 203, 'Semester 1', 88),
(4, 102, 201, 'Semester 1', 91),
(5, 102, 202, 'Semester 1', 84),
(6, 102, 203, 'Semester 1', 79),
(7, 103, 204, 'Semester 3', 73),
(8, 104, 205, 'Semester 3', 89),
(9, 104, 206, 'Semester 3', 94),
(10, 105, 201, 'Semester 1', 68),
(11, 105, 202, 'Semester 1', 72),
(12, 106, 205, 'Semester 3', 81),
(13, 106, 206, 'Semester 3', 87);

-- ============================================================
-- PRACTICE / DEMONSTRATION QUERIES
-- ============================================================

-- Q1. Display all students
SELECT * FROM students;

-- Q2. Students scoring 80 or above
SELECT student_name, year_level
FROM students
WHERE student_id IN (
    SELECT student_id
    FROM enrolments
    WHERE marks >= 80
);

-- Q3. Sort students by name
SELECT student_id, student_name
FROM students
ORDER BY student_name ASC;

-- Q4. Join students with their departments
SELECT s.student_name, d.department_name, s.year_level
FROM students s
JOIN departments d
ON s.department_id = d.department_id;

-- Q5. Show each student's courses and marks
SELECT s.student_name, c.course_name, e.marks
FROM enrolments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id
ORDER BY s.student_name, e.marks DESC;

-- Q6. Average marks by course
SELECT c.course_name, ROUND(AVG(e.marks), 2) AS average_marks
FROM enrolments e
JOIN courses c ON e.course_id = c.course_id
GROUP BY c.course_id, c.course_name
ORDER BY average_marks DESC;

-- Q7. Students with average marks above 80
SELECT s.student_name, ROUND(AVG(e.marks), 2) AS average_marks
FROM students s
JOIN enrolments e ON s.student_id = e.student_id
GROUP BY s.student_id, s.student_name
HAVING AVG(e.marks) > 80
ORDER BY average_marks DESC;

-- Q8. Count students in each department
SELECT d.department_name, COUNT(s.student_id) AS student_count
FROM departments d
LEFT JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_id, d.department_name;

-- Q9. Highest mark in each course
SELECT c.course_name, MAX(e.marks) AS highest_mark
FROM courses c
JOIN enrolments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name;

-- Q10. Update a student's email
UPDATE students
SET email = 'aarav.sharma@example.com'
WHERE student_id = 101;

-- Q11. Delete an enrolment record
-- Example only; uncomment when practicing:
-- DELETE FROM enrolments WHERE enrolment_id = 13;

-- Q12. Course-wise student count
SELECT c.course_name, COUNT(e.student_id) AS enrolled_students
FROM courses c
LEFT JOIN enrolments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name
ORDER BY enrolled_students DESC;
