
USE [APU_SEPL]
GO

---==============================================
--- STEP 13: QUERY FOR LAST N DAYS ON TRANSACTION 
---==============================================

--==============================================================================================
-- Transaction records that happen last n days (where n= {1,2,..,7}, including today where n = 1)
--==============================================================================================

DECLARE @n_days INT = 7;

Select trans.TRANS_ID, trans.TRANS_DATE, mem.MEM_ID, mem.MEM_NAME, et.TRANS_QUANT_PURCHASED, equip.EQ_ID, equip.EQ_NAME, equip.EQ_PPU
From [dbo].[TRANSACTION] trans
inner join [dbo].[MEMBER] mem ON mem.MEM_ID = trans.MEM_ID
Inner Join [dbo].[EQ_TRANS] et On et.TRANS_ID = trans.TRANS_ID
Inner Join [dbo].[EQUIPMENT] equip On et.EQ_ID = equip.EQ_ID
WHERE trans.TRANS_DATE >= DATEADD(DAY, -@n_days, GETDATE())
ORDER BY trans.TRANS_DATE DESC;

--==============================================================================================
-- TO VIEW THE TOTAL AMOUNT EARNED FROM LAST n DAY'S TRANSACTIONS (n = 1 to 7)
--==============================================================================================

DECLARE @n_days1 INT = 7;

SELECT CONVERT(date, TRANS_DATE) AS PURCHASE_DATE, SUM(TRANS_QUANT_PURCHASED * EQ_PPU) AS TOTAL_AMT_EARNED
FROM (
    SELECT trans.TRANS_ID, trans.TRANS_DATE, mem.MEM_ID, mem.MEM_NAME, et.TRANS_QUANT_PURCHASED, equip.EQ_ID, equip.EQ_NAME, equip.EQ_PPU
    FROM [dbo].[MEMBER] mem
    INNER JOIN [dbo].[TRANSACTION] trans ON trans.MEM_ID = mem.MEM_ID
    INNER JOIN [dbo].[EQ_TRANS] et ON et.TRANS_ID = trans.TRANS_ID
    INNER JOIN [dbo].[EQUIPMENT] equip ON et.EQ_ID = equip.EQ_ID
) transaction_details
WHERE transaction_details.TRANS_DATE >= DATEADD(DAY, -@n_days1, GETDATE())
GROUP BY CONVERT(date, transaction_details.TRANS_DATE)
ORDER BY PURCHASE_DATE DESC;


--==================================================================
-- Transaction records that happen last 30 days (1 month)
--==================================================================
Select trans.TRANS_ID, trans.TRANS_DATE, mem.MEM_ID, mem.MEM_NAME, et.TRANS_QUANT_PURCHASED, equip.EQ_ID, equip.EQ_NAME, equip.EQ_PPU
From [dbo].[TRANSACTION] trans
inner join [dbo].[MEMBER] mem ON mem.MEM_ID = trans.MEM_ID
Inner Join [dbo].[EQ_TRANS] et On et.TRANS_ID = trans.TRANS_ID
Inner Join [dbo].[EQUIPMENT] equip On et.EQ_ID = equip.EQ_ID
WHERE CONVERT(DATE, trans.TRANS_DATE) 
BETWEEN DATEADD(MONTH, -1, CONVERT(DATE, GETDATE())) 
AND DATEADD(MONTH, -0, CONVERT(DATE, GETDATE()))
ORDER BY trans.TRANS_DATE ASC

-- TO VIEW THE TOTAL AMOUNT EARNED FROM LAST MONTH'S TRANSACTIONS
Select CONVERT(date, TRANS_DATE) as PURCHASE_DATE, Sum(TRANS_QUANT_PURCHASED * EQ_PPU) as TOTAL_AMT_EARNED
From (
Select trans.TRANS_ID, trans.TRANS_DATE, mem.MEM_ID, mem.MEM_NAME, et.TRANS_QUANT_PURCHASED, equip.EQ_ID, equip.EQ_NAME, equip.EQ_PPU
From [dbo].[TRANSACTION] trans
inner join [dbo].[MEMBER] mem ON mem.MEM_ID = trans.MEM_ID
Inner Join [dbo].[EQ_TRANS] et On et.TRANS_ID = trans.TRANS_ID
Inner Join [dbo].[EQUIPMENT] equip On et.EQ_ID = equip.EQ_ID
) transaction_details
WHERE CONVERT(DATE, transaction_details.TRANS_DATE) 
BETWEEN DATEADD(MONTH, -1, CONVERT(DATE, GETDATE())) 
AND DATEADD(MONTH, -0, CONVERT(DATE, GETDATE())) 
Group By CONVERT(date, transaction_details.TRANS_DATE)
ORDER BY PURCHASE_DATE ASC

