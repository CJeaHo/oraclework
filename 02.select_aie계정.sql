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

/*
distinct
컬럼의 중복된 값들을 한번씩만 표시하고자 할 때
*/

-- 중복 포함
select job_code from employee;
select dept_code from employee;

-- 중복 제외
select DISTINCT job_code from employee;
select DISTINCT dept_code from employee;

-- 2개를 조합해서 중복되는건 없지만 하나씩만 보면 중복된다(select절에서 distinct는 한번만 기술)
-- select DISTINCT job_code, distinct job_code from employee;(x)
select DISTINCT job_code, job_code from employee;

/*
where 
조회하고자하는 테이블에서 특정 조건에 만족하는 데이터만 조회할 때
<비교연산자> 비교하는 연산자
> ,<, >=, <= 대소비교
= 같은지 비교
!=, ^=, <> 다른지 비교

<논리연산자> 여러개의 조건을 묶어서 제시하고자 할 때
and ~이면서, 그리고
or ~이거나, 또는

<between and> ~이상 ~이하인 범위 조건을 제시할 때
비교대상 컬럼 between 하한값 and 상한값

<like> 비교하고자하는 컬럼값이 내가 제시한 특정 패턴에 만족하는 경우 조회
비교대상 컬럼 like '특정 패턴'
%: 0글자 이상
ex) 비교대상컬럼 like '문자%' => 비교대상 컬럼값이 '문자'로 시작되는 것들을 조회: 문자, 문자+@
ex) 비교대상컬럼 like '%문자' => 비교대상 컬럼값이 '문자'로 끝나는 것들을 조회: 문자, @+문자
ex) 비교대상컬럼 like '%문자%' => 비교대상 컬럼값이 '문자'를 포함하는 것들을 조회: 문자, @+문자+@

_: N글자(한글자가 올 경우 '_문자', 두글자가 올 경우 '__문자' N글자가 올 경우 _를 N개 써서 붙인다)
ex) 비교대상컬럼 like '_문자' => 비교대상 컬럼값의 '문자'앞에 무조건 한글자가 올 경우
ex) 비교대상컬럼 like '문자_' => 비교대상 컬럼값의 문자'뒤'에 무조건 한글자가 올 경우
ex) 비교대상컬럼 like '_문자_' => 비교대상 컬럼값의 문자'앞'과 '뒤'에 무조건 한글자가 올 경우

<is null/is not null>
컬럼에 null이 있는 경우 null값 비교에 사용되는 연산자

<in/not in>
in 컬럼값이 내가 제시한 목록 중에 일치하는 값이 있는 것만 조회
not in 컬럼값이 내가 제시한 목록 중에 일치하는 값을 제외한 나머지만 회
ex) 비교대상 컬럼 in (값1, 값2,...)

[표현법]
select 컬럼1, 컬럼2,... 산술연산,... from 테이블명 where 조건식; (데이터는 대소문자 구분)
*/

-- <비교연산자>
-- employee에서 부서코드가 'D9'인 사원들의 모든 컬럼 조회
select * from employee where dept_code = 'D9';

-- employee에서 부서코드가 'D1'이 아닌 사원들의 사번, 사원명, 부서코드를 조회
select emp_id, emp_name, dept_code from employee where dept_code <> 'D1';

-- employee에서 급여가 400만원 이상인 사원들의 사원명, 부서코드, 급여 조회
select emp_name, dept_code, salary from employee where salary>=4000000;

-- employee에서 제직중인 사원의 사번, 사원명, 입사일 조회
select emp_id, emp_name, hire_date, ent_yn from employee where ent_yn='N';

-- <논리연산자>
-- 부서코드가 'D9'이면서 급여가 500만원 이상인 사원들의 사원명, 부서코드, 급여 조회
select emp_name, dept_code, salary from employee where dept_code = 'D9' and salary >= 5000000;

-- 부서코드가 'D6'이거나 급여가 300만원 이상인 사원들의 사원명, 부서코드, 급여 조회
select emp_name, dept_code, salary from employee where dept_code='D6' or salary>=3000000;

-- 급여가 350만원 이상 600만원 이하인 사원의 사번, 사원명, 급여 조회
select emp_id, emp_name, salary from employee where salary>=3500000 and salary<=6000000; 

-- <between A and B>
-- 급여가 350만원 이상 600만원 이하인 사원의 사번, 사원명, 급여 조회
select emp_id, emp_name, salary from employee where salary between 3500000 and 6000000; 

-- 급여가 350만원 이상 600만원 이하를 제외한 사원의 사번, 사원명, 급여 조회
select emp_id, emp_name, salary from employee where not salary between 3500000 and 6000000; 

-- 입사일이 90/01/01 ~ 01/12/31 사이인 사원의 사번, 사원명, 입사일 조회
select emp_id, emp_name, hire_date from employee where hire_date between '90/01/01' and '01/12/31';

-- <like 특정 패턴>
-- 사원들 중 성이 '전 씨'인 사원의 사번, 사원명 조회
select emp_id, emp_name from employee where emp_name like '전%';

-- 사원들 중 '하'가 포함되어있는 사원들의 사번, 사원명 조회
select emp_id, emp_name from employee where emp_name like '%하%';

-- 사원들 중 이름 가운데가 '하'인 사원들의 사번, 사원명 조회
select emp_id, emp_name from employee where emp_name like '_하_';

-- 전화번호 중 3번째 글자가 '1'인 사원의 사번, 사원명, 전화번호 조회
select emp_id, emp_name, phone from employee where phone like '__1%';

-- 이메일 중 _앞에 글자가 3글자인 사원들의 사번, 사원명, 이메일 조회
select emp_id, emp_name, email from employee where email like '____%';

