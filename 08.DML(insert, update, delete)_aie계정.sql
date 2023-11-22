/*
dml(date manipulation language): 데이터 조작언어
테이블에 값을 삽입(insert)하거나, 수정(update), 삭제(delete), 검색(select)하는 구문
*/

--===============================================================================================================

--------------------------------------------------------------------insert---------------------------------------------------------------------

--===============================================================================================================

/*
1. insert
테이블에 새로운 행을 추가하는 구문

[표현식]
1) insert into 테이블명 values(값1, 값2, 값3...)
    테이블의 모든 컬럼에 값을 직접 넣어 한 행을 넣고자 할 때
    컬럼의 순서대로 values에 값을 넣는다
    
    부족하게 값을 넣었을 때 => not enough value 오류
    값을 더 많이 넣었을 때 => too many values 오류
*/
insert into employee values(300, '이시영', '051117-1234567', 'lee_elk@elk.or.kr', '01023456789', 'D1', 'J5', 3500000, 0.2, 200, sysdate, null, default);
insert into employee values(301, '이시영', '051117-1234567', 'lee_elk@elk.or.kr', '01023456789', 'D1', 'J5', 3500000, 0.2, 200, sysdate, null); -- 값의 수가 충분하지 않습니다 00947. 00000 -  "not enough values"
insert into employee values(302, '이시영', '051117-1234567', 'lee_elk@elk.or.kr', '01023456789', 'D1', 'J5', 3500000, 0.2, 200, sysdate, null, default, null); -- 값의 수가 너무 많습니다 00913. 00000 -  "too many values"

--------------------------------------------------------------------------------------------------------------------------------------------------------

/*
2) insert into 테이블명 (컬럼명, 컬럼명, 컬럼명...) values (값, 값, 값...)
>> 컬럼명 순서에 맞개 해당 값의 순서도 지켜야한다
    테이블에 내가 선택한 컬럼에 값을 넣을 때 사용
    행단위로 추가되기 때문에 선책되지 않은 컬럼은 기본적으로 null이 들어감
    => 반드시 넣어야될 컬럼: 기본키, not null인 컬럼
    단, 기본값(default)가 지정되어 있는 컬럼은 null이 아닌 기본값이 들어감
*/

insert into employee (emp_id, emp_name, emp_no, job_code, hire_date) 
                     values (301, '김지창', '031017-1234567', 'J1', sysdate);
                     
select * from employee;

insert into employee (hire_date, emp_id,  job_code, emp_name, emp_no) 
                     values (sysdate, 302, 'J1', '허수연', '031017-1234567');
                     
select * from employee;

--------------------------------------------------------------------------------------------------------------------------------------------------------
/*
3) 서브쿼리를 이용한 insert
    insert into 테이블명 (서브쿼리);
    values의 값을 직접 명시하는 대신 서브쿼리로 조회된 결과값을 모두 insert 가능(여러행도 가능)
    */

-- 테이블 생성
create table emp_01 (
emp_id number,
emp_name varchar2(20),
dept_name varchar2(35)
);

-- 전체 사원의 사번, 사원명, 부서명 조회
select emp_id, emp_name, dept_title from employee left outer join department on dept_code = dept_id;

insert into emp_01 (select emp_id, emp_name, dept_title from employee left outer join department on dept_code = dept_id);

--========================================================================================================================================

/*
2. insert all: 2개 이상의 테이블에 각각 insert할 때
단, 이때 사용도는 서브쿼리가 동일한 경우

[표현법]
insert all
into 테이블명1 values (컬럼명, 컬럼명,...)
into 테이블명2 values (컬럼명, 컬럼명,...)
서브쿼리;
*/

-- 테이블 2개 생성
create table emp_dept
as select emp_id, emp_name, dept_code, hire_date
     from employee
     where 1 = 0;
    
create table emp_manager
as select emp_id, emp_name, manager_id
     from employee
     where 1 = 0;

-- 부서코드가 D1인 사원들의 사번, 사원명, 부서코드, 입사일, 사수번호 조회
select emp_id, emp_name, dept_code, hire_date, manager_id 
from employee 
where dept_code = 'D1';

-- 부서코드가 D1인 사원들의 사번, 사원명, 부서코드, 입사일, 사수번호를 emp_dept의 각 컬럼명에 emp_manager의 각 컬럼명에 분배해 삽입
insert all
into emp_dept values (emp_id, emp_name, dept_code, hire_date)
into emp_manager values(emp_id, emp_name, manager_id)
    select emp_id, emp_name, dept_code, hire_date, manager_id 
    from employee 
    where dept_code = 'D1';

--==============================================================================================================================================

/*
3. 조건을 제시하여 각 테이블에 insert 가능

[표현식]
insert all
when 조건1 then
    into 테이블명1 values (컬럼명, 컬럼명,...)
when 조건2 then
    into 테이블명2 values (컬럼명, 컬럼명,...)
...
서브쿼리
*/

