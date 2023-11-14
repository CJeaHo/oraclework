/*
<함수>
전달된 컬럼값을 읽어들여 함수를 실행한 결과 반환

- 단일행 함수: N개의 값을 읽어들여 N개의 결과값을 반환(매 행마다 함수 실행)
- 그룹 함수:  N개의 값을 읽어들여 1개의 결과값을 반환(그룹별로 함수 실행)

>> select절에 단일행 함수와 그룹 함수를 함께 사용 불가
>> 함수식을 기술할 수 있는 위치: select절, where절, order by절, having절

--------------------------------------------- 단일 행 함수 ----------------------------------------------
==================================================================================
                                                            <문자 처리 함수>
==================================================================================
*/

/*
length/lengthb => number로 반환
length(컬럼 | '문자열'): 해당 문자열의 글자수 반환
lengthb(컬럼 | '문자열'): 해당 문자열의 byte 반환
- 한글: XE 버전일 때 => 1글자당 3byte(ㄱ ㄴ ㄷ ㄹ ㅏ ㅑ ㅏ ㅕ 이런 것들도 1글자에 해당)
           EE 버전일 때 => 1글자당 2byte
- 그 외: 1글자당 1byte
*/

-- dual: 오라클에서 제공하는 가상 테이블
select length('오라클') || '글자' , lengthb('오라클') || 'byte' from dual; 

select length('oracle') || '글자' , lengthb('oracle') || 'byte' from dual; 

select length('ㅇㅗㄹㅏ') || '글자' , lengthb('ㅇㅗㄹㅏ') || 'byte' from dual;

select emp_name, length(emp_name) || '글자', lengthb(emp_name) || 'byte', email, length(email) || '글자', lengthb(email) || 'byte' from employee;

-------------------------------------------------------------------------단일 행 함수 --------------------------------------------------------------------------

/*
instr: 문자열로부터 특정 무낮의 시작위치(index)를 찾아서 반환(반환형 number)
>>oracle에서 index번호는 1부터 시작

instr(컬럼 | '문자열', '찾을 문자열', [찾을 위치의 시작값, [순번])
1: 앞에서부터 찾기(기본값)
-1: 뒤에서부터 찾기
*/

select instr('javascriptjavaoracle', 'a') from dual; -- 결과: 2, 앞
select instr('javascriptjavaoracle', 'a', 1) from dual; -- 결과: 2, 앞
select instr('javascriptjavaoracle', 'a', -1) from dual; -- 결과: 17, 뒤
select instr('javascriptjavaoracle', 'a', 1, 3) from dual; -- 결과: 12, 앞에서부터 3번째 a
select instr('javascriptjavaoracle', 'a', 3) from dual; -- 결과: 4, random
select instr('javascriptjavaoracle', 'a', -1, 2) from dual; -- 결과: 14, 뒤에서 2번째

-- 이메일 '_'위치, '@'위치 조회
select email, instr(email, '_') "_위치", instr(email, '@') "@위치" from employee;

------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
substr: 문자열에서 특정 문자열을 추출할여 반환(character)

substr('문자열', position, [length])
- position: 문자열을 추출할 시작 위치 index
- length: 추출할 문자개수(생략시 맨마지막까지 추출)
*/

select substr('oraclehtmlcss', 7) from dual; -- 출력: htmlcss
select substr('oraclehtmlcss', 7, 4) from dual; -- 출력: html
select substr('oraclehtmlcss', 1, 6) from dual; -- 출력: oracle
select substr('oraclehtmlcss', -7, 4) from dual; -- 출력: html(index가 음수이면 뒤에서부터 센다)

-- 주민번호에서 성별만 추출하여 주민번호, 사원명 성별을 조회
select  emp_name, emp_no, substr(emp_no, 8, 1) 성별 from employee;

-- 여자사원들만 사번, 사원명, 성별을 조회
select emp_id, emp_name, emp_no || '여' from employee where substr(emp_no, 8, 1)  = 2;
select emp_id, emp_name, emp_no || '여' from employee where substr(emp_no, 8, 1)  = 4;

-- 남자사원들만 사번, 사원명, 성별을 조회
select emp_id, emp_name, emp_no || '남' from employee where substr(emp_no, 8, 1) in (1, 3);

-- 사원명, 이메일 아이디(@표시 앞까지만) 조회
select emp_name, substr(email, 1, instr(email, '@')-1) from employee;

---------------------------------------------------------------------------------------------------------------------------------------------------------

