/*
<함수>
전달된 컬럼값을 읽어들여 함수를 실행한 결과 반환

- 단일행 함수: N개의 값을 읽어들여 N개의 결과값을 반환(매 행마다 함수 실행)
- 그룹 함수:  N개의 값을 읽어들여 1개의 결과값을 반환(그룹별로 함수 실행)

>> SELECT절에 단일행 함수와 그룹 함수를 함께 사용 불가
>> 함수식을 기술할 수 있는 위치: SELECT절, where절, order by절, havINg절

--------------------------------------------- 단일 행 함수 ----------------------------------------------
==================================================================================
                                                            <문자 처리 함수>
==================================================================================
*/

/*
length/lengthb => NUMBER로 반환
length(컬럼 | '문자열'): 해당 문자열의 글자수 반환
lengthb(컬럼 | '문자열'): 해당 문자열의 byte 반환
- 한글: XE 버전일 때 => 1글자당 3byte(ㄱ ㄴ ㄷ ㄹ ㅏ ㅑ ㅏ ㅕ 이런 것들도 1글자에 해당)
           EE 버전일 때 => 1글자당 2byte
- 그 외: 1글자당 1byte
*/

-- dual: 오라클에서 제공하는 가상 테이블
SELECT length('오라클') || '글자' , lengthb('오라클') || 'byte' FROM dual; 

SELECT length('oracle') || '글자' , lengthb('oracle') || 'byte' FROM dual; 

SELECT length('ㅇㅗㄹㅏ') || '글자' , lengthb('ㅇㅗㄹㅏ') || 'byte' FROM dual;

SELECT emp_name, length(emp_name) || '글자', lengthb(emp_name) || 'byte', email, length(email) || '글자', lengthb(email) || 'byte' FROM employee;

-------------------------------------------------------------------------단일 행 함수 --------------------------------------------------------------------------

/*
INSTR: 문자열로부터 특정 무낮의 시작위치(INdex)를 찾아서 반환(반환형 NUMBER)
>>oracle에서 INdex번호는 1부터 시작

INSTR(컬럼 | '문자열', '찾을 문자열', [찾을 위치의 시작값, [순번])
1: 앞에서부터 찾기(기본값)
-1: 뒤에서부터 찾기
*/

SELECT INSTR('javascriptjavaoracle', 'a') FROM dual; -- 결과: 2, 앞

SELECT INSTR('javascriptjavaoracle', 'a', 1) FROM dual; -- 결과: 2, 앞
SELECT INSTR('javascriptjavaoracle', 'a', -1) FROM dual; -- 결과: 17, 뒤
SELECT INSTR('javascriptjavaoracle', 'a', 1, 3) FROM dual; -- 결과: 12, 앞에서부터 3번째 a
SELECT INSTR('javascriptjavaoracle', 'a', 3) FROM dual; -- 결과: 4, random
SELECT INSTR('javascriptjavaoracle', 'a', -1, 2) FROM dual; -- 결과: 14, 뒤에서 2번째

-- 이메일 '_'위치, '@'위치 조회
SELECT email, INSTR(email, '_') "_위치", INSTR(email, '@') "@위치" FROM employee;

------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
SUBSTR: 문자열에서 특정 문자열을 추출할여 반환(character)

SUBSTR('문자열', position, [length])
- position: 문자열을 추출할 시작 위치 INdex
- length: 추출할 문자개수(생략시 맨마지막까지 추출)
*/

SELECT SUBSTR('oraclehtmlcss', 7) FROM dual; -- 출력: htmlcss
SELECT SUBSTR('oraclehtmlcss', 7, 4) FROM dual; -- 출력: html
SELECT SUBSTR('oraclehtmlcss', 1, 6) FROM dual; -- 출력: oracle
SELECT SUBSTR('oraclehtmlcss', -7, 4) FROM dual; -- 출력: html(INdex가 음수이면 뒤에서부터 센다)

