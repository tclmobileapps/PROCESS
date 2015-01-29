CREATE TABLE T_PP_PROCESS_DATA
(
	cProcess 			NVARCHAR(20)	NOT NULL,
	nRow				DECIMAL(2) 		NOT NULL,
	cSrl				NVARCHAR(20)	NOT NULL,
	cStep	 			NVARCHAR(2000)	NOT NULL,
	cControl 			NVARCHAR(2000)	    NULL,
	cResponsibility		NVARCHAR(2000)	    NULL,
	cMetrics 			NVARCHAR(2000)	    NULL,
	nMergeRows			DECIMAL(4)		NOT NULL,
	cIsMergeStart		NVARCHAR(1)		NOT NULL,
	cIsMergeEnd			NVARCHAR(1)		NOT NULL,
	PRIMARY KEY(cProcess, nRow),
	FOREIGN KEY(cProcess) REFERENCES T_PP_PROCESS(cProcess),
	CONSTRAINT C_PP_PROCESS_DATA_01 CHECK(cIsMergeStart IN('Y','N')),
	CONSTRAINT C_PP_PROCESS_DATA_02 CHECK(cIsMergeEnd IN('Y','N'))
);