/*
lpad/rpad: 문자열을 조회할 때 통일감 있게 조회하고자 할 때 (character: 반환형)

lpad/rpad('문자열', 최종적으로 반환할 문자의 길이, [덧붙이고자하는 문자])
문자열에 덧붙이고자하는 문자를 왼쪽 혹은 오른쪽에 덧붙여서 최종 기이만큼의 문자열 반환
*/

-- email을 20길이로 오른쪽 정렬로 출력
select emp_name, lpad(email, 20, '#') from employee;

-- email을 20길이로 왼쪽 정렬로 출력
select emp_name, rpad(email, 20, '#') from employee;

-- 사번, 사원명, 주민번호를 123456-1******의 형식으로 출력
select emp_id, emp_name, rpad(substr(emp_no, 1, 8), 14, '*') 주민번호 from employee;
select emp_id, emp_name, substr(emp_no, 1, 8) || '******' as 주민번호 from employee;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
ltrim/rtrim: 문자열에서 특정 문자를 제거한 나머지 문자 반환(character: 반환형)
trim: 문자열의 앞(l)/ 뒤(r) 양쪽에 있는 지정한 문자를 제거한 나머지 문자 반환
>> 제거할 문자(공백 포함) 해당안되는 부분을 만나면 그 뒤는 제거 안함(문자열 가운데 공백은 제거 불가)

[표현법]
ltrim/rtrim('문자열', [제거하고자하는 문자열]) 
trim([leading 앞 | trailing 뒤 | both 양쪽] 제거하고자하는 문자열 from '문자열')  

*/

-- 가운데 공백은 제거 안함
select ltrim('     A  I      E                ') || '에드인에듀' from dual;

-- 문자열 제거
select ltrim('javajavascriptspring', 'java') from dual; 

-- 제거시 무작위로 제거할 문자 해당되면 제거하나 해당안되는 문자열 뒤에 있으면 삭제 안함
select ltrim('bcabacbdfgiabc', 'abc') from dual; 
select ltrim('fbcabacbdfgiabc', 'abc') from dual;
select ltrim('751841798jhdflg52l3h51l','0123456789') from dual;
select rtrim('bcabacbdfgiabc', 'abc') from dual; 
select rtrim('bcabacbdfgiabcf', 'abc') from dual;
select rtrim('751841798jhdflg52l3h512759','0123456789') from dual;

-- 앞뒤 양쪽 모두 제거
select trim('           A   I     E   ') || '에드인에듀' from dual;

-- 앞뒤 양쪽 문자열 제거
select trim('a' from 'aaaabbbaaaaaqpjrklnvpfqhwgu4t9216abaaabaababba') from dual;

-- 앞 문자열 제거
select trim(leading 'a' from 'aaaaaauqorpjaaaa') from dual;

-- 뒤 문자열 제거
select trim(trailing 'a' from 'aaaaaauqorpjaaaa') from dual;

-------------------------------------------------------------------------------------------------------------------------------------------------------

/*
lower/upper/initcap: 문자열을 대/소문자로 혹은 단어의 앞글자만 대문자로 변환

[표현법]
lower/upper/initcap('영문자열')
*/

select lower('Java JavaScript Oracle') from dual;
select upper('Java JavaScript Oracle') from dual;
select initcap('java javascript oracle') from dual;

------------------------------------------------------------------------------------------------------------------------------------------------------

/*
concat: 문자열 두개를 하나로 합친 결과 반환
>> 2개만 가능

[표현법]
concat('문자열', '문자열')
*/

select concat('ora', 'cle') from dual;
select 'ora' || 'cle' from dual;

-- 문자열 2개를 초과할 시
select concat('ora', 'cle', '배우자') from dual; -- (x)
select 'ora' || 'cle' || '배우자' from dual; -- (o)

------------------------------------------------------------------------------------------------------------------------------------------------------
/*
replace: 기존 문자열을 새로운 문자열로 바꿈

[표현법]
replace('문자열', '바뀔 문자열', '바꿀 문자열')
*/

-- 바뀌지만 조회시 보여지는 것만 바뀌고 기존 내용은 안바뀜
select emp_name, email, replace(email, 'kh.or.kr', 'aie.or.kr') from employee;

--==================================================================================--
                                                            --<숫자 처리 함수>--
--==================================================================================--

/*
abs: 절대값을 구하는 함수

[표현법]
abs(number)
*/

