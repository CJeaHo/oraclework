/*
ddl: 데이터 정의어
오라클에서 제공하는 객체를 생성하고(create), 구조를 변경하고 (alter), 구조를 삭제(drop)하는 언어
즉, 실제 데이터 값이 아닌 구조 자체를 정의하는 언어
주로 db관리자, 설계자가 사용함

오라클 객체: 테이블(table), 뷰(view), 시퀀스(sequence), 인덱스(index), 패키지(package), 
트리거(trigger), 프로시저(procedure), 함수(function), 동의어(synonym), 사용자(user)
*/

-------------------------------------------------------------------------------------------------------------------------

/*
create: 객체를 생성하는 구문

테이블 생성: 행과 열로 구성되는 가장 기본적인 데이터베이스 객체
                      모든 데이터들은 테이블을 통해 저장됨
                      (DBMS 용어 중 하나로, 데이터를 일종의 표 형태로 만든 것)

[표현법]
create table 테이블명 (
컬럼명 자료형(크기),
컬럼명 자료형(크기),
컬럼명 자료형,
...
)

* 자료형
- 문자 (char(바이트 크기) | varchar2(바이트 크기)) => 반드시 크기 지정해야함
> char: 최대 2000byte까지 지정 가능
           고정길이(지정한 크기보다 더 적은 값이 들어와도 공백으로라도 채워서 처음 지정한 크기만큼 고정) -> 10byte로 지정하고 5byte만 넣어도 10byte를 차지
           고정된 데이터를 넣을 때 사용
> varchar2: 최대 4000byte까지 지정 가능
                  가변길이(담긴 값에 따라 공간의 크기가 맞춰짐)
                  몇글자가 들어올지 모를 경우 사용
- 숫자 (number)
- 날짜(date)
*/

-- 회원 테이블 member 생성
create table member (
mem_no number,
mem_id varchar(20),
mem_pw varchar(20),
mem_name varchar(20),
gender char(3),
phone varchar2(13),
email varchar2(50),
mem_date date
);

select * from member;

-------------------------------------------------------------------------------------------------------------------------
/*
컬럼에 주석 달기(컬럼에 대한 설명)

[표현법]
comment on column 테이블명.컬럼명 is '주석내용';
>> 잘못 작성했다면 수정후 다시 실행하면 됨
*/

comment on column member.mem_no is '회원번호';
comment on column member.mem_id is '회원아이디';
comment on column member.mem_pw is '회원비번';
comment on column member.mem_name is '회원이름';
comment on column member.gender is '회원성별';
comment on column member.phone is '회원전화번호';
comment on column member.email is '회원이메일';
comment on column member.mem_date is '회원등록일';

/*
테이블에 데이터 추가하기
insert into 테이블명 values();
*/

insert into member values(1, 'user01', '1234', '김나영', '여', '010-1234-5678', 'kim@naver.com', '23/11/16'); 
insert into member values(2, 'user02', '1234', '홍길동', '남', null, 'hong@naver.com', sysdate) ;
insert into member values(null, null, null, null, null, null, null, null) ;

-------------------------------------------------------------------------------------------------------------------------
/*
제약조건 constraint
- 원하는 데이터값(유요한 형식의 값)만 유지하기 위해 특정 컬럼에 설정하는 제약
종류: not null, unique, check(조건), primary key(pk 기본키), foreign key(fk 외래키)

- 데이터 무결성 보장을 목적으로 한다
> 무결성: 데이터에 결함이 없는 상태(즉, 데이터가 정확하고 유효하게 유지된 상태)
1. 개체 무결성 제약 조건: not null, unique, check(조건), primary key(pk 기본키)를 위배
2. 참조 무결성 제약 조건: foreign key(fk 외래키)를 위배 

컬럼 레벨 방식
테이블 생성 시 만들어질 컬럼에 하나하나 제약조건을 걸어둠
테이블 레벨 방식
테이블 생성 시 제약조건을 걸 컬럼을 하나로 묶어서 걸어둠

*/

