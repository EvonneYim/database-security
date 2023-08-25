--USE THE DATABASE
USE APU_SEPL
GO

--DROP DATABASE IF NECESSARY
--DROP DATABASE APU_SEPL


---==============================
--- STEP 02: TABLE CREATION
---==============================

---MEMBER TABLE
CREATE TABLE DBO.[MEMBER](
	MEM_ID INT IDENTITY(50001, 1) PRIMARY KEY,
	MEM_NRIC_PN VARBINARY(MAX),
	MEM_NAME VARCHAR(30) NOT NULL,
	MEM_ADDRESS VARBINARY(MAX),
	MEM_PHONE_NO VARCHAR(11),
	MEM_STATUS CHAR(7) DEFAULT 'ACTIVE',
	MEM_LOG_ID VARCHAR(8),
	MEM_REGISTER_DATE DATE NOT NULL DEFAULT GETDATE(),
);

---TRANSACTION TABLE
CREATE TABLE DBO.[TRANSACTION](
	TRANS_ID INT IDENTITY(10001, 1) PRIMARY KEY,
	TRANS_DATE DATE NOT NULL DEFAULT GETDATE(),
	MEM_ID INT FOREIGN KEY REFERENCES DBO.[MEMBER](MEM_ID) NOT NULL,
);

---CATEGORY TABLE
CREATE TABLE DBO.[CATEGORY](
	CAT_ID INT IDENTITY(1, 1) PRIMARY KEY,
	CAT_NAME VARCHAR(100) NOT NULL,
	CAT_DISCOUNT_NAME VARCHAR(100),
	CAT_DISCOUNT_VALUE DECIMAL(2,1),
);

---EQUIPMENT TABLE
CREATE TABLE DBO.[EQUIPMENT](
	EQ_ID INT IDENTITY(1, 1) PRIMARY KEY,
	EQ_NAME VARCHAR(60)  UNIQUE NOT NULL,
	EQ_PPU DECIMAL(5,2) NOT NULL,
	EQ_QUANTITY INT NOT NULL CHECK (EQ_QUANTITY BETWEEN 0 AND 500),
	EQ_COUNTRY VARCHAR(30),
	CAT_ID INT FOREIGN KEY REFERENCES DBO.[CATEGORY](CAT_ID) NOT NULL 
);

---EQ_TRANS TABLE
CREATE TABLE DBO.[EQ_TRANS](
TRANS_ID INT NOT NULL FOREIGN KEY REFERENCES DBO.[TRANSACTION](TRANS_ID),
EQ_ID INT NOT NULL FOREIGN KEY REFERENCES DBO.[EQUIPMENT](EQ_ID),
TRANS_QUANT_PURCHASED INT NOT NULL DEFAULT(1) CHECK (TRANS_QUANT_PURCHASED BETWEEN 1 AND 500),
PRIMARY KEY (TRANS_ID, EQ_ID)
);



----DROP MEMBER TABLE IF NECESSARY
DROP TABLE DBO.[MEMBER]
----DROP TRANSACTION TABLE IF NECESSARY
DROP TABLE DBO.[TRANSACTION]
----DROP CATEGORY TABLE IF NECESSARY
DROP TABLE DBO.[CATEGORY]
----DROP EQUIPMENT TABLE IF NECESSARY
DROP TABLE DBO.[EQUIPMENT]
----DROP EQ_TRANS TABLE IF NECESSARY
DROP TABLE DBO.[EQ_TRANS]