select abs(-10) from dual;
select abs(-3.14) from dual;
/*
mod: 두 수를 나눈 나머지값 반환

[표현법]
mod(number, number)
*/

select mod(10, 3) from dual;
select mod(10.9, 2) from dual; -- 잘 사용안함

/*
round: 반올림한 결과 반화
>> 양수, 음수 상관없이 반올림 그대로
[표현법]
round(number, [위치]) 위치 생략시 기본값으로 0 (소수점 첫째자리에서 1의 자리 반올림 = 정수만 남음)
*/

select round(1234.56) from dual;
select round(1234.56, 1) from dual; -- 소수점 첫째자리까지 반올림
select round(1234.56, -1) from dual; --10의 자리까지 반올림
select round(-1234.56) from dual;
select round(-1234.56, 1) from dual; -- 소수점 첫째자리까지 반올림
select round(-1234.56, -1) from dual; --10의 자리까지 반올림

------------------------------------------------------------------------------------------------------------------------------------------

/*
ceil: 올림한 결과 반환
>> 음수일 경우 내리는게 올림
>> 무조건  위치는 0으로 고정(소수 첫째자리에서 1의 자리 올림)
[표현법]
ceil(number) 
*/

select ceil(123.456) from dual;
select ceil(-123.456) from dual; 

/*
floor: 내림한 결과 반환
>> 음수일 경우 올리는게 내림
>> 무조건  위치는 0으로 고정(소수 첫째자리에서 1의 자리 내림)
[표현법]
floor(number) 
*/

select floor(123.456) from dual;
select floor(-123.456) from dual; 

/*
trunc: 위치 지정 가능한 버림처리 함수
>> 양수, 음수 상관없이 그대로 버림

[표현법]
trunc(number, [위치])  위치 생략시 기본값으로 0 (소수점 버림 = 정수만 남음)
*/

select trunc(123.456) from dual;
select trunc(123.456, 1) from dual;  -- 소수점 첫째자리까지는 남고 나머지 버림
select trunc(123.456, -1) from dual; -- 10의 자리까지는 남고 나머지 버림
select trunc(-123.456) from dual;
select trunc(-123.456, 1) from dual;  -- 소수점 첫째자리까지는 남고 나머지 버림
select trunc(-123.456, -1) from dual; -- 10의 자리까지는 남고 나머지 버림

--==================================================================================--
                                                            --<날짜 처리 함수>--
--==================================================================================--

/*
sysdate: 오늘 시스템 날짜와 시간 반환
>> 조회값 조정 가능
*/

select sysdate from dual;

------------------------------------------------------------------------------------------------------------------------------------------------

/*
month_between(date1, date2): 두 날짜 사이의 개월 수 반환
*/

-- 근무일수 조회
select emp_name, hire_date, ceil(sysdate - hire_date) 근무일수 from employee; 

-- 근무개월수 조회
select emp_name, hire_date, round(months_between(sysdate, hire_date)) 근무개월수 from employee; 
select emp_name, hire_date, round(months_between(sysdate, hire_date)) || '개월차' 근무개월수 from employee; 
select emp_name, hire_date, concat(round(months_between(sysdate, hire_date)), '개월차') 근무개월수 from employee;

/*
add_months(date, number): 특정날짜에 해당 숫자만큼의 개월 수를 더해 그 날짜 반환
*/

select add_months(sysdate, 1) from dual;

-- 사원명, 입사일, 입사후 정직원된 날짜(6개월 후) 조회
select emp_name, hire_date, add_months(hire_date, 6) "정직원된 날짜" from employee;

------------------------------------------------------------------------------------------------------------------------------------------------

/*
next_day(date, 요일(문자 | 숫자)): 특정 날짜 이후에 가까운 해당 요일의 날짜를 반환
*/

select sysdate, next_day(sysdate, '월요일') from dual;
select sysdate, next_day(sysdate, '월') from dual;

-- 1 ~ 7: 일요일 ~ 토요일 
select sysdate, next_day(sysdate, 2) from dual;

-- 현재 언어에 맞게
select sysdate, next_day(sysdate, 'monday') from dual; -- 한국인데 영어 x
-- 언어 변경 후 
alter session set nls_language = american;
select sysdate, next_day(sysdate, 'monday') from dual; -- (o) 
select sysdate, next_day(sysdate, '월') from dual; -- (x)

alter session set nls_language = korean;

------------------------------------------------------------------------------------------------------------------------------------------------