-- 주민번호에서 성별만 추출하여 주민번호, 사원명 성별을 조회
SELECT  emp_name, emp_no, SUBSTR(emp_no, 8, 1) 성별 FROM employee;

-- 여자사원들만 사번, 사원명, 성별을 조회
SELECT emp_id, emp_name, emp_no || '여' FROM employee where SUBSTR(emp_no, 8, 1)  = 2;
SELECT emp_id, emp_name, emp_no || '여' FROM employee where SUBSTR(emp_no, 8, 1)  = 4;

-- 남자사원들만 사번, 사원명, 성별을 조회
SELECT emp_id, emp_name, emp_no || '남' FROM employee where SUBSTR(emp_no, 8, 1) IN (1, 3);

-- 사원명, 이메일 아이디(@표시 앞까지만) 조회
SELECT emp_name, SUBSTR(email, 1, INSTR(email, '@')-1) FROM employee;

---------------------------------------------------------------------------------------------------------------------------------------------------------

/*
lpad/rpad: 문자열을 조회할 때 통일감 있게 조회하고자 할 때 (character: 반환형)

lpad/rpad('문자열', 최종적으로 반환할 문자의 길이, [덧붙이고자하는 문자])
문자열에 덧붙이고자하는 문자를 왼쪽 혹은 오른쪽에 덧붙여서 최종 기이만큼의 문자열 반환
*/

-- email을 20길이로 오른쪽 정렬로 출력
SELECT emp_name, lpad(email, 20, '#') FROM employee;

-- email을 20길이로 왼쪽 정렬로 출력
SELECT emp_name, rpad(email, 20, '#') FROM employee;

-- 사번, 사원명, 주민번호를 123456-1******의 형식으로 출력
SELECT emp_id, emp_name, rpad(SUBSTR(emp_no, 1, 8), 14, '*') 주민번호 FROM employee;
SELECT emp_id, emp_name, SUBSTR(emp_no, 1, 8) || '******' as 주민번호 FROM employee;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
ltrim/rtrim: 문자열에서 특정 문자를 제거한 나머지 문자 반환(character: 반환형)
trim: 문자열의 앞(l)/ 뒤(r) 양쪽에 있는 지정한 문자를 제거한 나머지 문자 반환
>> 제거할 문자(공백 포함) 해당안되는 부분을 만나면 그 뒤는 제거 안함(문자열 가운데 공백은 제거 불가)

[표현법]
ltrim/rtrim('문자열', [제거하고자하는 문자열]) 
trim([leadINg 앞 | trailINg 뒤 | both 양쪽] 제거하고자하는 문자열 FROM '문자열')  

*/

-- 가운데 공백은 제거 안함
SELECT ltrim('     A  I      E                ') || '에드인에듀' FROM dual;

-- 문자열 제거
SELECT ltrim('javajavascriptsprINg', 'java') FROM dual; 

-- 제거시 무작위로 제거할 문자 해당되면 제거하나 해당안되는 문자열 뒤에 있으면 삭제 안함
SELECT ltrim('bcabacbdfgiabc', 'abc') FROM dual; 
SELECT ltrim('fbcabacbdfgiabc', 'abc') FROM dual;
SELECT ltrim('751841798jhdflg52l3h51l','0123456789') FROM dual;
SELECT rtrim('bcabacbdfgiabc', 'abc') FROM dual; 
SELECT rtrim('bcabacbdfgiabcf', 'abc') FROM dual;
SELECT rtrim('751841798jhdflg52l3h512759','0123456789') FROM dual;

-- 앞뒤 양쪽 모두 제거
SELECT trim('           A   I     E   ') || '에드인에듀' FROM dual;

-- 앞뒤 양쪽 문자열 제거
SELECT trim('a' FROM 'aaaabbbaaaaaqpjrklnvpfqhwgu4t9216abaaabaababba') FROM dual;

-- 앞 문자열 제거
SELECT trim(leadINg 'a' FROM 'aaaaaauqorpjaaaa') FROM dual;

