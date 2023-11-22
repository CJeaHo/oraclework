--한 줄 주석 (ctrl + /)
/*
여러 줄 주석
(alt + shift + c)
*/ 

-- 커서가 있는 줄에 ctrl + enter: 그 줄 실행
-- 나의 계정 조회
show user;

--사용자 계정 조회
SELECT * FROM DBA_USERS;

--계정 만들기 (필수)
--오라클 12버전부터 일반 사용자는 c##을 붙여 이름을 작명한다
--CREATE user 생성할 계정명 IDENTIFIED BY 비밀번호(문자와 숫자 함께);
CREATE USER C##USER1 IDENTIFIED BY user1234;
CREATE USER C##USER6 IDENTIFIED BY "1234";

--계정 삭제
--[표현법] drop user 계정명 => 테이블이 없을 때
--[표현법] drop user 계정명 cascade => 테이블이 있을 때
DROP USER C##USER6;

--  사용자 이름에 c## 붙이는 것을 회피하는 방법
ALTER SESSION SET "_oracle_script" = TRUE;

--계정명은 대소문자를 가리지 않는다(소문자로 적어도 대문자)

--실제 사용할 계정 생성
CREATE USER aie IDENTIFIED BY AIE;

--권한 생성(필수)
--[표현법] grant 권한1, 권한2, ... to 계정명
GRANT RESOURCE, CONNECT TO aie;

--테이블 스페이스에 얼마만큼의 영역을 할당할 것인지를 부여(필수)
ALTER USER aie DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS;

--테이블 스페이스의 영역을 특정 용량만큼 할당하려면 (잘 사용안함)
ALTER USER USER1 QUOTA 30M ON USERS;

-- 워크북 사용자 계정 생성
ALTER SESSION SET "_oracle_script" = TRUE;
CREATE USER workbook IDENTIFIED BY workbook;
GRANT RESOURCE, CONNECT TO workbook;
ALTER USER workbook DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS;

-- ddl 사용자 계정 생성
ALTER SESSION SET "_oracle_script" = TRUE;
CREATE USER ddl IDENTIFIED BY ddl;
GRANT RESOURCE, CONNECT TO ddl;
ALTER USER ddl DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS;




