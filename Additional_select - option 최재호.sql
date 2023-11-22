-- 1. 학생이름과 주소지를 표시하시오. 단, 출력 헤더는 "학생 이름", "주소지"로 하고, 정렬은 일음으로 오름차순 표시하도록 한다
select student_name "학생 이름", student_address 주소지 from tb_student order by "학생 이름";

-- 2. 휴학 중인 학생들의 이름과 주민번호를 나이가 적은 순서로 화면에 출력하시오.
select student_name, student_ssn from tb_student where absence_yn = 'Y' order by substr(student_ssn, 1, 2) desc, substr(student_ssn, 3, 2) desc, substr(student_ssn, 5, 2) desc;

-- 3. 주소지가 강원도나 경기도인 학생들 중 1900년대 학번을 가진 학생들의 이름과 학번, 주소를 이름의 오름차순으로 화면에 출력하시오. 단, 출력헤더에는 "학생이름", "학번", "거주지 주소"가 출력되도록 한다
select student_name "학생 이름", student_no 학번, student_address "거주지 주소" from tb_student where substr(student_address, 1, 3) in ('경기도', '강원도') and substr(entrance_date, 1, 4) between 1900 and 1999;

-- 4. 현재 법학과 교수 중 가장 나이가 많은 사람부터 이름을 확인할 수 있는 sql 문장을 작성하시오
select professor_name, professor_ssn from tb_professor where department_no = (select department_no from tb_department where department_name = '법학과') order by substr(professor_ssn, 1, 2);

-- 5. 2004년 2학기 'C3118100' 과목을 수강한 학생들의 학점을 조회하려고 한다. 학점이 높은 학생부터 표시하고 , 학점이 같으면 학번이 낮은 학생부터 표시하는 구문을 작성
select student_no, point, term_no, class_no from tb_grade where class_no = 'C3118100' and substr(term_no, 1, 6) = 200402 order by point desc, student_no;

-- 6. 학생 번호, 학생 이름, 학과 이름을 학생 이름으로 오름차순 정렬하여 출력
select student_no, student_name, department_name from tb_student join tb_department using (department_no) order by student_name;

-- 7. 춘 기술대학교의 과목 이름과 과목의 학과 이름을 출력
select class_name, department_name from tb_class join tb_department using (department_no);

-- 8. 과목별 교수 이름을 찾으려고 한다. 과목 이름과 교수 이름을 출력
select class_name, professor_name 
from (select class_name, professor_name 
         from tb_class 
         join tb_professor using (department_no) 
         group by class_name, professor_name);
         
select class_name 과목, professor_name  교수이름
from tb_class
join tb_professor using (professor_no);
     

-- 선생님 풀이 => 과목이 하나씩이라서 하나라서 굳이 group by를 할 필요가 없다
select class_name, professor_name 
from tb_class
join tb_class_professor using (class_no)
join tb_professor using (professor_no);

-- 9. 8번의 결과 중 '인문사회' 계열에 속한 과목의 교수 이름을 찾으려고 한다. 이에 해당하는 과목 이름과 교수 이름을 출력
select class_name, professor_name, department_no, category 
from tb_class 
join tb_professor using (department_no) 
join tb_department using (department_no) 
group by class_name, professor_name, department_no, category 
having department_no in (select 
                                        department_no 
                                        from tb_department where category = '인문사회');

-- 선생님 풀이
select class_name, professor_name 
from tb_class c
join tb_class_professor using (class_no)
join tb_professor using (professor_no)
join tb_department d on d.department_no = c.department_no 
where category = '인문사회';

-- 10. '음악학과' 학생들의 평점을 구하려고 한다. 음악학과 학생들의 학번, 학생 이름, 전체 평점을 출력
select student_no 학번, student_name "학생 이름", round(avg(point), 1) "전체 평점", department_name from tb_student join tb_department using (department_no) join tb_grade using (student_no) group by student_no, student_name, department_name having department_name = '음악학과' order by 학번;

