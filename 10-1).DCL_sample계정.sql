/* 관리자 계정에서 
1-3) 테이블을 생성하기 위해 create table 권한 부여
grant create table to sample; 를 했기 때문에
테이블 생성 가능하다 그 전엔 불가
*/

create table test (
id varchar2(20),
name varchar2(20)
);

/* 관리자 계정에서
1-4) 데이터 삽입을 위해 tablespace 할당
alter user sample quota 2m on users; 을 했기 때문에
데이터 삽입 가능하다 그 전엔 불가
*/
insert into test values ('user01', '홍길동');

/* 관리자 계정에서
2-1) sample 계정에게 aie계정 employee테이블을 select할 수 있는 권한부여
grant select on aie.employee to sample; 를 했기 때문에
sample계정에서 aie계정의 employee테이블을 조회 할 수 있다*/
select * from aie.employee;

/* 관리자 계정에서
2- 2) sample계정에서 aie계정의 department테이블에 insert할 수 있는 권한부여
grant insert on aie.department to sample; 
grant select on aie.department to sample; 를 했기 때문에
sample계정에서 aie계정의 department테이블에 데이터를 삽입하고 조회할 수 있다*/
select * from aie.department;
insert into aie.department values('D0', '관리부', 'L2');
select * from aie.department;

commit;