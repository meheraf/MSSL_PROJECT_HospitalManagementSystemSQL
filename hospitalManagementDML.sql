/*
	SQL Project: Hospital Management
	Project By: Md Meheraf Hossain
*/

--Inserting Data


USE hospitalManagementSystemForCore_DB
GO

--Inserting Data into tbl_administrator

INSERT INTO tbl_administrator VALUES('Meheraf Hossain')
INSERT INTO tbl_administrator VALUES('H Mahmud')
GO

--Inserting Data into tbl_department

INSERT INTO tbl_department VALUES
	('Accident and emergency'),
	('Admissions'),
	('Anesthetics'),
	('Cardiology'),
	('Coronary Care Unit'),
	('Critical Care'),
	('Gastroenterology'),
	('General Services'),
	('Gynecology'),
	('Haematology'),
	('Nephrology'),
	('Neurology'),
	('Oncology'),
	('Pharmacy'),
	('Radiology'),
	('Urology'),
	('Accounts'),
	('Hospitality'),
	('Nurse'),
	('Ward Boy'),
	('Others Stuff')
GO


--Inserting Data into tbl_designation

INSERT INTO tbl_designation VALUES
	('CEO'),
	('Managing Director'),
	('Manager'),
	('Accountant'),
	('Recieptionist'),
	('Visiting Doctor'),
	('Junior Doctor'),
	('Senior Doctor'),
	('Junior Nurse'),
	('Senior Nurse'),
	('Junior Ward Boy'),
	('Senior Ward Boy'),
	('Junior stuff'),
	('Senior stuff')
GO

--Inserting Data into tbl_gender

INSERT INTO tbl_gender VALUES
	('Male'),
	('Female')
GO

--Inserting Data into tbl_doctors

INSERT INTO tbl_doctors VALUES
	('Dr Anisur Goni','an@gmail.com','01723147413',1,8,4,'01-01-2020',2),
	('Dr Mir Mubinul Islam','mm@gmail.com','01723554254',1,9,12,'01-02-2020',1),
	('Dr Borhan Uddin','bu@gmail.com','01787847413',1,8,13,'01-01-2021',2),
	('Dr Putul Sarkar','ps@gmail.com','01728887413',2,8,9,'01-01-2020',2),
	('Dr Ruhul Amin','ra@gmail.com','01723147666',1,8,3,'01-01-2020',2),
	('Dr Abu Hossain','ah@gmail.com','01799990413',1,9,16,'01-01-2020',2),
	('Dr Fatema  Tu-Zzahra','fz@gmail.com','0172388876',2,8,6,'01-01-2020',2)
GO

--Inserting Data into tbl_stuff

INSERT INTO tbl_stuff VALUES
	('Md Alam','alm@gmail.com','01853452314',19945231432133213,1,'02-02-1994',12,20,1,'02-02-2020','House-01,Road-01',1216,'Dhaka','Bangladesh',8000.00),
	('Mohammad Forkan','forkan@gmail.com','01853466656',19955231432133213,1,'02-02-1995',4,17,1,'02-01-2020','House-01,Road-01',1225,'Dhaka','Bangladesh',10000.00),
	('Md Kalam','klm@gmail.com','01853454432',19945231432133223,1,'02-02-1997',3,21,1,'02-02-2020','House-01,Road-01',1215,'Dhaka','Bangladesh',12000.00)
GO

--Inserting Data into tbl_patient

INSERT INTO tbl_patient VALUES
	('abir','abr@gmail.com','01853451147',1,'nawabganj',1225,'Dhaka','Bangladesh'),
	('nirob','nrb@gmail.com','01853453358',1,'mirpur',1216,'Dhaka','Bangladesh'),
	('marin','mrn@gmail.com','01853452247',1,'sreenagar',1325,'Dhaka','Bangladesh'),
	('samir','smr@gmail.com','01853457789',1,'nawabganj',1225,'Dhaka','Bangladesh'),
	('amir','mr@gmail.com','01813457789',1,'nawabganj',1225,'Dhaka','Bangladesh')
GO


--Inserting Data into tbl_lab

INSERT INTO tbl_lab VALUES
	('X-ray'),
	('CT Scan'),
	('MicroBiology'),
	('Ultrasound'),
	('General')
GO

--Inserting Data into tbl_room

INSERT INTO tbl_room VALUES
	('VIP'),
	('Normal'),
	('OT'),
	('ICU'),
	('CCU')
GO

--Inserting Data into tbl_inPatient

INSERT INTO tbl_inPatient VALUES
	(2,101,'01-03-2020','03-03-2020',5000.00,3,6,'N/A'),
	(4,102,'02-03-2020','06-03-2020',500.00,1,2,'N/A')
GO

--Inserting Data into tbl_outPatient

INSERT INTO tbl_outPatient VALUES
	(3,'02-03-2020',4,5),
	(5,'06-03-2020',5,1)
GO

--Inserting Data into tbl_bill

INSERT INTO tbl_bill VALUES
	('03-03-2020',5,'Emergency',1500.00,1000.00,5000.00,0.00,500.00,500.00,5000.00,25),
	('02-03-2020',2,'Emergency',500.00,1000.00,0.00,0.00,500.00,500.00,0.00,20),
	('06-03-2020',3,'Emergency',2500.00,1000.00,5000.00,0.00,500.00,500.00,500.00,20),
	('06-03-2020',4,'Emergency',500.00,1000.00,0.00,0.00,500.00,500.00,0.00,20)
GO

select * from tbl_patient
go
select max(PatientId)+1 as ID from tbl_patient
go
select * from tbl_patient where contactNo=01600202053
go
update tbl_patient set PatientName='Md Meheraf Hossain',email='contact@meheraf.com',contactNo='01600202053',genderId=1,streetAddress='mirpur 12',postalCode=1216,city='dhaka',country='bangladesh' where PatientId=6
go

select * from tbl_room
go
select * from tbl_inPatient
go

SELECT p.PatientId,p.PatientName,inp.roomNo,inp.admitDate,inp.discharegeDate,inp.labId,inp.drId,inp.disease,inp.advance,inp.discharegeDate FROM tbl_inPatient inp JOIN tbl_Patient p ON inp.PatientId=p.PatientId where p.PatientId=2
go

update tbl_inPatient set roomNo=102,admitDate='2020-01-01',discharegeDate='2020-01-01',advance=2000,labId=2,drId=3,disease='unknown' where PatientId=8
go
select * from tbl_outPatient
go
SELECT p.PatientId,p.PatientName,op.[date],op.labId,op.drId FROM tbl_outPatient op JOIN tbl_Patient p ON op.PatientId=p.PatientId where p.PatientId=3
go

select * from tbl_doctors
go

select max(drId)+1 as ID from tbl_doctors
go

select * from tbl_stuff
go

select max(stId)+1 as ID from tbl_stuff
go

