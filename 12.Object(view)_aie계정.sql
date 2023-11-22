/*
뷰(view)
select문을 저장해둘 수 있는 객체
(자주 쓰는 긴 select문을 저장해두면 그 긴 select문을 매번 다시 기술할 필요없음)
임시테이블같은 존재(실제 데이터가 담겨있는건 아님 => 논리적인 테이블)
*/

-- '한국'에서 근무하는 사원들의 사번, 사원명, 부서명, 급여, 근무국가명, 조회
select emp_id, emp_name, dept_title, salary, national_name
from employee
join department on (dept_code = dept_id)
join location on(location_id = local_code)
join national using(national_code)
where national_name = '한국';

-- '러시아'에서 근무하는 사원들의 사번, 사원명, 부서명, 급여, 근무국가명, 조회
select emp_id, emp_name, dept_title, salary, national_name
from employee
join department on (dept_code = dept_id)
join location on(location_id = local_code)
join national using(national_code)
where national_name = '러시아';

-- '일본'에서 근무하는 사원들의 사번, 사원명, 부서명, 급여, 근무국가명, 조회
select emp_id, emp_name, dept_title, salary, national_name
from employee
join department on (dept_code = dept_id)
join location on(location_id = local_code)
join national using(national_code)
where national_name = '일본';

--------------------------------------------------------일일이 다 길게 작성

/*
1. view 생성

[표현식]
create view 뷰명
as 서브쿼리문;
>> 관리자 계정에서 뷰 생성 권한을 줘야한다
*/

-- 반복되는 부분만 
create view vm_employee
as select emp_id, emp_name, dept_title, salary, national_name
        from employee
        join department on (dept_code = dept_id)
        join location on(location_id = local_code)
        join national using(national_code);

-- (관리자 계정으로 전환하고) view를 생성할 수 있는 권한 부여
grant create view to aie;

-- 뷰를 이용하여 
-- '한국'에서 근무하는 사원들의 사번, 사원명, 부서명, 급여, 근무국가명, 조회
select * from vm_employee where national_name = '한국'; 

-- '러시아'에서 근무하는 사원들의 사번, 사원명, 부서명, 급여, 근무국가명, 조회
select * from vm_employee where national_name = '러시아'; 

-- '일본'에서 근무하는 사원들의 사번, 사원명, 부서명, 급여, 근무국가명, 조회
select * from vm_employee where national_name = '일본'; 

-- '뷰' 항목 조회
select * from user_views;

------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
뷰 컬럼에 별칭 부여
서브쿼리의 select절에 함수식이나 산술연산식이 기술되어있을 경우 반드시 컬럼에 별칭 지정해야됨
*/
-- 전체 사원의 사번, 사원명, 직급명, 성별(남/여), 근무년수를 조회할 수 있는 view(vm_emp_job)생성
create view vm_emp_job
as select emp_id 사번, emp_name 사원명, job_name 직급명, decode(substr(emp_no,8,1), 1, '남', 2, '여') "성별(남/여)", substr(hire_date, 1, 4) 근무년수
    from employee
    join job using(job_code);
    
select * from vm_emp_job;    

/*
view 수정 
이미 같은 이름의 뷰가 있다면 그 뷰를 갱신(덮어쓰기)
없다면 생성

[표현식]
create or replace view 뷰명
바꿀 내용
*/

-- 뷰 수정 1. (내용)
create or replace view vm_emp_job
as select emp_id 사번, emp_name 사원명, job_name 직급명, decode(substr(emp_no,8,1), 1, '남', 2, '여') "성별(남/여)", extract(year from sysdate) - extract(year from hire_date) 근무년수
    from employee
    join job using(job_code);
    
-- 뷰 수정 2. (별칭)
create or replace view vm_emp_job(사번, 사원명, 직급명, 성별, 근무년수)
as select emp_id, emp_name, job_name, decode(substr(emp_no,8,1), 1, '남', 2, '여'), extract(year from sysdate) - extract(year from hire_date)
    from employee
    join job using(job_code);
    
