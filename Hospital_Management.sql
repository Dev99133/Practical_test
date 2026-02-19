Enter password: **********
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 9
Server version: 9.5.0 MySQL Community Server - GPL

Copyright (c) 2000, 2025, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
mysql>
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| ab                 |
| data_digger        |
| data_transformer   |
| information_schema |
| mysql              |
| performance_schema |
| sys                |
| university_db      |
+--------------------+
8 rows in set (0.158 sec)

mysql> -- Create Database
Query OK, 0 rows affected (0.004 sec)

mysql> CREATE DATABASE hospital_management;
Query OK, 1 row affected (0.102 sec)

mysql> USE hospital_management;
Database changed
mysql>
mysql> -- Patients Table
Query OK, 0 rows affected (0.001 sec)

mysql> CREATE TABLE Patients (
    ->   patient_id INT AUTO_INCREMENT PRIMARY KEY,
    ->   name VARCHAR(100),
    ->   dob DATE,
    ->   gender ENUM('Male','Female','Other'),
    ->   phone_number VARCHAR(15),
    ->   email VARCHAR(100),
    ->   address VARCHAR(255),
    ->   registration_date DATE
    -> );
Query OK, 0 rows affected (0.245 sec)

mysql>
mysql> -- Doctors Table
Query OK, 0 rows affected (0.003 sec)

mysql> CREATE TABLE Doctors (
    ->   doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    ->   name VARCHAR(100),
    ->   specialization VARCHAR(100),
    ->   phone_number VARCHAR(15),
    ->   email VARCHAR(100),
    ->   available_days VARCHAR(50),
    ->   consultation_fee DECIMAL(10,2)
    -> );
Query OK, 0 rows affected (0.238 sec)

mysql>
mysql> -- Departments Table
Query OK, 0 rows affected (0.003 sec)

mysql> CREATE TABLE Departments (
    ->   department_id INT AUTO_INCREMENT PRIMARY KEY,
    ->   department_name VARCHAR(100)
    -> );
Query OK, 0 rows affected (0.178 sec)

mysql>
mysql> -- Doctor_Department Mapping Table
Query OK, 0 rows affected (0.002 sec)

mysql> CREATE TABLE Doctor_Department (
    ->   doctor_id INT,
    ->   department_id INT,
    ->   PRIMARY KEY(doctor_id, department_id),
    ->   FOREIGN KEY(doctor_id) REFERENCES Doctors(doctor_id),
    ->   FOREIGN KEY(department_id) REFERENCES Departments(department_id)
    -> );
Query OK, 0 rows affected (0.489 sec)

mysql>
mysql> -- Appointments Table
Query OK, 0 rows affected (0.003 sec)

mysql> CREATE TABLE Appointments (
    ->   appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    ->   patient_id INT,
    ->   doctor_id INT,
    ->   appointment_date DATETIME,
    ->   status ENUM('Scheduled','Completed','Cancelled'),
    ->   FOREIGN KEY(patient_id) REFERENCES Patients(patient_id),
    ->   FOREIGN KEY(doctor_id) REFERENCES Doctors(doctor_id)
    -> );
Query OK, 0 rows affected (0.583 sec)

mysql>
mysql> -- Medical Records Table
Query OK, 0 rows affected (0.002 sec)

mysql> CREATE TABLE Medical_Records (
    ->   record_id INT AUTO_INCREMENT PRIMARY KEY,
    ->   patient_id INT,
    ->   doctor_id INT,
    ->   diagnosis TEXT,
    ->   prescription TEXT,
    ->   treatment_date DATE,
    ->   FOREIGN KEY(patient_id) REFERENCES Patients(patient_id),
    ->   FOREIGN KEY(doctor_id) REFERENCES Doctors(doctor_id)
    -> );
Query OK, 0 rows affected (0.586 sec)

mysql>
mysql> -- Billing Table
Query OK, 0 rows affected (0.003 sec)

mysql> CREATE TABLE Billing (
    ->   invoice_id INT AUTO_INCREMENT PRIMARY KEY,
    ->   patient_id INT,
    ->   appointment_id INT,
    ->   amount DECIMAL(10,2),
    ->   payment_status ENUM('Paid','Pending','Cancelled'),
    ->   payment_date DATE,
    ->   FOREIGN KEY(patient_id) REFERENCES Patients(patient_id),
    ->   FOREIGN KEY(appointment_id) REFERENCES Appointments(appointment_id)
    -> );
