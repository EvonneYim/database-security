--USE THE DATABASE
USE APU_SEPL
GO

---===========================================
--- STEP 12: ROW LEVEL SECURITY
---===========================================


------------------------------STEP 01: CREATE A SCHEMA FOR SECURITY------------------------------
-- ONE TIME CREATION STARTS HERE

CREATE SCHEMA Security;  
GO

-- TO VIEW SCHEMAS
SELECT * FROM sys.schemas WHERE name = 'Security';

------------------------------STEP 02: FUNCTION TO VALIDATE THE CURRENT USERNAME------------------------------
-- a. securitypredicate for user name 
CREATE OR ALTER FUNCTION Security.fn_securitypredicate
(
    @UserName AS nvarchar(100)
)  
RETURNS TABLE  
WITH SCHEMABINDING  
AS  
RETURN 
(
    SELECT 1 AS fn_securitypredicate_result
    WHERE @UserName = USER_NAME()
        OR USER_NAME() = 'dbo'
        OR IS_MEMBER('DBA') = 1
		OR IS_MEMBER('STORE_CLERKS') = 1
		OR IS_MEMBER('MANAGEMENT') = 1
);

-- b. securitypredicate for eq_trans table (filter trans_id and mem_id)
CREATE OR ALTER FUNCTION [Security].[fn_securitypredicate_trans_id] (
    @TRANS_ID AS INT,
    @UserName AS NVARCHAR(100)
)
RETURNS TABLE
WITH SCHEMABINDING
AS
RETURN
(
    SELECT 1 AS fn_security_result_1
    FROM dbo.[transaction] t
    WHERE 
    (
        (@TRANS_ID IS NULL AND @UserName NOT IN (SELECT DISTINCT CAST(MEM_ID AS NVARCHAR(100)) FROM dbo.[transaction])) 
        OR
        (
            @UserName = CAST(t.MEM_ID AS NVARCHAR(100)) AND
            @TRANS_ID IS NOT NULL AND
            @TRANS_ID = t.TRANS_ID
        )
        OR
        (
            USER_NAME() = 'dbo'
            OR IS_MEMBER('DBA') = 1
            OR IS_MEMBER('STORE_CLERKS') = 1
            OR IS_MEMBER('MANAGEMENT') = 1
        )
    )
);

-- ONE TIME CREATION ENDS HERE

-- TO VIEW FUNCTION
SELECT *
FROM sys.sql_modules
WHERE object_id = OBJECT_ID('Security.fn_securitypredicate');

------------------------------STEP 03: CREATE SECURITY POLICY AND APPLY TO OBJECT------------------------------
-- WILL CHECK WHENEVER THE USER PERFORM DML QUERIES 

---===========================================
--- MEMBER TABLE VIEWS
---===========================================

--UNCOMMENT IF NECESSARY
--DROP SECURITY POLICY [SecurityPolicy_MEMBER_TABLE]
--DROP SECURITY POLICY [SecurityPolicy_MEMBER_VIEW]  

/** RESTRICT FOR MEMBER TABLE (based on MEMBER ID)**/
CREATE SECURITY POLICY [SecurityPolicy_MEMBER_TABLE]   
ADD FILTER PREDICATE 
[Security].[fn_securitypredicate]([MEM_ID]) ON [dbo].[MEMBER] 

---===========================================
--- TRANSACTION TABLE VIEWS
---===========================================

--UNCOMMENT IF NECESSARY
--DROP SECURITY POLICY [SecurityPolicy_TRANS_TABLE] 
--DROP SECURITY POLICY [SecurityPolicy_TRANS_VIEW] 
--DROP SECURITY POLICY [SecurityPolicy_EQ_TRANS_TABLE] 

/** RESTRICT FOR TRANSACTION TABLE (based on MEMBER ID)**/
CREATE SECURITY POLICY [SecurityPolicy_TRANS_TABLE]   
ADD FILTER PREDICATE 
[Security].[fn_securitypredicate]([MEM_ID]) ON [dbo].[TRANSACTION]
--DROP SECURITY POLICY [SecurityPolicy_TRANS_TABLE]

/** RESTRICT FOR OWN TRANSACTION DETAILS VIEW (based on MEMBER ID)**/
CREATE SECURITY POLICY [SecurityPolicy_TRANS_VIEW]   
ADD FILTER PREDICATE [Security].[fn_securitypredicate]([MEM_ID]) ON [dbo].[OWN_TRANS_INFO_VIEW]

/** RESTRICT FOR EQ_TRANS TABLE (based on MEMBER ID)**/
CREATE SECURITY POLICY [SecurityPolicy_EQ_TRANS_TABLE]   
ADD FILTER PREDICATE [Security].[fn_securitypredicate_trans_id]([TRANS_ID], USER_NAME()) ON [dbo].[EQ_TRANS]


-- Testing 01 excecute as member
EXECUTE AS USER = '50005'
SELECT USER_NAME()

SELECT * FROM [OWN_MEMBER_INFO_VIEW]
SELECT * FROM  [MEMBER]
SELECT * FROM [OWN_TRANS_INFO_VIEW]
SELECT * FROM  [TRANSACTION]
SELECT * FROM  [EQ_TRANS]

REVERT
SELECT USER_NAME()

-- Testing 02 excecute as DBA (other roles)
EXECUTE AS USER = 'EVONNE'
SELECT USER_NAME()

SELECT * FROM [OWN_MEMBER_INFO_VIEW]
SELECT * FROM  [MEMBER]
SELECT * FROM [OWN_TRANS_INFO_VIEW]
SELECT * FROM  [TRANSACTION]
SELECT * FROM  [EQ_TRANS]

REVERT
SELECT USER_NAME()