/*
not null 제약조건
해당컬럼에 반드시 값이 존재해야만 할 경우(즉, 컬럼에 절대 null이 들어오면 안되는 경우)
삽입/ 수정시 null값을 허용하지않도록 제한

제약조건의 부여 방식은 크게 2가지로 나눔(컬럼 레벨 방식 | 테이블 레벨 방식)
- not null 제약조건은 오로지 컬럼 레벨 방식밖에 안됨
*/

create table mem_notnull (
mem_no number not null,
mem_id varchar(20) not null,
mem_pw varchar(20) not null,
mem_name varchar(20) not null,
gender char(3),
phone varchar2(13),
email varchar2(50),
mem_date date
);

select * from mem_notnull;

insert into mem_notnull values(1, 'user01', '1234', '김나영', '여', '010-1234-5678', 'kim@naver.com', '23/11/16'); 
insert into mem_notnull values(2, 'user02', null, '홍길동', '남', null, null, sysdate); -- not null 제약조건에 위배되는 오류 발생

insert into mem_notnull values(2, 'user01', 'pass01', '이영순', '여', null, null, sysdate);
insert into mem_notnull values(1, 'user01', 'pass01', '이영순', '여', null, null, sysdate);

/*
unique 제약조건
해당컬럼에 중복된 값이 들어가면 안되는 경우
컬럼값에 중복값 제한
삽입 / 수정 시 기존에 있는 데이터값이 중복되었을 때 오류 발생

컬럼 레벨 방식:
column1 unique,
column2 unique,

테이블 레벨 방식: 
column1,
column2,
unique(column1),
unique(column2),
unique(column1, column2)
>> 여러 컬럼을 한번에 unique로 걸면 여러 컬럼을 하나로 해서 중복 여부를 확인한다
*/

-- 컬럼 레벨 방식
create table mem_unique(
mem_no number not null unique,
mem_id varchar2(20) not null unique,
mem_pw varchar2(20) not null,
mem_name varchar2(20) not null,
gender char(3),
phone varchar2(13),
email varchar2(50),
mem_date date
);


-- 테이블 레벨 방식
create table mem_unique2(
mem_no number not null,
mem_id varchar2(20) not null,
mem_pw varchar2(20) not null,
mem_name varchar2(20) not null,
gender char(3),
phone varchar2(13),
email varchar2(50),
mem_date date,
-- unique (mem_no, mem_id), -- mem_no와 mem_id를 하나로 해서 중복값을 체크
unique (mem_no), -- mem_no 값 따로
unique (mem_id) -- mem_id 값 따로
);

insert into mem_unique values(1, 'user01', 'pass01', '김나영', '여', null, null, null); 
insert into mem_unique values(1, 'user02', 'pass02', '김나일', '여', null, null, null); -- unique 제한 조건 위배

insert into mem_unique2 values(1, 'user01', 'pass01', '김나영', '여', null, null, null); 
insert into mem_unique2 values(2, 'user01', 'pass02', '김나일', '여', null, null, null); 

/*
제약조건 부여시 제약조건명까지 부여할 수 있다 (생략 가능)

- 컬럼 레벨 방식
create tabel 테이블명(
컬럼명 자료형() [constraint 제약조건명] 제약조건,
...
);

- 테이블 레벨 방식
create table 테이블명(
컬럼명 자료형(),
...
[constraint 제약조건명] 제약조건(컬럼명)
);
*/

create table mem_unique3(
mem_no number constraint memno_nn not null constraint nounique unique,
mem_id varchar2(20) not null constraint idunique unique,
mem_pw varchar2(20) constraint pw_nn not null,
mem_name varchar2(20),
gender char(3),
constraint name_unique unique(mem_name) -- 테이블 레벨 방식
);
insert into mem_unique3 values(1, 'uid', 'upw', '김길동', null);
insert into mem_unique3 values(1, 'uid2', 'upw2', '김길', null); -- 제약조건의 바뀐이름을 볼 수 있음

insert into mem_unique3 values(2, 'uid2', 'upw2', 'ㄱ', null);
insert into mem_unique3 values(3, 'uid3', 'upw3', '이름', 'm');

