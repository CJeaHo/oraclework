/*
<함수>
전달된 컬럼값을 읽어들여 함수를 실행한 결과 반환

- 단일행 함수: N개의 값을 읽어들여 N개의 결과값을 반환(매 행마다 함수 실행)
- 그룹 함수:  N개의 값을 읽어들여 1개의 결과값을 반환(그룹별로 함수 실행)

>> select절에 단일행 함수와 그룹 함수를 함께 사용 불가
>> 함수식을 기술할 수 있는 위치: select절, where절, order by절, having절

--------------------------------------------- 단일 행 함수 ----------------------------------------------
==================================================================================
                                                            <문자 처리 함수>
==================================================================================
*/

/*
length/lengthb => number로 반환
length(컬럼 | '문자열'): 해당 문자열의 글자수 반환
lengthb(컬럼 | '문자열'): 해당 문자열의 byte 반환
- 한글: XE 버전일 때 => 1글자당 3byte(ㄱ ㄴ ㄷ ㄹ ㅏ ㅑ ㅏ ㅕ 이런 것들도 1글자에 해당)
           EE 버전일 때 => 1글자당 2byte
- 그 외: 1글자당 1byte
*/

-- dual: 오라클에서 제공하는 가상 테이블
select length('오라클') || '글자' , lengthb('오라클') || 'byte' from dual; 

select length('oracle') || '글자' , lengthb('oracle') || 'byte' from dual; 

select length('ㅇㅗㄹㅏ') || '글자' , lengthb('ㅇㅗㄹㅏ') || 'byte' from dual;

select emp_name, length(emp_name) || '글자', lengthb(emp_name) || 'byte', email, length(email) || '글자', lengthb(email) || 'byte' from employee;

-------------------------------------------------------------------------단일 행 함수 --------------------------------------------------------------------------

/*
instr: 문자열로부터 특정 무낮의 시작위치(index)를 찾아서 반환(반환형 number)
>>oracle에서 index번호는 1부터 시작

instr(컬럼 | '문자열', '찾을 문자열', [찾을 위치의 시작값, [순번])
1: 앞에서부터 찾기(기본값)
-1: 뒤에서부터 찾기
*/

select instr('javascriptjavaoracle', 'a') from dual; -- 결과: 2, 앞
select instr('javascriptjavaoracle', 'a', 1) from dual; -- 결과: 2, 앞
select instr('javascriptjavaoracle', 'a', -1) from dual; -- 결과: 17, 뒤
select instr('javascriptjavaoracle', 'a', 1, 3) from dual; -- 결과: 12, 앞에서부터 3번째 a
select instr('javascriptjavaoracle', 'a', 3) from dual; -- 결과: 4, random
select instr('javascriptjavaoracle', 'a', -1, 2) from dual; -- 결과: 14, 뒤에서 2번째

select email, instr(email, '_') "_위치", instr(email, '@') "@위치" from employee;