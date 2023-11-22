/*
tcl(transaction Control Language)
트랜잭션 제어어

트랜잭션
- 데이터베이스의 논리적 연산단위
- 데이터의 변경사항(dml)들을 하나의 트랜잭션에 묶어서 처리
   >dml문 한개를 수행할 때 트랜잭션이 존재하면 해당 트랜잭션에 같이 묶어서 처리
   >트랜잭션이 존재하지 않으면 트랜잭션을 만들어서 묶음
   >commit을 하기전까지의 변경사항들을 하나의 트랜잭션에 담게됨
-  트랜잭션의 대상이 되는 sql: insert, update, delete

종류
- commit(트랜잭션 종료 처리 후 확정)
> commit; 진행: 한 트랜잭션에 담겨있는 변경사항들을 실제 db에 반영시키겠다는 의미(후에 트랜잭션은 사라짐)
- rollback(트랜잭션 취소)
> rollback; 진행: 한 트랜잭션에 담겨있는 변경사항들은 삭제한 후 마지막 commit 시점으로 돌아감
- savepoint(임시저장)
> savepoint 포인트명; 진행: 현재 이 시점에 해당 포인트명으로 임시저장점을 정의해두는 것
                                          rollback진행 시 전체 변경사항들을 다 삭제하는게 아니라 일부만 롤백 가능
*/

select * from emp_01;

-- 사번이 300인 사원 삭제(트랜잭션 생성)
delete from emp_01 where emp_id = 300;

-- 사번이 301인 사원 삭제(트랜잭션 생성)
delete from emp_01 where emp_id = 301;

-- 위의 트랜잭션에 delete 301 들어감
-- 실제 db에 반영 안됨

rollback; -- 300, 301번이 되살아남(트랜잭션이 사라짐)

--------------------------------------------------------------------------------

-- 사번이 200인 사원 삭제(트랜잭션 생성)
delete from emp_01 where emp_id = 200;

select * from emp_01; 

-- 값을 추가 삽입(트랜잭션 생성)
insert into emp_01 values(500, '남길동', '기술지원부');

commit; -- 생성된 트랜잭션을 저장하고 트랜잭션 삭제

rollback; -- 트랜잭션이 없으므로 롤백해도 못살림

------------------------------------------------------------------------------------------------------------------------------------------

-- 216, 217, 214 사원 삭제
delete from emp_01 where emp_id in (216, 217, 214);

-- 임시저장점 만들기 (변수 생성하듯이)
savepoint sp;

select * from emp_01;

-- 값 추가 삽입
insert into emp_01 values(501, '이세종', '총무부');

-- 사원 218번 삭제
delete from emp_01 where emp_id = 218;

-- 임시저장점 sp지점까지만 rollback하고 싶으면 
rollback to sp;

select * from emp_01;

commit;

--------------------------------------------------------------------------------------------------------------------------------------------------
/*
자동 commit되는 경우
- 정상 종료
- dcl과 ddl명령문이 수행된 경우

자동 rollback되는 경우
- 비정상 종료(전원꺼짐, 정전, 컴퓨터 down)
*/

-- 사번 300, 500 삭제(트랜잭션 생성)
delete from emp_01 where emp_id in(300, 500);

-- 사번 302 삭제(트랜잭션 생성)
delete from emp_01 where emp_id = 302;

-- ddl문 수행 (자동 commit: 생성된 트랜잭션을 저장하고 트랜잭션 삭제)
create table test (
t_id number
);

rollback; -- 트랜잭션이 없으므로 롤백해도 못살림

select * from emp_01;
















