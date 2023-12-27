CREATE TABLE p_member (
    p_no VARCHAR2(20) CONSTRAINT pk_p_member PRIMARY KEY,
    p_id VARCHAR2(30) CONSTRAINT uc_p_member_id UNIQUE NOT NULL,
    p_pw VARCHAR2(30) NOT NULL,
    p_name VARCHAR2(20) NOT NULL,
    p_nickname VARCHAR2(30) NOT NULL,
    p_email VARCHAR2(50) NOT NULL,
    p_phone VARCHAR2(20) NOT NULL,
    p_regdate DATE DEFAULT SYSDATE NOT NULL,
    p_yn NUMBER(3) DEFAULT 0 NOT NULL
);

CREATE SEQUENCE p_member_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE FUNCTION real_p_member_no
RETURN VARCHAR2
AS
  s_no     NUMBER;
  s_result VARCHAR2(20);
BEGIN
  SELECT p_member_seq.NEXTVAL INTO s_no FROM DUAL;
  s_result := 'p000' || s_no;
  RETURN s_result;
END real_p_member_no;
/

CREATE OR REPLACE TRIGGER trg_real_p_member_no
BEFORE INSERT ON p_member
FOR EACH ROW
BEGIN
  :NEW.p_no := real_p_member_no();
END;
/

CREATE TABLE e_member (
    e_no VARCHAR2(20) CONSTRAINT pk_e_member PRIMARY KEY,
    e_id VARCHAR2(30) CONSTRAINT uc_e_member_id UNIQUE NOT NULL,
    e_pw VARCHAR2(30) NOT NULL,
    e_name VARCHAR2(20) NOT NULL,
    e_email VARCHAR2(50) NOT NULL,
    e_zipcode NUMBER NOT NULL,
    e_addr1 VARCHAR(100) NOT NULL,
    e_addr2 VARCHAR2(50) NULL,
    e_phone VARCHAR2(20) NOT NULL,
    e_bizno VARCHAR2(30) NOT NULL,
    e_depyo VARCHAR2(20) NOT NULL,
    e_regdate DATE DEFAULT SYSDATE NOT NULL,
    e_yn NUMBER(3) DEFAULT 0 NOT NULL
);

CREATE SEQUENCE e_member_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE FUNCTION real_e_member_no
RETURN VARCHAR2
AS
  s_no     NUMBER;
  s_result VARCHAR2(20);
BEGIN
  SELECT e_member_seq.NEXTVAL INTO s_no FROM DUAL;
  s_result := 'e000' || s_no;
  RETURN s_result;
END real_e_member_no;
/

CREATE OR REPLACE TRIGGER trg_real_e_member_no
BEFORE INSERT ON e_member
FOR EACH ROW
BEGIN
  :NEW.e_no := real_e_member_no();
END;
/

CREATE TABLE jobsearchboard (
    js_no NUMBER CONSTRAINT pk_jobsearchboard PRIMARY KEY,
    p_no VARCHAR2(20) NOT NULL,
    js_title VARCHAR2(30) NOT NULL,
    js_date DATE DEFAULT SYSDATE NOT NULL
);

ALTER TABLE jobsearchboard ADD CONSTRAINT fk_jobsearchboard_p_member FOREIGN KEY (p_no) REFERENCES p_member (p_no);

CREATE TABLE clean_info (
    js_no NUMBER NOT NULL,
    clean_kind NUMBER NOT NULL,
    clean_option NUMBER NOT NULL,
    home_style NUMBER NOT NULL,
    room_count NUMBER NOT NULL,
    restroom_count NUMBER NOT NULL,
    veranda_count NUMBER NOT NULL,
    pyungsu NUMBER NOT NULL,
    needs VARCHAR2(100) NULL,
    clean_date DATE NOT NULL,
    clean_time DATE NOT NULL,
    clean_addr1 VARCHAR2(100) NOT NULL,
    clean_addr2 VARCHAR2(50) NOT NULL
);

ALTER TABLE clean_info ADD CONSTRAINT fk_clean_info_jobsearchboard FOREIGN KEY (js_no) REFERENCES jobsearchboard (js_no);

CREATE TABLE request (
    req_no NUMBER CONSTRAINT pk_request PRIMARY KEY,
    js_no NUMBER NOT NULL,
    e_no VARCHAR2(20) NOT NULL,
    req_content VARCHAR2(100) NOT NULL,
    req_cost NUMBER NOT NULL,
    req_yn NUMBER(3) DEFAULT 0 NOT NULL
);

ALTER TABLE request ADD CONSTRAINT fk_request_jobsearchboard FOREIGN KEY (js_no) REFERENCES jobsearchboard (js_no);
ALTER TABLE request ADD CONSTRAINT fk_request_e_member FOREIGN KEY (e_no) REFERENCES e_member (e_no);

