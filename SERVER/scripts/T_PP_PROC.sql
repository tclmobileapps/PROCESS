CREATE TABLE T_PP_PROC
(
	cFunc	 			NVARCHAR(20)	NOT NULL,
	cProd	 			NVARCHAR(20)	NOT NULL,
	cProc				NVARCHAR(20)	NOT NULL,
	cName				NVARCHAR(100)	NOT NULL,
	nVersionMajor		DECIMAL(2)		NOT NULL,
	nVersionMinor		DECIMAL(3)		NOT NULL,
	cDate				NVARCHAR(8)		NOT NULL,
	nDisplayOrder		DECIMAL(2) 		NOT NULL,
	cIsActive			NVARCHAR(1) 	NOT NULL,
	PRIMARY KEY(cFunc, cProd, cProc),
	FOREIGN KEY(cFunc, cProd) REFERENCES T_PP_PROD(cFunc, cProd),
	CONSTRAINT C_PP_PROC_01 CHECK(cIsActive IN('Y','N'))
)
INSERT INTO T_PP_PROC VALUES('CFAB','AL','ACP','A/C Closure Process',1,1,'20140101',7,'Y');
INSERT INTO T_PP_PROC VALUES('CFAB','AL','CCP','Contract Creation Process',1,1,'20140101',4,'Y');
INSERT INTO T_PP_PROC VALUES('CFAB','AL','CSP','Credit Sanction Process',1,1,'20140101',3,'Y');
INSERT INTO T_PP_PROC VALUES('CFAB','AL','EMP','EMI Management Process',1,1,'20140101',5,'Y');
INSERT INTO T_PP_PROC VALUES('CFAB','AL','LMP','Lead Management Process',1,1,'20140101',1,'Y');
INSERT INTO T_PP_PROC VALUES('CFAB','AL','OCRP','Overdue Collection and Remedial Process',1,1,'20140101',6,'Y');
INSERT INTO T_PP_PROC VALUES('CFAB','AL','SAI','Sanctioning and Inwarding Process',1,1,'20140101',8,'Y');
INSERT INTO T_PP_PROC VALUES('CFAB','AL','SP','Sales Process',1,1,'20140101',2,'Y');