/*
last_day(date): 해당 월의 마지막 날짜 반환
*/

select last_day(sysdate) from dual;

-- 사원명, 입사일, 입사한 달의 마지막 날짜 조회
select emp_name, hire_date, last_day(hire_date) from employee;

-- 사원명, 입사일, 입사한 달의 마지막 날짜, 입사한 달의 근무일수 조회
select emp_name, hire_date, last_day(hire_date), last_day(hire_date)-hire_date+1 "해당월 근무일수"  from employee;

------------------------------------------------------------------------------------------------------------------------------------------------

/*
extract: 특정 날짜로부터 년/월/일 값을 추출하여 반환하는 함수(반환형: number)

[표현법]
extract(year from date): 년도만 추출
extract(month from date): 월만 추출
extract(day from date): 일만 추출
*/

-- 사원명, 입사년도, 입사월, 입사일 조회
select emp_name, extract(year from hire_date) 입사년도, extract(month from hire_date) 입사월, extract(day from hire_date) 입사일 from employee
order by 입사년도, 입사월, 입사일; -- 별칭 달았으면 별칭으로 해도 된다 이 말이야

--==================================================================================--
                                                            --<형변환 함수>--
--==================================================================================--

/*
to_char: 숫자 또는 날짜의 값을 문자 타입으로 변환

[표현법]
to_char(숫자 | 날짜, [포맷])
포맷: 반환 결과를 특정 형식에 맞게 출력하도록 함
*/

-----------------------------------------------숫자 => 문자------------------------------------------------

/*
9: 해당 자리의 숫자를 의미
>> 값이 없을 경우 소수점 이상은 공백, 소수점 이하는 0으로 표시
0: 해당 자리의 숫자를의미
>> 값이 없을 경우 0표시, 숫자의 길이를 고정적으로 표시할 대 주로 사용
FM: 좌우 9로 치환된 소수점 이상의 공백 및 소수점 이하의 0을 제거
>> 해당 자리에 값이 없을 경우 자리차지하지 않음
*/

select to_char(1234)  from dual; -- =문자는 왼쪽
select 1234 "to_char(1234)" from dual; -- 숫자는 오른쪽

-- 9
select to_char(1234, '999999') from dual; -- 6자리 공간 차지, 빈칸 공백 출력: (XX)1234

-- 0
select to_char(1234, '000000') from dual; -- 6자리 공간 차지, 빈칸 0으로 출력: 001234

select to_char(1234, 'L999999') from dual; -- L(local) 현재 설정된 나라의 화폐단위(빈칸 공백으로 생략)
select to_char(1234, 'L999,999') from dual; -- ,(콤마)로 자리수 나눌 수 있다
select to_char(1234, 'L000000') from dual; -- L(local) 현재 설정된 나라의 화폐단위(빈칸 0)
select to_char(1234, 'L000,000') from dual; -- ,(콤마)로 자리수 나눌 수 있다
select to_char(1234, '$999999') from dual; -- $화폐
select to_char(1234, '$000000') from dual; -- $화폐

-- 사번, 이름, 급여(\1,111,111), 연봉(\111,111,111) 조회
select emp_id, emp_name, to_char(salary, 'L9,999,999') 급여, to_char(salary*12, 'L999,999,999') 연봉 from employee;

-- fm
select to_char(123.456, 'fm999990.999')"123.456", to_char(1234.56, 'fm9990.99')"1234.56", to_char(0.1000, 'fm9990.999') "0.1", to_char(0.1000, 'fm9990.00') "0.10", to_char(0.1000, 'fm9999.999') ".1" from dual;
-- (9이면 해당 자리는 나올필요 없다면 생략,0이면 해당 자리는 무조건 나오게, fm은 자리 차지x)

-----------------------------------------------날짜 => 문자------------------------------------------------

-- 시간
select to_char(sysdate, 'am hh:mi:ss') 한국날짜, to_char(sysdate, 'am hh:mi:ss', 'nls_date_language=american') 미국날짜 from dual;
select to_char(sysdate, 'am hh:mi:ss') from dual; -- 12시간 형식
select to_char(sysdate, 'am hh24:mi:ss') from dual; -- 24시간 형식

