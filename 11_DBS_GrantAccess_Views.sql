--USE THE DATABASE
USE APU_SEPL
GO

---============================
--- STEP 11: GRANT VIEW ACCESS 
---============================


------------------------------VIEW LEVEL: MEMBER------------------------------
GRANT SELECT ON DBO.EXPIRE_MEMBER_VIEW TO STORE_CLERKS
GRANT SELECT ON DBO.EXPIRE_MEMBER_VIEW TO MANAGEMENT
DENY INSERT, UPDATE, DELETE ON DBO.EXPIRE_MEMBER_VIEW TO DBA

GRANT SELECT ON DBO.ACTIVE_MEMBER_VIEW TO STORE_CLERKS
GRANT SELECT ON DBO.ACTIVE_MEMBER_VIEW TO MANAGEMENT
DENY INSERT, UPDATE, DELETE ON DBO.ACTIVE_MEMBER_VIEW TO DBA

GRANT SELECT, UPDATE ON DBO.OWN_MEMBER_INFO_VIEW TO MEMBERS
DENY SELECT, INSERT, UPDATE, DELETE ON DBO.OWN_MEMBER_INFO_VIEW TO DBA

GRANT SELECT, INSERT, UPDATE ON DBO.ALL_MEMBER_INFO_VIEW TO STORE_CLERKS
GRANT SELECT ON DBO.ALL_MEMBER_INFO_VIEW TO MANAGEMENT
DENY SELECT, INSERT, UPDATE, DELETE ON DBO.ALL_MEMBER_INFO_VIEW TO DBA


----TEST ACCESS
Execute as User = '50004'
Execute as User = 'YEE'
Execute as User = 'EVONNE'
Execute as User = 'LI_WEI'
SELECT * FROM EXPIRE_MEMBER_VIEW
SELECT * FROM ACTIVE_MEMBER_VIEW
SELECT * FROM OWN_MEMBER_INFO_VIEW
SELECT * FROM ALL_MEMBER_INFO_VIEW
REVERT

SELECT user_name()


------------------------------VIEW LEVEL: TRANSACTION------------------------------
GRANT SELECT ON DBO.OWN_TRANS_INFO_VIEW TO MEMBERS
DENY SELECT, INSERT, UPDATE, DELETE ON DBO.OWN_TRANS_INFO_VIEW TO DBA

GRANT SELECT ON DBO.EXPENSIVE_TRANS_VIEW TO STORE_CLERKS
GRANT SELECT ON DBO.EXPENSIVE_TRANS_VIEW TO MANAGEMENT
DENY SELECT, INSERT, UPDATE, DELETE ON DBO.EXPENSIVE_TRANS_VIEW TO DBA

GRANT SELECT ON DBO.TRANS_EXCEED_1000_VIEW TO STORE_CLERKS
GRANT SELECT ON DBO.TRANS_EXCEED_1000_VIEW TO MANAGEMENT
DENY SELECT, INSERT, UPDATE, DELETE ON DBO.TRANS_EXCEED_1000_VIEW TO DBA

GRANT SELECT ON DBO.RECENT_TRANS TO STORE_CLERKS
GRANT SELECT ON DBO.RECENT_TRANS TO MANAGEMENT
DENY SELECT, INSERT, UPDATE, DELETE ON DBO.RECENT_TRANS TO DBA


----TEST ACCESS
Execute as User = '50004'
Execute as User = 'YEE'
Execute as User = 'EVONNE'
Execute as User = 'LI_WEI'
SELECT * FROM OWN_TRANS_INFO_VIEW
SELECT * FROM EXPENSIVE_TRANS_VIEW
SELECT * FROM TRANS_EXCEED_1000_VIEW
SELECT * FROM RECENT_TRANS ORDER BY TRANS_DATE DESC
REVERT

SELECT user_name()


------------------------------VIEW LEVEL: CATEGORY------------------------------
GRANT SELECT ON DBO.AVAILABLE_CAT_DISCOUNT_VIEW TO MEMBERS
GRANT SELECT ON DBO.AVAILABLE_CAT_DISCOUNT_VIEW TO STORE_CLERKS
GRANT SELECT ON DBO.AVAILABLE_CAT_DISCOUNT_VIEW TO MANAGEMENT
DENY SELECT, INSERT, UPDATE, DELETE ON DBO.AVAILABLE_CAT_DISCOUNT_VIEW TO DBA

GRANT SELECT ON DBO.CATEGORIES_WITH_COUNT_VIEW  TO STORE_CLERKS
GRANT SELECT ON DBO.CATEGORIES_WITH_COUNT_VIEW  TO MANAGEMENT
DENY SELECT, INSERT, UPDATE, DELETE ON DBO.CATEGORIES_WITH_COUNT_VIEW  TO DBA


----TEST ACCESS
Execute as User = '50004'
Execute as User = 'YEE'
Execute as User = 'EVONNE'
Execute as User = 'LI_WEI'
SELECT * FROM AVAILABLE_CAT_DISCOUNT_VIEW
SELECT* FROM CATEGORIES_WITH_COUNT_VIEW
REVERT

SELECT user_name()


------------------------------VIEW LEVEL: EQUIPMENT------------------------------
GRANT SELECT ON DBO.CHECK_LESS_EQPMENT_VIEW  TO STORE_CLERKS
GRANT SELECT ON DBO.CHECK_LESS_EQPMENT_VIEW  TO MANAGEMENT
DENY SELECT, INSERT, UPDATE, DELETE ON DBO.CHECK_LESS_EQPMENT_VIEW  TO DBA

GRANT SELECT ON DBO.CHECK_MORE_EQPMENT_VIEW  TO STORE_CLERKS
GRANT SELECT ON DBO.CHECK_MORE_EQPMENT_VIEW  TO MANAGEMENT
DENY SELECT, INSERT, UPDATE, DELETE ON DBO.CHECK_MORE_EQPMENT_VIEW  TO DBA

GRANT SELECT ON DBO.EQPMENT_WITH_CAT_VIEW TO MEMBERS
GRANT SELECT ON DBO.EQPMENT_WITH_CAT_VIEW TO STORE_CLERKS
GRANT SELECT ON DBO.EQPMENT_WITH_CAT_VIEW TO MANAGEMENT
DENY SELECT, INSERT, UPDATE, DELETE ON DBO.EQPMENT_WITH_CAT_VIEW TO DBA


----TEST ACCESS
Execute as User = '50004'
Execute as User = 'YEE'
Execute as User = 'EVONNE'
Execute as User = 'LI_WEI'
SELECT * FROM CHECK_LESS_EQPMENT_VIEW
SELECT * FROM CHECK_MORE_EQPMENT_VIEW
SELECT* FROM EQPMENT_WITH_CAT_VIEW
REVERT

SELECT user_name()