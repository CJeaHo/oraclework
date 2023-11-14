-- 1. 춘 기술대학교의 학과 이름과 계열을 표시시오. 단, 출력 헤더는 "학과 명", "계열"으로 표시하도록 한다.
select department_name "학과 명", category 계열 from tb_department;

-- 2. 학과의 학과 정원을 다은과 같은 형태로 화면에 출력한다
select department_name || '의 정원은' || capacity  || '명 입니다' as "학과별 정원" from tb_department;

-- 3. "국어국문학과"에 다니는 여학생 중 휴학중인 여학생을 찾아달라는 요청이 들어왔다. 누구인가?
select student_name from tb_student where absence_yn = 'Y' and substr(student_ssn, 8, 1) in (2, 4) and department_no = 1;

-- 4. 도서관에서 대출 도서 장기 연체자들을 찾아 이름을 게시하고자 한다. 그 대상자들의 학번이 다음과 같을 때 대상자들을 찾는 적절한 SQL 구문을 작성하시오
select student_name from tb_student where student_no in ('A513079', 'A513090', 'A513091', 'A513110', 'A513119') order by student_name desc;

-- 5. 입학정원이 20명 이상 30명 이하인 학과들의 학과 이름과 계열을 출력하시오
select department_name, category from tb_department where capacity between 20 and 30;

-- 6. 춘 기술대학교는 총장을 제외하고 모든 교수들이 소속 학과를 가지고 있따. 그럼 춘 기술대학교의 총장의 이름을 알아낼 수 있는 SQL 문장을 작성하시오
select professor_name from tb_professor where department_no is null;

-- 7. 혹시 전산상의 착오로 학과가 지정되어있지 않은 학생이 있는지 확인하고자 한다. 어떠한 sql문장을 사용하면 될 것인지 작성하시오
select * from tb_student where department_no is null;

-- 8. 수강신청을 하려고 한다. 선수과목 여부를 확인해야 하는데, 선수과목이 존재하는 과목들은 어떤 과목인지 과목번호를 조회해보시오
select class_no from tb_class where preattending_class_no is not null;

-- 9. 춘 대학에는 어떤 계열들이 있는지 조회해보시오
select distinct category from tb_department order by category;

-- 10. 02학번 전주 거주자들의 모임을 만들려고 한다. 휴학한 사람들은 제외한 재학중인 학생들의 학번, 이름, 주민번호를 출력하는 구문을 작성하시오
select * from tb_student where substr(student_address, 1, 2) = '전주' and absence_yn = 'N' and substr(entrance_date, 3, 2) = 02;