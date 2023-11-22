/*
DCL: Data Control Language
데이터 제어어
계정에게 시스템권한 또는 객체에 접근권한 부여(GRANT)하거나 회수(REVOKE)하는 구문

> 시스템 권한: db에 접근하는 권한, 객체들을 생성할 수 있는 권한
> 객체접근 권한: 특정 객체를 조작할 수 있는 권한


1. 권한 부여
GRANT 부여할 권한 ON TO 계정명;

2. 권한 회수
REVOKE 회수할 권한 ON FROM 계정명;
*/

--================================================================================================================================

/*
1. 시스템 권한의 종류
- CREATE SESSION: 접속할 수 있는 권한
- CREATE TABLE: 테이블을 생성할 수 있는 권한
- CREATE VIEW: 뷰를 생성할 수 있는 권한
- CREATE SEQUENCE: 시퀀스 생성할 수 있는 권한
...
*/

-- 1-1) sample / sample 계정 생성
ALTER SESSION SET "_oracle_script" = TRUE; -- c## 붙이는걸 안하려고
CREATE user sample IDENTIFIED BY sample;
-- 생성은 되었으나 접근할 권한은 아직 없다


-- 1-2) 접속을 위해 CREATE SESSION 권한 부여
GRANT CREATE SESSION TO sample;

/*
CREATE table test (
id varchar2(20),
name varchar2(20)
);
*/
-- 접속은 되었으나 테이블 생성할 권한은 아직 없다


-- 1-3) 테이블을 생성하기 위해 CREATE table 권한 부여
GRANT CREATE TABLE TO sample;

-- INSERT inTO test values ('user01', '홍길동');
-- 생성은 되나 데이터를 넣은을 권한은 아직 없다


-- 1-4) 데이터 삽입을 위해 tablespace 할당
ALTER user sample quota 2m ON users;

--================================================================================================================================

/*
2. 객체접근 권한의 종류
SELECT =>   TABLE, VIEW, SEQUENCE
INSERT =>   TABLE, VIEW
UPDATE => TABLE, VIEW
DELETE =>  TABLE, VIEW
...
*/

-- 2-1) sample 계정에게 aie계정 employee테이블을 SELECT할 수 있는 권한부여
GRANT SELECT ON aie.employee TO sample;

-- 2-2) sample계정에서 aie계정의 department테이블에 INSERT할 수 있는 권한부여
GRANT INSERT ON aie.department TO sample;

GRANT SELECT ON aie.department TO sample;

/*ROLE 롤
- 특정 권한들을 하나의 집합으로 모아놓은 것

CONNECT: CREATE, SESSION 생성 및 접속 권한
RESOURCE: CREATE 객체(뷰, 시퀀스 등)
DBA: 시스템 및 객체 관리에 대한 모든 권한(사용자 계정 생성 제외)을 갖고 있는 롤
*/

-- 권한 회수
REVOKE SELECT ON aie.employee FROM sample;
REVOKE INSERT ON aie.department FROM sample;
REVOKE SELECT ON aie.department FROM sample;