-- 11. 학번이 A313047인 학생이 학교에 나오고 있지 않다. 지도 교수에게 내용을 전달하기 위한 학과 이름, 학생 이름과 지도 교수 이름이 필요
select department_name 학과이름, student_name 학생이름, professor_name 지도교수이름
from tb_student 
join tb_department using (department_no) 
join tb_professor on coach_professor_no = professor_no 
where student_no = 'A313047';

-- 12. 2007년도에 '인간관계론' 과목을 수강한 학생을 찾아 학생 이름과 수강학기를 표시하는 SQL 문장을 작성하시오
SELECT student_name, term_no
FROM tb_student
JOIN tb_grade USING(student_no)
WHERE class_no = (select class_no from tb_class where class_name = '인간관계론') and substr(term_no, 1, 4) = 2007;

-- 13. 예체능 계열 과목 중 과목 담당 교수를 한 명도 배정받지 못한 과목을 찾아 그 과목 이름과 학과 이름을 출력
select class_name, department_name 
from (select * 
        from tb_department 
        join tb_class using (department_no) 
        where department_no in (select department_no 
                                                from tb_department 
                                                where category = '예체능')) 
where class_no not in (select class_no 
                                   from tb_class_professor);

-- 14. 춘 기술대학교 서반아어학과 학생들의 지도교수를 게시하고자 한다. 학생이름과 지도교수이름을 찾고 만일 지도 교수가 없는 학생일 경우, 지도교수 미지정으로 표시하도록하는 sql문을 작성
select student_name 학생이름, nvl(professor_name, '지도교수 미지정') 지도교수 
from (select student_name, coach_professor_no 
         from tb_student 
         where department_no = (select department_no 
                                                from tb_department 
                                                where department_name = '서반아어학과'))
left join tb_professor on coach_professor_no = professor_no;

-- 15. 휴학생이 아닌 학생 중 평점이 4.0 이상인 학생을 찾아 그 학생의 학번, 이름, 학과, 이름, 평점을 출력
select student_no 학번, student_name 이름, department_name "학과 이름", trunc(avg(point), 8) 평점 
from tb_student 
join tb_department using (department_no) 
join tb_grade using (student_no)
group by student_no, student_name, department_name, absence_yn
having absence_yn = 'N' and avg(point) >= 4 order by 학번;

-- 16. 환경조경학과 전공과목들의 과목 별 평점을 파악할 수 있는 sql문 작성
select class_no, class_name, department_no, trunc(avg(point), 8)
from tb_class 
join tb_grade using(class_no) 
group by class_no, class_name, department_no, class_type
having department_no = (select department_no 
                                       from tb_department 
                                       where department_name = '환경조경학과')
                                       and class_type = '전공선택'
order by class_no;

-- 17. 춘 기술대학교에 다니고 있는 최경희 학생과 같은 과 학생들의 이름과 주소를 출력
select student_name, student_address 
from tb_student 
where department_no = (select department_no 
                                       from tb_student
                                       where student_name = '최경희');
                                       
-- 18. 국어국문학과에서 총 평점이 가장 높은 학생의 이름과 학번 표시
select student_no, student_name 
from (select student_no, student_name, avg(point) 
        from tb_student 
        join tb_grade using (student_no) 
        group by student_no, student_name, department_no
        having department_no = (select department_no 
                                               from tb_department 
                                               where department_name = '국어국문학과')
        order by avg(point) desc)
where rownum = 1;

-- 19. 춘 기술대학교의 "환경조경학과"가 속한 같은 계열 학과들의 학과 별 전공과목 평점을 파악하기 위한 sql문 출력. 출력 헤더는 "계열 학과명", "전공평점"으로 표시, 평점은 소수점 한자리까지만 반올림
select department_name "계열 학과명", round(avg(point),1) 전공평점
from tb_student 
join tb_department using (department_no)
join tb_grade using (student_no)
group by department_name, category
having category = (select category from tb_department where department_name = '환경조경학과')
order by department_name;