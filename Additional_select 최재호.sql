-- 1. 
select student_no 학번, student_name 이름, entrance_date 입학년도 from tb_student where department_no = 002 order by entrance_date;

-- 2. 
select professor_name, professor_ssn from tb_professor where length (professor_name) <> 3;

-- 3.
select professor_name 교수이름, extract(year from sysdate) - '19' || substr(professor_ssn, 1, 2) 나이 from tb_professor where substr(professor_ssn, 8, 1) = '1' order by 나이;
-- select professor_name 교수이름, extract(year from sysdate), extract(year from to_date(substr(professor_ssn, 1, 6), 'rrmmdd')) 나이 from tb_professor where substr(professor_ssn, 8, 1) = '1' order by 나이;

-- 4.
select substr(professor_name, 2) 이름 from tb_professor;

-- 5. 
select student_no, student_name from  tb_student where extract(year from sysdate) - to_number('19' || substr(student_ssn, 1, 2)) >19;

-- 6.
select to_char(to_date('20201225', 'yyyymmdd'), 'day') from dual;

-- 7.
select to_date('99/10/11', 'yy/mm/dd'), to_date('49/10/11', 'yy/mm/dd'), to_date('99/10/11', 'rr/mm/dd'), to_date('49/10/11', 'rr/mm/dd') from dual;

-- 8.
select student_no, student_name from tb_student where extract(year from entrance_date) < 2000;

-- 9.
select round(sum(point)/count(*),1) from tb_grade where student_no = 'A517178';

-- 10.
select department_no 학과번호, capacity "학생수(명)" from tb_department;

--11.
select count(*) from tb_student where coach_professor_no is null;

-- 12.
select substr(term_no, 1, 4) 년도,  round(avg(point), 1) "년도 별 평점" from tb_grade where student_no = 'A112113' group by substr(term_no, 1, 4);

-- 13.
select department_no 학과번호,  nvl(count(department_no), 0) "휴학생 수" from tb_student where absence_yn = 'Y' group by department_no order by department_no;
select department_no 학과번호, count(decode(absence_yn, 'Y', 1)) "휴학생 수" from tb_student group by department_no order by department_no;

-- 14.
select student_name 동명이인, count(student_name) from tb_student  group by student_name having count(student_name) >= 2 order by student_name;

-- 15.