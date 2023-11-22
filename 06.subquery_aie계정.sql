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

--------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
2. 다중행 서브쿼리(multi row subquery)
서브쿼리의 조회 결과값이 여러행일 때(여러행 1열)

다중 값 연산자
in, any

- in: 여러개의 결과값 중 한개라도 일치하는 값이 있을 경우
- any: 여러개의 결과값 중 "한개라도 크거나(>) 작을(<) 경우" 경우(여러개의 결과값 중 가장 작은 값보다 클 경우 | 가장 큰 값보다 작을 경우)
비교대상 >, (<) any (값1, 값2, 값3,...) = 비교대상 > , (<) 값1 or 비교대상 >, (<) 값2 or ....
- all: 서브쿼리의 값들 중 가장 큰(작은) 값보다 더 큰(작은) 값을 얻어올 때
비교대상 >, (<) all (값1, 값2, 값3,...) = 비교대상 > , (<) 값1 and 비교대상 >, (<) 값2 and ....
*/

-- 1) 조정연 또는 전지연과 같은 직급인 사원들의 사번, 사원명, 직급코드, 급여
--      1.1 조정연 또는 전지연이 어떤 직급인지 조회
select job_code from employee where emp_name in ('전지연', '조정연');

--      1.2 직급코드가 J3, J7인 사원의 사번, 사원명 직급코드, 급여 조회
select emp_id, emp_name, job_code, salary from employee where job_code in ('J3', 'J7');

--      1.3 1.1과 1.2를 합침
select emp_id, emp_name, e.job_code, salary from employee e, job j where e.job_code = j.job_code and e.job_code in (select job_code from employee where emp_name in ('조정연', '전지연')); 

-- 2) 대리 직급임에도 불구하고 과장직급의 급여보다 많이 받는 직원의 사번, 사원명, 직급, 급여조회 
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
                        
-- 단일행 서브쿼리로도 가능
select emp_id, emp_name, job_name, salary
from employee
join job using(job_code)
where job_name = '대리' 
and salary > (select min(salary)
                        from employee
                        join job using(job_code)
                        where job_name = '과장');
                        
-- 3) 차장 직급임에도 불구하고 과장직급의 급여보다 적게 받는 직원의 사번, 사원명, 직급, 급여조회                         
select emp_id, emp_name, job_name, salary 
from employee
join job using(job_code)
where job_name = '차장' 
and salary < any (select salary
                        from employee
                        join job using(job_code)
                        where job_name = '과장');                        

-- 단일행 서브쿼리
select emp_id, emp_name, job_name, salary 
from employee
join job using(job_code)
where job_name = '차장' 
and salary < (select max(salary)
                        from employee
                        join job using(job_code)
                        where job_name = '과장');                

-- 4) 과장 직급임에도 불구하고 차장 직급 사원들의 모든 급여보다 더 많이 받는 사원들의 사번, 사원명, 직급, 급여조회      
select emp_id, emp_name, job_name, salary 
from employee
join job using(job_code)
where job_name = '과장' 
and salary > all (select salary
                        from employee
                        join job using(job_code)
                        where job_name = '차장');    

select emp_id, emp_name, job_name, salary 
from employee
join job using(job_code)
where job_name = '과장' 
and salary > (select max(salary)
                        from employee
                        join job using(job_code)
                        where job_name = '차장');      

----------------------------------------------------------------------------------------------------------------------------------------
                       
/*
3. 다중열 서브쿼리(multi coloumn subquery)
서브쿼리의 조회 결과값이 여러열일 때(1행 여러열)
*/   

-- 1) 장정보 사원과 같은 부서코드, 같은 직급코드에 해당하는 사원들의 사번, 사원명, 부서코드 , 직급코드 조회 
--      1.1                   
select emp_id, emp_name, dept_code, job_code
from employee
where dept_code = (select dept_code from employee where emp_name = '장정보')
and job_code = (select job_code from employee where emp_name = '장정보');

--      1.2 다중열 서브쿼리(겹치는걸 하나로)
select emp_id, emp_name, dept_code, job_code
from employee
where (dept_code, job_code) = (select dept_code, job_code from employee where emp_name = '장정보');

-- 2) 지정보 사원과 같은 직급코드, 같은 사수를 가지고 잇는 사원들의 사번, 사원명, 직급코드, 사수번호 조회
select emp_id, emp_name, job_code, manager_id
from employee
where (job_code, manager_id) = (select job_code, manager_id from employee where emp_name = '지정보');

---------------------------------------------------------------------------------------------------------------------------------------- 

/*
4. 다중행 다중열 서브쿼리(multi coloumn multi row subquery)
서브쿼리의 조회 결과값이 여러행, 여러열일 때(여러행 여러열)
*/   

-- 1) 각 직급별 최소급여를 받는 사원의 사번, 이름, 직급코드, 급여 조회
--      1.1 각 직급별로 최소급여를 받는 사원의 직급코드, 최소급여 조회
--select emp_id, emp_name, job_code, salary
--from employee
--where job_code ='J5' and salary = 2200000 or job_code ='J6' and salary = 2000000 or ....;