/*
check(조건식) 제약조건
해당 컬럼에 들어올 수 없는 값에 대한 조건을 제시해 둘 수 있다
해당 조건에 만족하는 데이터값만 입력하도록 할 수 있다
*/

create table mem_check(
mem_no number not null unique,
mem_id varchar2(20) not null unique,
mem_pw varchar2(20) not null,
mem_name varchar2(20) not null,
--gender char(3) check(gender in('남', '여')), -- 컬럼 레벨 방식
phone varchar2(13),
email varchar2(50),
mem_date date
check(gender in ('남', '여')) -- 테이블 레벨 방식
); 

insert into mem_check values(1, 'user01', 'pass01', '홍길동', '남', null, null, sysdate);
insert into mem_check values(2, 'user02', 'pass01', '이길동', 'm', null, null, sysdate); -- check 제약조건 위배
insert into mem_check values(2, 'user02', 'pass01', '이길동', '남', null, null, sysdate);

/*
primary key(기본키) 제약조건
테이블에서 각 행들을 식별하기 위해 사용될 컬럼에 부여하는 제약조건(식별자 역할)

ex) 회원번호, 학번, 사번, 예약번호, 운송장 번호... etc

primary key 제약조건을 부여하면 그 컬럼에 자동으로 not null + unique 제약조건을 의미
대체적으로 검색, 수정, 삭제에서 기본키의 컬럼값을 이용함

>>한 테이블에 하나의 primary key만 가질 수 있다
>>테이블 레벨 방식 시 여러 컬럼을 묶어서 primary key를 지정할 수 있다 (여러 칼럼을 하나로 해서 기본키로 설정됨)
단, 따로 따로 개별적으로는 안된다
*/

create table mem_primary(
mem_no number primary key, -- 컬럼 레벨 방식
mem_id varchar2(20) not null unique,
mem_pw varchar2(20) not null,
mem_name varchar2(20) not null,
gender char(3),
phone varchar2(13),
email varchar2(50),
mem_date date
--primary key(mem_no) -- 테이블 레벨 방식
); 

insert into mem_primary values(1, 'user01', '1234', '김나영', '여', '010-1234-5678', 'kim@naver.com', '23/11/16'); 
insert into mem_primary values(1, 'user02', '1234', '이나영', '여', '010-1234-5678', 'lee@naver.com', '23/11/16'); 

-- 생성 불가
--create table mem_primary2(
--mem_no number primary key,
--mem_id varchar2(20) primary key, -- 오류: 테이블에는 하나의 기본 키만 가질 수 있습니다.
--mem_pw varchar2(20) not null,
--mem_name varchar2(20) not null,
--gender char(3),
--phone varchar2(13),
--email varchar2(50),
--mem_date date
--); 

create table mem_primary2(
mem_no number,
mem_id varchar2(20),
mem_pw varchar2(20) not null,
mem_name varchar2(20) not null,
gender char(3),
phone varchar2(13),
email varchar2(50),
mem_date date,
primary key(mem_no, mem_id) -- 복합 기본키로 생성됨
); 

insert into mem_primary2 values(1, 'uid', 'upw', '나길동', '남', null, null, sysdate); 
insert into mem_primary2 values(2, 'uid', 'upw', '나길동', '남', null, null, sysdate); -- 하나로 묶어서 했기때문에 여러 컬럼값중 중복된게 있더라도 완전 중복이지 않아서 삽입 가능
insert into mem_primary2 values(1, 'uid2', 'upw', '나길동', '남', null, null, sysdate); -- 하나로 묶어서 했기때문에 여러 컬럼값중 중복된게 있더라도 완전 중복이지 않아서 삽입 가능
insert into mem_primary2 values(1, null, 'upw', '나길동', '남', null, null, sysdate); -- null값은 묶은 것중 하나라도 있다면 불허

------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 회원등급를 저장하는 테이블(mem_grade)
create table mem_grade(
grade_code number primary key,
grade_name varchar2(30) not null
);

insert into mem_grade values(10, '일반회원');
insert into mem_grade values(20, '우수회원');
insert into mem_grade values(30, '특별회원');