Query OK, 0 rows affected (0.455 sec)

mysql>
mysql>
mysql> -- Insert sample patient
Query OK, 0 rows affected (0.004 sec)

mysql> INSERT INTO Patients(name,dob,gender,phone_number,email,address,registration_date)
    -> VALUES('John Doe','1989-05-15','Male','9876543210','john@example.com','Gujarat',CURDATE());
Query OK, 1 row affected (0.169 sec)

mysql>
mysql> -- Update patient address
Query OK, 0 rows affected (0.004 sec)

mysql> UPDATE Patients
    -> SET address='Ahmedabad'
    -> WHERE patient_id = 1;
Query OK, 1 row affected (0.048 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql>
mysql> -- Delete old appointments (older than 6 months)
Query OK, 0 rows affected (0.003 sec)

mysql> DELETE FROM Appointments
    -> WHERE appointment_date < DATE_SUB(CURDATE(), INTERVAL 6 MONTH);
Query OK, 0 rows affected (0.020 sec)

mysql> show tables;
+-------------------------------+
| Tables_in_hospital_management |
+-------------------------------+
| appointments                  |
| billing                       |
| departments                   |
| doctor_department             |
| doctors                       |
| medical_records               |
| patients                      |
+-------------------------------+
7 rows in set (0.073 sec)

mysql> select * from patients;
+------------+----------+------------+--------+--------------+------------------+-----------+-------------------+
| patient_id | name     | dob        | gender | phone_number | email            | address   | registration_date |
+------------+----------+------------+--------+--------------+------------------+-----------+-------------------+
|          1 | John Doe | 1989-05-15 | Male   | 9876543210   | john@example.com | Ahmedabad | 2026-02-19        |
+------------+----------+------------+--------+--------------+------------------+-----------+-------------------+
1 row in set (0.005 sec)

mysql>
mysql> -- Patients registered last year
Query OK, 0 rows affected (0.004 sec)

mysql> SELECT * FROM Patients
    -> WHERE registration_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR);
+------------+----------+------------+--------+--------------+------------------+-----------+-------------------+
| patient_id | name     | dob        | gender | phone_number | email            | address   | registration_date |
+------------+----------+------------+--------+--------------+------------------+-----------+-------------------+
|          1 | John Doe | 1989-05-15 | Male   | 9876543210   | john@example.com | Ahmedabad | 2026-02-19        |
+------------+----------+------------+--------+--------------+------------------+-----------+-------------------+
1 row in set (0.006 sec)

mysql>
mysql> -- Top 5 highest paying patients
Query OK, 0 rows affected (0.002 sec)

mysql> SELECT patient_id, SUM(amount) AS total_spent
    -> FROM Billing
    -> GROUP BY patient_id
    -> ORDER BY total_spent DESC
    -> LIMIT 5;
Empty set (0.035 sec)

mysql>
mysql> -- Doctors charging more than 1000
Query OK, 0 rows affected (0.002 sec)

mysql> SELECT * FROM Doctors
    -> WHERE consultation_fee > 1000;
Empty set (0.021 sec)

mysql>
mysql>
mysql> -- Scheduled appointments for doctor 3
Query OK, 0 rows affected (0.004 sec)

mysql> SELECT * FROM Appointments
    -> WHERE status='Scheduled' AND doctor_id=3;
Empty set (0.004 sec)

mysql>
mysql> -- Doctors in Cardiology or Neurology
Query OK, 0 rows affected (0.001 sec)

mysql> SELECT * FROM Doctors
    -> WHERE specialization='Cardiology' OR specialization='Neurology';
Empty set (0.004 sec)

mysql>
mysql> -- Patients NOT visited in past year
Query OK, 0 rows affected (0.003 sec)

mysql> SELECT * FROM Patients
    -> WHERE patient_id NOT IN (
    ->   SELECT patient_id FROM Appointments
    ->   WHERE appointment_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
    -> );
+------------+----------+------------+--------+--------------+------------------+-----------+-------------------+
| patient_id | name     | dob        | gender | phone_number | email            | address   | registration_date |
+------------+----------+------------+--------+--------------+------------------+-----------+-------------------+
|          1 | John Doe | 1989-05-15 | Male   | 9876543210   | john@example.com | Ahmedabad | 2026-02-19        |
+------------+----------+------------+--------+--------------+------------------+-----------+-------------------+
1 row in set (0.006 sec)

