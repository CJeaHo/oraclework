/*
서브쿼리(subquery)
하나의 sql문 안에 포함된 또 다른 select문
메인 sql문의 보조 역할을 하는 쿼리문
*/

-- 1) 박정보 사원과 같은 부서에 속한 사원들 조회
--      1.1 박정보 사원 부서코드 조회 > 'D9'
select dept_code from employee where emp_name = '박정보';
--      1.2 부서코드가 'D9'인 사원의 정보 조회
select emp_name from employee where dept_code = 'D9';
--      1.3 1.1과 1.2를 합침
select emp_name from employee where dept_code = (select dept_code from employee where emp_name = '박정보');

-- 전 직원의 편균 급여보다 더 많이 받는 사원의 사번, 사원명, 급여, 직급코드 조회
select emp_id, emp_name, salary, dept_code from employee where salary > (select avg(salary) from employee);

----------------------------------------------------------------------------------------------------------------------------------------

/*
서브쿼리의 구분
서브쿼리를 수행한 결과값이 몇 행 몇 열이냐에 따라 분류

- 단일행 서브쿼리: 서브쿼리의 조회 결과값이 오로지 1개일 때 (1행 1열)
- 다중행 서브쿼리: 서브쿼리의 조회 결과값이 여러 행일 때 (다중행 1열)
- 다중열 서브쿼리: 서브쿼리의 조회 결과값이 여러 열일 때 (1행 다중열)
- 다중행 다중열 서브쿼리: 서브쿼리의 조회 결과값이 여러 행 여러 열일 때(다중행 다중열)
>> 서브쿼리의 종류가 무엇이냐에따라 서브쿼리 앞에 붙는 연산자가 달라짐
*/

/*
1. 단일행 서브쿼리(single row subquery)
서브쿼리의 조회 결과값이 오로지 1개일 때(1행 1열)

일반 비교연산자 사용
=, !=, <>, >, < ...
*/

-- 1) 전 직원의 평균 급여보다 적게 받는 사원의 사원명, 급여 조회
select emp_name, salary from employee where salary < (select avg(salary) from employee) order by salary;

-- 2) 최저 급여를 받는 사원의 사원명, 급여 조회
select emp_name, salary from employee where salary = (select min(salary) from employee);

-- 3) 박정보 사원의 급여보다 더 많이 받는 사원의 사번, 사원명, 급여 조회
select emp_id, emp_name, salary from employee where salary > (select salary from employee where emp_name = '박정보');

-- join + subquery 이용
-- 4) 박정보 사원의 급여보다 더 많이 받는 사원의 사번, 사원명, 부서코드, 급여 조회
-- > 오라클 전용 구문
select emp_id, emp_name, dept_code, salary from employee, department where dept_code = dept_id and salary > (select salary from employee where emp_name = '박정보');

--> ANSI 구문
select emp_id, emp_name, dept_code, salary from employee join department on dept_code = dept_id and salary > (select salary from employee where emp_name = '박정보');

-- 5) 왕정보 사원과 같은 부서원들의 사번, 사원명, 전화번호, 부서명 조회 단, 왕정보는 제외
-- > 오라클 전용 구문
select emp_id, emp_name, phone, dept_title from employee, department where dept_code = dept_id and dept_code = (select dept_code from employee where emp_name = '왕정보') and emp_name <> '왕정보';

--> ANSI 구문
select emp_id, emp_name, phone, dept_title from employee join department on dept_code = dept_id and dept_code = (select dept_code from employee where emp_name = '왕정보') and emp_name != '왕정보';

-- group + subquery
-- 6) 부서별 급여합이 가장 큰 부서의 부서코드, 급여합 조회
--      6.1 부서별 합계 조회
select dept_code, sum(salary) 급여합 from employee group by dept_code order by 급여합 desc;
--      6.2 부서별 급여합 중 가장 큰 값 조회
select max(sum(salary)) from employee group by dept_code;

--      6.3 6.1의 값과 6.2의 값을 합침(부서별 급여합이 17,700,000인 부서 조회)
select dept_code, sum(salary) 급여합 from employee group by dept_code having sum(salary) = (select max(sum(salary)) from employee group by dept_code);

/*
2. 다중행 서브쿼리(single row subquery)
서브쿼리의 조회 결과값이 여러행일 때(여러행 1열)

다중 값 연산자
in, any

- in: 여러개의 결과값 중 한개라도 일치하는 값이 있을 경우
- >any: 여러개의 결과값 중 "한개라도 클" 경우(여러개의 결과값 중 가장 작은 값보다 클 경우)
비교대상 > any(값1, 값2, 값3,...)  비교대상 > 값1 or 비교대상 > 값2 or ....
- <any: 여러개의 결과값 중 "한개라도 작을" 경우(여러개의 결과값 중 가장 큰 값보다 작을 경우)
비교대상 < any(값1, 값2, 값3,...) 비교대상 < 값1 or 비교대상 < 값2 or ....
*/