-- 날짜
select to_char(sysdate, 'yyyy-mm-dd day') from dual;
select to_char(sysdate, 'dl') from dual; -- yyyy-mm-dd day 과 같다
select to_char(sysdate, 'yy-mm-dd day') from dual;
select to_char(sysdate, 'mon, yyyy') from dual; -- 월, 년
select to_char(sysdate, 'yyyy"년 " mm"월 " dd "일" day') from dual; -- 날짜 사이사이 문자열 넣기 (")쌍따옴표로 입력

-- 사원명, 입사일(23-02-02), 입사일(2023년 2월 2일 금요일) 조회
select emp_name, to_char(hire_date, 'yy-mm-dd'), to_char(hire_date, 'yyyy"년 " mm"월 " dd "일" day') from employee;

/*
년도
yy: 무조건 앞에 '20'이 붙는다
rr: 50년을 기준으로 50보다 작으면 앞에 '20'을 붙이고 50보다 크면 앞에 '19'를 붙임
*/

select to_char(sysdate, 'yyyy'), to_char(sysdate, 'yy'), to_char(sysdate, 'rrrr'), to_char(sysdate, 'rr'), to_char(sysdate, 'year') from dual;

select to_char(hire_date, 'yyyy'), to_char(hire_date, 'rrrr') from employee;


-- 월
select to_char(sysdate, 'mm'),  -- 숫자로만
          to_char(sysdate, 'mon'),  -- 숫자 + 월
          to_char(sysdate, 'month'),  -- 숫자 + 월
          to_char(sysdate, 'rm') -- 로마자
from dual;


-- 일
select to_char(sysdate, 'dd'), -- 월 기준으로 몇일째
          to_char(sysdate, 'ddd'), -- 년 기준으로 몇일째
          to_char(sysdate, 'd') -- 주 기준(일요일)으로 몇일째
from dual;


-- 요일
select to_char(sysdate, 'day'), -- 월요일, 화요일,...
          to_char(sysdate, 'dy') -- 월, 화,...
from dual;

-----------------------------------------------문자(숫자) => 날짜------------------------------------------------

/*
to_date: 숫자 또는 문자 타입을 날짜타입으로 변환

[표현법]
to_char(숫자 | 문자, [포맷])
*/

select to_date(20231110) from dual;
select to_date(231110) from dual;

-- 맨 앞이 0이면 문자타입으로 해야한다. 숫자 형태로 넣을때 앞이 0이면 오류
select to_date('011110') from dual;

select to_date('070407 020830','yymmdd hhmiss') from dual; -- 년월일만 출력
select to_char(to_date('070407 020830','yymmdd hhmiss'), 'yy-mm-dd hh:mi:ss') from dual; -- 년월일 시분초 출력

-- 도구 -> 환경설정 -> 데이터베이스 -> NLS -> 날짜 형식을 RR -> RRRR로 변경하면 4자리 년도로 출력
select to_date('041110','yymmdd'), to_date('981110', 'yymmdd') from dual; -- yy는 앞에 무조건 '20'이 붙는다
select to_date('041110','rrmmdd'), to_date('981110', 'rrmmdd') from dual; -- rr은 50보다 크고 작음으로 '20' 또는 '19'가 붙는다

-----------------------------------------------문자 => 숫자------------------------------------------------

/*
to_number: 문자 타입을 숫자 타입으로 변환

[표현법]
to_number(문자, [포맷])
*/

select to_number('021234567') from dual; -- 숫자일시 맨 앞 0은 생략
select '1000' + '5500' from dual; -- 연산이 들어가면 자동으로 숫자로 형변환
select to_number('1,000', '9,999,999') from dual; -- 포맷 형식에 맞게 문자도 변경해줘야 출력된다
select to_number('1,000,000', '9,999,999') from dual;
select to_number('1,000', '9,999,999') + to_number('1,000,000', '9,999,999') from dual;

--==================================================================================--
                                                            --<null 함수>--
--==================================================================================--

/*
nvl(컬럼, 해당컬럼이 null일 경우 반환될 값)
*/

select emp_name, nvl(bonus, 0) from employee;

-- 사원명, 보너스포함 연봉 조회
select emp_name, (salary+salary*nvl(bonus,0))*12 from employee;

select emp_name, nvl(dept_code, '부서 없음') from employee;

---------------------------------------------------------------------------------------------------------------------

/*
nvl2(컬럼, 반환값1, 반환값2)
- 컬럼값이 존재할 경우 반환값1
- 컬럼값이 null일 때 반환값2
*/

select emp_name, salary, bonus, salary*nvl2(bonus, 0.5, 0.1) from employee;

select emp_name, nvl2(dept_code, '부서 있음', '부서 없음') from employee;

---------------------------------------------------------------------------------------------------------------------

/*
nullif(비교대상1, 비교대상2)
- 두개의 값이 일치하면 null 반환
- 두개의 값이 일치하지 않으면 비교대상1 반환
*/

select nullif('1234', '1234') from dual;
select nullif('1234', '5678') from dual;

--==================================================================================--
                                                            --<선택 함수>--
--==================================================================================--

/*
decode(비교하고자하는 대상(컬럼 | 산술 연산 | 함수식), 비교값1, 결과값1, 비교값2, 결과값2,...)

switch(비교대상){
case 비교값1:
    결과값1;
case 비교값2:
    결과값2;
...
>> 오라클에서는 쓰지않으면 default처리된다
.*/

-- 사원명, 성별
select emp_name, decode(substr(emp_no, 8, 1), 1, '남자', 2, '여자') from employee;

-- 직원의 급여를 직급별로 인상해서 조회
-- J7이면 급여의 10% 인상
-- J6이면 급여의 15% 인상
-- J5이면 급여의 20% 인상
--  그 외 5% 인상
select emp_name, job_code, salary, decode(job_code, 'J7', salary+salary*0.1, 'J6', salary+salary*0.15, 'J5', salary+salary*0.2, salary+salary*0.05) "급여 인상" from employee;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
case when then
end

[표현문]
case when 조건식1 then 결과값1
        when 조건식2 then 결과값2
        ...
        else 결과값N
end
*/

-- 급여가 500만원 이상이면 '고급', 350만원 이상이면 '중급' 나머지는 '초급'
select case
when salary >= 5000000 then '고급' 
when salary >= 3500000 then '중급'
else '초급'
end 급수
from employee;

--==================================================================================--
                                                            --<그룹 함수>--
--==================================================================================--
-->> 단일 함수와 그룹 함수는 같이 쓸 수 없다


/*
sum(숫자타입의 컬럼): 해달컬럼값들의 합계를 반환
*/

-- 전 사원의 총 급여액 조회
select sum(salary) "총 급여액" from employee;

-- 남자 사원의 총 급여액 조회
select sum(salary) "남자사원의 총 급여액" from employee where substr(emp_no, 8, 1) in (1, 3);

-- 부서코드가 'D5'인 사원의 총 급여액 조회
select sum(salary) "D5사원 총 급여액" from employee where dept_code = 'D5';

-- 부서코드가 'D5'인 사원의 총 연봉 조회
select sum(salary*nvl(bonus,0)+salary) "D5사원 총 연봉" from employee where dept_code = 'D5';

-- 전 사원의 총 급여액 조회
-- 부서코드가 'D5'인 사원의 총 급여액 조회
select to_char(sum(salary), 'L999,999,999') "총 급여액" from employee;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
avg(숫자타입 컬럼): 해당 컬럼 값들의 평균을 반환
*/

-- 전 사원의 평균 급여액 조회
select round(avg(salary)) "평균 급여액" from employee;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
max(모든타입 컬럼): 해당 컬럼 값들 중 최대값 반환
min(모든타입 컬럼): 해당 컬럼 값들 중 최소값 반환
*/

-- 이름 중 가장 작은 값(사전순) 급여 중 가장 적게 받는 값, 입사일 중 가장 먼저 입사한 날짜
select min(emp_name), min(salary), min(hire_date) from employee; 
-->> 한 행이 아니라 다 다른 값들이 합쳐지는 것

-- 이름 중 가장 큰 값(사전순), 급여 중 가장 많이 받는 값
select max(emp_name), max(salary), max(hire_date) from employee; 

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
count(* | 컬럼 | distinct 컬럼): 행의 갯수 반환
count(*): 조회된 결과의 모든 행의 갯수 반환
count(컬럼): 제시한 컬럼의 null값을 제외한 행의 갯수 반환
count(distinct 컬럼): 해당 컬럼값 중복을 제거한 후의 행의 갯수 반환
*/

-- 전체 사원 수 조회
select count(*) from employee;

-- 여성 사원 수 조회
select count(*) from employee where substr(emp_no, 8, 1) in (2,4);

-- 보너스를 받는 사원 수 조회
select count(bonus) from employee ;

-- 부서 배치를 받은 사원 수 조회
select count(dept_code) from employee;

-- 현재 사원들이 총 몇개의 부서에 배치되었는지 조회
select count(distinct dept_code) from employee;