mysql>
mysql>
mysql> -- Doctors by specialization
Query OK, 0 rows affected (0.002 sec)

mysql> SELECT * FROM Doctors
    -> ORDER BY specialization;
Empty set (0.003 sec)

mysql>
mysql> -- Number of patients per doctor
Query OK, 0 rows affected (0.002 sec)

mysql> SELECT doctor_id, COUNT(*) AS num_patients
    -> FROM Appointments
    -> GROUP BY doctor_id;
Empty set (0.009 sec)

mysql>
mysql> -- Total revenue per department
Query OK, 0 rows affected (0.003 sec)

mysql> SELECT d.department_name, SUM(b.amount) AS revenue
    -> FROM Billing b
    -> JOIN Appointments a ON b.appointment_id = a.appointment_id
    -> JOIN Doctor_Department dd ON a.doctor_id=dd.doctor_id
    -> JOIN Departments d ON dd.department_id=d.department_id
    -> GROUP BY d.department_name;
Empty set (0.042 sec)

mysql>
mysql>
mysql> -- Total revenue collected
Query OK, 0 rows affected (0.004 sec)

mysql> SELECT SUM(amount) AS total_revenue
    -> FROM Billing;
+---------------+
| total_revenue |
+---------------+
|          NULL |
+---------------+
1 row in set (0.008 sec)

mysql>
mysql> -- Most visited doctor
Query OK, 0 rows affected (0.002 sec)

mysql> SELECT doctor_id, COUNT(*) AS visits
    -> FROM Appointments
    -> GROUP BY doctor_id
    -> ORDER BY visits DESC
    -> LIMIT 1;
Empty set (0.006 sec)

mysql>
mysql> -- Average consultation fee
Query OK, 0 rows affected (0.004 sec)

mysql> SELECT AVG(consultation_fee) AS avg_fee
    -> FROM Doctors;
+---------+
| avg_fee |
+---------+
|    NULL |
+---------+
1 row in set (0.004 sec)

mysql>
mysql>
mysql> -- Doctors with department names
Query OK, 0 rows affected (0.003 sec)

mysql> SELECT dr.name, d.department_name
    -> FROM Doctors dr
    -> INNER JOIN Doctor_Department dd ON dr.doctor_id=dd.doctor_id
    -> INNER JOIN Departments d ON dd.department_id=d.department_id;
Empty set (0.004 sec)

mysql>
mysql> -- All patients with completed appointments
Query OK, 0 rows affected (0.002 sec)

mysql> SELECT p.name, a.status
    -> FROM Patients p
    -> LEFT JOIN Appointments a ON p.patient_id=a.patient_id
    -> WHERE a.status='Completed';
Empty set (0.005 sec)

mysql>
mysql> -- Appointments without payments
Query OK, 0 rows affected (0.002 sec)

mysql> SELECT a.appointment_id
    -> FROM Appointments a
    -> RIGHT JOIN Billing b ON a.appointment_id=b.appointment_id
    -> WHERE b.appointment_id IS NULL;
Empty set (0.005 sec)

mysql>
mysql> -- Patients with no appointments
Query OK, 0 rows affected (0.003 sec)

mysql> SELECT p.name
    -> FROM Patients p
    -> LEFT JOIN Appointments a ON p.patient_id=a.patient_id
    -> WHERE a.appointment_id IS NULL;
+----------+
| name     |
+----------+
| John Doe |
+----------+
1 row in set (0.005 sec)

mysql>
mysql>
mysql> -- Doctors with more than 50 patients
Query OK, 0 rows affected (0.003 sec)

mysql> SELECT doctor_id
    -> FROM (
    ->   SELECT doctor_id, COUNT(*) AS total
    ->   FROM Appointments
    ->   GROUP BY doctor_id
    -> ) AS sub
    -> WHERE total > 50;
Empty set (0.006 sec)

mysql>
mysql> -- Patient who spent the most
Query OK, 0 rows affected (0.002 sec)

mysql> SELECT patient_id
    -> FROM Billing
    -> GROUP BY patient_id
    -> ORDER BY SUM(amount) DESC
    -> LIMIT 1;
Empty set (0.005 sec)

mysql>
mysql> -- Appointments with dermatologist doctors
Query OK, 0 rows affected (0.002 sec)

mysql> SELECT * FROM Appointments
    -> WHERE doctor_id IN (
    ->   SELECT doctor_id FROM Doctors
    ->   WHERE specialization='Dermatology'
    -> );