-- 회원정보를 저장하는 테이블(mem)
create table mem(
mem_no number primary key,
mem_id varchar2(20) not null unique,
mem_pw varchar2(20) not null,
mem_name varchar2(20) not null,
gender char(3) check(gender in('남', '여')),
phone varchar2(13),
email varchar2(50),
mem_date date,
grade_id number -- 회원 등급을 보관할 컬럼
);

insert into mem values(1, 'user01', 'pass01', '홍길동', '남', null, null, sysdate, null);
insert into mem values(2, 'user02', 'pass02', '김길동', '여', null, null, sysdate, 10);
insert into mem values(3, 'user03', 'pass03', '여길녀', '여', null, null, sysdate, 50); -- 유효한 회원등급번호가 아님에도 삽입이 되었음 -> 방지하기 위해 foreign key를 사용

/*
foreign key(외래키) 제약조건
다른 테이블에 존재하는 값만 들어와야되는 특정 컬럼에 부여하는 제약조건
다른 체이블을 참조한다고 표현
주로 foreign key 제약 조건에 의해 테이블 간의 관계가 형성됨

> 컬럼 레벨 방식
컬럼명 자료형 references 참조할 테이블명 (참조할 컬럼명)
컬럼명 자료형 [constraint 제약조건명] references 참조할 테이블명 (참조할 컬럼명-> *primary key라면 생략 가능)

> 컬럼 테이블 방식
foreign key(컬럼명) references 참조할 테이블명 (참조할 컬럼명-> *primary key라면 생략 가능)
[constraint 제약조건명]

>> 참조할 컬럼이 primary key이면 생략 가능(자동으로 primary key와 외래키를 맺음)
*/

create table mem2(
mem_no number primary key,
mem_id varchar2(20) not null unique,
mem_pw varchar2(20) not null,
mem_name varchar2(20) not null,
gender char(3) check(gender in('남', '여')),
phone varchar2(13),
email varchar2(50),
mem_date date,
grade_id number,
--grade_id number references mem_grade(grade_code) -- 컬럼 레벨 방식
foreign key(grade_id) references mem_grade(grade_code) -- 테이블 레벨 방식
);

insert into mem2 values(1, 'user01', 'pass01', '홍길동', '남', null, null, sysdate, null);
insert into mem2 values(2, 'user02', 'pass02', '김길동', '여', null, null, sysdate, 10);
insert into mem2 values(3, 'user03', 'pass03', '여길녀', '여', null, null, sysdate, 50); -- 오류: 무결성 제약조건이 위배되었습니다- 부모 키가 없습니다

/* mem_grade(부모테이블) -|----------<- mem2(자식테이블)
이때 부모테이블에서 데이터값을 삭제할 경우 (delete from 부모테이블명 where 조건;)
> 자식테이블에서 부모테이블의 데이터값을 사용한다면
삭제 불가

> 사용하지 않는 경우
삭제 가능
*/

-- mem_grade 테이블에서 10번 등급 삭제
-- 오류: 무결성 제약조건이 위배되었습니다- 자식 레코드가 발견되었습니다
delete from mem_grade where grade_code = 10; -- 자식테이블에서 10이라는 값을 사용하고 있기 때문에 삭제 안됨

delete from mem_grade where grade_code = 30; -- 자식테이블에서 30이라는 값을 사용하고 있지 않아서 삭제 가능

---------------------------------------------------------------------------------------------------------------------------------
/*
자식테이블 생성시 외래키 제약조건 부여할 때 삭제옵션 지정 가능
> 삭제 옵션: 부모테이블의 데이터 삭제시 그 데이터를 사용하고 있는 자식테이블의 값을 어떻게 처리하는가?
- on delete restricted(기본값): 삭제 제한 옵션으로, 자식테이블에서 쓰이는 값은 부모테이블에서 삭제
- on delete set null: 부모테이블에서 삭제시 자식테이블의 값은 null로 변경하고 부모테이블의 행 삭제
- on delete cascade: 부모테이블에서 삭제하면 자식테이블의 행도 삭제
*/

