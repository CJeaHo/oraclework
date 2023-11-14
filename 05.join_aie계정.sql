 /*
 join: 2개 이상의 테이블에서 데이터를 조회하고자 할 때 사용되는 구문
 조회 결과 하나의 결과물(result set)로 나옴
 
관계형 데이터베이스로 최소한 데이터로 각각 테이블에 담고 있음
(중복을 최소화하기 위해 최대한 나눠서 관리)

=> 관계형 데이터베이스에서 sql문을 이용한 테이블간의 "관계"를 맺는 방법
join은 크기 "오라클 전용 구문"과 "ANSI 구문" (ANSI = 미국 국립 표준 협회)

[용어 정리]
오라클 전용 구문                                       / ANSI

등가 조인(equal join)  ---------------------------------------------------------------
                                                              / 내부조인(inner join) => join using()/on
                                                              / 자연조인(natural join) => join using
포괄 조인(외부조인 outer join) ------------------------------------------------------
left outer                                               / 왼쪽 외부 조인(left outer join)
right outer                                             / 오른쪽 외부 조인(right outer join)
                                                             / 전체 외부 조인(full outer join)
--------------------------------------------------------------------------------------
자체 조인(self join)                                   / join on
비등가 조인(non equal join)                      / join on
--------------------------------------------------------------------------------------
교차 조인(카테시안 곱 cartesian product)  / join on
 */
 
-- 전체 사원들의 사번, 사원명, 부서코드, 부서명을 조회
 select emp_id, emp_name, dept_code from employee;
 
 select dept_id, dept_title from department;
 
 ----------------------------------------------------------------------------------------------------------------------
 /*
 1. 등가 조인(equal join / inner join)
 연결시키고자 하는 컬럼 값이 "일치하는 행"들만 조인되어 조회(=일치하는 값이 없으면 조회에서 제외)
 
 오라클 전용
 
 from에 조회하고자하는 테이블들을 나열((,)쉼표 구분자로)
 where절에 매칭시킬 컬럼(연결고리)에 대한 조건 제시
 */
 
-- 1) 연결할 두 컬럼명이 다른 경우(employee에선 dept_code, department에선 dept_id)

-- 전체 사원들의 사번, 사원명, 부서코드, 부서명을 조회
select emp_id, emp_name, dept_code, dept_title from employee, department where dept_code = dept_id; -- 일치하는 값이 없는 행은 조회에서 제외(null값 제외)
 
-- 2) 연결할 두 칼럼명이 같은 경우(employee에선 job_code, job에도 job_code)

-- 전체 사원들의 사번, 사원명, 직급코드, 직급명 조회
-- 오류: 열의 정의가 애매하다
select emp_id, emp_name, job_code, job_name from employee, job where job_code = job_code; 

-- 해결 1.테이블명을 그대로 이용하는 방법(컬럼에도 붙여줘야하며 employee.job_code를 하든 job.job_code를 하든 결과는 같다. 즉, 조인되는 테이블명 아무거나 사용)
select emp_id, emp_name, employee.job_code, job_name from employee, job where employee.job_code = job.job_code; 

-- 해결 2. 테이블명에 별칭을 붙여 이용하는 방법(컬럼에도 붙여줘야하며 .job_code를 하든 j.job_code를 하든 결과는 같다. 즉, 조인되는 별칭 아무거나 사용)
select emp_id, emp_name, e.job_code, job_name from employee e, job j where e.job_code = j.job_code; 

-- >> ANSI 구문으로

/*
from에 기준이되는 테이블을 하나만 기술
join절에 같이 조회하고자하는 테이블을 기술 + 매칭시킬 컬럼에 대한 조건도 기술
- join using(), join on
*/

-- 1) 연결할 두 컬럼명이 다른 경우(employee에선 dept_code, department에선 dept_id)-> join on으로만 사용 가능

-- 전체 사원들의 사번, 사원명, 부서코드, 부서명을 조회
select emp_id, emp_name, dept_code, dept_title from employee join department on dept_code = dept_id;

-- 2) 연결할 두 칼럼명이 같은 경우(employee에선 job_code, job에도 job_code)-> join on, join using 사용 가능

-- 전체 사원들의 사번, 사원명, 직급코드, 직급명 조회
-- 오류: 열의 정의가 애매하다
select emp_id, emp_name, job_code, job_name from employee join job on job_code = job_code; 

