--===============================================================================================================

---------------------------------------------------------------------alter----------------------------------------------------------------------

--===============================================================================================================

/*
alter
객체를 변경하는 구문

[표현식]
alter table 테이블명 변경할 내용;

- 변경할 내용
  1) 컬럼 추가 / 수정 / 삭제
  2) 제약조건 추가/삭제 -> 수정 불가(수정하고자하면 삭제 후 새로 추가)
  3) 컬럼명 / 제약조건명 / 테이블명 변경
*/

-- 1. 컬럼 추가/수정/삭제 ======================================================================================================================================

/* 1) 컬럼 추가(add)
    add 컬럼명 데이터타입 [default 기본값]

>> 다중 변경 가능
*/

-- dept_copy 테이블에 cname 컬럼 추가
alter table dept_copy add cname varchar2(20);
--> 새로운 컬럼이 만들어지고 기본적으로 null로 채워짐

-- dept_copy 테이블에 lname 컬럼 추가, 기본값은 한국으로 추가
alter table dept_copy add lname varchar(20) default '한국';
--> 새로운 컬럼이 만들어지고 내가 지정한 기본값으로 채워짐

--==========================================================================================================================================================

/* 2) 컬럼 수정(modify)
    데이터 타입 수정: modify 컬럼명 바꾸고자하는 데이터타입
    default값 수정: modify 컬럼명 default 바꾸고자하는 기본값
>> 컬럼의 데이터 타입을 변경하기 위해선 해당 컬럼의 값을 모두 지워야 변경 가능
>> 컬럼의 데이터 타입 범위를 변경하기 위해선 기존 데이터값들이 변경할 범위 내에 해당되어 있어야한다 
>> 다중 변경 가능
*/

-- dept_copy테이블의 dept_id의 데이터타입을 char(3)으로 수정
alter table dept_copy modify dept_id char(3);

-- 컬럼의 데이터 타입을 변경하기 위해선 해당 컬럼의 값을 모두 지워야 변경 가능
-- dept_copy테이블의 dept_id의 데이터타입을 number로 수정
alter table dept_copy modify dept_id number; -- 오류 발생: 컬럼값에 영문이 있음.

-- 컬럼의 데이터 타입 범위를 변경하기 위해선 기존 데이터값들이 변경할 범위 내에 해당되어 있어야한다 
-- dept_copy테이블의 dept_title의 데이터타입을 varchar2(10)으로 수정
alter table dept_copy modify dept_title varchar2(10); -- 오류 발생: 컬럼의 값에 10byte가 넘는 데이터가 있음

-- dept_title => varchar2(40)
-- location_id => varchar2(2)
-- lname => '미국'

alter table dept_copy modify dept_title varchar2(40);
alter table dept_copy modify location_id varchar2(2);
alter table dept_copy modify  lname default '미국';

/* 한꺼번에 다중 변경 가능
alter table dept_copy 
modify dept_title varchar2(40)
modify location_id varchar2(2)
modify  lname default '미국';
*/

--==========================================================================================================================================================

/* 3) 컬럼 삭제(drop column)

[표현식]
alter table 테이블명 drop column 컬럼명;

>> 다중 컬럼 삭제할 수 없다
>> 모든 열을 삭제할 수 없다
*/

create table dept_copy2
as select * from dept_copy;

-- dept_copy2 테이블에서 cname컬럼 삭제
alter table dept_copy2 drop column cname;


/* 컬럼 삭제는 다중 안됨
alter table dept_copy2
drop column dept_title
drop column lname;
*/

-- 테이블에 모든 열 전부 삭제 불가
alter table dept_copy2 drop column dept_title;
alter table dept_copy2 drop column lname;
alter table dept_copy2 drop column location_id;
alter table dept_copy2 drop column dept_id; -- 오류 발생: 최소 한개의 컬럼은 존재해야함

-- 2. 제약조건 추가 / 삭제 ======================================================================================================================================

/* 1) 제약조건 추가(add)
 
[표현식]
alter table 테이블명 add primary key(컬럼명);
alter table 테이블명 add foreign key(컬럼명) references 참조할 테이블명(참조할 컬럼명 -> pk라면 생략 가능);
alter table 테이블명 add unique(컬럼명);
alter table 테이블명 add check(컬럼에 대한 조건식);
*/

--==========================================================================================================================================================

/* 2) 제약조건 삭제(drop, modify)
 
[표현식]
alter table 테이블명 drop constraint 제약조건;
alter table 테이블명 modify 컬럼명 null; -> null일 경우엔 수정으로
*/

alter table employee drop constraint f_job;

alter table emp_dept modify emp_name null;

-- 3. 컬럼명 / 제약조건명 / 테이블명 변경 ==========================================================================================================================

-- 1) 컬럼명 변경: rename column 기존 컬럼명 to 바꿀 컬럼명
-- dept_copy 테이블의 dept_title을 dept_name으로 컬럼명 변경
alter table dept_copy rename column dept_title to detp_name;

-- 2) 제약조건명 변경: rename constraint 기존 제약조건명 to 바꿀 제약조건명
-- employee_copy 테이블의 기본키의 제약조건의 이름 변경
alter table employee_copy rename constraint SYS_C008454 to ec_pk;

-- 3) 테이블명 변경: table [기존 테이블명] rename to 바꿀 테이블명
-- dept_copy 테이블을 dept_test로 이름 변경
alter table dept_copy rename to dept_test;

-- dept_copy2 테이블을 dept_test2로 이름 변경
alter table dept_copy2 to dept_test2;

--===============================================================================================================

----------------------------------------------------------------------drop----------------------------------------------------------------------

--===============================================================================================================

/*
drop
테이블을 완전 삭제

[표현식]
drop table 테이블명;

>> 어딘가에서 참조되고 있는 부모테이블은 함부로 삭제 안됨
     만약 삭제를 하고 싶다면
     > 방법1. 자식테이블을 먼저 삭제 후 부모테이블 삭제
     > 방법2. 그냥 부모테이블만 삭제하는데 제약조건가지 같이 삭제(drop table 테이블명 cascade constraint;)
*/

drop table dept_test;