--      1.2
--select emp_id, emp_name, job_code, salary
--from employee
--where job_code, salary = ('J5', 2200000) or job_code, salary = ('J6', 2200000) or ...;

--      1.3 다중행 다중열 서브쿼리
select emp_id, emp_name, job_code, salary
from employee
where (job_code, salary) in (select job_code, min(salary) 
                                          from employee 
                                          group by job_code);
                                          
-- 2) 각 부서별 최소급여를 받는 사원의 사번, 이름, 직급코드, 급여 조회
select emp_id, emp_name, dept_code, salary
from employee
where (dept_code, salary) in (select dept_code, min(salary) 
                                          from employee 
                                          group by dept_code);                                             

----------------------------------------------------------------------------------------------------------------------------------------

/*
5. 인라인 뷰(inline view)
from절에 서브쿼리 작성
서브쿼리를 수행한 결과를 마치 테이블처럼 사용

주 사용처:TOP/BOTTOM-N분석(상/하위 몇위만 가져오기)
* rownum: 오라클에서 제공해주는 컬럼, 조회된 순서대로 1부터 부여해줌
*/   

--  1) 사원들의 사번, 사원명, 보너스 포함연봉, 부서코드 조회
-- 조건 1. 보너스 포함 연봉이 null이 나오지 않도록
-- 조건 2. 보너스 포함 연봉이 3000만원 이상인 사원들만 조회

--      1.1 원래대로
select emp_id, emp_name, salary *  (1 + nvl(bonus, 1) ) * 12 연봉, dept_code 
from employee
where salary *  (1 + nvl(bonus, 1) ) * 12 >= 30000000;

--      1.2 인라인 뷰 방식
--select 연봉
--from 내가 만든 테이블(보너스 포함 연봉)
--where 조건2

select * -- 인라인 뷰에 없는 컬럼은 가져올 수 없다
from (select emp_id, emp_name, salary *  (1 + nvl(bonus, 1) ) * 12 연봉, dept_code 
         from employee)
where 연봉 >= 30000000;

-- 2) 전 직원 중 급여 가장 높은 상위 5위만 가져오기
--       2.1 순서가 뒤죽박죽
select *
from (select rownum, salary from employee)
where rownum <=5
order by salary desc;

--      2.2 먼저 정렬(order by)한 테이블을 만들고 그테이블에서 rownum을 부여
-- from에 있는 rownum그대로(순서대로가 아님)
select *
from (select rownum, salary from employee order by salary desc)
where rownum <=5;

-- rownum이 순서대로
select salary
from (select rownum, salary from employee order by salary desc)
where rownum <=5;

-- 3) 가장 최근에 입사한 사원 5명의 rownum, 사번, 사원명, 입사일 조회
select rownum, i.*
from (select emp_id, emp_name, hire_date from employee order by hire_date desc) i
where rownum <=5;

-- 4) 각 부서별 평균급여가 높은 3개 부서의 부서코드, 평균급여 조회
select rownum, i.*
from (select dept_code, ceil(avg(salary)) 평균급여 
         from employee 
         group by dept_code 
         order by 2 desc) i
where rownum <=3;

----------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
6. with
서브쿼리에 이름을 붙여주고 인라인 뷰로 사용시 서브쿼리의 이름으로 from절에 기술

- 장점
  - 같은 서브쿼리가 여러번 사용될 경우 중복 작성을 피할 수 있다
  - 실행속도도 빨라짐
*/   

with topn_sal1 as (select ceil(avg(salary)) 평균급여, dept_code from employee group by dept_code order by 평균급여 desc)
select *
from topn_sal1
where rownum <=5;

---------------------------------------------------------------------------------------------------------------------------------------------------

/*
7. 순위 함수(window function)
rank() over(정렬기준), dense_rank() over(정렬기준)

- rank() over(정렬기준): 동일한 순위 이후의 등수를 동일한 인원 수 만큼 건너뛰고 순위 계산
ex) 공동 1순위가 3명이면 그 다음 순위는 4위
- dense_rank() over(정렬기준): 동일한 순위가 있어도 다음 등수는 무조건 1씩 증가
ex) 공동 1순위가 3명이면 그 다음 순위는 2위

>> 두 함수 모두 select절에서만 사용 가능 >> 인라인 뷰와 같이 사용
*/

-- 1) 급여가 높은 순서대로 순위를 매겨서 사원명, 급여, 순위 조회
select emp_name, salary, rank() over(order by salary desc) 순위 from employee;
select emp_name, salary, dense_rank() over(order by salary desc) 순위 from employee;

-- 2) 급여가 상위 5위인 사원의 사원명, 급여, 순위 조회 
-- 인라인 뷰
select * from (select emp_name, salary, rank() over(order by salary desc) 순위 from employee)  where 순위 <= 5;

-- with
with w as (select emp_name, salary, rank() over(order by salary desc) 순위 from employee) 
select *
from w
where 순위 <= 5;