--==================================================================
-- Transaction records that happen last year 
--==================================================================
Select trans.TRANS_ID, trans.TRANS_DATE, mem.MEM_ID, mem.MEM_NAME, et.TRANS_QUANT_PURCHASED, equip.EQ_ID, equip.EQ_NAME, equip.EQ_PPU
From [dbo].[TRANSACTION] trans
inner join [dbo].[MEMBER] mem ON mem.MEM_ID = trans.MEM_ID
Inner Join [dbo].[EQ_TRANS] et On et.TRANS_ID = trans.TRANS_ID
Inner Join [dbo].[EQUIPMENT] equip On et.EQ_ID = equip.EQ_ID
WHERE YEAR(trans.TRANS_DATE) = YEAR(DATEADD(YEAR, -1, GETDATE())); 
/* Testing purpose - to update the transaction date to 2022 last year
UPDATE [TRANSACTION]
SET TRANS_DATE = '2022-12-25'
WHERE TRANS_ID = '10003'
select * from [TRANSACTION]
*/

-- TO VIEW THE TOTAL AMOUNT EARNED FROM LAST 3 YEAR'S TRANSACTIONS
Select CONVERT(date, TRANS_DATE) as PurchaseDate, Sum(TRANS_QUANT_PURCHASED * EQ_PPU) as TotalAmountEarned
From (
Select trans.TRANS_ID, trans.TRANS_DATE, mem.MEM_ID, mem.MEM_NAME, et.TRANS_QUANT_PURCHASED, equip.EQ_ID, equip.EQ_NAME, equip.EQ_PPU
From [dbo].[TRANSACTION] trans
inner join [dbo].[MEMBER] mem ON mem.MEM_ID = trans.MEM_ID
Inner Join [dbo].[EQ_TRANS] et On et.TRANS_ID = trans.TRANS_ID
Inner Join [dbo].[EQUIPMENT] equip On et.EQ_ID = equip.EQ_ID
) transaction_details
WHERE CONVERT(DATE, transaction_details.TRANS_DATE) 
BETWEEN DATEADD(YEAR, -3, CONVERT(DATE, GETDATE())) 
AND DATEADD(YEAR, -0, CONVERT(DATE, GETDATE())) 
Group By CONVERT(date, transaction_details.TRANS_DATE)


--==================================================================
-- TOTAL AMOUNT OF QUANTITY PURCHASED BY EACH MEMBER IN PAST N DAYS
--==================================================================

DECLARE @n_days INT = 1;

SELECT M.MEM_ID, M.MEM_NAME, equip.EQ_NAME,SUM(eq.TRANS_QUANT_PURCHASED) AS TOTAL_QUANT_PURCHASED
FROM MEMBER M
INNER JOIN [TRANSACTION] trans ON M.MEM_ID = trans.MEM_ID
INNER JOIN EQ_TRANS eq ON trans.TRANS_ID = eq.trans_id
INNER JOIN EQUIPMENT equip ON eq.EQ_ID = equip.EQ_ID
WHERE trans.TRANS_DATE >= DATEADD(DAY, -@n_days, GETDATE())
GROUP BY M.MEM_ID, M.MEM_NAME, eq.EQ_ID, equip.EQ_NAME
ORDER BY TOTAL_QUANT_PURCHASED DESC;


--==================================================================
-- TOTAL SUM AMOUNT PURCHASED BY EACH MEMBER IN PAST N DAYS
--==================================================================
DECLARE @n_days INT = 7;

SELECT M.MEM_ID, M.MEM_NAME, equip.EQ_NAME,SUM(eq.TRANS_QUANT_PURCHASED * equip.EQ_PPU) AS TOTAL_AMOUNT_BEFORE_DISCOUNT
FROM MEMBER M
INNER JOIN [TRANSACTION] trans ON M.MEM_ID = trans.MEM_ID
INNER JOIN EQ_TRANS eq ON trans.TRANS_ID = eq.trans_id
INNER JOIN EQUIPMENT equip ON eq.EQ_ID = equip.EQ_ID
WHERE trans.TRANS_DATE >= DATEADD(DAY, -@n_days, GETDATE())
GROUP BY M.MEM_ID, M.MEM_NAME, eq.EQ_ID, equip.EQ_NAME
ORDER BY TOTAL_AMOUNT_BEFORE_DISCOUNT DESC;


--==================================================================
-- ALL TRANSACTION DETAILS BY EACH MEMBER IN PAST N DAYS
--==================================================================

DECLARE @n_days INT = 7;

