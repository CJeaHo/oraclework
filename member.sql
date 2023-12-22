CREATE TABLE member (
id VARCHAR2(20) PRIMARY KEY,
pwd VARCHAR2(20) NOT NULL,
name VARCHAR2(20) NOT NULL,
gender CHAR(1),
birthday CHAR(6),
email VARCHAR2(30),
zipcode CHAR(5),
address VARCHAR2(100),
detail_address VARCHAR2(50),
hobby CHAR(5),
job VARCHAR2(30)
);



INSERT INTO MEMBER VALUES('kim', '1234', '홍길동', '1', '231205', 'kim@naver.com', '12345', '서울특별시 영등포구 당산동 이레빌딩', '19층','11001','학생');
INSERT INTO MEMBER VALUES('lee', '1234', '이길동', '2', '231115', 'lee@naver.com', '23456', '인천광역시 남동구 구월동', '17층','10001','교수');
INSERT INTO MEMBER VALUES('park', '1234', '박길동', '1', '231021', 'park@naver.com', '34567', '경기도 성남시 수정구', '수정아파트','01010','공무원');