-- 와일드 카드인지 데이터인지 구분을 해줘야한다
-- 데이터값으로 취급하고자하는 값앞에 나만의 와일드카드(아무거나 문자, 숫자, 특수문자(&제외))를 제시하고
-- 나만의 와일드카드를 escape로 등록해야함
select emp_id, emp_name, email from employee where email like '___$_%' escape '$';

--1. 이름이 '연'으로 끝나는 사원들의 사번, 사원명, 고용일 조회
select emp_id, emp_name, hire_date from employee where emp_name like '%연';

--2. 전화번고 처음 3자리가 010이 아닌 사원들의 사원명, 전화번호 조회
select emp_name, phone from employee where not phone like '010%';

--3. 이름에 '하'가 포함되어 있고 급여가 250만원 이상인 사원들의 사원명, 급여 조회
select emp_name, salary from employee where emp_name like '%하%' and salary >= 2500000;

--4. department테이블에서 해외 영업부인 부서들의 부서코드, 부서명 조회
select dept_id, dept_title from department where dept_title like '해외영업%';

-- <is null/is not null>
-- 보너스를 받지 않는 사원의 사번, 사원명, 급여, 보너스 조회
--select emp_id, emp_name, salary, bonus from employee where bonus = null; (x)
select emp_id, emp_name, salary, bonus from employee where bonus is null;

-- 보너스를 받는 사원의 사번, 사원명, 급여, 보너스 조회 (not의 위치는 변동 가능)
select emp_id, emp_name, salary, bonus from employee where bonus is not null;
select emp_id, emp_name, salary, bonus from employee where not bonus is null;

-- 사수가 없는 사원들의 사번, 사원명, 사수번호 조회
select emp_id, emp_name, manager_id from employee where manager_id is null;

-- 부서배치를 받지 않았지만 보너스 받는 사원들의 사원명, 보너스, 부서코드 조회
select emp_name, bonus, dept_code from employee where dept_code is null and bonus is not null;

-- <in/not in>
-- 부서코드가 D5, D6, D8인 사원의 사원명, 부서코드, 급여 조회
select emp_name, dept_code, salary from employee where dept_code='D5' or dept_code='D6' or dept_code='D8';
select emp_name, dept_code, salary from employee where dept_code in ('D5', 'D6', 'D8');

/*
연산자 우선순위
1.()
2.산술연산자
3.연결연산자
4.비교연산자
5.is null/like '패턴'/in
6.between and
7.not(논리연산자)
8.and(논리연산자)
9.or(논리연산자)
*/

-- 직급코드가 J7이거나 J2인 사원들 중 급여가 200만원 이상인 사원들의 모든 컬럼 조회
select emp_name, job_code, salary from employee where job_code in ('J7', 'J2') and  salary >=2000000;
select emp_name, job_code, salary from employee where (job_code ='J7'or job_code = 'J2') and  salary >=2000000;
select emp_name, job_code, salary from employee where job_code ='J7' and salary >=2000000 or job_code = 'J2' and  salary >=2000000;

-- 1. 사수가 없고 부서배치도 받지 않는 사원들의 사원명, 사수사번, 부서코드 조회
select * from employee where manager_id is null and dept_code is null;

-- 2. 연봉(보너스 포함x)이 3000만원 이상이고 보너스를 받지 않은 사원들의 사번, 사원명, 급여, 보너스 조회
select * from employee where (salary*12) >= 30000000 and bonus is null;

-- 3. 입사일이 95/01/01 이상이고 부서배치를 받은 사원들의 사번, 사원명, 입사일, 부서코드 조회
select * from employee where hire_date >= '95/01/01' and dept_code is not null;

-- 4. 급여가 200만원 이상 500만원 이하고 입사일이 01/01/01 이상이고 보너스를 받지 않는 사원들의 사번, 사원명, 급여, 입사일, 보너스 조회
select * from employee where (salary between 2000000 and 5000000) and hire_date >= '01/01/01' and bonus is null; 

-- 5. 보너스 포함 연봉이 null이 아니고 이름에 '하'가 포함되어 있는 사원들의 사번, 사원명, 급여, 보너스포함 연봉 조회(별칭 부여)
select emp_id "사번", emp_name "사원명", salary "급여", (salary+bonus*salary)*12 "보너스포함 연봉" from employee where bonus is not null and emp_name like '%하%';

---------------------------------------------------------------------------------------------

/*
<order by 절> 정렬
select문 가장 마지막 줄에 작성, 실행 순서 또한 맨 마지막에 실행
[표현법]
select 컬럼1, 컬럼2, ... from where order by 정렬기준이 되는 컬럼명 | 별칭 | 컬럼순번 [asc | desc] | [nulls first | nulls last]

asc 오름차순(기본값)
desc 내림차순

nulls first 정렬하고자 하는 컬럼값에 null이 있는 경우 해당 데이터를 맨 앞에 배치(생략시 desc일 때는 기본값)
nulls last 정렬하고자 하는 컬럼값에 null이 있는 경우 해당 데이터를 맨 뒤에 배치(생략시 asc일 때는 기본값)
*/

-- 보너스로 정렬
select * from employee
-- order by bonus;  오름차순 기본값으로 null이 끝에 옴
-- order by bonus nulls first; null이 처음에 옴
-- order by bonus desc  내림차순 기본값으로 null이 맨 앞에 옴
-- order by bonus nulls last; null이 끝에 옴
order by bonus desc, salary asc; -- 보너스로 내림차순하지만 값이 같은 경우 급여를 기준으로 오름차순  

-- 전 사원의 사원명, 연봉조회(연봉의 내림차순 정렬 조회)
select * from employee order by (salary+(salary*bonus))*12 desc;