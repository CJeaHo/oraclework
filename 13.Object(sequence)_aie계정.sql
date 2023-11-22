/*
시퀀스(sequence)
자동으로 번호를 발생시켜주는 역할을 하는 객체
정수값을 순차적으로 일정값씩 증가시키면서 생성

ex) 회원번호, 사원번호, 게시글번호,...
*/

/*
시퀀스 객체 생성

[표현식]
create sequence 시퀀스명
[start with 시작숫자] -> 처음 발생시킬 시작값 지정(기본값은 1)
[increment by 숫자]  -> 몇 씩 증가시킬 것인지(기본값은 1)
[maxvalue 숫자] -> 최대값 지정(기본값은 불가사의)
[minvalue 숫자] -> 최소값 지정(기본값은 1)
[nocycle | cycle] -> 값 순환 여부 지정(기본값은 nocycle)
[cache | nocache] -> 캐시메모리 할당(기본값 cache 20)
*캐시메모리: 미리 발생될 값들을 생성해서 저장해두는 공간
                    매번 호출할 때마다 새롭게 번호를 생성하는게 아니라
                    캐시메모리 고간에 미리 생성된 값들을 가져다 쓸 수 있음(속도가 빨라짐)
                    접속이 해제되면 -> 캐시메모리에 미리 만들어둔 번호 다 날라감

테이블명: tb_
뷰명: vw_
시퀀스명: seq_
트리거명: trg_
*/

-- 시퀀스 생성
create sequence seq_test;

-- [참고] 현재 계정이 소유하고 있는 시퀀스들의 구조를 보고자 할 때
select * from user_sequences;

----------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
시퀀스 사용
시퀀스명.currval: 현재 시퀀스 값(마지막으로 성공한 nextval의 값)
시퀀스명.nextval: 시퀀스 값에 일정값을 증가시켜 나온 값
                          현재 시퀀스 값에서  increment by값 만큼 증가된 값
                          == 시퀀스명.currval + increment by 값
*/

create sequence seq_empno
start with 400
increment by 5
maxvalue 410
nocycle
nocache;

select seq_empno.currval from dual; -- nextval를 단 한번도 수행하지 않는 이상 currval할 수 없음

select seq_empno.nextval from dual; -- nextval 수행 400
select seq_empno.currval from dual; -- 400
select seq_empno.nextval from dual; -- 405
select seq_empno.nextval from dual; -- 410 (maxvalue)

select seq_empno.nextval from dual; -- exceeds MAXVALUE은 사례로 될 수 없습니다
-- nocycle에 maxval값을 초과하면 오류발생

select seq_empno.currval from dual; -- 410

/*
시퀀스 구조 변경
alter sequence 시퀀스명
[increment by 숫자]
[maxvalue 숫자]
[minvalue 숫자]
[nocycle | cycle]
[cache | nocache]
*/

alter sequence seq_empno
increment by 10 
maxvalue 1000;

select * from user_sequences;

select seq_empno.nextval from dual; -- 420

/*
시퀀스 삭제
drop sequence 시퀀스명;
*/

drop sequence seq_empno;

------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 사원번호로 활용할 경우
create sequence seq_eid
start with 303;

insert into employee (emp_id, emp_name, emp_no, job_code, hire_date)
values (seq_eid.nextval, '홍길동', '123456-1234567', 'J7', sysdate);




