select * from vm_emp_job where 성별 = '여';
select * from vm_emp_job where 근무년수 >= '20';

/*
뷰 삭제

[표현식]
drop view 뷰명;
*/

-- 뷰 삭제
drop view vm_emp_job;

------------------------------------------------------------------------------------------------------------------------------------------------

/* 
생성된 뷰를 이용해 dml(insert, update, delete) 가능
뷰를 통해 조작하면 실제 데이터가 담겨있는 베이스 테이블에 반영됨

>> dml명령어로 조작이 불가능한 경우가 더 많음
    1) 뷰에 정의되어있지 않은 컬럼을 조작하려는 경우
    2) 뷰에 정의되어있지 않은 컬럼 중에 기존 테이블 상에 not null 제약조건이 지정되어 있는 경우
    3) 산술연산식이나 함수식으로 정의되어있는 경우
    4) 그룹함수나 group by절이 포함되어 있는 경우
    5) distinct(중복불허)구문이 포함된 경우
    6) join을 이용하여 여러 테이블을 연결시켜 놓은 경우
*/
create or replace view vm_job
as select job_code, job_name
    from job;

select * from vm_job;
select * from job;

-- 뷰를 통해 insert
insert into vm_job values('J8', '인턴');

-- 뷰를 통해 update
update vm_job set job_name = '알바' where job_code = 'J8';

-- 뷰를 통해 delete
delete from vm_job where job_code = 'J8';

-- 1) 뷰에 정의되어 있지 않은 컬럼을 조작할 경우
create or replace view vm_job
as select job_code
    from job;
    
--  insert
insert into vm_job (job_code, job_name) values('J8', '인턴'); -- "JOB_NAME": 부적합한 식별자
-- 뷰에 job_name이란 컬럼이 존재하지 않는다

-- update
update vm_job set job_name = '알바' where job_code = 'J8'; -- "JOB_NAME": 부적합한 식별자

-- delete
delete from vm_job where job_name = '사원'; -- "JOB_NAME": 부적합한 식별자

-- 2) 뷰에 정의되어있지 않은 컬럼 중에 기존 테이블 상에 not null 제약조건이 지정되어 있는 경우
create or replace view vm_job
as select job_name
    from job;

-- insert
insert into vm_job values('사원'); -- NULL을 ("AIE"."JOB"."JOB_CODE") 안에 삽입할 수 없습니다
                                                  -- 실제 테이블에 insert할 때는 values(null, '사원') 삽입 => job_code는 pk라서 null을 넣을 수 없다

-- delete
delete from vm_job where job_name = '사원'; -- 무결성 제약조건(AIE.SYS_C008460)이 위배되었습니다- 자식 레코드가 발견되었습니다
-- 외래키가 되어있을 경우 자식테이블에서 사용하고 있으면 삭제 안됨

-- 3) 산술연산식이나 함수식으로 정의되어있는 경우
create or replace view vm_emp_sal
as select emp_id, emp_name, salary, salary * 12 연봉
    from employee;
    
-- insert
insert into vm_emp_sal values(600, '김상진', 3000000, 36000000); -- 가상 열은 사용할 수 없습니다
-- 실제 테이블에는 연봉이라는 컬럼이 없다

insert into vm_emp_sal (emp_id, emp_name, salary) values (600, '김상진', 3000000); -- NULL을 ("AIE"."EMPLOYEE"."EMP_NO") 안에 삽입할 수 없습니다
-- not null에 걸린다

-- update
update vm_emp_sal set 연봉 = 40000000 where emp_id  = 301; -- 가상 열은 사용할 수 없습니다
-- 실제 테이블에 없는 컬럼

update vm_emp_sal set salary = 4000000 where emp_id  = 301;
-- 뷰에도 기존 테이블에도 있는 컬럼의 값을 바꾸는 것이므로 수정이 된다

select * from vm_emp_sal order by 연봉;

-- delete
delete from vm_emp_sal where 연봉 =16560000; 
-- 산술연산식으로 나온 결과의 값을 삭제 할 수 있다

