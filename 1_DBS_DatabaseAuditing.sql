
---===========================
--- STEP 1: DATABASE AUDITING
---============================

--=====================================
--i)Login and logout
--=====================================
USE master;

--CREATE DATABASE FOR THE ASSIGNMENT
CREATE DATABASE APU_SEPL

-- Create server audit for login and logout
CREATE SERVER AUDIT LoginLogoutAudit
TO FILE (FILEPATH = 'C:\Temp_DBS');
GO

-- Enable the server audit
ALTER SERVER AUDIT LoginLogoutAudit WITH (STATE = ON);		--TURN OFF TO DELETE THE AUDIT FILES

CREATE SERVER AUDIT SPECIFICATION [LoginLogout_Specification]
FOR SERVER AUDIT [LoginLogoutAudit]
--ADD (SUCCESSFUL_DATABASE_AUTHENTICATION_GROUP), ADD(DATABASE_LOGOUT_GROUP), ADD(FAILED_DATABASE_AUTHENTICATION_GROUP)
ADD (SUCCESSFUL_LOGIN_GROUP), ADD(LOGOUT_GROUP), ADD(FAILED_LOGIN_GROUP)
WITH (STATE = ON);
GO


--DROP IF NECESSARY
ALTER SERVER AUDIT SPECIFICATION [LoginLogout_Specification] WITH (STATE = OFF);
DROP SERVER AUDIT SPECIFICATION [LoginLogout_Specification]


-- View audit data
DECLARE @AuditFilePath VARCHAR(8000);

Select @AuditFilePath = audit_file_path
From sys.dm_server_audit_status
where name = 'LoginLogoutAudit'

-- Details of the audit data
select event_time, action_id,session_server_principal_name,server_principal_name, server_instance_name
from sys.fn_get_audit_file(@AuditFilePath,default,default)
Where action_id in ('LGIS', 'LGO', 'LGIF') AND server_principal_name IN ('YEE', 'LI_WEI', 'EVONNE', '50003')
ORDER BY EVENT_TIME


EXECUTE AS USER = 'EVONNE'
REVERT
--=====================================
--ii) Database structural changes
--=====================================
USE master;

-- Create server audit for database structural changes
CREATE SERVER AUDIT DBSCAudit
TO FILE (FILEPATH = 'C:\Temp_DBS');
GO

-- Enable the server audit
ALTER SERVER AUDIT DBSCAudit WITH (STATE = ON);

CREATE SERVER AUDIT SPECIFICATION DBSC_Specification
FOR SERVER AUDIT DBSCAudit
ADD (SCHEMA_OBJECT_CHANGE_GROUP)  
WITH (STATE = ON);
GO


-- DROP IS NECESSARY
ALTER SERVER AUDIT SPECIFICATION [DBSC_Specification] WITH (STATE = OFF);
DROP SERVER AUDIT SPECIFICATION [DBSC_Specification]


-- View audit data
DECLARE @AuditFilePath VARCHAR(8000);

Select @AuditFilePath = audit_file_path
From sys.dm_server_audit_status
where name = 'DBSCAudit'

-- Details of the audit data
select action_id, event_time, database_name, database_principal_name, object_name, statement
from sys.fn_get_audit_file(@AuditFilePath,default,default)
Where database_name = 'APU_SEPL' and database_principal_name != 'dbo'


--TEST AUDIT
USE APU_SEPL
EXECUTE AS USER = 'EVONNE'
CREATE TABLE TEST2 (TEST INT PRIMARY KEY, UI INT)
ALTER TABLE TEST2 ADD INU INT
DROP TABLE TEST2
REVERT
SELECT USER_NAME()

--enable TRIGGER DROP_TABLE_WARNING ON DATABASE


--=====================================
--iii) Data changes
--=====================================
USE master;

-- Create server audit for data changes
CREATE SERVER AUDIT DataChangeAudit
TO FILE (FILEPATH = 'C:\Temp_DBS');
GO