SELECT M.MEM_ID, M.MEM_NAME, trans.TRANS_ID, trans.TRANS_DATE, equip.EQ_NAME, eq.TRANS_QUANT_PURCHASED, equip.EQ_PPU
FROM MEMBER M
INNER JOIN [TRANSACTION] trans ON M.MEM_ID = trans.MEM_ID
INNER JOIN EQ_TRANS eq ON trans.TRANS_ID = eq.TRANS_ID
INNER JOIN EQUIPMENT equip ON eq.EQ_ID = equip.EQ_ID
WHERE trans.TRANS_DATE >= DATEADD(DAY, -@n_days, GETDATE())
ORDER BY trans.TRANS_DATE DESC;



--==================================================================
-- PRODUCT THAT HAS THE HIGHEST SOLD QUANTITY IN PAST N DAYS 
--==================================================================

DECLARE @n INT = 7;

SELECT e.EQ_ID, e.EQ_NAME, c.CAT_NAME, SUM(eq.TRANS_QUANT_PURCHASED) AS total_sold
FROM EQUIPMENT e
INNER JOIN EQ_TRANS eq ON e.EQ_ID = eq.EQ_ID
INNER JOIN [TRANSACTION] trans ON trans.TRANS_ID = eq.TRANS_ID
INNER JOIN CATEGORY c ON e.CAT_ID = c.CAT_ID
WHERE trans.TRANS_DATE >= DATEADD(DAY, -@n, GETDATE())
GROUP BY e.EQ_ID, e.EQ_NAME, c.CAT_NAME
ORDER BY total_sold DESC;

--=================================================================================
-- PRODUCT THAT HAS THE HIGHEST SOLD QUANTITY WITH MOST MEMBER OF PURCHASED IN PAST N DAYS 
--=================================================================================

DECLARE @n1 INT = 7;

SELECT e.EQ_ID, e.EQ_NAME, 
       SUM(eq.TRANS_QUANT_PURCHASED) AS total_sold,
       COUNT(DISTINCT trans.MEM_ID) AS total_members_purchased
FROM EQUIPMENT e
INNER JOIN EQ_TRANS eq ON e.EQ_ID = eq.EQ_ID
INNER JOIN [TRANSACTION] trans ON trans.TRANS_ID = eq.TRANS_ID
WHERE trans.TRANS_DATE >= DATEADD(DAY, -@n1, GETDATE())
GROUP BY e.EQ_ID, e.EQ_NAME
ORDER BY total_sold DESC, total_members_purchased DESC;


--============================================================================================
-- MOST POPULAR DAY OF THE WEEK WITH TOTAL QTY SOLD AND TOTAL MEMBER PURCHASED IN PAST N DAYS 
--============================================================================================

DECLARE @n INT = 7;

SELECT DATENAME(WEEKDAY, trans.TRANS_DATE) AS day_of_week,
       SUM(eq.TRANS_QUANT_PURCHASED) AS total_sold,
       COUNT(DISTINCT trans.MEM_ID) AS total_members_purchased
FROM EQUIPMENT e
INNER JOIN EQ_TRANS eq ON e.EQ_ID = eq.EQ_ID
INNER JOIN [TRANSACTION] trans ON trans.TRANS_ID = eq.TRANS_ID
WHERE trans.TRANS_DATE >= DATEADD(DAY, -@n, GETDATE())
GROUP BY DATENAME(WEEKDAY, trans.TRANS_DATE)
ORDER BY total_sold DESC, total_members_purchased DESC;

/* UPDATE the transaction date to test the third query
SELECT * FROM [TRANSACTION]
-- Update the transaction date
UPDATE [TRANSACTION]
SET TRANS_DATE = '2023-07-25'
WHERE TRANS_ID = '10003'

UPDATE [TRANSACTION]
SET TRANS_DATE = '2023-07-27'
WHERE TRANS_ID = '10004'
*/
--==================================================================
-- TOTAL TRANSACTION FOR THE PAST N DAYS
--==================================================================

DECLARE @n_days INT = 7;

SELECT COUNT(*) AS TOTAL_TRANSACTIONS
FROM [TRANSACTION]
WHERE TRANS_DATE >= DATEADD(DAY, -@n_days, GETDATE())


--==================================================================
-- CATEGORY THAT HAS THE HIGHEST SALES IN PAST N DAYS 
--==================================================================

DECLARE @n INT = 7;

SELECT c.CAT_ID, c.CAT_NAME, SUM(eq.TRANS_QUANT_PURCHASED) AS TOTAL_QTY_SOLD
FROM CATEGORY c
INNER JOIN EQUIPMENT e ON e.CAT_ID = c.CAT_ID
INNER JOIN EQ_TRANS eq ON e.EQ_ID = eq.EQ_ID
INNER JOIN [TRANSACTION] trans ON trans.TRANS_ID = eq.TRANS_ID
WHERE trans.TRANS_DATE >= DATEADD(DAY, -@n, GETDATE())
GROUP BY c.CAT_ID, c.CAT_NAME
ORDER BY TOTAL_QTY_SOLD DESC;


