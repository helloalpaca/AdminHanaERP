DROP TABLE SPECIFIC;

CREATE TABLE SPECIFIC (
	c_id NUMBER NOT NULL,
	spc_rank VARCHAR(10) DEFAULT '일반' NULL,
	spc_creditrank NUMBER(1) NULL,
    CONSTRAINT CK_SPECIFIC_SPC_RANK CHECK (spc_rank IN ('일반','VIP')),
	CONSTRAINT PK_SPECIFIC PRIMARY KEY (c_id),
	CONSTRAINT FK_CUSTOMER_TO_SPECIFIC_1 FOREIGN KEY (c_id) REFERENCES CUSTOMER (c_id) ON DELETE CASCADE
);

COMMENT ON COLUMN SPECIFIC.spc_rank IS '일반, VIP';

COMMENT ON COLUMN SPECIFIC.spc_creditrank IS '1~10';

--INSERT INTO SPECIFIC VALUES(1,'VIP',2);
insert into SPECIFIC (c_id, spc_rank, spc_creditrank) values (1, 'VIP', 6);

--공부용 !!아래 두개의 INSERT 문은 오류가 난다.
-- CK_SPECIFIC_SPC_RANK (CHECK) 에 의해 VIP2는 삽입될 수 없음.
INSERT INTO SPECIFIC VALUES(1,'VIP2',2);
-- FK_CUSTOMER_TO_SPECIFIC_1 (FOREIGN KEY)에 의해서
-- 손님(CUSTOMER) 테이블에 해당 c_id 가 없기 때문에 삽입 불가.
INSERT INTO SPECIFIC VALUES(4,'일반',2);
SELECT * FROM SPECIFIC;
--공부용 !! SQL 문에서 CREATE 를 하며 제약조건 CONSTRAINT를 걸거나 아래와 같이 따로도 ok.

--ALTER TABLE SPECIFIC ADD CONSTRAINT PK_SPECIFIC PRIMARY KEY (
--	c_id
--);
--
--ALTER TABLE SPECIFIC ADD CONSTRAINT FK_CUSTOMER_TO_SPECIFIC_1 FOREIGN KEY (
--	c_id
--) REFERENCES CUSTOMER (c_id);