-- 해결 1. 테이블명이나 별칭을 붙여 이용하는 방법(컬럼에도 붙여줘야하고 조인되는 테이블명이나 별칭 아무거나 사용)
select emp_id, emp_name, e.job_code, job_name from employee e join job j on e.job_code = j.job_code;

-- 해결 2. join using구문을 사용하는 방법(두 컬럼명이 일치할 때만 사용 가능)
select emp_id, emp_name, job_code, job_name from employee join job using (job_code);

-- [참고사항]
-- 자연조인(natural join): 각 테이블마다 동일한 컬럼이 딱 하나만 존재할 경우
select emp_id, emp_name, job_code, job_name from employee natural join job;

-- 3) 추가적인 조건도 제시 가능
-- 직급이 '대리'인 사원의 사번, 사원명, 직급명, 급여 조회

-- >> 오라클 전용 구문
select emp_id, emp_name, job_name, salary from employee e, job j where e.job_code = j.job_code and  job_name = '대리'; 

-- >> ANSI 구문
select emp_id, emp_name, job_name, salary from employee join job using (job_code) where job_name = '대리'; 

--------------------------------------- <실습 문제>---------------------------------------------------------------------------
-- 1. 부서가 인사관리부인 사원의 사번, 이름, 부서명, 보너스 조회
-- >> 오라클 구문 전용
select emp_id, emp_name, dept_title, bonus from employee, department where dept_code = dept_id and dept_title = '인사관리부';

-- >> ANSI 구문
select emp_id, emp_name, dept_title, bonus from employee join department on dept_code = dept_id and dept_title = '인사관리부';

-- 2. DEPARTMENT와 LOCATION을 참고하여 전체 부서의 부서코드, 부서명, 지역코드, 지역명 조회
-- >> 오라클 구문 전용
select dept_id, dept_title, local_code, local_name from department, location where location_id = local_code;

-- >> ANSI 구문
select dept_id, dept_title, local_code, local_name from department join location on location_id = local_code;

-- 3. 보너스를 받는 사원들의 사번, 사원명, 보너스, 부서명 조회
-- >> 오라클 구문 전용
select emp_id, emp_name, bonus, dept_title from employee, department where dept_id = dept_code and bonus is not null;

-- >> ANSI 구문
select emp_id, emp_name, bonus, dept_title from employee join department on dept_id = dept_code and bonus is not null;

-- 4. 부서가 총무부가 아닌 사원들의 사원명, 급여, 부서명 조회
-- >> 오라클 구문 전용
select emp_name, salary, dept_title from employee, department where dept_id = dept_code and dept_title != '총무부';

-- >> ANSI 구문
select emp_name, salary, dept_title from employee join department on dept_id = dept_code and dept_title != '총무부';

-------------------------------------------------------------------------------------------------------------------------------------------

/*
 2. 포괄 조인(외부 조인 outer join)
 두 테이블간의 join시 일치하지 않는 행도 null 값도 포함시켜 조회
 단, 반드시 left/right를 지정해야됨(기준이 되는 테이블을 지정)
 그래서 기준되는 테이블이 다르므로 left/right 값이 다르다
*/

-- 사원명, 부서명, 급여, 연봉
select emp_name, dept_title, salary, salary*12 from employee join department on dept_code = dept_id;

-- 1) left [outer] join: 두 테이블 중 왼쪽에 기술된 테이블을 기준으로 join
-- >> 오라클 전용 구문(기준이 안되는 테이블에 (+)를 붙임)
select emp_name, dept_title, salary, salary*12 from employee join department on dept_code = dept_id(+); --23

-->> ANSI 구문
select emp_name, dept_title, salary, salary*12 from employee left join department on dept_code = dept_id; --23

-- 2) right [outer] join: 두 테이블 중 오른쪽에 기술된 테이블을 기준으로 join
-- >> 오라클 전용 구문(기준이 안되는 테이블에 (+)를 붙임)
select emp_name, dept_title, salary, salary*12 from employee join department on dept_code(+) = dept_id; --24

-->> ANSI 구문
select emp_name, dept_title, salary, salary*12 from employee right join department on dept_code = dept_id; --24

-- 3) full [outer] join: 두 테이블에 기술된 모든행을 조회(기준이 없고 오라클 전용 구문이 없다)
-->> ANSI 구문
select emp_name, dept_title, salary, salary*12 from employee full join department on dept_code = dept_id; --26

-------------------------------------------------------------------------------------------------------------------------------------------