-- 4) 그룹함수나 group by절이 포함되어 있는 경우
create or replace view vm_group_dept
as select dept_code, sum(salary) 합계, round(avg(salary)) 평균
    from employee
    group by dept_code;

select * from vm_group_dept;
select * from employee;

-- insert
insert into vm_group_dept values('D3', 8000000, 40000000); -- 가상 열은 사용할 수 없습니다

-- insert
update vm_group_dept set 합계 = 6000000 where dept_code= 'D2'; -- 뷰에 대한 데이터 조작이 부적합합니다

-- delete
delete from vm_group_dept where 합계 = 17700000; -- 뷰에 대한 데이터 조작이 부적합합니다

-- 5) distinct(중복불허)구문이 포함된 경우
create or replace view vm_job
as select distinct job_code
    from employee;
    
select * from vm_job;

-- insert
insert into vm_job values('J8'); -- 뷰에 대한 데이터 조작이 부적합합니다
-- not null 제약조건과 distinct 때문에 오류

-- update
update vm_job set job_code = 'J8' where job_code = 'J1'; -- 뷰에 대한 데이터 조작이 부적합합니다

-- delete
delete from vm_job where job_code = 'J1'; -- 뷰에 대한 데이터 조작이 부적합합니다

-- 6) join을 이용하여 여러 테이블을 연결시켜 놓은 경우
create or replace view vm_join
as select emp_id, emp_name, dept_title 
    from employee 
    join department on (dept_code = dept_id);
    
select * from vm_join;

-- insert
insert into vm_join values(700, '황미정', '총무부'); -- 조인 뷰에 의하여 하나 이상의 기본 테이블을 수정할 수 없습니다.

-- update
update vm_join set emp_name = '김새로이' where emp_id = 200;
update vm_join set dept_title = '인사관리부' where emp_id = 200; 
-- join을 통해 부서를 가져왔기 때문에 employee테이블의 dept_code 수정안됨

-- delete
delete from vm_join where emp_id = 200;

rollback;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
view 옵션

[표현식]
create [or replace] [noforce | force] view 뷰명
as 서브쿼리
[with check option]
[with read only]

1) or replace: 기존에 동일 뷰가 있으면 갱신시키고 없으면 새로 생성
2) noforce | force
    - noforce: 서브쿼리에 기술된 테이블이 존재해야하만 뷰를 생성할 수 있음(생략시 기본값)
    - force: 서브쿼리에 기술된 테이블이 존재하지 않아도 뷰가 생성됨
3) with check option: dml시 서브쿼리에 기술된 조건에 부합하는 값으로만 dml이 가능하도록 함
4) with read only: 뷰에 대해 조회만 가능(select 제외한 dml문 불가)
*/

--  noforce 
create or replace noforce view vm_emp as select tcode, tname, tcount from tt; -- tt테이블이 없어서 생성불가

--  force
create or replace force view vm_emp as select tcode, tname, tcount from tt; -- tt테이블이 없지만 생성(컴파일 오류와 함께)

-- 테이블을 생성해야만 그때무터 view 활용
create table tt (
    tcode number,
    tname varchar2(20),
    tcount number
);

select * from vm_emp;

-- with check option 미사용시
create or replace view vm_emp 
as select * 
    from employee 
    where salary >= 3000000; -- 8명 조회
    
-- 200번 사원의 급여를 200만원으로 변경
update vm_emp set salary = 2000000 where emp_id = 200; -- 조건에 안맞게 했더니 안맞는 값은 제외되서 7명 조회

-- with check option 사용시
create or replace view vm_emp_check 
as select * 
    from employee 
    where salary >= 3000000 with check option;
    
-- 201번 사원의 급여를 200만원으로 변경
update vm_emp_check set salary = 2000000 where emp_id = 201; -- 조건에 안맞으면 오류가 뜬다(뷰의 WITH CHECK OPTION의 조건에 위배 됩니다)

-- with read only
create or replace view vm_emp_read 
as select emp_id, emp_name, bonus 
    from employee 
    where bonus is not null with read only;

-- select만 가능 그 외 insert, update, delete 오류
select * from vm_emp_read;












