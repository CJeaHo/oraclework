/*
PL/SQL(Procedual Language Extenstion To Sql)
오라클 자체에 내장되어 있는 절차적 언어
sql문장 내에서 변수의 정의, 조건처리(if), 반복처리(loop, for, while)등을 지원하여 sql단점 보와
다수의 sql문을 한번에 실행 가능(block 구조)

PL/SQL구조
- [선언부 (declare section)]: DECLARE로 시작, 변수나 상수를 선언 및 초기화하는 부분
- 실행부 (executable section): begsin으로 시작, sql문 또는 제어문(조건문, 반복문)등의 로직을 기술하는 부분
- [예외처리부(exception section)]: exception으로 시작, 예외 발생시 해결하기 위한 구문을 미리 기술해 둘 수 있는 부분
*/

-- * 화면에 오라클 출력(껏다 다시 키면 반드시 실행해야 함)
SET SERVEROUTPUT ON;

-- hello oracle 출력 BEGIN~END~/
BEGIN
    -- System.out.println("hello oracle") 자바
    dbms_output.put_line('hello oracle');
END;
/

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
1. DECLARE(선언부)
변수 및 상수 선언하는 공간(선언과 동시에 초기화도 가능)
일반 타입 변수, 레퍼런스타입 변수, row 타입의 변수
*/

/*
1.1 일반타입 변수 선언 및 초기화

[표현식] 
변수명 [CONSTANT] 자료형 [:=값];
*/

DECLARE 
    EID NUMBER;
    ENAME VARCHAR2(20);
    PI CONSTANT NUMBER := 3.14;
BEGIN
    EID := 500;
    ENAME := '장남일';

    -- System.out.println("EID: " + EID);
    dbms_output.put_line('EID: ' || EID);
    dbms_output.put_line('ENAME: ' || ENAME);
    dbms_output.put_line('PI: ' || PI);
END;
/

-- 사용자로부터 입력받기
DECLARE
    EID NUMBER;
    ENAME VARCHAR2(20);
    PI CONSTANT NUMBER := 3.14;
BEGIN
    -- &: 값을 입력
    EID := &번호;
    ENAME := '&이름';
    
    dbms_output.put_line('EID: ' || EID);
    dbms_output.put_line('ENAME: ' || ENAME);
    dbms_output.put_line('PI: ' || PI);
END;
/

/*
1.2 레퍼런스타입 변수 선언 및 초기화
어떤 테이블의 어떤 컬럼의 데이터 타입을 참조해서 그 타입으로 지정

[표현식]
변수명 테이블명.컬럼명%TYPE;
*/

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
BEGIN
    EID := '300';
    ENAME := '유재석';
    SAL := 3000000;
    
    dbms_output.put_line('EID: ' || EID);
    dbms_output.put_line('ENAME: ' || ENAME);
    dbms_output.put_line('SAL: ' || SAL);
END;
/

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
BEGIN

    --1. 사번이 200번인 사원의 사번, 사원명, 급여 조회해서 변수에 저장
    SELECT EMP_ID, EMP_NAME, SALARY
        INTO EID, ENAME, SAL
    FROM EMPLOYEE
    WHERE EMP_ID = 200;
    
    -- 2. 입력받아 검색하여 변수에 저장
    SELECT EMP_ID, EMP_NAME, SALARY
        INTO EID, ENAME, SAL
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    dbms_output.put_line('EID: ' || EID);
    dbms_output.put_line('ENAME: ' || ENAME);
    dbms_output.put_line('SAL: ' || SAL);
END;
/
---------------------------------------------실습문제----------------------------------------------

/*
레퍼런스타입 변수로 EID, ENAME, JCODE, SAL, DTITLE을 선언하고 각 자료형 EMPLOYEE(EMP_ID, EMP_NAME, JOB_CODE, SALARY), DEPARTMENT(DEPT_TITLE)들을 참조
사용자가 입력한 사번의 사원의 사번, 사원명, 직급코드, 급여, 부서명, 조회한 후 각 변수에 담아 출력
*/

DECLARE 
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    JCODE EMPLOYEE.JOB_CODE%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY, DEPT_TITLE 
        INTO EID, ENAME, JCODE, SAL, DTITLE
    FROM EMPLOYEE 
    JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID) 
    WHERE EMP_ID =&사번;

    dbms_output.put_line('EID: ' || EID);
    dbms_output.put_line('ENAME: ' || ENAME);
    dbms_output.put_line('JCODE: ' || JCODE);
    dbms_output.put_line('SAL: ' || SAL);
    dbms_output.put_line('DTITLE: ' || DTITLE);