drop table mem;
drop table mem2;

-- 자식테이블은 null이 되는 방식
create table mem(
mem_no number primary key,
mem_id varchar2(20) not null unique,
mem_pw varchar2(20) not null,
mem_name varchar2(20) not null,
gender char(3) check(gender in('남', '여')),
phone varchar2(13),
email varchar2(50),
mem_date date,
grade_id number,
foreign key(grade_id) references mem_grade on delete set null
);

insert into mem values(1, 'user01', 'pass01', '홍길동', '남', null, null, sysdate, null);
insert into mem values(2, 'user02', 'pass02', '김길동', '여', null, null, sysdate, 10);
insert into mem values(3, 'user03', 'pass03', '여길녀', '여', null, null, sysdate, 20); 
insert into mem values(4, 'user04', 'pass04', '남길동', '남', null, null, sysdate, 10);

delete from mem_grade where grade_code = 10;

-- 자식테이블도 같이 삭제되는 방식
create table mem2(
mem_no number primary key,
mem_id varchar2(20) not null unique,
mem_pw varchar2(20) not null,
mem_name varchar2(20) not null,
gender char(3) check(gender in('남', '여')),
phone varchar2(13),
email varchar2(50),
mem_date date,
grade_id number,
foreign key(grade_id) references mem_grade on delete cascade
);

insert into mem2 values(1, 'user01', 'pass01', '홍길동', '남', null, null, sysdate, null);
insert into mem2 values(2, 'user02', 'pass02', '김길동', '여', null, null, sysdate, 10);
insert into mem2 values(3, 'user03', 'pass03', '여길녀', '여', null, null, sysdate, 20); 
insert into mem2 values(4, 'user04', 'pass04', '남길동', '남', null, null, sysdate, 10);

delete from mem_grade where grade_code = 10;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
default 기본값: 제약조건 아님
데이터 삽입시 데이터를 넣지 않을 경우  default값으로 삽입되게 함
*/

create table member2(
mem_no number primary key,
mem_id varchar2(20) not null,
mem_pw varchar2(20) not null,
mem_age number,
hobby varchar(20) default '없음',
mem_date date default sysdate
);

insert into member2 values (1, 'user01', 'p01', 24, '공부', '23/11/16');
insert into member2 values (2, 'user02', 'p02', null, null, null);
insert into member2 values (3, 'user03', 'p03', null, default, default);


--===========================================================================================================================================
--=============================================================aie 계정========================================================================
/*
subquery를 이용한 테이블 생성
테이블복사하는 개념

[표현식]
create table 테이블명
as 서버쿼리
*/

-- employee테이블을 복제한 새로운 테이블 생성
-- 컬럼, 데이터값, 제약조건(not null만) 복사됨
-- default, comment, primary key는 복사가 안됨
create table employee_copy as select * from employee;

create table employee_copy2 as select emp_id, emp_name, salary, bonus from employee;

-- where 1 = 0 => 테이블의 구조만 복사하고자 할 때 스이는 구문(데이터 값이 필요없을 때)
create table employee_copy3 as select emp_id, emp_name, salary, bonus from employee where 1 = 0;

-- 오류: 수식을 넣을 때는 별칭을 꼭 넣어줘야한다
--create table employee_copy4 as select emp_id, emp_name, salary*12 from employee;
create table employee_copy4 as select emp_id, emp_name, salary*12 연봉 from employee;

/*
alter: 테이블을 다 생성한 후에 제약조건 추가, 변경
alter table 테이블명 변경할 내용;

- add: alter table 테이블명 add primary key(컬럼명);
          alter table 테이블명 add foreign key(컬럼명) references 참조할 테이블명(참조할 컬럼명 -> pk라면 생략 가능);
          alter table 테이블명 add unique(컬럼명);
          alter table 테이블명 add check(컬럼에 대한 조건식);
- modify: alter table 테이블명 modify 컬럼명 not null;
*/

-- employee_copy테이블에 primary key 제약조건 추가
alter table employee_copy add primary key(emp_id);