-- 1) 조정연 또는 전지연과 같은 직급인 사원들의 사번, 사원명, 직급코드, 급여
--      1.1 조정연 또는 전지연이 어떤 직급인지 조회
select job_code from employee where emp_name in ('전지연', '조정연');

--      1.2 직급코드가 J3, J7인 사원의 사번, 사원명 직급코드, 급여 조회
select emp_id, emp_name, job_code, salary from employee where job_code in ('J3', 'J7');

--      1.3 1.1과 1.2를 합침
select emp_id, emp_name, e.job_code, salary from employee e, job j where e.job_code = j.job_code and e.job_code in (select job_code from employee where emp_name in ('조정연', '전지연')); 

-- 2) 대리 직급임에도 불구하고 과장직급의 급여 급여보다 많이 받는 직원의 사번, 사원명, 직급, 급여조회 
-- 대표 => 부사장 => 부장 => 차장 => 과장 => 대리 => 사원
--      2.1 과장 직급인 사원들의 최소 급여 조회
select emp_id, emp_name, job_name, salary 
from employee
join job using(job_code)
where job_name = '과장'; -- 2,200, 2,500, 3,760

--      2.2 직급이 대리이면서 급여가 위의 목록값 중에 하나라도 큰 사원
select salary 
from employee
join job using(job_code)
where job_name = '대리' 
and salary > any(2200000, 2500000, 3760000);

--      2.3 위의 식을 합친다
select emp_id, emp_name, job_name, salary 
from employee
join job using(job_code)
where job_name = '대리' 
and salary > any (select salary
                        from employee
                        join job using(job_code)
                        where job_name = '과장');
                        
------------------------------------ 연습문제
-- 1. 70년대 생(1970~1979) 중 여자이면서 전씨인 사원의 이름과, 주민번호, 부서명, 직급 조회  
select emp_name, emp_no, dept_title, job_name from employee
join department on dept_code = dept_id
join job using(job_code)
where (substr(emp_no, 1, 2) between 70 and 79) and substr(emp_no, 8, 1) in (2, 4) and emp_name like '전%'; 

-- 2. 나이가 가장 막내의 사원 코드, 사원 명, 나이, 부서 명, 직급 명 조회
select emp_id, emp_name, extract(year from sysdate) - '19' || substr(emp_no, 1, 2) 나이, dept_title, job_name from employee
join department on dept_code = dept_id
join job using(job_code)
where (extract(year from sysdate) - '19' || substr(emp_no, 1, 2)) = (select min(extract(year from sysdate) - '19' || substr(emp_no, 1, 2)) from employee);

-- 3. 이름에 ‘하’가 들어가는 사원의 사원 코드, 사원 명, 직급 조회
select emp_id, emp_name, job_name from employee
join job using(job_code)
where emp_name like '%하%';

-- 4. 부서 코드가 D5이거나 D6인 사원의 사원 명, 직급, 부서 코드, 부서 명 조회
select emp_name, job_name, dept_code, dept_title from employee
join department on dept_code = dept_id
join job using(job_code)
where dept_code in ('D5', 'D6');

-- 5. 보너스를 받는 사원의 사원 명, 보너스, 부서 명, 지역 명 조회
select emp_name, bonus, dept_title, local_name from employee
join department on dept_code = dept_id
join location on location_id = local_code
where bonus is not null;

-- 6. 사원 명, 직급, 부서 명, 지역 명 조회
select emp_name, job_name, dept_title, local_name from employee
join department on dept_code = dept_id
join job using(job_code)
join location on location_id = local_code;

-- 7. 한국이나 일본에서 근무 중인 사원의 사원 명, 부서 명, 지역 명, 국가 명 조회 
select emp_name, dept_title, local_name, national_name from employee
join department on dept_code = dept_id
join location on location_id = local_code
join national using(national_code)
where dept_code in (select dept_id from department where location_id in (select local_code from location where national_code in ('KO', 'JP')));

-- 8. 한 사원과 같은 부서에서 일하는 사원의 이름 조회
select emp_name from employee where dept_code = (select dept_code from employee where emp_name like '한%');

-- 9. 보너스가 없고 직급 코드가 J4이거나 J7인 사원의 이름, 직급, 급여 조회 (NVL 이용)
select emp_name, job_name, salary from employee
join job using(job_code)
where bonus is null and job_code in ('J4', 'J7');

-- 10. 퇴사 하지 않은 사람과 퇴사한 사람의 수 조회
select count(end_date), count(nvl(end_date, 1)) from employee;