END;
/

--------------------------------------------------------------------------------------------------

/*
1.3 ROW타입 변수 선언
테이블의 한 행에 대한 모든 컬럼값을 한꺼번에 담을 수 있는 변수

[표현식]
변수명 테이블명%ROWTYPE;
*/

DECLARE
    E EMPLOYEE%ROWTYPE;
BEGIN
    SELECT * -- ROWTYPE을 사용하면 무조건 * 여야한다 (컬럼 전부 다 쓰던가)
        INTO E
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;

    dbms_output.put_line('사원명 : ' || E.EMP_NAME);
    dbms_output.put_line('급여 : ' || E.SALARY);
    -- dbms_output.put_line('보너스 : ' || E.BONUS);
    -- dbms_output.put_line('보너스 : ' || NVL(E.BONUS, 없음)); -- 숫자타입인데 문자를 넣기 때문에 오류
    dbms_output.put_line('보너스 : ' || NVL(E.BONUS, 0));
END;
/

--------------------------------------------------------------------------------------------------

/*
2. BEGIN 실행부

<조건문>
1) IF 조건식 THEN 실행내용 END IF; (단일 조건문)
2) IF 조건식 THEN 실행내용 ELSE 실행내용 END IF; (IF-ELSE문)
3) IF 조건식1 THEN 실행내용1 ELSIF 조건식2 THEN 실행내용2...ELSE 실행내용 END IF; (IF-ELSIF문)
4) CASE 비교대상자 WHEN 비교할 값1 THEN 실행내용1 WHEN 비교할 값2 THEN 실행내용2 ELSE 실행내용 END;
     SWITCH => CASE
         CASE => WHEN
    실행내용 => THEN
    DEFALUT=> ELSE
*/

-- 사번 입력받은 후 해당 사원의 사번, 이름, 급여, 보너스율(%) 출력
-- 단, 보너스를 받지 않는 사원은 보너스율 출력전 '보너스를 지급받지 않는 사원입니다' 출력

-- 1) 단일 조건문

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
BEGIN

    SELECT EMP_ID, EMP_NAME, SALARY, BONUS
        INTO EID, ENAME, SAL, BONUS
        FROM EMPLOYEE
        WHERE EMP_ID = &사번;
        
        dbms_output.put_line('사번: ' || EID);
        dbms_output.put_line('사원명: ' || ENAME);
        dbms_output.put_line('급여: ' || SAL);
        IF BONUS IS NULL THEN dbms_output.put_line('보너스를 지급받지 않는 사원입니다');
        END IF;
        
        dbms_output.put_line('보너스율: ' || BONUS*100 || '%');
END;
/

-- 2) IF-ELSE문

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
BEGIN

    SELECT EMP_ID, EMP_NAME, SALARY, BONUS
        INTO EID, ENAME, SAL, BONUS
        FROM EMPLOYEE
        WHERE EMP_ID = &사번;
        
        dbms_output.put_line('사번: ' || EID);
        dbms_output.put_line('사원명: ' || ENAME);
        dbms_output.put_line('급여: ' || SAL);
        IF BONUS IS NULL 
            THEN dbms_output.put_line('보너스를 지급받지 않는 사원입니다');
        ELSE
            dbms_output.put_line('보너스율: ' || BONUS*100 || '%');
        END IF;
        
        
END;
/

---------------------------------------실습문제----------------------------------------

/* 
레퍼런스 변수: EID, ENAME, DTITLE, NCODE
       참조 컬럼: EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_CODE
       일반 변수: TEAM(소속)
       
실행: 사용자가 입력한 사번의 사번, 이름, 부서명, 근무국가코드를 변수에 대입
단, NCODE값이 KO일 경우 => TEAM변수에 '국내팀'
     NCODE값이 KO가 아닐 경우 => TEAM변수에 '해외팀'
     
출력: 사번, 이름, 부서명, 소속 출력
*/

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
    NCODE LOCATION.NATIONAL_CODE%TYPE;
    TEAM VARCHAR2(20);
BEGIN

    SELECT EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_CODE
        INTO EID, ENAME, DTITLE, NCODE
        FROM employee
        JOIN department ON (DEPT_CODE = DEPT_ID)
        JOIN location ON (LOCATION_ID = LOCAL_CODE)
        WHERE EMP_ID = &사번;
        
        IF NCODE = 'KO' THEN
            TEAM := '국내팀';
        ELSE
            TEAM := '해외팀';
        END IF;
    

        dbms_output.put_line('사번: ' || EID);
        dbms_output.put_line('이름: ' || ENAME);
        dbms_output.put_line('부서명: ' || DTITLE);
       dbms_output.put_line('소속: ' || TEAM);
        