-- 뒤 문자열 제거
SELECT trim(trailINg 'a' FROM 'aaaaaauqorpjaaaa') FROM dual;

-------------------------------------------------------------------------------------------------------------------------------------------------------

/*
LOWER/UPPER/INITCAP: 문자열을 대/소문자로 혹은 단어의 앞글자만 대문자로 변환

[표현법]
LOWER/UPPER/INITCAP('영문자열')
*/

SELECT LOWER('Java JavaScript Oracle') FROM dual;
SELECT UPPER('Java JavaScript Oracle') FROM dual;
SELECT INITCAP('java javascript oracle') FROM dual;

------------------------------------------------------------------------------------------------------------------------------------------------------

/*
CONCAT: 문자열 두개를 하나로 합친 결과 반환
>> 2개만 가능

[표현법]
CONCAT('문자열', '문자열')
*/

SELECT CONCAT('ora', 'cle') FROM dual;
SELECT 'ora' || 'cle' FROM dual;

-- 문자열 2개를 초과할 시
SELECT CONCAT('ora', 'cle', '배우자') FROM dual; -- (x)
SELECT 'ora' || 'cle' || '배우자' FROM dual; -- (o)

------------------------------------------------------------------------------------------------------------------------------------------------------
/*
REPLACE: 기존 문자열을 새로운 문자열로 바꿈

[표현법]
REPLACE('문자열', '바뀔 문자열', '바꿀 문자열')
*/

-- 바뀌지만 조회시 보여지는 것만 바뀌고 기존 내용은 안바뀜
SELECT emp_name, email, REPLACE(email, 'kh.or.kr', 'aie.or.kr') FROM employee;

--==================================================================================--
                                                            --<숫자 처리 함수>--
--==================================================================================--

/*
ABS: 절대값을 구하는 함수

[표현법]
ABS(NUMBER)
*/

SELECT ABS(-10) FROM dual;
SELECT ABS(-3.14) FROM dual;
/*
mod: 두 수를 나눈 나머지값 반환

[표현법]
mod(NUMBER, NUMBER)
*/

SELECT mod(10, 3) FROM dual;
SELECT mod(10.9, 2) FROM dual; -- 잘 사용안함

/*
ROUND: 반올림한 결과 반화
>> 양수, 음수 상관없이 반올림 그대로
[표현법]
ROUND(NUMBER, [위치]) 위치 생략시 기본값으로 0 (소수점 첫째자리에서 1의 자리 반올림 = 정수만 남음)
*/

SELECT ROUND(1234.56) FROM dual;
SELECT ROUND(1234.56, 1) FROM dual; -- 소수점 첫째자리까지 반올림
SELECT ROUND(1234.56, -1) FROM dual; --10의 자리까지 반올림
SELECT ROUND(-1234.56) FROM dual;
SELECT ROUND(-1234.56, 1) FROM dual; -- 소수점 첫째자리까지 반올림
SELECT ROUND(-1234.56, -1) FROM dual; --10의 자리까지 반올림

------------------------------------------------------------------------------------------------------------------------------------------

/*
CEIL: 올림한 결과 반환
>> 음수일 경우 내리는게 올림
>> 무조건  위치는 0으로 고정(소수 첫째자리에서 1의 자리 올림)
[표현법]
CEIL(NUMBER) 
*/

SELECT CEIL(123.456) FROM dual;
SELECT CEIL(-123.456) FROM dual; 

/*
FLOOR: 내림한 결과 반환
>> 음수일 경우 올리는게 내림
>> 무조건  위치는 0으로 고정(소수 첫째자리에서 1의 자리 내림)
[표현법]
FLOOR(NUMBER) 
*/

SELECT FLOOR(123.456) FROM dual;
SELECT FLOOR(-123.456) FROM dual; 

/*
TRUNC: 위치 지정 가능한 버림처리 함수
>> 양수, 음수 상관없이 그대로 버림

[표현법]
TRUNC(NUMBER, [위치])  위치 생략시 기본값으로 0 (소수점 버림 = 정수만 남음)
*/

