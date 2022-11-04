CREATE DATABASE primary_school;

USE primary_school;

CREATE TABLE school(
school_id INT PRIMARY KEY UNIQUE NOT NULL AUTO_INCREMENT,
school_name VARCHAR(100)  NOT NULL,
director_name VARCHAR(100) NOT NULL,
municipality VARCHAR(100) NOT NULL
);

CREATE TABLE teacher(
teacher_id INT PRIMARY KEY UNIQUE NOT NULL AUTO_INCREMENT,
school_id INT NOT NULL,
full_name VARCHAR(100) NOT NULL,
telephone CHAR(15) NOT NULL
);

CREATE TABLE student(
student_id INT PRIMARY KEY UNIQUE NOT NULL AUTO_INCREMENT,
school_id INT NOT NULL,
department_id INT NOT NULL,
full_name VARCHAR(100) NOT NULL,
father_name VARCHAR(20) NOT NULL,
guardian_tel CHAR(15) NOT NULL
);

CREATE TABLE class(
class_id INT PRIMARY KEY UNIQUE NOT NULL AUTO_INCREMENT,
school_id INT NOT NULL,
Class CHAR(2) NOT NULL
);

CREATE TABLE department(
department_id INT PRIMARY KEY UNIQUE NOT NULL AUTO_INCREMENT,
department INT NOT NULL,
class_id INT NOT NULL
);

CREATE TABLE lesson(
lesson_id INT PRIMARY KEY UNIQUE NOT NULL AUTO_INCREMENT,
lesson_title VARCHAR(100) UNIQUE NOT NULL,
year_of_publication INT
);

CREATE TABLE week_schedule(
schedule_id INT PRIMARY KEY UNIQUE NOT NULL AUTO_INCREMENT,
teacher_id INT NOT NULL,
department_id INT NOT NULL,
week_day ENUM ('Monday','Tuesday','Wednesday','Thursday','Friday') NOT NULL,
lesson_time DATETIME NOT NULL
);

CREATE TABLE absence_book(
absence_book_id INT PRIMARY KEY UNIQUE NOT NULL AUTO_INCREMENT,
department_id INT NOT NULL,
lesson_id INT NOT NULL,
keeper VARCHAR(100) UNIQUE NOT NULL,
student_with_absence VARCHAR(100),
date_of_absence DATETIME,
justification TEXT(1000)
);

CREATE TABLE performance_check(
performance_check_id INT PRIMARY KEY UNIQUE NOT NULL AUTO_INCREMENT,
student_id INT NOT NULL,
lesson_id INT NOT NULL,
school_year VARCHAR(100) NOT NULL,
semester ENUM ('1st','2nd','3rd','4th') NOT NULL,
grade ENUM ('1','2','3','4','5','6','7','8','9','10') NOT NULL
);

CREATE TABLE student_absence_book(
student_id INT NOT NULL,
absence_book_id INT NOT NULL,
last_update TIMESTAMP(6) NOT NULL,
PRIMARY KEY (student_id,absence_book_id),
FOREIGN KEY (student_id) REFERENCES student(student_id),
FOREIGN KEY (absence_book_id) REFERENCES absence_book(absence_book_id)
);

ALTER TABLE teacher
ADD FOREIGN KEY (school_id) REFERENCES school(school_id);

ALTER TABLE student
ADD FOREIGN KEY (school_id) REFERENCES school(school_id),
ADD FOREIGN KEY (department_id) REFERENCES department(department_id);

ALTER TABLE class
ADD FOREIGN KEY (school_id) REFERENCES school(school_id);

ALTER TABLE department
ADD FOREIGN KEY (class_id) REFERENCES class(class_id);

ALTER TABLE week_schedule
ADD FOREIGN KEY (teacher_id) REFERENCES teacher(teacher_id),
ADD FOREIGN KEY (department_id) REFERENCES department(department_id);

ALTER TABLE absence_book
ADD FOREIGN KEY (lesson_id) REFERENCES lesson(lesson_id),
ADD FOREIGN KEY (department_id) REFERENCES department(department_id);

ALTER TABLE performance_check
ADD FOREIGN KEY (lesson_id) REFERENCES lesson(lesson_id),
ADD FOREIGN KEY (student_id) REFERENCES student(student_id);
