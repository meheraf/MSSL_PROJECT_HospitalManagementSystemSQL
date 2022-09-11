/*
	SQL Project: Hospital Management
	Project By: Md Meheraf Hossain
*/

--Creating Objects

USE master
GO

DROP DATABASE IF EXISTS hospitalManagementSystemForCore_DB
GO

CREATE DATABASE hospitalManagementSystemForCore_DB
ON
(
	NAME= hospitalManagementSystem_DB_Data,
	FILENAME='E:\PGD\MVC Core project\dbFile\hospitalManagementSystemForCore_DB_Data.mdf',
	SIZE=100MB,
	MAXSIZE=5000MB,
	FILEGROWTH=5%
)
LOG ON
(
	NAME=hospitalManagementSystem_DB_log,
	FILENAME='E:\PGD\MVC Core project\dbFile\hospitalManagementSystemForCore_DB_log.ldf',
	SIZE=50MB,
	MAXSIZE=2000MB,
	FILEGROWTH=5%
)
GO
USE hospitalManagementSystemForCore_DB
go

CREATE TABLE tbl_administrator
(
	adminId INT IDENTITY PRIMARY KEY,
	adminName VARCHAR(30) not null
)
GO

CREATE TABLE tbl_department
(
	depId INT IDENTITY PRIMARY KEY,
	depName VARCHAR(50) not null
)
GO

CREATE TABLE tbl_designation
(
	desigId INT IDENTITY PRIMARY KEY,
	desigTitle VARCHAR(20) not null,
)
GO


CREATE TABLE tbl_gender
(
	genderId INT PRIMARY KEY IDENTITY,
	gender VARCHAR(6) not null
)
GO

CREATE TABLE tbl_doctors
(
	drId INT IDENTITY PRIMARY KEY,
	drName VARCHAR(30),
	email VARCHAR(35) UNIQUE null,
	contactNo VARCHAR(20) UNIQUE not null,
	genderID INT REFERENCES tbl_gender(genderID),
	desigId INT REFERENCES tbl_designation(desigId),
	depId INT REFERENCES tbl_department(depId),
	joinDate DATE DEFAULT GETDATE() not null,
	adminId INT REFERENCES tbl_administrator
)
GO

