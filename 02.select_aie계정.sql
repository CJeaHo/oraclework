--테이블의 컬럼의 정보 조회

/*
(')홀따옴표: 문자열일 때
(")쌍따옴표: 컬럼명일 때
*/

/*
SELECT: 데이터 조회할 때 사용
result set: SELECT문을 통해 조회된 결과물(조회된 행들의 집합)

[표현법]
SELECT 조회하려는 컬럼명1, 컬럼명2, ...
FROM 테이블명
*/

SELECT *
FROM EMPLOYEE;

SELECT *
FROM DEPARTMENT;

SELECT EMP_ID, EMP_NAME, PHONE 
FROM EMPLOYEE;

/*
<컬럼값을 통한 산술연산>
SELECT를 컬럼명 작성부분에 산술연산 기술 가능(이때 산술연산된 결과 조회)
*/BONUS

--EMPLOYEE에서 사원명, 사원의 연봉(급여*12)조회
SELECT EMP_NAME, BONUS*12 FROM EMPLOYEE;

SELECT EMP_NAME, BONUS, BONUS FROM EMPLOYEE;

--EMPLOYEE에서 사원명, 급여, 보너스, 연봉, 보너스를 포함한 연봉((급여+(보너스+급여)*12)
SELECT EMP_NAME, BONUS, , BONUS*12, (BONUS+(BONUS+BONUS)*12) FROM EMPLOYEE;

--산술 연산 중 NULL이 존재하면 결과는 무조건 NULL

--EMPLOYEE에서 사원명, 입사일, 근무일수(오늘날짜-입사일)
--date형끼리도 연산 가능, 결과값은 일 단위
--오늘 날짜: SYSDATE;
SELECT EMP_NAME, HIRE_DATE, SYSDATE-HIRE_DATE FROM EMPLOYEE;

--함수로 date날짜처리하면 초단위를 관리할 수 있음
-------------------------------------------------------------------------------

/*
컬럼명에 별칭 지정하기
산술연산의 산술에 들어간 수식 그대로 컬럼명이 됨, 이때 별칭을 부여하면 깔끔하게 처리

[표현볍]
컬럼명 별칭/ 컬럼명 AS 별칭/ 컬럼명 "별칭"/ 컬럼명 AS "별칭"
별칭에 띄어쓰기나 특수문자 포함되면 반드시 (")쌍따옴표를 넣어줘야 함;
*/

SELECT EMP_NAME 사원명, BONUS AS 급여, BONUS "보너스", BONUS*12 AS "연봉(원)", (BONUS+(BONUS+BONUS)*12) "총 소득"  FROM EMPLOYEE;

SELECT EMP_NAME 사원명, HIRE_DATE AS 입사일, SYSDATE-HIRE_DATE FROM EMPLOYEE;

/*
리터럴: 임의로 지정된 문자열(')
SELECT절에 리터럴을 제시하면 마치 테이블상에 존재하는 데이터처럼 조회가능
조회된 result set의 모든 행에 반복적으로 출력
*/

--EMPLOYEE에 사번, 사원명, 급여 원 AS 단위 조회
SELECT EMP_ID, EMP_NAME, BONUS, '원' AS "단위" FROM EMPLOYEE;

--------------------------------------------------------------

/*
연결 연산자: ||
여러 컬럼값들을 마치 하나의 컬럼값인 것처럼 연결하거나, 컬럼값과 리터럴을 연결할 수 있음
*/

-- EMPLOYEE에 사번, 사원명, 급여를 하나의 컬럼으로 조회
SELECT EMP_ID || EMP_NAME || BONUS "사원들의 아이디와 이름, 급여" FROM EMPLOYEE;

SELECT EMP_ID, EMP_NAME, BONUS || '원'  FROM EMPLOYEE;

-- 홍길동의 월급은 900000원입니다
SELECT EMP_NAME || '의 월급은' || BONUS || '원 입니다' FROM EMPLOYEE;

-- 홍길동의 전화번호는 PHONE이고 이메일은 EMAIL입니다
SELECT EMP_NAME || '의 전화번호는 ' || PHONE || '이고 이메일은 ' || EMAIL || '입니다' FROM EMPLOYEE;

/*
DISTINCT
컬럼의 중복된 값들을 한번씩만 표시하고자 할 때
*/

-- 중복 포함
SELECT JOB_CODE FROM EMPLOYEE;
SELECT DEPT_CODE FROM EMPLOYEE;

-- 중복 제외
SELECT DISTINCT JOB_CODE FROM EMPLOYEE;
SELECT DISTINCT DEPT_CODE FROM EMPLOYEE;

-- 2개를 조합해서 중복되는건 없지만 하나씩만 보면 중복된다(SELECT절에서 DISTINCT는 한번만 기술)
-- SELECT DISTINCT JOB_CODE, DISTINCT JOB_CODE FROM EMPLOYEE;(x)
SELECT DISTINCT JOB_CODE, JOB_CODE FROM EMPLOYEE;

/*
WHERE 
조회하고자하는 테이블에서 특정 조건에 만족하는 데이터만 조회할 때
<비교연산자> 비교하는 연산자
> ,<, >=, <= 대소비교
= 같은지 비교
!=, ^=, <> 다른지 비교

<논리연산자> 여러개의 조건을 묶어서 제시하고자 할 때
AND ~이면서, 그리고
OR ~이거나, 또는

<BETWEEN AND> ~이상 ~이하인 범위 조건을 제시할 때
비교대상 컬럼 BETWEEN 하한값 AND 상한값

<LIKE> 비교하고자하는 컬럼값이 내가 제시한 특정 패턴에 만족하는 경우 조회
비교대상 컬럼 LIKE '특정 패턴'
%: 0글자 이상
ex) 비교대상컬럼 LIKE '문자%' => 비교대상 컬럼값이 '문자'로 시작되는 것들을 조회: 문자, 문자+@
ex) 비교대상컬럼 LIKE '%문자' => 비교대상 컬럼값이 '문자'로 끝나는 것들을 조회: 문자, @+문자
ex) 비교대상컬럼 LIKE '%문자%' => 비교대상 컬럼값이 '문자'를 포함하는 것들을 조회: 문자, @+문자+@

_: N글자(한글자가 올 경우 '_문자', 두글자가 올 경우 '__문자' N글자가 올 경우 _를 N개 써서 붙인다)
ex) 비교대상컬럼 LIKE '_문자' => 비교대상 컬럼값의 '문자'앞에 무조건 한글자가 올 경우
ex) 비교대상컬럼 LIKE '문자_' => 비교대상 컬럼값의 문자'뒤'에 무조건 한글자가 올 경우
ex) 비교대상컬럼 LIKE '_문자_' => 비교대상 컬럼값의 문자'앞'과 '뒤'에 무조건 한글자가 올 경우

<IS NULL/IS NOT NULL>
컬럼에 NULL이 있는 경우 NULL값 비교에 사용되는 연산자

<IN/NOT IN>
IN 컬럼값이 내가 제시한 목록 중에 일치하는 값이 있는 것만 조회
NOT IN 컬럼값이 내가 제시한 목록 중에 일치하는 값을 제외한 나머지만 회
ex) 비교대상 컬럼 IN (값1, 값2,...)

[표현법]
SELECT 컬럼1, 컬럼2,... 산술연산,... FROM 테이블명 WHERE 조건식; (데이터는 대소문자 구분)
*/

-- <비교연산자>
-- EMPLOYEE에서 부서코드가 'D9'인 사원들의 모든 컬럼 조회
SELECT * FROM EMPLOYEE WHERE DEPT_CODE = 'D9';

-- EMPLOYEE에서 부서코드가 'D1'이 아닌 사원들의 사번, 사원명, 부서코드를 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE FROM EMPLOYEE WHERE DEPT_CODE <> 'D1';

-- EMPLOYEE에서 급여가 400만원 이상인 사원들의 사원명, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, BONUS FROM EMPLOYEE WHERE BONUS>=4000000;

-- EMPLOYEE에서 제직중인 사원의 사번, 사원명, 입사일 조회
SELECT EMP_ID, EMP_NAME, HIRE_DATE, ent_yn FROM EMPLOYEE WHERE ent_yn='N';

-- <논리연산자>
-- 부서코드가 'D9'이면서 급여가 500만원 이상인 사원들의 사원명, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, BONUS FROM EMPLOYEE WHERE DEPT_CODE = 'D9' AND BONUS >= 5000000;

-- 부서코드가 'D6'이거나 급여가 300만원 이상인 사원들의 사원명, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, BONUS FROM EMPLOYEE WHERE DEPT_CODE='D6' OR BONUS>=3000000;

-- 급여가 350만원 이상 600만원 이하인 사원의 사번, 사원명, 급여 조회
SELECT EMP_ID, EMP_NAME, BONUS FROM EMPLOYEE WHERE BONUS>=3500000 AND BONUS<=6000000; 

-- <BETWEEN A AND B>
-- 급여가 350만원 이상 600만원 이하인 사원의 사번, 사원명, 급여 조회
SELECT EMP_ID, EMP_NAME, BONUS FROM EMPLOYEE WHERE BONUS BETWEEN 3500000 AND 6000000; 

-- 급여가 350만원 이상 600만원 이하를 제외한 사원의 사번, 사원명, 급여 조회
SELECT EMP_ID, EMP_NAME, BONUS FROM EMPLOYEE WHERE not BONUS BETWEEN 3500000 AND 6000000; 

-- 입사일이 90/01/01 ~ 01/12/31 사이인 사원의 사번, 사원명, 입사일 조회
SELECT EMP_ID, EMP_NAME, HIRE_DATE FROM EMPLOYEE WHERE HIRE_DATE BETWEEN '90/01/01' AND '01/12/31';

-- <LIKE 특정 패턴>
-- 사원들 중 성이 '전 씨'인 사원의 사번, 사원명 조회
SELECT EMP_ID, EMP_NAME FROM EMPLOYEE WHERE EMP_NAME LIKE '전%';

-- 사원들 중 '하'가 포함되어있는 사원들의 사번, 사원명 조회
SELECT EMP_ID, EMP_NAME FROM EMPLOYEE WHERE EMP_NAME LIKE '%하%';

-- 사원들 중 이름 가운데가 '하'인 사원들의 사번, 사원명 조회
SELECT EMP_ID, EMP_NAME FROM EMPLOYEE WHERE EMP_NAME LIKE '_하_';

-- 전화번호 중 3번째 글자가 '1'인 사원의 사번, 사원명, 전화번호 조회
SELECT EMP_ID, EMP_NAME, PHONE FROM EMPLOYEE WHERE PHONE LIKE '__1%';

-- 이메일 중 _앞에 글자가 3글자인 사원들의 사번, 사원명, 이메일 조회
SELECT EMP_ID, EMP_NAME, EMAIL FROM EMPLOYEE WHERE EMAIL LIKE '____%';

-- 와일드 카드인지 데이터인지 구분을 해줘야한다
-- 데이터값으로 취급하고자하는 값앞에 나만의 와일드카드(아무거나 문자, 숫자, 특수문자(&제외))를 제시하고
-- 나만의 와일드카드를 escape로 등록해야함
SELECT EMP_ID, EMP_NAME, EMAIL FROM EMPLOYEE WHERE EMAIL LIKE '___$_%' escape '$';

-- 1. 이름이 '연'으로 끝나는 사원들의 사번, 사원명, 고용일 조회
SELECT EMP_ID, EMP_NAME, HIRE_DATE FROM EMPLOYEE WHERE EMP_NAME LIKE '%연';

-- 2. 전화번고 처음 3자리가 010이 아닌 사원들의 사원명, 전화번호 조회
SELECT EMP_NAME, PHONE FROM EMPLOYEE WHERE not PHONE LIKE '010%';

-- 3. 이름에 '하'가 포함되어 있고 급여가 250만원 이상인 사원들의 사원명, 급여 조회
SELECT EMP_NAME, BONUS FROM EMPLOYEE WHERE EMP_NAME LIKE '%하%' AND BONUS >= 2500000;

-- 4. DEPARTMENT테이블에서 해외 영업부인 부서들의 부서코드, 부서명 조회
SELECT dept_id, dept_title FROM DEPARTMENT WHERE dept_title LIKE '해외영업%';

-- <IS NULL/IS NOT NULL>
-- 보너스를 받지 않는 사원의 사번, 사원명, 급여, 보너스 조회
-- SELECT EMP_ID, EMP_NAME, BONUS, BONUS FROM EMPLOYEE WHERE BONUS = NULL; (x)
SELECT EMP_ID, EMP_NAME, BONUS, BONUS FROM EMPLOYEE WHERE BONUS IS NULL;

-- 보너스를 받는 사원의 사번, 사원명, 급여, 보너스 조회 (not의 위치는 변동 가능)
SELECT EMP_ID, EMP_NAME, BONUS, BONUS FROM EMPLOYEE WHERE BONUS IS NOT NULL;
SELECT EMP_ID, EMP_NAME, BONUS, BONUS FROM EMPLOYEE WHERE not BONUS IS NULL;

-- 사수가 없는 사원들의 사번, 사원명, 사수번호 조회
SELECT EMP_ID, EMP_NAME, manager_id FROM EMPLOYEE WHERE manager_id IS NULL;

-- 부서배치를 받지 않았지만 보너스 받는 사원들의 사원명, 보너스, 부서코드 조회
SELECT EMP_NAME, BONUS, DEPT_CODE FROM EMPLOYEE WHERE DEPT_CODE IS NULL AND BONUS IS NOT NULL;

-- <IN/NOT IN>
-- 부서코드가 D5, D6, D8인 사원의 사원명, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, BONUS FROM EMPLOYEE WHERE DEPT_CODE='D5' OR DEPT_CODE='D6' OR DEPT_CODE='D8';
SELECT EMP_NAME, DEPT_CODE, BONUS FROM EMPLOYEE WHERE DEPT_CODE IN ('D5', 'D6', 'D8');

/*
연산자 우선순위
1.()
2.산술연산자
3.연결연산자
4.비교연산자
5.IS NULL/LIKE '패턴'/IN
6.BETWEEN AND
7.not(논리연산자)
8.AND(논리연산자)
9.OR(논리연산자)
*/

-- 직급코드가 J7이거나 J2인 사원들 중 급여가 200만원 이상인 사원들의 모든 컬럼 조회
SELECT EMP_NAME, JOB_CODE, BONUS FROM EMPLOYEE WHERE JOB_CODE IN ('J7', 'J2') AND  BONUS >=2000000;
SELECT EMP_NAME, JOB_CODE, BONUS FROM EMPLOYEE WHERE (JOB_CODE ='J7'OR JOB_CODE = 'J2') AND  BONUS >=2000000;
SELECT EMP_NAME, JOB_CODE, BONUS FROM EMPLOYEE WHERE JOB_CODE ='J7' AND BONUS >=2000000 OR JOB_CODE = 'J2' AND  BONUS >=2000000;

-- 1. 사수가 없고 부서배치도 받지 않는 사원들의 사원명, 사수사번, 부서코드 조회
SELECT * FROM EMPLOYEE WHERE manager_id IS NULL AND DEPT_CODE IS NULL;

-- 2. 연봉(보너스 포함x)이 3000만원 이상이고 보너스를 받지 않은 사원들의 사번, 사원명, 급여, 보너스 조회
SELECT * FROM EMPLOYEE WHERE (BONUS*12) >= 30000000 AND BONUS IS NULL;

-- 3. 입사일이 95/01/01 이상이고 부서배치를 받은 사원들의 사번, 사원명, 입사일, 부서코드 조회
SELECT * FROM EMPLOYEE WHERE HIRE_DATE >= '95/01/01' AND DEPT_CODE IS NOT NULL;

-- 4. 급여가 200만원 이상 500만원 이하고 입사일이 01/01/01 이상이고 보너스를 받지 않는 사원들의 사번, 사원명, 급여, 입사일, 보너스 조회
SELECT * FROM EMPLOYEE WHERE (BONUS BETWEEN 2000000 AND 5000000) AND HIRE_DATE >= '01/01/01' AND BONUS IS NULL; 

-- 5. 보너스 포함 연봉이 NULL이 아니고 이름에 '하'가 포함되어 있는 사원들의 사번, 사원명, 급여, 보너스포함 연봉 조회(별칭 부여)
SELECT EMP_ID "사번", EMP_NAME "사원명", BONUS "급여", (BONUS+BONUS*BONUS)*12 "보너스포함 연봉" FROM EMPLOYEE WHERE BONUS IS NOT NULL AND EMP_NAME LIKE '%하%';

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
<ORDER BY 절> 정렬
SELECT문 가장 마지막 줄에 작성, 실행 순서 또한 맨 마지막에 실행

[표현법]
SELECT 컬럼1, 컬럼2, ... FROM WHERE ORDER BY 정렬기준이 되는 컬럼명 | 별칭 | 컬럼순번 [ASC | DESC] | [NULLS FIRST | NULLS LAST]

ASC 오름차순(기본값)
DESC 내림차순

NULLS FIRST 정렬하고자 하는 컬럼값에 NULL이 있는 경우 해당 데이터를 맨 앞에 배치(생략시 desc일 때는 기본값으로 NULL이 제일 앞에)
NULLS LAST 정렬하고자 하는 컬럼값에 NULL이 있는 경우 해당 데이터를 맨 뒤에 배치(생략시 ASc일 때는 기본값으로 NULL이 제일 뒤에)
*/

-- 보너스로 정렬
SELECT * FROM EMPLOYEE
-- ORDER BY BONUS: 오름차순 기본값으로 NULL이 맨 뒤에 옴
-- ORDER BY BONUS NULLS FIRST: NULL이 처음에 옴
-- ORDER BY BONUS DESC: 내림차순 기본값으로 NULL이 맨 앞에 옴
-- ORDER BY BONUS NULLS LAST: NULL이 끝에 옴
ORDER BY BONUS DESC, BONUS ASC; -- 보너스로 내림차순하지만 값이 같은 경우 급여를 기준으로 오름차순  

-- 전 사원의 사원명, 연봉조회(연봉의 내림차순 정렬 조회)
SELECT * FROM EMPLOYEE ORDER BY (BONUS+(BONUS*BONUS))*12 DESC;