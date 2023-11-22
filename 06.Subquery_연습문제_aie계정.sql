------------------------------------ 연습문제----------------------------------------------------------------------------------------------------------------------------------------
-- 1. 70년대 생(1970~1979) 중 여자이면서 전씨인 사원의 이름과, 주민번호, 부서명, 직급 조회  
select emp_name, emp_no, dept_title, job_name from employee
join department on dept_code = dept_id
join job using(job_code)
where (substr(emp_no, 1, 2) between 70 and 79) and substr(emp_no, 8, 1) in (2, 4) and emp_name like '전%'; 

-- 2. 나이가 가장 막내의 사원 코드, 사원 명, 나이, 부서 명, 직급 명 조회
select emp_id, emp_name, extract(year from sysdate) - to_number('19' || substr(emp_no, 1, 2)) 나이, dept_title, job_name from employee
join department on dept_code = dept_id
join job using(job_code)
where (extract(year from sysdate) - to_number('19' || substr(emp_no, 1, 2))) = (select min(extract(year from sysdate) - to_number('19' || substr(emp_no, 1, 2))) from employee);

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

-- 8. 하정연과 같은 부서에서 일하는 사원의 이름 조회
select emp_name from employee where dept_code = (select dept_code from employee where emp_name = '하정연');

-- 9. 보너스가 없고 직급 코드가 J4이거나 J7인 사원의 이름, 직급, 급여 조회 (NVL 이용)
select emp_name, job_name, salary from employee
join job using(job_code)
where bonus is null and job_code in ('J4', 'J7');

-- 10. 퇴사 하지 않은 사람과 퇴사한 사람의 수 조회
select count(end_date), count(decode(end_date, null, 1)) from employee;

-- 11. 보너스 포함한 연봉이 높은 5명의 사번, 이름, 부서 명, 직급, 입사일, 순위 조회
select * 
from (select emp_id, 
                   emp_name,
                   dept_title,
                   job_name, 
                   hire_date,
                   salary *  (1 + nvl(bonus, 1) ) * 12 연봉,
                   rank() over(order by salary *  (1 + nvl(bonus, 1) ) * 12 desc) 연봉순위 
                   from employee
                   join department on dept_id = dept_code
                   join job using (job_code)) 
where 연봉순위 <= 5;

select * 
from (select emp_id, 
                   emp_name,
                   dept_title,
                   job_name, 
                   hire_date,
                   salary * nvl(1 + bonus, 1) * 12 연봉,
                   rank() over(order by (salary * nvl(1 + bonus, 1) * 12) desc) 연봉순위 
                   from employee
                   join department on dept_id = dept_code
                   join job using (job_code)) 
where 연봉순위 <= 5;

-- 12. 부서 별 급여 합계가 전체 급여 총 합의 20%보다 많은 부서의 부서 명, 부서 별 급여 합계 조회
--	    12-1. JOIN과 HAVING 사용                
select sum(salary), dept_code, dept_title from employee
join department on dept_code = dept_id
group by dept_code, dept_title having sum(salary) > (select sum(salary) from employee) * 0.2; 

--	    12-2. 인라인 뷰 사용      
--     12-2-1
select * from 
(select sum(salary), dept_code, dept_title 
from employee
join department on dept_code = dept_id
group by dept_code, dept_title 
having sum(salary) > (select sum(salary) from employee) * 0.2);  

--     12-2-2
select * from 
(select sum(salary) 부서급여합, dept_code, dept_title 
from employee
join department on dept_code = dept_id
group by dept_code, dept_title)
where 부서급여합 > (select sum(salary) from employee) * 0.2;  

--	    12-3. WITH 사용
--	    12-3-1
with w as (select sum(salary), dept_code, dept_title from employee
join department on dept_code = dept_id
group by dept_code, dept_title having sum(salary) > (select sum(salary) from employee) * 0.2)
select *
from w;

--	    12-3-2
with w as (select sum(salary) 부서급여합, dept_code, dept_title from employee
join department on dept_code = dept_id group by dept_code, dept_title)
select *
from w
where 부서급여합 > (select sum(salary) from employee) * 0.2;

-- 13. 부서 명과 부서 별 급여 합계 조회
select sum(salary), dept_title, dept_code from employee
join department on dept_code = dept_id
group by dept_code, dept_title;

-- 14. WITH를 이용하여 급여 합과 급여 평균 조회
with w as (select sum(salary), round(avg(salary)) from employee)
select *
from w;