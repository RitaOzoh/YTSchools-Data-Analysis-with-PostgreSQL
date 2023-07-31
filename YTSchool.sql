-- CREATE COURSES TABLES

create table courses(course_id varchar(6) primary key, 
							course_name varchar(50), 
							course_unit integer, 
							department varchar(6)
						   );

insert into courses(course_id, course_name, course_unit, department)
values('EX101', 'Introduction to Microsoft Excel', 5, 'DP1'),
			('EX102', 'Intermediate Excel', 4, 'DP1'),
			('EX103', 'Advanced Excel', 3, 'DP1'),
			('PB101', 'Power BI for Dummies', 5, 'DP2'),
			('PB102', 'Data Modelling in Power BI', 3, 'DP2');

select * from courses;


-- CREATE DEPARTMENT TABLES
create table department(department_id varchar(4) primary key, 
						department_name varchar(20));

insert into department(department_id, department_name)
values('DP1', 'MS Excel'),
		('DP2', 'Power BI'),
		('DP3', 'Tableau'),
		('DP4', 'SQL');

select * from department;

-- CREATE SCORES TABLES

create table scores (student_id integer primary key,
					student_name varchar(50),
					course varchar(50),
					score integer);

insert into scores(student_id, student_name, course, score)
values( 1, 'Bill James', 'PB102', 53),
		(2,'Thompson Jude','EX103',78),
		(3,'Shade Cooker','PB101',66),
		(4, 'Granite Bin', 'PB102',71),
		(5, 'Jide Stone', 'EX103',56),
		(6,'Bode Thomas','EX101',94),
		(7,'Sardina Grills','EX103',99),
		(8,'Shark-Dodo King','EX103',87),
		(9,'Queen Rotiseri','EX101',66),
		(10,'Hillary James','EX103',74),
		(11,'Senior Tina','PB101',70),
		(12, 'Denis Joker', 'PB101',99),
		(13,'Beauty TheBeholder','EX103',83),
		(14,'Johnny Komel','EX101',63),
		(15,'Densel California','PB101',58),
		(16,'Jack Robin', 'PB102',92),
		(17,'Hillary Young', 'EX102',61),
		(18,'Robin Hood','EX101',74),
		(19,'James Matilda','PB102',58),
		(20,'Tina Smart','EX101',51);

select * from scores;

-- CREATE A RELATIONSHIP AMONGST THE THREE TABLES
alter table courses
	add constraint
	department foreign key
	(department) references department(department_id);

alter table scores
	add constraint
	course foreign key
	(course) references courses(course_id);

-- YtSchools would like to know their performance in terms of number of students enrolled in each department and each course.
-- Number of students enrolled in each course.
select * from scores;

select course, count(student_id) as number_of_students
from scores
group by course;

-- Number of students in each department.
select * from scores
join courses
on scores.course = courses.course_id;

select department, count(student_id) as number_of_students
from scores
join courses
on scores.course = courses.course_id
group by department;

-- How many courses have at least 5 students enrolled.
select course, count(student_id) as number_of_students
from scores
group by course
having count(student_id) >= 5;

-- The HOD of DP1 will like to know the average score of students in the department.
select * from scores
join courses
on scores.course = courses.course_id;

select department, round(avg(score),2) as average_score
from scores
join courses
on scores.course = courses.course_id
where department = 'DP1'
group by department;

---------OR------------

select department, round(avg(score),2) as average_score
from scores
join courses
on scores.course = courses.course_id
group by department
having department = 'DP1';

-- YTSchools would like to know which departments do not have courses yet.
select * from courses
full join department
on courses.department = department.department_id
where course_id is null;

-- YTSchools will like to know the courses offered by the ‘Power BI’ Department.
select * from courses
join department
on courses.department = department.department_id;

select course_id, course_name, department_name
from courses
join department
on courses.department = department.department_id
where department_name = 'Power BI';



-- Hi Rita, the data entry person just created a new table containing teachers’ details, please create the table for this database
create table teachers (teacher_id varchar(6) primary key,
					   teacher_name varchar(50),
					   sex varchar(2),
					   teacher_salary integer,
					   teacher_course varchar(20)
					  );

insert into teachers (teacher_id, teacher_name, sex, teacher_salary, teacher_course)
values
		('T001', 'Mensah James', 'M', 3000, 'EX102'),
		('T002','Daril Smith','M',1500,'EX101'),
		('T003','Ajibola Hellis','F',7000,'PB101'),
		('T004','Noel Damnin','M',4000,'PB101'),
		('T005','Oyin Dave','F',3500,'PB102'),
		('T006','Gladys Manasseh','F',4600,'EX101'),
		('T007','Samuel Millim','M',7000,'EX101'),
		('T008','Peter Scotland','M',7900,'EX102');
		
select * from teachers;

-- CREATE A RELATIONSHIP BETWEEN TEACHERS AND COURSE TABLE
alter table teachers
	add constraint
	course foreign key
	(teacher_course) references courses(course_id);

-- Which course does not have a teacher yet?
select course_id, course_name, teacher_id
from courses
left join teachers
on teachers.teacher_course = courses.course_id
where teacher_id is null;

-- How much does each department pay to teachers per month?
select department, sum(teacher_salary) as total_salary
from courses
full join teachers
on courses.course_id = teachers.teacher_course
group by department;

-- What department does ‘Mensah James’ belong to?
select teacher_name, department
from teachers
full join courses
on teachers.teacher_course = courses.course_id
where teacher_name = 'Mensah James';

-- How many female teachers are in each department?
select department, sex, count(teacher_id) as number_of_female_teachers
from teachers
join courses
on teachers.teacher_course = courses.course_id
where sex = 'F'
group by department, sex;

-- How many male teachers are in each department?
select department, sex, count(teacher_id) as number_of_male_teachers
from teachers
join courses
on teachers.teacher_course = courses.course_id
group by department, sex
having sex = 'M';

-- Who are the teachers that teach ‘PB101’?
select teacher_name, teacher_course
from teachers
where teacher_course = 'PB101'

-- How many teachers teach ‘PB101’ and what is their average salary? N.B. Your result should be in a single table
select teacher_course, count(teacher_id) as number_of_teachers, round(avg(teacher_salary),0) as average_salary
from teachers
group by teacher_course
having teacher_course = 'PB101';