-- Enable the server audit
ALTER SERVER AUDIT DataChangeAudit WITH (STATE = ON);

USE APU_SEPL

CREATE DATABASE AUDIT SPECIFICATION DataChange_Specification
FOR SERVER AUDIT DataChangeAudit
ADD ( INSERT, UPDATE, DELETE, SELECT ON DATABASE::APU_SEPL BY public) 
WITH (STATE = ON) ;   
GO

-- DROP IS NECESSARY
ALTER SERVER AUDIT SPECIFICATION [DataChange_Specification] WITH (STATE = OFF);
DROP SERVER AUDIT SPECIFICATION [DataChange_Specification]

-- View audit data
DECLARE @AuditFilePath VARCHAR(8000);

Select @AuditFilePath = audit_file_path
From sys.dm_server_audit_status
where name = 'DataChangeAudit'

-- Details of the audit data
select action_id, event_time, database_name, database_principal_name, object_name, statement
from sys.fn_get_audit_file(@AuditFilePath,default,default)
Where database_name = 'APU_SEPL' and database_principal_name != 'dbo' --and object_name IN ('MEMBER', 'OWN_MEMBER_INFO_VIEW', 'ALL_MEMBER_INFO_VIEW')
ORDER BY EVENT_TIME


--TEST AUDIT
USE APU_SEPL
EXECUTE AS USER = 'YEE'
INSERT INTO EQUIPMENT (EQ_NAME, EQ_PPU, EQ_QUANTITY, EQ_COUNTRY, CAT_ID)
VALUES ('Baseball Bat for Kids', 125, 30, 'China', 3)
UPDATE EQUIPMENT SET EQ_COUNTRY = 'Japan' WHERE EQ_ID = 7
DELETE EQUIPMENT WHERE EQ_ID = 7
SELECT * FROM EQUIPMENT
SELECT * FROM CATEGORY
REVERT
SELECT USER_NAME()


--=====================================
--iv) User permission changes
--=====================================
USE master;

CREATE SERVER AUDIT UserPermissionAudit
TO FILE (FILEPATH = 'C:\Temp_DBS');
GO

-- Enable the server audit
ALTER SERVER AUDIT UserPermissionAudit WITH (STATE = ON);

--Create a Database Audit Specification for User Permission Change
USE master;
GO

CREATE SERVER AUDIT SPECIFICATION UserPermission_Specification
FOR SERVER AUDIT UserPermissionAudit
ADD (SCHEMA_OBJECT_PERMISSION_CHANGE_GROUP), ADD (DATABASE_ROLE_MEMBER_CHANGE_GROUP), ADD (DATABASE_PRINCIPAL_CHANGE_GROUP)
WITH (STATE = ON);
GO

-- DROP IS NECESSARY
ALTER SERVER AUDIT SPECIFICATION [UserPermission_Specification] WITH (STATE = OFF);
DROP SERVER AUDIT SPECIFICATION [UserPermission_Specification]

-- View audit data
DECLARE @AuditFilePath VARCHAR(8000);

Select @AuditFilePath = audit_file_path
From sys.dm_server_audit_status
where name = 'UserPermissionAudit'

-- Details of the audit data
select action_id, event_time, database_name, database_principal_name, object_name, statement
from sys.fn_get_audit_file(@AuditFilePath,default,default)
Where database_name = 'APU_SEPL' and database_principal_name != 'dbo'


--TEST AUDIT
USE APU_SEPL
EXECUTE AS USER = 'EVONNE'
CREATE LOGIN [50001] WITH PASSWORD = '12345'
CREATE USER [50001] FOR LOGIN [50001]
ALTER ROLE [MEMBERS] ADD MEMBER [50001]
GRANT SELECT ON [MEMBER] TO [MEMBERS]
REVOKE SELECT ON [MEMBER] TO [MEMBERS]
EXEC SP_DROPROLEMEMBER MEMBERS, 50001
DROP USER [50001]
REVERT
SELECT USER_NAME()

