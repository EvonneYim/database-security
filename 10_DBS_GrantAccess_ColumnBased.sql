--USE THE DATABASE
USE APU_SEPL
GO
---======================================
--- STEP 10: GRANT COLUMN LEVEL SECURITY
---======================================

---===================================================================
--- COLUMN BASED LEVEL SECURITY (DENY UPDATE TO SPECIFIC COLUMNS)
---===================================================================

---- DENY UPDATE PERMISSION FOR SPECIFIC COLUMNS
DENY UPDATE ON [MEMBER](MEM_STATUS) TO [MEMBERS];
DENY UPDATE ON [MEMBER](MEM_LOG_ID) TO [MEMBERS];
DENY UPDATE ON [MEMBER](MEM_REGISTER_DATE) TO [MEMBERS];
DENY UPDATE ON [MEMBER](MEM_ID) TO [MEMBERS];
DENY UPDATE ON [TRANSACTION] (TRANS_DATE) TO [MEMBERS];
DENY UPDATE ON [TRANSACTION] (MEM_ID) TO [MEMBERS];
DENY UPDATE ON [EQ_TRANS](EQ_ID) TO [MEMBERS];
DENY UPDATE ON [EQ_TRANS](TRANS_ID) TO [MEMBERS];


DENY UPDATE ON [MEMBER](MEM_NRIC_PN) TO [STORE_CLERKS];
DENY UPDATE ON [MEMBER](MEM_ADDRESS) TO [STORE_CLERKS];
DENY UPDATE ON [MEMBER](MEM_ID) TO [STORE_CLERKS];
DENY UPDATE ON [EQUIPMENT](EQ_ID) TO [STORE_CLERKS];
DENY UPDATE ON [CATEGORY](CAT_ID) TO [STORE_CLERKS];


-- TESTING 
EXECUTE AS USER = '50004'
UPDATE MEMBER SET MEM_STATUS = 'Expired' WHERE MEM_ID = 50004


/*SHOULD NOT BE WORKING, BECAUSE STORE CLERK:
	1. DO NOT HAVE THE SYMMETRIC KEY AND CERT
	2. DENIED MODIFICATIONS TO THE MEMBER CONFIDENTIAL DATA
*/

EXECUTE AS USER =  'YEE'
OPEN SYMMETRIC KEY SIMKEY_MEMBER
DECRYPTION BY CERTIFICATE CERT_MEMBER
UPDATE MEMBER SET MEM_NRIC_PN = ENCRYPTBYKEY(KEY_GUID('SIMKEY_MEMBER'),'HACKINGINTOTHESYSTEM') WHERE MEM_ID = 50001
CLOSE SYMMETRIC KEY SIMKEY_MEMBER

SELECT USER_NAME()
SELECT * FROM MEMBER
REVERT 
