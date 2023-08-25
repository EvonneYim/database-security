
---===================================
--- STEP 05: CREATE LOGIN, USER, ROLES 
---===================================

--USE THE DATABASE
USE APU_SEPL
GO

--CREATE ROLES
CREATE ROLE [MANAGEMENT]
GO
CREATE ROLE [DBA]
GO
CREATE ROLE [STORE_CLERKS]
GO
CREATE ROLE [MEMBERS]
GO


--CREATE MANAGEMENT LOGIN
CREATE LOGIN [LI_WEI] WITH PASSWORD = '12345'

---CREATE USER ASSOCIATED WITH THE LOGIN
CREATE USER [LI_WEI] FOR LOGIN [LI_WEI]

---ASSIGN ROLE TO USER
ALTER ROLE [MANAGEMENT] ADD MEMBER [LI_WEI]
GO


--CREATE DBA LOGIN
CREATE LOGIN [EVONNE] WITH PASSWORD = '12345'

---CREATE USER ASSOCIATED WITH THE LOGIN
CREATE USER [EVONNE] FOR LOGIN [EVONNE]

---ASSIGN ROLE TO USER
ALTER ROLE [DBA] ADD MEMBER [EVONNE]
GO


--CREATE STORE CLERK LOGIN
CREATE LOGIN [YEE] WITH PASSWORD = '12345'

---CREATE USER ASSOCIATED WITH THE LOGIN
CREATE USER [YEE] FOR LOGIN [YEE]

---ASSIGN ROLE TO USER
ALTER ROLE [STORE_CLERKS] ADD MEMBER [YEE]
GO


--CREATE MEMBERS LOGIN
CREATE LOGIN [50004] WITH PASSWORD = '12345' -- YUKI
CREATE LOGIN [50005] WITH PASSWORD = '12345' -- TAN
CREATE LOGIN [50003] WITH PASSWORD = '12345'

---CREATE USER ASSOCIATED WITH THE LOGIN
CREATE USER [50004] FOR LOGIN [50004]
CREATE USER [50005] FOR LOGIN [50005]
CREATE USER [50003] FOR LOGIN [50003]

---ASSIGN ROLE TO USER
ALTER ROLE [MEMBERS] ADD MEMBER [50004]
GO
ALTER ROLE [MEMBERS] ADD MEMBER [50005]
GO
ALTER ROLE [MEMBERS] ADD MEMBER [50003]
GO

--================================================================
-- CHEKCING PURPOSE
--================================================================

--CHECK SQL SERVER LOGINS CREDENTIALS (created on '2023-07-24') 
SELECT [LOGINNAME], * 
FROM  SYSLOGINS 
WHERE CAST([CREATEDATE]  AS DATE) ='2023-07-26'

--TO VIEW ROLES DATABASE-LEVEL ROLES
--ROLES (R), APPLICATION ROLES (A), AND BUILT-IN ROLES (G)

SELECT NAME AS 'ROLE NAME', TYPE_DESC AS 'TYPE'
FROM SYS.DATABASE_PRINCIPALS
WHERE TYPE IN ('R', 'A', 'G')

-- SPECIFIC USERS INFO
SELECT NAME, * FROM SYS.sysusers WHERE NAME IN ('LI_WEI', 'EVONNE','YEE','YUKI','TAN')

-- TO VIEW MEMBERS IN EACH ROLE
-- MANAGEMENT ROLE
SELECT r.name AS RoleName, m.name AS MemberName
FROM sys.database_role_members drm
JOIN sys.database_principals r ON drm.role_principal_id = r.principal_id
JOIN sys.database_principals m ON drm.member_principal_id = m.principal_id
WHERE r.name = 'MANAGEMENT'

-- DBA ROLE
SELECT r.name AS RoleName, m.name AS MemberName
FROM sys.database_role_members drm
JOIN sys.database_principals r ON drm.role_principal_id = r.principal_id
JOIN sys.database_principals m ON drm.member_principal_id = m.principal_id
WHERE r.name = 'DBA'

-- STORE_CLERKS ROLE
SELECT r.name AS RoleName, m.name AS MemberName
FROM sys.database_role_members drm
JOIN sys.database_principals r ON drm.role_principal_id = r.principal_id
JOIN sys.database_principals m ON drm.member_principal_id = m.principal_id
WHERE r.name = 'STORE_CLERKS'

-- MEMBERS ROLE
SELECT r.name AS RoleName, m.name AS MemberName
FROM sys.database_role_members drm
JOIN sys.database_principals r ON drm.role_principal_id = r.principal_id
JOIN sys.database_principals m ON drm.member_principal_id = m.principal_id
WHERE r.name = 'MEMBERS'