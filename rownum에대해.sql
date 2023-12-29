select *
from (select * from board order by ref desc, pos)
where rownum >= 11 and rownum <= 20; 
-- rownum은 기준 1에서 데이터를 상대적인 번호로 검색해 온다
-- 기준 1번이 없어서 검색 안됨

select rownum, bt1.*
from (select * from board order by ref desc, pos) bt1
where rownum >= 1 and rownum <= 10; 
-- rownum을 출력하면서 서브쿼리 테이블의 모든 컬럼을 가져오려면 반드시 서브쿼리에 별칭 부여해야한다

select *
from (select rownum rnum, bt1.* from (select * from board order by ref desc, pos) bt1) -- 서브쿼리에 rownum이 1부터 모두 들어있어야한다
where rnum >= 11 and rnum <= 20; 

select *
from (select rownum rnum, bt1.* from (select * from board order by ref desc, pos) bt1) -- 서브쿼리에 rownum이 1부터 모두 들어있어야한다
where rnum >= ? and rnum <= ?; 