SELECT TRUNC(123.456) FROM dual;
SELECT TRUNC(123.456, 1) FROM dual;  -- 소수점 첫째자리까지는 남고 나머지 버림
SELECT TRUNC(123.456, -1) FROM dual; -- 10의 자리까지는 남고 나머지 버림
SELECT TRUNC(-123.456) FROM dual;
SELECT TRUNC(-123.456, 1) FROM dual;  -- 소수점 첫째자리까지는 남고 나머지 버림
SELECT TRUNC(-123.456, -1) FROM dual; -- 10의 자리까지는 남고 나머지 버림

--==================================================================================--
                                                            --<날짜 처리 함수>--
--==================================================================================--

/*
SYSDATE: 오늘 시스템 날짜와 시간 반환
>> 조회값 조정 가능
*/

SELECT SYSDATE FROM dual;

------------------------------------------------------------------------------------------------------------------------------------------------

/*
MONTH_BETWEEN(DATE1, DATE2): 두 날짜 사이의 개월 수 반환
*/

-- 근무일수 조회
SELECT emp_name, hire_date, CEIL(SYSDATE - hire_date) 근무일수 FROM employee; 

-- 근무개월수 조회
SELECT EMP_NAME, HIRE_DATE, ROUND(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) 근무개월수 FROM employee; 
SELECT EMP_NAME, HIRE_DATE, ROUND(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) || '개월차' 근무개월수 FROM employee; 
SELECT EMP_NAME, HIRE_DATE, CONCAT(ROUND(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)), '개월차') 근무개월수 FROM employee;

/*
ADD_MONTHS(DATE, NUMBER): 특정날짜에 해당 숫자만큼의 개월 수를 더해 그 날짜 반환
*/

SELECT ADD_MONTHS(SYSDATE, 1) FROM dual;

-- 사원명, 입사일, 입사후 정직원된 날짜(6개월 후) 조회
SELECT EMP_NAME, HIRE_DATE, ADD_MONTHS(HIRE_DATE, 6) "정직원된 날짜" FROM employee;

------------------------------------------------------------------------------------------------------------------------------------------------

/*
next_day(date, 요일(문자 | 숫자)): 특정 날짜 이후에 가까운 해당 요일의 날짜를 반환
*/

SELECT SYSDATE, next_day(SYSDATE, '월요일') FROM dual;
SELECT SYSDATE, next_day(SYSDATE, '월') FROM dual;

-- 1 ~ 7: 일요일 ~ 토요일 
SELECT SYSDATE, next_day(SYSDATE, 2) FROM dual;

-- 현재 언어에 맞게
SELECT SYSDATE, next_day(SYSDATE, 'monday') FROM dual; -- 한국인데 영어 x
-- 언어 변경 후 
alter session set nls_language = american;
SELECT SYSDATE, next_day(SYSDATE, 'monday') FROM dual; -- (o) 
SELECT SYSDATE, next_day(SYSDATE, '월') FROM dual; -- (x)

alter session set nls_language = korean;

------------------------------------------------------------------------------------------------------------------------------------------------

/*
last_day(date): 해당 월의 마지막 날짜 반환
*/

SELECT last_day(SYSDATE) FROM dual;

-- 사원명, 입사일, 입사한 달의 마지막 날짜 조회
SELECT emp_name, hire_date, last_day(hire_date) FROM employee;

-- 사원명, 입사일, 입사한 달의 마지막 날짜, 입사한 달의 근무일수 조회
SELECT emp_name, hire_date, last_day(hire_date), last_day(hire_date)-hire_date+1 "해당월 근무일수"  FROM employee;

------------------------------------------------------------------------------------------------------------------------------------------------

/*
extract: 특정 날짜로부터 년/월/일 값을 추출하여 반환하는 함수(반환형: NUMBER)

[표현법]
extract(year FROM date): 년도만 추출
extract(month FROM date): 월만 추출
extract(day FROM date): 일만 추출
*/