CREATE TABLE review (
    re_no NUMBER CONSTRAINT pk_review PRIMARY KEY,
    p_no VARCHAR2(20) NOT NULL,
    re_content VARCHAR2(50) NULL,
    starpoint NUMBER NOT NULL,
    re_date DATE DEFAULT SYSDATE NOT NULL
);

ALTER TABLE review ADD CONSTRAINT fk_review_p_member FOREIGN KEY (p_no) REFERENCES p_member (p_no);

CREATE TABLE reservation (
    res_no NUMBER CONSTRAINT pk_reservation PRIMARY KEY,
    p_no VARCHAR2(20) NOT NULL,
    e_no VARCHAR2(20) NOT NULL,
    req_no NUMBER NOT NULL,
    res_cost NUMBER NOT NULL,
    res_yn NUMBER(3) DEFAULT 0 NOT NULL
);

ALTER TABLE reservation ADD CONSTRAINT fk_reservation_p_member FOREIGN KEY (p_no) REFERENCES p_member (p_no);
ALTER TABLE reservation ADD CONSTRAINT fk_reservation_e_member FOREIGN KEY (e_no) REFERENCES e_member (e_no);
ALTER TABLE reservation ADD CONSTRAINT fk_reservation_request FOREIGN KEY (req_no) REFERENCES request (req_no);

CREATE TABLE clean_situation (
    clean_no NUMBER CONSTRAINT pk_clean_situation PRIMARY KEY,
    res_no NUMBER NOT NULL,
    pay_no NUMBER NOT NULL,
    m_id VARCHAR2(30) NOT NULL,
    clean_yn NUMBER(3) DEFAULT 0 NOT NULL,
    clean_start DATE DEFAULT SYSDATE NOT NULL,
    clean_end DATE DEFAULT SYSDATE NOT NULL
);

ALTER TABLE clean_situation ADD CONSTRAINT fk_clean_situation_reservation FOREIGN KEY (res_no) REFERENCES reservation (res_no);
ALTER TABLE clean_situation ADD CONSTRAINT fk_clean_situation_pay FOREIGN KEY (pay_no) REFERENCES pay (pay_no);
ALTER TABLE clean_situation ADD CONSTRAINT fk_clean_situation_manager FOREIGN KEY (m_id) REFERENCES manager (m_id);

CREATE TABLE zzim (
    zzim_no NUMBER CONSTRAINT pk_zzim PRIMARY KEY,
    p_no VARCHAR2(20) NOT NULL,
    e_no VARCHAR2(20) NOT NULL,
    zzim_yn NUMBER(3) DEFAULT 0 NOT NULL,
    zzim_date DATE DEFAULT SYSDATE NOT NULL
);

ALTER TABLE zzim ADD CONSTRAINT fk_zzim_p_member FOREIGN KEY (p_no) REFERENCES p_member (p_no);
ALTER TABLE zzim ADD CONSTRAINT fk_zzim_e_member FOREIGN KEY (e_no) REFERENCES e_member (e_no);

CREATE TABLE p_alarm (
    p_alno NUMBER CONSTRAINT pk_p_alarm PRIMARY KEY,
    p_qnano NUMBER NOT NULL,
    p_ansno NUMBER NOT NULL,
    clean_no NUMBER NOT NULL,
    res_no NUMBER NOT NULL,
    req_no NUMBER NOT NULL,
    p_altime DATE DEFAULT SYSDATE NOT NULL
);

ALTER TABLE p_alarm ADD CONSTRAINT fk_p_alarm_p_qna FOREIGN KEY (p_qnano) REFERENCES p_qna (p_qnano);
ALTER TABLE p_alarm ADD CONSTRAINT fk_p_alarm_p_answer FOREIGN KEY (p_ansno) REFERENCES p_answer (p_ansno);
ALTER TABLE p_alarm ADD CONSTRAINT fk_p_alarm_clean_situation FOREIGN KEY (clean_no) REFERENCES clean_situation (clean_no);
ALTER TABLE p_alarm ADD CONSTRAINT fk_p_alarm_reservation FOREIGN KEY (res_no) REFERENCES reservation (res_no);
ALTER TABLE p_alarm ADD CONSTRAINT fk_p_alarm_request FOREIGN KEY (req_no) REFERENCES request (req_no);

CREATE TABLE manager (
    m_id VARCHAR2(30) CONSTRAINT pk_manager PRIMARY KEY,
    m_pw VARCHAR2(30) NOT NULL
);

CREATE TABLE blacklist (
    black_no NUMBER CONSTRAINT pk_blacklist PRIMARY KEY,
    m_id VARCHAR2(30) NOT NULL,
    p_no VARCHAR2(20) NOT NULL,
    e_no VARCHAR2(20) NOT NULL,
    black_yn NUMBER(3) DEFAULT 0 NOT NULL
);

