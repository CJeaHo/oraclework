/*
group by 절: 어떠한 그룹을 기준으로 제시할 수 있는 구문(여러 그룹기준별로 여러 그룹으로 묶을 수 있음)
여러개의 값들을 하나의 그룹으로 묶어서 처리할 수 있음
*/

-- 총 급여 조회
select sum(salary) from employee;

-- 부서별 총 급여합 조회
select dept_code, sum(salary) from employee group by dept_code;

-- 각 부서별 사원수 조회
select dept_code, count(*) from employee group by dept_code;

-- 각 부서별 급여 합계와 사원수 조회
select dept_code, sum(salary), count(*) from employee group by dept_code order by dept_code;

-- 각 직급별 급여 합계와 사원수를 직급별 내림차순으로 조회
select job_code, sum(salary), count(*) from employee group by job_code order by job_code;

-- 각 직급별 총 사원수, 보너스를 받는 사원수, 급여 총합, 평균급여, 최저급여, 최고급여 조회(직급별 오름차순)
select job_code, count(*), count(bonus), sum(salary), round(avg(salary)), min(salary),  max(salary) from employee group by job_code order by job_code;

-- group by절에 함수식도 기술 가능
-- 여성별 남성별의 사원 수
select decode(substr(emp_no, 8, 1),'1', '남', '2', '여', '3', '남', '4', '여'), count(*) from employee group by substr(emp_no, 8, 1);

-- 부서코두, 직급코드 별 사원수, 급여 합
select dept_code, job_code, count(*), sum(salary) from employee group by dept_code, job_code order by 1;

----------------------------------------------------------------------------------------------------------------------------------------------------

/*
having: 그룹에 대한 조건을 제시할 때 사용되는 구문(주로 그룹함수식을 가지고 조건을 제시할 때 사용)
*/

-- 각 부서별 평균 급여 조회(부서코드, 평균급여)
select dept_code, avg(salary) from employee group by dept_code;

-- 각 부서별 평균 급여가 300만원 이상인 부서만 조회
-- 그룹 함수가 있는 구문에 where절은 허가되지 않는다
--select dept_code, ceil(avg(salary)) from employee where avg(salary) >= 3000000 group by  dept_code; 

select dept_code, ceil(avg(salary)) from employee group by dept_code having avg(salary) >= 3000000;

-- 직급별 총 급여액(단, 직급별 급여합이 1000만원 이상인 직급만 조회) - 직급코드, 급여합
select job_code, sum(salary) from employee group by job_code having sum(salary)>=10000000; 

-- 부서별 보너스를 받는 사원이 없는 부서만 부서코드 조회 - 부서코드, 사원수
select dept_code, count(bonus) from employee group by dept_code having count(bonus) = 0;

----------------------------------------------------------------------------------------------------------------------------------------------------

/*
집계 함수: 그룹별 산출된 결과 값에 중간 집계를 계산해 주는 함수
roll up, cube
=> group by절에 기술하는 함수
- rollup(컬럼1, 컬럼2): 컬럼1을 가지고 다시 중간집계를 내는 함수
- cube(컬럼1, 컬럼2): 컬럼1을 가지고 다시 중간집계를 내고 컬럼2를 가지고 다시 중간 집계를 내는 함수
*/

-- 컬럼이 하나일 때는 집계 함수가 필요 없다.
select job_code, sum(salary) from employee group by job_code order by 1;
select job_code, sum(salary) from employee group by cube(job_code) order by 1;

-- roll up, cube
select dept_code, job_code, sum(salary) from employee group by dept_code, job_code order by 1;
-- dept_code로 그룹맺어 나온 급여합 + 그 그룹 안에서 또 job_code로 그룹을 맺어 급여합, 총 합 출력
select dept_code, job_code, sum(salary) from employee group by rollup(dept_code, job_code) order by 1; 
-- dept_code로 그룹맺어 나온 급여합 + 그 그룹 안에서 또 job_code로 그룹 맺어 나온 급여합, job_code 그룹으로 나온 급여합, 총 합 출력
select dept_code, job_code, sum(salary) from employee group by cube(dept_code, job_code) order by 1; 

----------------------------------------------------------------------------------------------------------------------------------------------------

/*
집합 연산자 == set operation
여러개의 쿼리문을 가지고 하나의 쿼리문으로 만드는 연산자
>> 두 구문의 조회할 컬럼의 갯수와 컬럼명이 같아야한다

- union: or | 합집합(두 쿼리문을 수행한 결과값을 더한 후 중복되는 값은 한번만 더해준다)
- intersect: and | 교집합(두 쿼리문을 수행한 결과값의 중복된 결과값)
- union all: 합집합+ 교집합(중복값은 두번 표현됨)
- minus: 차집합(첫번째 집합에서 두번째 잡합의 값을 뺀 나머지)
*/


-- 부서코드가 D5인 사원 또는 급여가 300만원 초과인 사원을 조회
select * from employee where dept_code = 'D5' ; --6명
select * from employee where salary>3000000; -- 8명

-- union(or)
select * from employee where dept_code = 'D5' union select * from employee where salary>3000000;  -- 12명
select * from employee where dept_code = 'D5' or salary>3000000;  -- 12명

-- intersect(and)
select * from employee where dept_code = 'D5' intersect select * from employee where salary>3000000;  -- 2명
select * from employee where dept_code = 'D5' and salary>3000000;  -- 2명

-- union all
select * from employee where dept_code = 'D5' union all select * from employee where salary>3000000;  -- 14명

-- minus
select * from employee where dept_code = 'D5' minus select * from employee where salary>3000000;  -- 4명
select * from employee where dept_code = 'D5' and salary <=3000000;  -- 4명
select * from employee where salary>3000000 minus select * from employee where dept_code = 'D5';  -- 6명
select * from employee where dept_code != 'D5' and salary>3000000;  -- 6명