-- 사원명, 입사년도, 입사월, 입사일 조회
SELECT emp_name, extract(year FROM hire_date) 입사년도, extract(month FROM hire_date) 입사월, extract(day FROM hire_date) 입사일 FROM employee
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

SELECT to_char(1234)  FROM dual; -- =문자는 왼쪽
SELECT 1234 "to_char(1234)" FROM dual; -- 숫자는 오른쪽

-- 9
SELECT to_char(1234, '999999') FROM dual; -- 6자리 공간 차지, 빈칸 공백 출력: (XX)1234

-- 0
SELECT to_char(1234, '000000') FROM dual; -- 6자리 공간 차지, 빈칸 0으로 출력: 001234

SELECT to_char(1234, 'L999999') FROM dual; -- L(local) 현재 설정된 나라의 화폐단위(빈칸 공백으로 생략)
SELECT to_char(1234, 'L999,999') FROM dual; -- ,(콤마)로 자리수 나눌 수 있다
SELECT to_char(1234, 'L000000') FROM dual; -- L(local) 현재 설정된 나라의 화폐단위(빈칸 0)
SELECT to_char(1234, 'L000,000') FROM dual; -- ,(콤마)로 자리수 나눌 수 있다
SELECT to_char(1234, '$999999') FROM dual; -- $화폐
SELECT to_char(1234, '$000000') FROM dual; -- $화폐

-- 사번, 이름, 급여(\1,111,111), 연봉(\111,111,111) 조회
SELECT emp_id, emp_name, to_char(salary, 'L9,999,999') 급여, to_char(salary*12, 'L999,999,999') 연봉 FROM employee;

-- fm
SELECT to_char(123.456, 'fm999990.999')"123.456", to_char(1234.56, 'fm9990.99')"1234.56", to_char(0.1000, 'fm9990.999') "0.1", to_char(0.1000, 'fm9990.00') "0.10", to_char(0.1000, 'fm9999.999') ".1" FROM dual;
-- (9이면 해당 자리는 나올필요 없다면 생략,0이면 해당 자리는 무조건 나오게, fm은 자리 차지x)

-----------------------------------------------날짜 => 문자------------------------------------------------

-- 시간
SELECT to_char(SYSDATE, 'am hh:mi:ss') 한국날짜, to_char(SYSDATE, 'am hh:mi:ss', 'nls_date_language=american') 미국날짜 FROM dual;
SELECT to_char(SYSDATE, 'am hh:mi:ss') FROM dual; -- 12시간 형식
SELECT to_char(SYSDATE, 'am hh24:mi:ss') FROM dual; -- 24시간 형식

