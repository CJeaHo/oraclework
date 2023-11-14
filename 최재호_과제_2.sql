
--15. EMPLOYEE테이블에서 사원 명과 직원의 주민번호를 이용하여 생년, 생월, 생일 조회
select emp_name, to_date(substr(emp_no,1,6),'rrmmdd') from employee;

--16. EMPLOYEE테이블에서 사원명, 주민번호 조회 (단, 주민번호는 생년월일만 보이게 하고, '-'다음 값은 '*'로 바꾸기)
select emp_name, substr(emp_no, 1, 7) || '********' from employee;

--17. EMPLOYEE테이블에서 사원명, 입사일-오늘, 오늘-입사일 조회 (단, 각 별칭은 근무일수1, 근무일수2가 되도록 하고 모두 정수(내림), 양수가 되도록 처리)
select emp_name, abs(ceil(hire_date-sysdate)), floor(sysdate-hire_date) from employee; 

--18. EMPLOYEE테이블에서 사번이 홀수인 직원들의 정보 모두 조회
select * from employee where mod(emp_id, 2) = 1;

--19. EMPLOYEE테이블에서 근무 년수가 20년 이상인 직원 정보 조회
select * from employee where extract(year from sysdate)-extract(year from hire_date) >= 20;

--20. EMPLOYEE 테이블에서 사원명, 급여 조회 (단, 급여는 '\9,000,000' 형식으로 표시)
select emp_name 사원명, to_char(salary, 'L9,999,999') 급여 from employee;

--21. EMPLOYEE테이블에서 직원 명, 부서코드, 생년월일, 나이 조회 (단, 생년월일은 주민번호에서 추출해서 00년 00월 00일로 출력되게 하며 나이는 주민번호에서 출력해서 날짜데이터로 변환한 다음 계산)
select emp_name "직원 명", emp_id 부서코드, 19 || to_char(to_date(substr(emp_no, 1, 6), 'yymmdd'), 'yy"년" mm"월" dd"일"') 생년월일, trunc((sysdate - to_date(substr(emp_no, 1, 6), 'rrmmdd')) / 365.25) 나이 from employee;
select emp_name "직원 명", emp_id 부서코드, 19 || substr(emp_no, 1, 2) || '년' || substr(emp_no, 3, 2) || '월' || substr(emp_no, 5, 2) || '일' 생년월일, extract(year from sysdate) - extract(year from to_date(substr(emp_no, 1, 2), 'rrrr')) 나이 from employee;

--23. EMPLOYEE테이블에서 사번이 201번인 사원명, 주민번호 앞자리, 주민번호 뒷자리, 주민번호 앞자리와 뒷자리의 합 조회
select emp_name 사원명, substr(emp_no, 1, 6) "주민번호 앞자리", substr(emp_no, 8, 14) "주민번호 뒷자리" , substr(emp_no, 1, 6) + substr(emp_no, 8, 14) "주민번호 앞자리와 뒷자리의 합" from employee where emp_id = 201;

--24. employee테이블에서 부서코드가 D5인 직원의 보너스 포함 연봉 합 조회
select sum(salary*nvl(bonus,0)+salary) "D5사원 총 연봉" from employee where dept_code = 'D5';

--25. 직원들의 입사일로부터 년도만 가지고 각 년도별 입사 인원수 조회
select substr(hire_date, 1, 4), count(substr(hire_date, 1, 4)) from employee group by substr(hire_date, 1, 4) having substr(hire_date, 1, 4) in (2001, 2002, 2003, 2004);

-- 섞어 쓸 수 있다 (decode, case when then  등)
select count(*) 전체직원수, 
count(case when extract(year from hire_date) = 2001 then 1 end) "2001년",
count(decode(extract(year from hire_date), '2002', 1)) "2002년",
count(case when(substr(hire_date, 1, 4)) = 2003 then 1 end ) "2003년",
count(decode(to_char(hire_date, 'yyyy'), '2004', 1)) "2004년"
from employee;



