-- 2000년도 이전에 입사한 사원들의 대한 정보를 담을 테이블 생성
create table emp_old
as select emp_id, emp_name, hire_date, salary
      from employee
    where 1=0;
    
-- 2000년도 이후에 입사한 사원들의 대한 정보를 담을 테이블 생성
create table emp_new
as select emp_id, emp_name, hire_date, salary
      from employee
    where 1=0;
    
insert all
when hire_date < '2000/01/01' then 
    into emp_old values (emp_id, emp_name, hire_date, salary)
when hire_date >= '2000/01/01' then
    into emp_new values (emp_id, emp_name, hire_date, salary)
select emp_id, emp_name, hire_date, salary
from employee;

--===============================================================================================================

--------------------------------------------------------------------update---------------------------------------------------------------------

--===============================================================================================================

/*
1.update
테이블에 저장되어 있는 기존의 데이터를 수정

[표현식]
update 테이블명
set 컬럼명 = 바꿀값,
      컬럼명 = 바꿀값,
      ...
[where 조건]

>> where절이 없으면 해당 컬럼의 데이터가 변경됨
*/

-- 복사 테이블 생성
create table dept_copy
as select * from department;

-- D3 부서의 부서명을 '전략기회팀'으로 수정
update dept_copy
set dept_title = '전략기회팀';

rollback;

update dept_copy
set dept_title = '전략기회팀' where dept_id = 'D3';

-- 복사 테이블 생성
create table emp_salary
as select emp_id, emp_name, dept_code, salary, bonus from employee;

-- 박정보 사원의 급여를 400만원으로 변경
update emp_salary
set salary = 4000000 where emp_name = '박정보';

rollback;

-- 조정연 사원의 급여를 410만으로, 보너스를 0.25로 변경
update emp_salary
set salary = 4100000, bonus = 0.25 where emp_name = '조정연';

rollback;

-- 전체 사원의 급여를 기존 급여의 10%인상한 금액으로 변경(기존급여 * 1.1) = 기존급여 + (기존급여 * 0.1)
update emp_salary
set salary = salary * 1.1;

rollback;
--==========================================================================================================================================================

/*
2. update시 서브쿼리 사용

[표현식]
update 테이블명
set 컬럼명= (서브쿼리)
[where 조건];

>> update시에도 해당 컬럼에 대한 제약조건에 위배되면 안됨
*/

-- 왕정보 사원의 급여와 보너스값을 조정연 사원의 급여와 보너스값으로 변경
update emp_salary
set salary = (select salary from employee where emp_name = '조정연'),
      bonus = (select bonus from employee where emp_name = '조정연')
where emp_name = '왕정보';

update emp_salary
set (salary, bonus) = (select salary, bonus from employee where emp_name = '조정연')
where emp_name = '왕정보';

-- 이시영, 김지창, 허수연, 현정보, 선우정보 사원들의 급여와 보너스를 조정연 사원과 같도록 변경
update emp_salary
set (salary, bonus) = (select salary, bonus from employee where emp_name = '조정연')
where emp_name in ('이시영', '김지창', '허수연', '현정보', '선우정보');

-- join으로 데이터 변경
-- asia 지역에서 근무하는 사원들의 보너스를 0.3으로 변경
update emp_salary
set bonus = 0.3
where dept_code in (select dept_code 
           from employee 
           join department on dept_code =dept_id
           join location on local_code = location_id
           where local_name like 'ASIA%');
           
-- update시에도 해당 컬럼에 대한 제약조건에 위배되면 안됨           
-- 사번이 200번인 사원의 이름 null 변경 
update employee
set emp_name = null
where emp_id = 200; -- not null 제약조건 위배

-- 왕정보인 사원의 직급코드를 J9로 변경
update employee
set job_code = 'D9'
where emp_name ='왕정보'; -- 외래키 제약조건 위배

--===============================================================================================================

--------------------------------------------------------------------delete---------------------------------------------------------------------

--===============================================================================================================
/*
1. delete
테이블에 저장된 데이터를 삭제 (행단위로 삭제)

[표현식]
delete from 테이블명
[where 조건];

>> where절이 없으면 모든 행 삭제
>> delete시에도 해당 컬럼에 대한 제약조건에 위배되면 안됨 
*/

-- 지정보 사원을 삭제
delete from employee;

rollback;

delete from employee where emp_name = '지정보';

rollback;

delete from employee where emp_id = 300;

-- delete시에도 해당 컬럼에 대한 제약조건에 위배되면 안됨   
-- job_code가 J1인 부서 삭제
delete from job where job_code = 'J1'; -- 무결성 제약조건 위배

/*
2. truncate
테이블 전체 데이터를 삭제할 때 사용하는 구문
delete보다 수행속도가 빠르다
별도의 조건제시 불가, rollback 불가

[표현식]
truncate table 테이블명;
*/

truncate table emp_salary; -- 잘렸다고 출력됨

rollback; -- 롤백 완료라고 출력되나 복구 안됨