ALTER TABLE blacklist ADD CONSTRAINT fk_blacklist_manager FOREIGN KEY (m_id) REFERENCES manager (m_id);
ALTER TABLE blacklist ADD CONSTRAINT fk_blacklist_p_member FOREIGN KEY (p_no) REFERENCES p_member (p_no);
ALTER TABLE blacklist ADD CONSTRAINT fk_blacklist_e_member FOREIGN KEY (e_no) REFERENCES e_member (e_no);

CREATE TABLE e_alarm (
    e_alno NUMBER CONSTRAINT pk_e_alarm PRIMARY KEY,
    pay_no NUMBER NOT NULL,
    res_no NUMBER NOT NULL,
    e_ansno NUMBER NOT NULL,
    e_qnano NUMBER NOT NULL,
    e_no VARCHAR2(20) NOT NULL,
    e_altime DATE DEFAULT SYSDATE NOT NULL
);

ALTER TABLE e_alarm ADD CONSTRAINT fk_e_alarm_pay FOREIGN KEY (pay_no) REFERENCES pay (pay_no);
ALTER TABLE e_alarm ADD CONSTRAINT fk_e_alarm_reservation FOREIGN KEY (res_no) REFERENCES reservation (res_no);
ALTER TABLE e_alarm ADD CONSTRAINT fk_e_alarm_e_member FOREIGN KEY (e_no) REFERENCES e_member (e_no);
ALTER TABLE e_alarm ADD CONSTRAINT fk_e_alarm_e_qna FOREIGN KEY (e_qnano) REFERENCES e_qna (e_qnano);
ALTER TABLE e_alarm ADD CONSTRAINT fk_e_alarm_e_answer FOREIGN KEY (e_ansno) REFERENCES e_answer (e_ansno);

CREATE TABLE pay (
    pay_no NUMBER CONSTRAINT pk_pay PRIMARY KEY,
    p_no VARCHAR2(20) NOT NULL,
    pay_yn NUMBER(3) DEFAULT 0 NOT NULL,
    pay_time DATE DEFAULT SYSDATE NOT NULL,
    pay_money NUMBER NOT NULL,
    pay_type NUMBER NOT NULL
);

ALTER TABLE pay ADD CONSTRAINT fk_pay_p_member FOREIGN KEY (p_no) REFERENCES p_member (p_no);

CREATE TABLE p_qna (
    p_qnano NUMBER CONSTRAINT pk_p_qna PRIMARY KEY,
    m_id VARCHAR2(30) NOT NULL,
    p_no VARCHAR2(20) NOT NULL,
    p_qnacate NUMBER NOT NULL,
    p_qnatitle VARCHAR2(40) NOT NULL,
    p_qnacontent VARCHAR2(100) NOT NULL,
    p_qnadate DATE DEFAULT SYSDATE NOT NULL
);

ALTER TABLE p_qna ADD CONSTRAINT fk_p_qna_manager FOREIGN KEY (m_id) REFERENCES manager (m_id);
ALTER TABLE p_qna ADD CONSTRAINT fk_p_qna_p_member FOREIGN KEY (p_no) REFERENCES p_member (p_no);

CREATE TABLE e_qna (
    e_qnano NUMBER CONSTRAINT pk_e_qna PRIMARY KEY,
    m_id VARCHAR2(30) NOT NULL,
    e_no VARCHAR2(20) NOT NULL,
    e_qnacate NUMBER NOT NULL,
    e_qnatitle VARCHAR2(40) NOT NULL,
    e_qnacontent VARCHAR2(100) NOT NULL,
    e_qnadate DATE DEFAULT SYSDATE NOT NULL
);

ALTER TABLE e_qna ADD CONSTRAINT fk_e_qna_manager FOREIGN KEY (m_id) REFERENCES manager (m_id);
ALTER TABLE e_qna ADD CONSTRAINT fk_e_qna_e_member FOREIGN KEY (e_no) REFERENCES e_member (e_no);

CREATE TABLE p_answer (
    p_ansno NUMBER CONSTRAINT pk_p_answer PRIMARY KEY,
    p_qnano NUMBER NOT NULL,
    p_anscontent VARCHAR2(50) NOT NULL,
    p_ansdate DATE DEFAULT SYSDATE NOT NULL,
    p_ansyn NUMBER(3) DEFAULT 0 NOT NULL
);

ALTER TABLE p_answer ADD CONSTRAINT fk_p_answer_p_qna FOREIGN KEY (p_qnano) REFERENCES p_qna (p_qnano);

CREATE TABLE e_answer (
    e_ansno NUMBER CONSTRAINT pk_e_answer PRIMARY KEY,
    e_qnano NUMBER NOT NULL,
    e_anscontent VARCHAR2(50) NOT NULL,
    e_ansdate DATE DEFAULT SYSDATE NOT NULL,
    e_ansyn NUMBER(3) DEFAULT 0 NOT NULL
);

ALTER TABLE e_answer ADD CONSTRAINT fk_e_answer_e_qna FOREIGN KEY (e_qnano) REFERENCES e_qna (e_qnano);