-- 날짜
SELECT to_char(SYSDATE, 'yyyy-mm-dd day') FROM dual;
SELECT to_char(SYSDATE, 'dl') FROM dual; -- yyyy-mm-dd day 과 같다
SELECT to_char(SYSDATE, 'yy-mm-dd day') FROM dual;
SELECT to_char(SYSDATE, 'mon, yyyy') FROM dual; -- 월, 년
SELECT to_char(SYSDATE, 'yyyy"년 " mm"월 " dd "일" day') FROM dual; -- 날짜 사이사이 문자열 넣기 (")쌍따옴표로 입력

-- 사원명, 입사일(23-02-02), 입사일(2023년 2월 2일 금요일) 조회
SELECT emp_name, to_char(hire_date, 'yy-mm-dd'), to_char(hire_date, 'yyyy"년 " mm"월 " dd "일" day') FROM employee;

/*
년도
yy: 무조건 앞에 '20'이 붙는다
rr: 50년을 기준으로 50보다 작으면 앞에 '20'을 붙이고 50보다 크면 앞에 '19'를 붙임
*/

SELECT to_char(SYSDATE, 'yyyy'), to_char(SYSDATE, 'yy'), to_char(SYSDATE, 'rrrr'), to_char(SYSDATE, 'rr'), to_char(SYSDATE, 'year') FROM dual;

SELECT to_char(hire_date, 'yyyy'), to_char(hire_date, 'rrrr') FROM employee;


-- 월
SELECT to_char(SYSDATE, 'mm'),  -- 숫자로만
          to_char(SYSDATE, 'mon'),  -- 숫자 + 월
          to_char(SYSDATE, 'month'),  -- 숫자 + 월
          to_char(SYSDATE, 'rm') -- 로마자
FROM dual;


-- 일
SELECT to_char(SYSDATE, 'dd'), -- 월 기준으로 몇일째
          to_char(SYSDATE, 'ddd'), -- 년 기준으로 몇일째
          to_char(SYSDATE, 'd') -- 주 기준(일요일)으로 몇일째
FROM dual;


-- 요일
SELECT to_char(SYSDATE, 'day'), -- 월요일, 화요일,...
          to_char(SYSDATE, 'dy') -- 월, 화,...
FROM dual;

-----------------------------------------------문자(숫자) => 날짜------------------------------------------------

/*
to_date: 숫자 또는 문자 타입을 날짜타입으로 변환

[표현법]
to_char(숫자 | 문자, [포맷])
*/

SELECT to_date(20231110) FROM dual;
SELECT to_date(231110) FROM dual;

-- 맨 앞이 0이면 문자타입으로 해야한다. 숫자 형태로 넣을때 앞이 0이면 오류
SELECT to_date('011110') FROM dual;

SELECT to_date('070407 020830','yymmdd hhmiss') FROM dual; -- 년월일만 출력
SELECT to_char(to_date('070407 020830','yymmdd hhmiss'), 'yy-mm-dd hh:mi:ss') FROM dual; -- 년월일 시분초 출력

-- 도구 -> 환경설정 -> 데이터베이스 -> NLS -> 날짜 형식을 RR -> RRRR로 변경하면 4자리 년도로 출력
SELECT to_date('041110','yymmdd'), to_date('981110', 'yymmdd') FROM dual; -- yy는 앞에 무조건 '20'이 붙는다
SELECT to_date('041110','rrmmdd'), to_date('981110', 'rrmmdd') FROM dual; -- rr은 50보다 크고 작음으로 '20' 또는 '19'가 붙는다

-----------------------------------------------문자 => 숫자------------------------------------------------

/*
to_NUMBER: 문자 타입을 숫자 타입으로 변환

[표현법]
to_NUMBER(문자, [포맷])
*/

SELECT to_NUMBER('021234567') FROM dual; -- 숫자일시 맨 앞 0은 생략
SELECT '1000' + '5500' FROM dual; -- 연산이 들어가면 자동으로 숫자로 형변환
SELECT to_NUMBER('1,000', '9,999,999') FROM dual; -- 포맷 형식에 맞게 문자도 변경해줘야 출력된다
SELECT to_NUMBER('1,000,000', '9,999,999') FROM dual;
SELECT to_NUMBER('1,000', '9,999,999') + to_NUMBER('1,000,000', '9,999,999') FROM dual;

--==================================================================================--
                                                            --<null 함수>--
--==================================================================================--

/*
nvl(컬럼, 해당컬럼이 null일 경우 반환될 값)
*/

SELECT emp_name, nvl(bonus, 0) FROM employee;

-- 사원명, 보너스포함 연봉 조회
SELECT emp_name, (salary+salary*nvl(bonus,0))*12 FROM employee;

SELECT emp_name, nvl(dept_code, '부서 없음') FROM employee;

---------------------------------------------------------------------------------------------------------------------

/*
nvl2(컬럼, 반환값1, 반환값2)
- 컬럼값이 존재할 경우 반환값1
- 컬럼값이 null일 때 반환값2
*/

SELECT emp_name, salary, bonus, salary*nvl2(bonus, 0.5, 0.1) FROM employee;

SELECT emp_name, nvl2(dept_code, '부서 있음', '부서 없음') FROM employee;

---------------------------------------------------------------------------------------------------------------------

/*
nullif(비교대상1, 비교대상2)
- 두개의 값이 일치하면 null 반환
- 두개의 값이 일치하지 않으면 비교대상1 반환
*/

SELECT nullif('1234', '1234') FROM dual;
SELECT nullif('1234', '5678') FROM dual;

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
SELECT emp_name, decode(SUBSTR(emp_no, 8, 1), 1, '남자', 2, '여자') FROM employee;

-- 직원의 급여를 직급별로 인상해서 조회
-- J7이면 급여의 10% 인상
-- J6이면 급여의 15% 인상
-- J5이면 급여의 20% 인상
--  그 외 5% 인상
SELECT emp_name, job_code, salary, decode(job_code, 'J7', salary+salary*0.1, 'J6', salary+salary*0.15, 'J5', salary+salary*0.2, salary+salary*0.05) "급여 인상" FROM employee;

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
SELECT case
when salary >= 5000000 then '고급' 
when salary >= 3500000 then '중급'
else '초급'
end 급수
FROM employee;

--==================================================================================--
                                                            --<그룹 함수>--
--==================================================================================--
-->> 단일 함수와 그룹 함수는 같이 쓸 수 없다


/*
sum(숫자타입의 컬럼): 해달컬럼값들의 합계를 반환
*/

-- 전 사원의 총 급여액 조회
SELECT sum(salary) "총 급여액" FROM employee;

-- 남자 사원의 총 급여액 조회
SELECT sum(salary) "남자사원의 총 급여액" FROM employee where SUBSTR(emp_no, 8, 1) IN (1, 3);

-- 부서코드가 'D5'인 사원의 총 급여액 조회
SELECT sum(salary) "D5사원 총 급여액" FROM employee where dept_code = 'D5';

-- 부서코드가 'D5'인 사원의 총 연봉 조회
SELECT sum(salary*nvl(bonus,0)+salary) "D5사원 총 연봉" FROM employee where dept_code = 'D5';

-- 전 사원의 총 급여액 조회
-- 부서코드가 'D5'인 사원의 총 급여액 조회
SELECT to_char(sum(salary), 'L999,999,999') "총 급여액" FROM employee;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
avg(숫자타입 컬럼): 해당 컬럼 값들의 평균을 반환
*/

-- 전 사원의 평균 급여액 조회
SELECT ROUND(avg(salary)) "평균 급여액" FROM employee;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
max(모든타입 컬럼): 해당 컬럼 값들 중 최대값 반환
mIN(모든타입 컬럼): 해당 컬럼 값들 중 최소값 반환
*/

-- 이름 중 가장 작은 값(사전순) 급여 중 가장 적게 받는 값, 입사일 중 가장 먼저 입사한 날짜
SELECT mIN(emp_name), mIN(salary), mIN(hire_date) FROM employee; 
-->> 한 행이 아니라 다 다른 값들이 합쳐지는 것

-- 이름 중 가장 큰 값(사전순), 급여 중 가장 많이 받는 값
SELECT max(emp_name), max(salary), max(hire_date) FROM employee; 

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
count(* | 컬럼 | distINct 컬럼): 행의 갯수 반환
count(*): 조회된 결과의 모든 행의 갯수 반환
count(컬럼): 제시한 컬럼의 null값을 제외한 행의 갯수 반환
count(distINct 컬럼): 해당 컬럼값 중복을 제거한 후의 행의 갯수 반환
*/

-- 전체 사원 수 조회
SELECT count(*) FROM employee;

-- 여성 사원 수 조회
SELECT count(*) FROM employee where SUBSTR(emp_no, 8, 1) IN (2,4);

-- 보너스를 받는 사원 수 조회
SELECT count(bonus) FROM employee ;

-- 부서 배치를 받은 사원 수 조회
SELECT count(dept_code) FROM employee;

-- 현재 사원들이 총 몇개의 부서에 배치되었는지 조회
SELECT count(distINct dept_code) FROM employee;