Empty set (0.006 sec)

mysql>
mysql>
mysql> -- Visits per month
Query OK, 0 rows affected (0.004 sec)

mysql> SELECT MONTH(appointment_date) AS month, COUNT(*) AS visits
    -> FROM Appointments
    -> GROUP BY MONTH(appointment_date);
Empty set (0.010 sec)

mysql>
mysql> -- Hospital stay duration
Query OK, 0 rows affected (0.002 sec)

mysql> SELECT DATEDIFF(discharge_date, admission_date) AS stay_days;
ERROR 1054 (42S22): Unknown column 'discharge_date' in 'field list'
mysql>
mysql> -- Format treatment_date
Query OK, 0 rows affected (0.002 sec)

mysql> SELECT DATE_FORMAT(treatment_date,'%d-%m-%Y')
    -> FROM Medical_Records;
Empty set (0.025 sec)

mysql>
mysql>
mysql> -- Uppercase patient names
Query OK, 0 rows affected (0.002 sec)

mysql> SELECT UPPER(name)
    -> FROM Patients;
+-------------+
| UPPER(name) |
+-------------+
| JOHN DOE    |
+-------------+
1 row in set (0.013 sec)

mysql>
mysql> -- Trim doctor names
Query OK, 0 rows affected (0.002 sec)

mysql> SELECT TRIM(name)
    -> FROM Doctors;
Empty set (0.005 sec)

mysql>
mysql> -- Replace missing phones
Query OK, 0 rows affected (0.003 sec)

mysql> UPDATE Patients
    -> SET phone_number='Not Available'
    -> WHERE phone_number IS NULL;
Query OK, 0 rows affected (0.004 sec)
Rows matched: 0  Changed: 0  Warnings: 0

mysql>
mysql> -- Rank doctors by patients
Query OK, 0 rows affected (0.004 sec)

mysql> SELECT doctor_id,
    ->        COUNT(*) AS total_patients,
    ->        RANK() OVER (ORDER BY COUNT(*) DESC) AS rank
    -> FROM Appointments
    -> GROUP BY doctor_id;
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'rank
FROM Appointments
GROUP BY doctor_id' at line 3
mysql>
mysql> -- Cumulative revenue per month
Query OK, 0 rows affected (0.002 sec)

mysql> SELECT MONTH(payment_date) AS month,
    ->        SUM(amount) OVER (ORDER BY MONTH(payment_date)) AS cumulative
    -> FROM Billing;
Empty set (0.006 sec)

mysql>
mysql> -- Running total of appointments
Query OK, 0 rows affected (0.004 sec)

mysql> SELECT appointment_id,
    ->        COUNT(*) OVER (ORDER BY appointment_date) AS running_total
    -> FROM Appointments;
Empty set (0.005 sec)

mysql>
mysql>
mysql> -- Patient risk level
Query OK, 0 rows affected (0.003 sec)

mysql> SELECT patient_id,
    -> CASE
    ->   WHEN COUNT(record_id) > 5 THEN 'High'
    ->   WHEN COUNT(record_id) BETWEEN 3 AND 5 THEN 'Medium'
    ->   ELSE 'Low'
    -> END AS Patient_Risk_Level
    -> FROM Medical_Records
    -> GROUP BY patient_id;
Empty set (0.012 sec)

mysql>
mysql> -- Doctor categorization
Query OK, 0 rows affected (0.003 sec)

mysql> SELECT name,
    -> CASE
    ->   WHEN consultation_fee > 2000 THEN 'Senior'
    ->   WHEN consultation_fee BETWEEN 1000 AND 2000 THEN 'Mid-Level'
    ->   ELSE 'Junior'
    -> END AS Category
    -> FROM Doctors;
Empty set (0.005 sec)

mysql>
mysql>
mysql> # Hospital Management System SQL
Query OK, 0 rows affected (0.003 sec)

mysql>
mysql> ## Tables
Query OK, 0 rows affected (0.003 sec)

mysql> - Patients
    -> - Doctors
    -> - Departments
    -> - Doctor_Department
    -> - Appointments
    -> - Medical_Records
    -> - Billing
    ->
    -> ## Features Implemented
    -> - CRUD operations
    -> - SQL Clauses (WHERE, HAVING, LIMIT)
    -> - Joins, Subqueries
    -> - Window functions
    -> - Case expressions
    ->
    -> ## Usage
    -> Instructions to run the .sql file and sample queries.
    ->