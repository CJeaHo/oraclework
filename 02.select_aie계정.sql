--테이블의 컬럼의 정보 조회

/*
(')홀따옴표: 문자열일 때
(")쌍따옴표: 컬럼명일 때
*/

/*
select: 데이터 조회할 때 사용
result set: select문을 통해 조회된 결과물(조회된 행들의 집합)

[표현법]
select 조회하려는 컬럼명1, 컬럼명2, ...
from 테이블명
*/

select *
from employee;

select *
from department;

select emp_id, emp_name, phone 
from employee;

/*
<컬럼값을 통한 산술연산>
select를 컬럼명 작성부분에 산술연산 기술 가능(이때 산술연산된 결과 조회)
*/

--employee에서 사원명, 사원의 연봉(급여 *12)조회
select emp_name, salary*12 from employee;

select emp_name, salary, bonus from employee;

--employee에서 사원명, 급여, 보너스, 연봉, 보너스를 포함한 연봉((급여+(보너스+급여)*12)
select emp_name, salary, bonus, salary*12, (salary+(bonus+salary)*12) from employee;

--산술 연산 중 null이 존재하면 결과는 무조건 null

--employee에서 사원명, 입사일, 근무일수(오늘날짜-입사일)
--date형끼리도 연산 가능, 결과값은 일 단위
--오늘 날짜: sysdate;
select emp_name, hire_date, sysdate-hire_date from employee;

--함수로 date날짜처리하면 초단위를 관리할 수 있음
-------------------------------------------------------------------------------

/*
컬럼명에 별칭 지정하기
산술연산의 산술에 들어간 수식 그대로 컬럼명이 됨, 이때 별칭을 부여하면 깔끔하게 처리
[표현볍]
컬럼명 별칭/ 컬럼명 as 별칭/ 컬럼명 "별칭"/ 컬럼명 as "별칭"
별칭에 띄어쓰기나 특수문자 포함되면 반드시 (")쌍따옴표를 넣어줘야 함;
*/

select emp_name 사원명, salary as 급여, bonus "보너스", salary*12 as "연봉(원)", (salary+(bonus+salary)*12) "총 소득"  from employee;

select emp_name 사원명, hire_date as , sysdate-hire_date from employee;

/*
리터럴: 임의로 지정된 문자열(')
select절에 리터럴을 제시하면 마치 테이블상에 존재하는 데이터처럼 조회가능
조회된 result set의 모든 행에 반복적으로 출력
*/

--employee에 사번, 사원명, 급여 원 as 단위 조회
select emp_id, emp_name, salary, '원' as "단위" from employee;

--------------------------------------------------------------

/*
연결 연산자: ||
여러 컬럼값들을 마치 하나의 컬럼값인 것처럼 연결하거나, 컬럼값과 리터럴을 연결할 수 있음
*/

--employee에 사번, 사원명, 급여를 하나의 컬럼으로 조회
select emp_id || emp_name || salary "사원들의 아이디와 이름, 급여" from employee;

select emp_id, emp_name, salary || '원'  from employee;

--홍길동의 월급은 900000원입니다
select emp_name || '의 월급은' || salary || '원 입니다' from employee;

--홍길동의 전화번호는 phone이고 이메일은 email입니다
select emp_name || '의 전화번호는 ' || phone || '이고 이메일은 ' || email || '입니다' from employee;