/*
 3. 비등가 조인(non equal join)
 매칭시킬 컬럼에 대한 조건 작성시 '='(등호)를 사용하지 않는 join문
 ANSI 구문으로는 join on만 가능
*/

-- 사원명, 급여, 급여레벨 조회
-- >> 오라클 전용 구문
select emp_name, salary, sal_level from employee, sal_grade where salary >= min_sal and salary <=max_sal;
select emp_name, salary, sal_level from employee, sal_grade where salary between min_sal and max_sal;

-- >> ANSI 구문
select emp_name, salary, sal_level from employee join sal_grade on (salary between min_sal and max_sal);

-------------------------------------------------------------------------------------------------------------------------------------------

/*
 4. 자체 조인(self join)
 같은 테이블을 다시 한번 조인하는 경우
 null값을 넣으려면 포괄 조인과 같이
*/

-- 사수가 있는 사원의 사번, 사원명,  직급코드 => employee
-- 사수의 사번, 사원명, 직급코드 => employee
-- >> 오라클 전용 구문
select e.emp_id, e.emp_name, e.dept_code, m.emp_id, m.emp_name, m.dept_code from employee e, employee m where e.manager_id = m.emp_id;

-- >> ANSI 구문
select e.emp_id, e.emp_name, e.dept_code, m.emp_id, m.emp_name, m.dept_code from employee e join employee m on e.manager_id = m.emp_id;

-- 사수가 없어도 출력되게 하시오
-- >> 오라클 전용 구문
select e.emp_id, e.emp_name, e.dept_code, m.emp_id, m.emp_name, m.dept_code from employee e, employee m where e.manager_id = m.emp_id(+);

-- >> ANSI 구문
select e.emp_id, e.emp_name, e.dept_code, m.emp_id, m.emp_name, m.dept_code from employee e left join employee m on e.manager_id = m.emp_id;

-------------------------------------------------------------------------------------------------------------------------------------------

/*
 5. 다중 조인(multi join)
 2개 이상의 테이블을 join
*/

-- 가져올 컬럼명                              | 조인될 컬럼명
-- employee -> emp_id, emp_name,| dept_code, job_code
-- department ->          dept_title,   | dept_id, d
-- job ->                        job_name,  |                  job_code                   

-- >> 오라클 전용 구문
select emp_id, emp_name, dept_title, job_name from employee e, department d, job j where dept_code = dept_id and e.job_code = j.job_code;

-- >> ANSI 구문
select emp_id, emp_name, dept_title, job_name from employee join department on dept_code = dept_id join job using(job_code);

-- 사원의 사번, 사원명, 부서명, 지역명 조회
-- >> 오라클 전용 구문
select emp_id, emp_name, dept_title, local_name from employee, department, location where dept_code = dept_id and location_id = local_code;

-- >> ANSI 구문
select emp_id, emp_name, dept_title, local_name from employee join department on dept_code = dept_id join location on location_id = local_code;

----------------------------------------------------------------- <실습 문제>---------------------------------------------------------------------------

-- 1. 사번, 사원명, 부서명, 지역명, 국가명 조회(employee, department, location, national 조인)
-- >> 오라클 전용 구문
select emp_id 사번, emp_name 사원명, dept_title 부서명, local_name 지역명, national_name 국가명 
from employee, department, location l, national n 
where dept_code = dept_id 
and location_id = local_code
and l.national_code = n.national_code;

-- >> ANSI 구문
select emp_id 사번, emp_name 사원명, dept_title 부서명, local_name 지역명, national_name 국가명 
from employee 
join department on dept_code = dept_id 
join location on  location_id = local_code 
join national using(national_code);

-- 2. 사번, 사원명, 부서명, 직급명, 지역명, 국가명, 급여등급 조회(모든 테이블 다 조인)
-- >> 오라클 전용 구문
select emp_id 사번, emp_name 사원명, dept_title 부서명, job_name 직급명, local_name 지역명, national_name 국가명, sal_level 급여등급
from employee e, department, job j, location l, national n, sal_grade
where dept_code = dept_id
and location_id = local_code  
and e.job_code = j.job_code
and l.national_code = n.national_code 
and salary between min_sal and max_sal;

-- >> ANSI 구문
select emp_id 사번, emp_name 사원명, dept_title 부서명, job_name 직급명, local_name 지역명, national_name 국가명, sal_level 급여등급
from employee
join department on dept_code = dept_id
join job using(job_code)
join location on location_id = local_code
join national using(national_code)
join sal_grade on (salary between min_sal and max_sal);