END;
/

-- 사용자로부터 점수를 입력받아 점수와 학점 출력
-- 3) IF-ELSIF문
DECLARE
    SCORE NUMBER;
    GRADE CHAR(1);
    
BEGIN
    
    SCORE := &점수;

    IF SCORE >= 90 
        THEN GRADE := 'A';
    ELSIF SCORE >= 80
        THEN GRADE := 'B';
    ELSIF SCORE >= 70
        THEN GRADE := 'C';
    ELSIF SCORE >= 60 
        THEN GRADE := 'D';
    ELSE
        GRADE := 'F';
    END IF;
    
    dbms_output.put_line('당신의 점수는 ' || SCORE || ', 학점은 ' || GRADE);

END;
/

-------------------------------------실습문제-------------------------------------

DECLARE
    SAL EMPLOYEE.SALARY%TYPE;
    GRADE VARCHAR2(10);
BEGIN
    
    SELECT SALARY
        INTO SAL
        FROM EMPLOYEE
        WHERE EMP_ID = &사번;
        
        IF SAL >= 5000000
            THEN GRADE := '고급';
        ELSIF SAL >= 3000000
            THEN GRADE := '중급';
        ELSIF SAL < 3000000
            THEN GRADE := '초급';
        END IF;
        
        dbms_output.put_line('해상 사원의 급여 등급은 ''' || GRADE || ''' 입니다.');
        
END;
/

------------------------------------------------------------------------------------

-- 4) CASE 비교대상자
     
DECLARE
    EMP EMPLOYEE%ROWTYPE;
    DNAME VARCHAR2(30);
BEGIN

    SELECT *
        INTO EMP
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;

    DNAME := 
    CASE EMP.DEPT_CODE
        WHEN 'D1' THEN '인사관리부'
        WHEN 'D2' THEN '회계관리부'
        WHEN 'D3' THEN '마케팅부'
        WHEN 'D4' THEN '국내영업부'
        WHEN 'D8' THEN '기술지원부'
        WHEN 'D9' THEN '총무부'
        ELSE '해외영업부'
    END;
    
    dbms_output.put_line(EMP.EMP_NAME || '는 '''  || DNAME || ''' 입니다.');
    
END;
/

--------------------------------------------------------------------------------

/*
<반복문>
1) LOOP 반복 실행내용 *반복문을 빠져나갈 수 있는 구문 END LOOP; (일반 LOOP문)
2) FOR 변수 IN [REVERSE] 초기값..최종값 LOOP 실행내용 END LOOP; (FOR LOOP문)
3) WHILE 반복 조건문 LOOP 반복 실행내용; END LOOP;(WHILE LOOP문)

* 반복문을 빠져나갈 수 있는 조건문 2가지
1) IF 조건식 이용
    IF 조건식 THEN EXIT; END IF;
2) EXIT
    EXIT WHEN 조건식;
*/

-- 1) 일반 LOOP문
-- 1-1) IF 조건식
DECLARE
    I NUMBER := 1;
BEGIN
    LOOP
        dbms_output.put_line(I);
        I := I + 1; -- I++, I+=1 이런거 없음
        IF I = 6 
            THEN EXIT;
        END IF;
    END LOOP;
END;
/

-- 1-2) EXIT
DECLARE
    I NUMBER := 1;
BEGIN
    LOOP
        dbms_output.put_line(I);
        I := I +1;
        
        EXIT WHEN I = 6;
    END LOOP;
END;
/

-------------------------------------------------------------------------------
-- 2) FOR LOOP문
-- 2-1) 1~5
BEGIN
    FOR I IN 1..5
    LOOP
        dbms_output.put_line(I);
    END LOOP;
END;
/

-- 2-2) 5~1
BEGIN
    FOR I IN REVERSE 1..5
    LOOP
        dbms_output.put_line(I);
    END LOOP;
END;
/

---------------------------- 적용
DROP TABLE TEST;
DROP SEQUENCE SEQ_TNO;

CREATE TABLE TEST(
    TNO NUMBER PRIMARY KEY,
    TDATE DATE
);

CREATE SEQUENCE SEQ_TNO
INCREMENT BY 2;

BEGIN
    FOR I IN 1..100 -- 1부터 100행까지
    LOOP
        INSERT INTO TEST VALUES(SEQ_TNO.NEXTVAL, SYSDATE);
    END LOOP;
END;
/

SELECT * FROM TEST;

-----------------------------------------------------------------------------------------

--3) WHILE LOOP

DECLARE
    I NUMBER := 1;
BEGIN
    WHILE I < 6
        LOOP
            dbms_output.put_line(I);
            I := I + 1;
        END LOOP;
    END;
/

/*
3. 예외 처리부
예외(EXCEPTION): 실행 중 발생하는 오류

[표현식]
EXCEPTION
    WHEN 예외명1 THEN 예외처리구문1;
    WHEN 예외명2 THEN 예외처리구문2;
    WHEN OTHERS THEN 예외처리구문;
    
>>시스템 예외(오라클에서 미리 정의해둔 예외)
- NO_DATA_FOUND: SELECT한 결과 한 행도 없을 경우
- TOO_MANY_ROWS: SELECT한 결과 여러행일 경우
- ZERO_DIVIDE: 0으로 나눴을 경우
- DUP_VAL_ON_INDEX: UNIQUE 제약조건에 위배되었을 경우
...
*/

-- 사용자가 입력한 수로 나눗셈 연산
DECLARE
    RESULT NUMBER;
    
BEGIN
    RESULT := 10/&숫자;
    dbms_output.put_line('결과: ' || RESULT);
EXCEPTION
--    WHEN ZERO_DIVIDE THEN dbms_output.put_line('0으로 나눌 수 없다');
    WHEN OTHERS THEN dbms_output.put_line('0으로 나눌 수 없다');
END;
/

-- UNIQUE 제약조건 위배
BEGIN
    UPDATE EMPLOYEE
        SET EMP_ID = '&변경할사번'
        WHERE EMP_NAME = '김정보';
        
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN dbms_output.put_line('이미 존재하는 사번입니다');
END;
/

-- 사수 200번은 6명, 202번은 하나도 없고, 201번은 1명
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME
        INTO EID, ENAME
        FROM EMPLOYEE
        WHERE MANAGER_ID = &사수번호;
        
        dbms_output.put_line('사번: ' || EID);
        dbms_output.put_line('이름: ' || ENAME);
EXCEPTION
    WHEN TOO_MANY_ROWS THEN dbms_output.put_line('조회된 행이 너무 많습니다');
    WHEN NO_DATA_FOUND THEN dbms_output.put_line('조회된 행이 하나도 없습니다');
END;
/

------------------------------------ 연습문제
-- 1. 사원의 연봉을 구하는 PL/SQL 블럭 작성, 보너스가 있는 사원은 보너스도 포함하여 계산
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;  
    
    YSAL NUMBER;
BEGIN

    SELECT EMP_ID, EMP_NAME, SALARY, BONUS
        INTO EID, ENAME, SAL, BONUS
        FROM EMPLOYEE
        WHERE EMP_ID = &사번;
        
        IF BONUS IS NULL
            THEN YSAL := SAL*12;
        ELSE
            YSAL := SAL*(1+BONUS)*12;
        END IF;
        
        dbms_output.put_line(ENAME || '사원의 연봉은' || TO_CHAR(YSAL, 'L999,999,999') || '입니다');
END;
/

-- 2. 구구단 짝수단 출력
-- 2-1) FOR LOOP
BEGIN
    FOR I IN 2..9 BY 2
    LOOP
        FOR J IN 1..9
        LOOP
        dbms_output.put_line(I || '*' || J || '=' || I*J);
        END LOOP;
        dbms_output.put_line('');
    END LOOP;
END;
/
------------------------------
BEGIN
    FOR I IN 2..9
    LOOP
        IF MOD(I , 2) = 0
        THEN
            FOR J IN 1..9
            LOOP
                dbms_output.put_line(I || '*' || J || '=' || I * J );
            END LOOP;
        dbms_output.put_line('');
        END IF;
    END LOOP;
END;
/

-- 2-1) WHILE LOOP
DECLARE
    I NUMBER := 2;
    J NUMBER;
    
BEGIN
    WHILE I <= 9
    LOOP
        J := 1; -- 초기화
        WHILE J <= 9
        LOOP
            dbms_output.put_line(I || '*' || J || '=' || I*J);
            J := J + 1;
        END LOOP;
        dbms_output.put_line('');
        I := I + 2;
    END LOOP;
END;
/
--------------------------------
DECLARE
    I NUMBER := 2;
    J NUMBER;
    
BEGIN
    WHILE I <= 9
    LOOP
        J := 1; -- 초기화
        IF MOD(I , 2) = 0
        THEN
            WHILE J <= 9
            LOOP
                dbms_output.put_line(I || '*' || J || '=' || I * J );
                J := J + 1;
            END LOOP;
            dbms_output.put_line('');
        END IF;
        I := I + 1;
    END LOOP;
END;
/