CREATE TABLE tbl_stuff
(
	stId INT IDENTITY PRIMARY KEY,
	stName VARCHAR(30) not null,
	email VARCHAR(35) UNIQUE null,
	contactNo VARCHAR(20) UNIQUE not null,
	NID CHAR(17) UNIQUE NOT NULL CHECK(NID LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	genderID INT REFERENCES tbl_gender(genderID),
	birthDate DATETIME NOT NULL,
	desigId INT REFERENCES tbl_designation(desigId),
	depName INT REFERENCES tbl_department(depId),
	adminId INT REFERENCES tbl_administrator,
	joinDate DATE DEFAULT GETDATE() not null,
	streetAddress VARCHAR(60) NOT NULL,
	postalCode INT NOT NULL,
	city VARCHAR(20) NOT NULL DEFAULT 'Dhaka',
	country VARCHAR(25) NOT NULL DEFAULT 'Bangladesh',
	salary MONEY DEFAULT 0.00 not null,
)
GO

CREATE TABLE tbl_patient
(
	PatientId INT IDENTITY PRIMARY KEY,
	PatientName VARCHAR(30) not null,
	email VARCHAR(35) UNIQUE null,
	contactNo VARCHAR(20) UNIQUE not null,
	genderId INT REFERENCES tbl_gender(genderId),
	streetAddress VARCHAR(60) NOT NULL,
	postalCode INT NOT NULL,
	city VARCHAR(20) NOT NULL DEFAULT 'Dhaka',
	country VARCHAR(25) NOT NULL DEFAULT 'Bangladesh'
)
GO
CREATE TABLE tbl_lab
(
	labId INT IDENTITY PRIMARY KEY,
	category VARCHAR(20) not null
)
GO

CREATE TABLE tbl_room
(
	roomNo INT IDENTITY(101,1) PRIMARY KEY,
	roomType VARCHAR(20) not null
)
GO

CREATE TABLE tbl_inPatient
(
	inPatientId INT IDENTITY PRIMARY KEY,
	PatientId INT REFERENCES tbl_patient(PatientId),
	roomNo INT REFERENCES tbl_room(roomNo),
	admitDate DATE DEFAULT getdate() not null,
	discharegeDate DATE null,
	advance money null,
	labId INT REFERENCES tbl_lab(labId),
	drId INT REFERENCES tbl_doctors(drId),
	disease	VARCHAR(20) not null
)
GO

CREATE TABLE tbl_outPatient
(
	outPatientId INT IDENTITY PRIMARY KEY,
	PatientId INT REFERENCES tbl_patient(PatientId),
	[date] DATE DEFAULT getdate() not null,
	labId INT REFERENCES tbl_lab(labId),
	drId INT REFERENCES tbl_doctors(drId)
)
GO

CREATE TABLE tbl_bill
(
	billNo INT IDENTITY(1001,1) PRIMARY KEY,
	billDate DATE DEFAULT getdate() not null,
	PatientId INT REFERENCES tbl_patient(PatientId),
	patientType VARCHAR(20) not null,
	doctorCharge MONEY DEFAULT 0.00 not null,
	medicineCharge MONEY DEFAULT 0.00 not null,
	roomCharge MONEY DEFAULT 0.00 not null,
	operationCharge MONEY DEFAULT 0.00 not null,
	nursingCharge MONEY DEFAULT 0.00 not null,
	labCharge MONEY DEFAULT 0.00 not null,
	advance MONEY DEFAULT 0.00 not null,
	discountRate FLOAT null,
	totalBill AS (((doctorCharge+medicineCharge+roomCharge+operationCharge+nursingCharge+labCharge)*(1-discountRate/100))-advance)
)
GO

--Creating non clustered index ON national ID number for Stuff table
CREATE NONCLUSTERED INDEX NCI_stf_nid
ON tbl_stuff(NID)
GO

--Creating non clustered index ON email number for Stuff table
CREATE NONCLUSTERED INDEX NCI_stf_email
ON tbl_stuff(email)
GO


--Create stored procedure for INSERTING data into tbl_patient table


CREATE PROC sp_insertPatient
			@PatientName VARCHAR(30),
			@genderId INT,
			@email VARCHAR(35),
			@contactNo VARCHAR(20),
			@streetAddress VARCHAR(60),
			@postalCode INT,
			@city VARCHAR(20),
			@country VARCHAR(25)
AS
BEGIN
	INSERT INTO tbl_patient VALUES(@PatientName,@genderId,@email,@contactNo,@streetAddress,@postalCode,@city,@country)
END
GO


--Create stored procedure for DELETE data from tbl_stuff table


CREATE PROC sp_deleteStuff
			@stuffId INT
AS
BEGIN
	DELETE FROM tbl_stuff
	WHERE stId=@stuffId
END
GO

--Create TRIGGER for preventing gender from modification


CREATE TRIGGER tr_lockGenderMofication
	ON tbl_gender
	FOR INSERT,UPDATE,DELETE
AS
	PRINT 'You can''t modify or delete GENDER!'
	ROLLBACK TRANSACTION
GO

-- INSTEAD OF TRIGGER
-- PREVENT OVER DISCOUNT
-- CAN'T GIVE MORE THAN 50% DISCOUNT

CREATE TRIGGER tr_preventOverDiscount
ON tbl_bill
INSTEAD OF INSERT
AS
BEGIN
		DECLARE 
				@d FLOAT
		SELECT @d=discountRate FROM inserted

		IF @d<=50
			BEGIN
					INSERT INTO tbl_bill(billDate,PatientId,patientType,doctorCharge,medicineCharge,roomCharge,operationCharge,nursingCharge,labCharge,advance,discountRate)
					SELECT billDate,PatientId,patientType,doctorCharge,medicineCharge,roomCharge,operationCharge,nursingCharge,labCharge,advance,discountRate FROM inserted
			END
		ELSE
			BEGIN
					RAISERROR('You Can''t give a patient over 50 percent discount ',10,1)
			END
END
GO

--Creating VIEW for showing full details of inPatient
CREATE VIEW vDetailsOfInPatient
AS
	SELECT p.PatientId,p.PatientName,g.gender,p.email,p.contactNo,inp.admitDate,inp.disease,inp.advance,inp.discharegeDate,d.drName,l.category,r.roomType,p.streetAddress,p.postalCode,p.city,p.country FROM tbl_inPatient inp
	JOIN tbl_Patient p ON inp.PatientId=p.PatientId
	JOIN tbl_gender g ON g.genderId=p.genderId
	JOIN tbl_doctors d ON d.drId=inp.drId
	JOIN tbl_lab l ON l.labId=inp.labId
	JOIN tbl_room r ON r.roomNo=inp.roomNo
GO

--Creating FUNCTION for calculating discounted bill of a patient by inputing discount value

CREATE FUNCTION fnCalcBillByDiscount(@ID INT,@dis FLOAT)
RETURNS MONEY
AS
BEGIN
		DECLARE @bill MONEY
		SELECT @bill=(((doctorCharge+medicineCharge+roomCharge+operationCharge+nursingCharge+labCharge)*(1-@dis/100))-advance)
		FROM tbl_bill
		WHERE PatientId=@ID
		RETURN @bill
END
GO

--Creating FUNCTION which shows patient details by inserting patient ID

CREATE FUNCTION fnPatientDetails(@ID INT)
RETURNS TABLE
AS
RETURN
(
	SELECT	PatientName 'PatientName',
			gender 'gender',
			contactNo 'contact no',
			email 'email',
			admitDate 'admitDate',
			disease 'disease',
			advance 'advance',
			discharegeDate 'discharegeDate',
			drName 'drName',
			category 'category',
			roomType 'roomType',
			streetAddress 'streetAddress',
			postalCode 'postalCode',
			city 'city',
			country 'country'
	FROM vDetailsOfInPatient
	WHERE PatientId=@ID
)
GO

--Creating FUNCTION which shows patient Normal Bill, discount, Discounted Bill by inserting patient ID

CREATE FUNCTION fnPatientBill(@ID INT)
RETURNS @PatientBillDetails TABLE
(
	PatientName VARCHAR(30),
	NormalBill MONEY,
	discount INT,
	discountAmount MONEY,
	advance MONEY,
	netBill MONEY
)
AS
BEGIN
		INSERT INTO @PatientBillDetails
		SELECT p.PatientName,
		SUM(b.doctorCharge+b.medicineCharge+b.roomCharge+b.operationCharge+b.nursingCharge+b.labCharge),
		b.discountRate,
		SUM(((b.doctorCharge+b.medicineCharge+b.roomCharge+b.operationCharge+b.nursingCharge+b.labCharge)/100)*b.discountRate),
		b.advance,
		SUM(((b.doctorCharge+b.medicineCharge+b.roomCharge+b.operationCharge+b.nursingCharge+b.labCharge)*(1-b.discountRate/100))-b.advance) 
		FROM tbl_bill b
		JOIN tbl_patient p ON p.PatientId=b.PatientId
		GROUP BY p.PatientName, b.discountRate, p.PatientId, b.advance
		HAVING p.PatientId=@ID
		
		RETURN
END
GO
