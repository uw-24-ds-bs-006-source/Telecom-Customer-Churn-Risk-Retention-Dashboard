use telecom_db
select * from telecom_customer_churn_messy
select count(*) as total_rows from telecom_customer_churn_messy
create table customer_churn_backup as select * from telecom_customer_churn_messy

 select * from customer_churn_backup
 
select count(*) as total_rows from customer_churn_backup

SELECT Customer_ID,Gender,Senior_Citizen,Partner,Dependents,Tenure_Months,Phone_Service,
Multiple_Lines,Internet_Service,Online_Security,Online_Backup,Device_Protection,
Tech_Support,Streaming_TV,Streaming_Movies,Contract,Paperless_Billing,Payment_Method,
Monthly_Charges,Total_Charges,Churn,COUNT(*) AS duplicate_count FROM 
telecom_customer_churn_messy GROUP BY Customer_ID,Gender,Senior_Citizen,Partner,Dependents,
Tenure_Months,Phone_Service,Multiple_Lines,Internet_Service,Online_Security,Online_Backup,
Device_Protection,Tech_Support,Streaming_TV,Streaming_Movies,Contract,Paperless_Billing,
Payment_Method,Monthly_Charges,Total_Charges,Churn HAVING COUNT(*) > 1

SELECT SUM(duplicate_count - 1) AS extra_duplicate_rows FROM (SELECT COUNT(*) AS 
duplicate_count FROM telecom_customer_churn_messy GROUP BY Customer_ID,Gender,Senior_Citizen,
Partner,Dependents,Tenure_Months,Phone_Service,Multiple_Lines,Internet_Service,
Online_Security,Online_Backup,Device_Protection,Tech_Support,Streaming_TV,Streaming_Movies,
Contract,Paperless_Billing,Payment_Method,Monthly_Charges,Total_Charges,Churn
HAVING COUNT(*) > 1)AS duplicates

create table telecom_customer_churn_clean as select distinct * from 
telecom_customer_churn_messy

select count(*) as rows_after_duplicate_removal FROM telecom_customer_churn_clean

select count(*) as original_rows from telecom_customer_churn_messy

Select Customer_ID,count(*) as id_count from telecom_customer_churn_clean where 
trim(Customer_ID)<> '' group by Customer_ID having count(*)>1

select*from telecom_customer_churn_clean where Customer_ID in ('CUST-8168','CUST-7730',
'CUST-7561','CUST-7316','CUST-8197','CUST-7726','CUST-7806','CUST-8315','CUST-7296',
'CUST-7162','CUST-8213','CUST-7093','CUST-7506','CUST-7944','CUST-7862','CUST-7864')
order by Customer_ID

select Customer_ID,count(distinct Monthly_Charges) as different_monthly_charges from 
telecom_customer_churn_clean group by Customer_ID having count(distinct Monthly_Charges)>1

select*from telecom_customer_churn_clean where Customer_ID in('CUST-7162','CUST-7506',
'CUST-7561','CUST-7726','CUST-7944','CUST-8197')order by Customer_ID

select Customer_ID,Monthly_Charges,Tenure_Months,Total_Charges,
ROUND(Monthly_Charges*Tenure_Months, 2) AS Calculated_Total from
telecom_customer_churn_clean where Customer_ID in('CUST-7162','CUST-7506','CUST-7561',
'CUST-7726','CUST-7944','CUST-8197') order by Customer_ID, Monthly_Charges

select SUM(CASE WHEN TRIM(Gender) = '' OR Gender IS NULL THEN 1 ELSE 0 END) AS Missing_Gender,
SUM(CASE WHEN TRIM(Partner) = '' OR Partner IS NULL THEN 1 ELSE 0 END) AS Missing_Partner,
SUM(CASE WHEN TRIM(Dependents) = '' OR Dependents IS NULL THEN 1 ELSE 0 END) AS Missing_Dependents,
SUM(CASE WHEN TRIM(Payment_Method) = '' OR Payment_Method IS NULL THEN 1 ELSE 0 END) AS Missing_Payment_Method,
SUM(CASE WHEN TRIM(Total_Charges) = '' OR Total_Charges IS NULL THEN 1 ELSE 0 END) AS Missing_Total_Charges,
SUM(CASE WHEN TRIM(Churn) = '' OR Churn IS NULL THEN 1 ELSE 0 END) AS Missing_Churn
from telecom_customer_churn_clean

select Customer_ID,Gender,Senior_Citizen,Partner,Dependents,Tenure_Months,Monthly_Charges,
Total_Charges,Churn from telecom_customer_churn_clean where Gender is null or TRIM(Gender)=''

SET SQL_SAFE_UPDATES = 0;
update telecom_customer_churn_clean set Gender='Unknown' where Gender is null
OR TRIM(Gender)=''

select count(*) as Unknown_Gender_Count from telecom_customer_churn_clean
where TRIM(Gender)='Unknown'

select Gender,cOUNT(*) as Customer_Count from telecom_customer_churn_clean group by Gender

update telecom_customer_churn_clean set Gender=case WHEN LOWER(TRIM(Gender)) 
IN ('female', 'femal') THEN 'Female' WHEN LOWER(TRIM(Gender)) = 'male' THEN 'Male'
WHEN LOWER(TRIM(Gender)) = 'unknown' THEN 'Unknown'ELSE Gender END

select Gender, count(*) as Customer_Count from telecom_customer_churn_clean
group by Gender

select Customer_ID,Gender,Partner,Dependents,Tenure_Months,Contract,Monthly_Charges,
Total_Charges,Churn from telecom_customer_churn_clean where Partner is null OR 
TRIM(Partner)=''

SET SQL_SAFE_UPDATES = 0;
update telecom_customer_churn_clean set Partner='Unknown' where Partner is null
OR TRIM(Partner)=''

select Partner,count(*) as Customer_Count from telecom_customer_churn_clean
group by Partner

select Customer_ID,Gender,Partner,Dependents,Tenure_Months,Contract,Monthly_Charges,
Total_Charges,Churn from telecom_customer_churn_clean where Dependents is null or
 TRIM(Dependents)=''
 
 SET SQL_SAFE_UPDATES = 0;
update telecom_customer_churn_clean set Dependents='Unknown' where Dependents is null
OR TRIM(Dependents)=''

select Dependents,count(*) as Customer_Count from telecom_customer_churn_clean
GROUP BY Dependents

select Customer_ID,Gender,Partner,Dependents,Payment_Method,Tenure_Months,Contract,
Monthly_Charges,Total_Charges,Churn from telecom_customer_churn_clean
where Payment_Method is null OR TRIM(Payment_Method)=''

Update telecom_customer_churn_clean set Payment_Method='Unknown' where Payment_Method IS NULL
OR TRIM(Payment_Method) = ''

select Payment_Method,count(*) as Customer_Count from telecom_customer_churn_clean
group by Payment_Method

select Customer_ID,Tenure_Months,Monthly_Charges,Total_Charges,ROUND(Monthly_Charges*
Tenure_Months, 2) as Calculated_Total from telecom_customer_churn_clean
WHERE Total_Charges IS NULL OR TRIM(Total_Charges) = ''

UPDATE telecom_customer_churn_clean SET Total_Charges=ROUND(Monthly_Charges*Tenure_Months, 2)
WHERE (Total_Charges IS NULL OR TRIM(Total_Charges)='')AND Monthly_Charges IS NOT NULL
AND Tenure_Months IS NOT NULL

select COUNT(*) AS Remaining_Missing_Total_Charges from telecom_customer_churn_clean
where Total_Charges IS NULL OR TRIM(Total_Charges)=''

select Customer_ID,Gender,Partner,Dependents,Tenure_Months,Contract,Monthly_Charges,
Total_Charges,Churn from telecom_customer_churn_clean where Churn is null
or TRIM(Churn)=''

SET SQL_SAFE_UPDATES = 0;
update telecom_customer_churn_clean set Churn='Unknown' where Churn is null OR TRIM(Churn)=''

select Churn,count(*) as Customer_Count from telecom_customer_churn_clean
 group by Churn
 
select Customer_ID,Churn,LENGTH(Churn) AS Churn_Length,HEX(Churn) AS Churn_Hex
FROM telecom_customer_churn_clean WHERE Churn IS NULL
OR TRIM(Churn)='' OR LENGTH(TRIM(Churn)) = 0

update telecom_customer_churn_clean set Churn = 'Unknown' where LENGTH(TRIM(Churn))=0

select Churn,count(*) as Customer_Count from telecom_customer_churn_clean
GROUP BY Churn

update telecom_customer_churn_clean set Churn=case WHEN LOWER(TRIM(Churn))='yes' THEN 'Yes'
WHEN LOWER(TRIM(Churn))='no' THEN 'No' WHEN LOWER(TRIM(Churn))='unknown' THEN 'Unknown'
ELSE Churn END

select Churn,count(*) as Customer_Count from telecom_customer_churn_clean
GROUP BY Churn

select Contract,count(*) as Customer_Count from telecom_customer_churn_clean
group by Contract order by Customer_Count desc

select Customer_ID,Gender,Partner,Dependents,Tenure_Months,Contract,Monthly_Charges,
Total_Charges,Churn from telecom_customer_churn_clean where Contract is null OR 
TRIM(Contract)=''

DELETE FROM telecom_customer_churn_clean
WHERE (Customer_ID IS NULL OR TRIM(Customer_ID) = '')
  AND (Gender = 'Unknown' OR Gender IS NULL OR TRIM(Gender) = '')
  AND (Partner = 'Unknown' OR Partner IS NULL OR TRIM(Partner) = '')
  AND (Dependents = 'Unknown' OR Dependents IS NULL OR TRIM(Dependents) = '')
  AND (Contract IS NULL OR TRIM(Contract) = '')
  AND (Churn = 'Unknown' OR Churn IS NULL OR TRIM(Churn) = '');
  
select count(*) as Remaining_Blank_Records from telecom_customer_churn_clean
WHERE Customer_ID IS NULL OR TRIM(Customer_ID) = ''


select Contract, count(*) as Customer_Count from telecom_customer_churn_clean
group by Contract order bY Customer_Count DESC


UPDATE telecom_customer_churn_clean
SET Contract =CASE WHEN LOWER(TRIM(Contract)) IN ('month-to-month', 'month to month')
THEN 'Month-to-month'WHEN LOWER(TRIM(Contract)) IN ('one year', '1 year')THEN 'One year'
WHEN LOWER(TRIM(Contract)) IN ('two year', '2 year')THEN 'Two year'ELSE Contract END


SELECT Contract,COUNT(*) AS Customer_Count FROM telecom_customer_churn_clean
GROUP BY Contract ORDER BY Customer_Count DESC

select Customer_ID,Tenure_Months,Monthly_Charges,Total_Charges,Contract,Churn from
telecom_customer_churn_clean where Tenure_Months<0 order by Tenure_Months

SET SQL_SAFE_UPDATES = 0;
update telecom_customer_churn_clean set Tenure_Months=abs(Tenure_Months)
where Tenure_Months<0

select count(*) as Remaining_Negative_Tenure from telecom_customer_churn_clean
where Tenure_Months<0

select Customer_ID,Tenure_Months from telecom_customer_churn_clean where Customer_ID in (
'CUST-8287','CUST-8268','CUST-7250','CUST-7658','CUST-7093','CUST-7219','CUST-8300','CUST-7223',
'CUST-7472','CUST-7142') order by Customer_ID

select Customer_ID,Monthly_Charges from telecom_customer_churn_clean
where trim(Monthly_Charges) LIKE '$%'

SET SQL_SAFE_UPDATES = 0;
update telecom_customer_churn_clean set Monthly_Charges=REPLACE(TRIM(Monthly_Charges),'$','')
WHERE TRIM(Monthly_Charges) LIKE '$%'

select Customer_ID,Monthly_Charges from telecom_customer_churn_clean where 
TRIM(Monthly_Charges) LIKE '$%'

SELECT COUNT(*) AS Total_Rows,SUM(CASE WHEN TRIM(Monthly_Charges) LIKE '$%' THEN 1
ELSE 0 END) AS Remaining_Dollar_Values FROM telecom_customer_churn_clean

select Senior_Citizen,count(*) as Customer_Count from telecom_customer_churn_clean
group by Senior_Citizen order by Customer_Count DESC

SET SQL_SAFE_UPDATES = 0;
UPDATE telecom_customer_churn_clean SET Senior_Citizen=CASE WHEN TRIM(Senior_Citizen) 
IN ('1','Yes','YES')THEN 'Yes' WHEN TRIM(Senior_Citizen) IN ('0', 'No', 'NO')THEN 'No'
ELSE Senior_Citizen END

select Senior_Citizen,count(*) as Customer_Count from telecom_customer_churn_clean
GROUP BY Senior_Citizen ORDER BY Customer_Count DESC

select Customer_ID,count(*) as ID_Count from telecom_customer_churn_clean
where Customer_ID is not null and TRIM(Customer_ID)<>'' group by Customer_ID having COUNT(*)>1
order by ID_Count DESC, Customer_ID

SELECT Customer_ID,COUNT(*) AS Record_Count,COUNT(DISTINCT Gender) AS Different_Gender,
COUNT(DISTINCT Senior_Citizen) AS Different_Senior_Citizen,
COUNT(DISTINCT Partner) AS Different_Partner,
COUNT(DISTINCT Dependents) AS Different_Dependents,
COUNT(DISTINCT Tenure_Months) AS Different_Tenure,
COUNT(DISTINCT Monthly_Charges) AS Different_Monthly_Charges,
COUNT(DISTINCT Total_Charges) AS Different_Total_Charges,
COUNT(DISTINCT Churn) AS Different_Churn FROM telecom_customer_churn_clean
WHERE Customer_ID IS NOT NULL AND TRIM(Customer_ID) <> ''GROUP BY Customer_ID
HAVING COUNT(*) > 1 ORDER BY Customer_ID


select* from telecom_customer_churn_clean where Customer_ID IN ('CUST-7162','CUST-7296',
'CUST-7506','CUST-7561','CUST-7726','CUST-7730','CUST-7806','CUST-7862','CUST-7864',
'CUST-7944','CUST-8197','CUST-8213','CUST-8315') order by Customer_ID

SET SQL_SAFE_UPDATES = 0;
UPDATE telecom_customer_churn_clean SET Churn=CASE
WHEN Customer_ID = 'CUST-7730' THEN 'Yes'WHEN Customer_ID = 'CUST-7806' THEN 'No'
WHEN Customer_ID = 'CUST-7862' THEN 'No'WHEN Customer_ID = 'CUST-7864' THEN 'Yes'
WHEN Customer_ID = 'CUST-8315' THEN 'No'ELSE Churn END WHERE Customer_ID IN (
'CUST-7730','CUST-7806','CUST-7862','CUST-7864','CUST-8315')


UPDATE telecom_customer_churn_clean SET Partner = 'No'
WHERE Customer_ID = 'CUST-8213' AND Partner = 'Unknown'


UPDATE telecom_customer_churn_clean SET Gender='Female' WHERE Customer_ID = 'CUST-8315'
AND Gender = 'Unknown'

select Customer_ID,Gender,Partner,Churn from telecom_customer_churn_clean where Customer_ID 
IN ('CUST-7730','CUST-7806','CUST-7862','CUST-7864','CUST-8213','CUST-8315')
ORDER BY Customer_ID


select Customer_ID,COUNT(*) AS ID_Count FROM telecom_customer_churn_clean
WHERE Customer_ID IS NOT NULL AND TRIM(Customer_ID) <> ''GROUP BY Customer_ID
HAVING COUNT(*) > 1 ORDER BY Customer_ID


SELECT Customer_ID,COUNT(*) AS Record_Count,COUNT(DISTINCT Gender) AS Different_Gender,
COUNT(DISTINCT Senior_Citizen) AS Different_Senior_Citizen,COUNT(DISTINCT Partner) AS Different_Partner,
COUNT(DISTINCT Dependents) AS Different_Dependents,COUNT(DISTINCT Tenure_Months) AS Different_Tenure,
COUNT(DISTINCT Monthly_Charges) AS Different_Monthly_Charges,COUNT(DISTINCT Total_Charges) AS Different_Total_Charges,
COUNT(DISTINCT Churn) AS Different_Churn FROM telecom_customer_churn_clean
WHERE Customer_ID IS NOT NULL AND TRIM(Customer_ID) <> ''GROUP BY Customer_ID
HAVING COUNT(*) > 1 ORDER BY Customer_ID

SELECT *FROM telecom_customer_churn_clean WHERE Customer_ID IN ('CUST-7093','CUST-7316',
'CUST-7730','CUST-7806','CUST-7862','CUST-7864','CUST-8168','CUST-8213','CUST-8315')
ORDER BY Customer_ID

create table telecom_churn_deduped as select distinct*from telecom_customer_churn_clean

select count(*) as Total_Rows from telecom_churn_deduped

SELECT Customer_ID,COUNT(*) AS ID_Count FROM telecom_churn_deduped WHERE Customer_ID 
IS NOT NULL AND TRIM(Customer_ID) <> '' GROUP BY Customer_ID HAVING COUNT(*) > 1
ORDER BY Customer_ID


SELECT Customer_ID,Monthly_Charges,Total_Charges,Tenure_Months,Churn FROM telecom_churn_deduped
WHERE Customer_ID IN ('CUST-7162','CUST-7296','CUST-7506','CUST-7561','CUST-7726','CUST-7944',
'CUST-8197')ORDER BY Customer_ID, Monthly_Charges

ALTER TABLE telecom_churn_deduped ADD COLUMN Data_Quality_Flag VARCHAR(100)

SET SQL_SAFE_UPDATES = 0;
UPDATE telecom_churn_deduped SET Data_Quality_Flag = CASE WHEN Customer_ID IN ('CUST-7162',
'CUST-7296','CUST-7506','CUST-7561','CUST-7726','CUST-7944','CUST-8197')THEN 
'Duplicate ID - Conflicting Values'ELSE 'Clean'END

SELECT Data_Quality_Flag,COUNT(*) AS Record_Count FROM telecom_churn_deduped
GROUP BY Data_Quality_Flag;

SELECT COUNT(*) AS Total_Rows FROM telecom_churn_deduped

SELECT Customer_ID, COUNT(*) AS ID_Count FROM telecom_churn_deduped GROUP BY Customer_ID 
HAVING COUNT(*) > 1

SELECT 
    SUM(CASE WHEN Gender IS NULL OR TRIM(Gender)='' THEN 1 ELSE 0 END) AS Missing_Gender,
    SUM(CASE WHEN Contract IS NULL OR TRIM(Contract)='' THEN 1 ELSE 0 END) AS Missing_Contract,
    SUM(CASE WHEN Churn IS NULL OR TRIM(Churn)='' THEN 1 ELSE 0 END) AS Missing_Churn,
    SUM(CASE WHEN Total_Charges IS NULL OR TRIM(Total_Charges)='' THEN 1 ELSE 0 END) AS Missing_Total_Charges
FROM telecom_churn_deduped

SELECT Customer_ID, Monthly_Charges, Total_Charges, Tenure_Months
FROM telecom_churn_deduped WHERE Monthly_Charges NOT REGEXP '^[0-9]+(\.[0-9]+)?$'
OR Total_Charges NOT REGEXP '^[0-9]+(\.[0-9]+)?$'

SET SQL_SAFE_UPDATES = 0;
DELETE t1 FROM telecom_churn_deduped t1 JOIN telecom_churn_deduped t2 
ON t1.Customer_ID = t2.Customer_ID AND t1.Monthly_Charges <> t2.Monthly_Charges
WHERE ABS(t1.Total_Charges - (t1.Monthly_Charges * t1.Tenure_Months)) > 5

UPDATE telecom_churn_deduped SET Total_Charges = '0.00' WHERE Tenure_Months = 0 AND
(Total_Charges = '-0.0' OR Total_Charges ='0.0' OR Total_Charges IS NULL OR Total_Charges='')


UPDATE telecom_churn_deduped SET Total_Charges = ROUND(CAST(Monthly_Charges 
AS DECIMAL(10,2)) * Tenure_Months, 2)WHERE Total_Charges IS NULL OR TRIM(Total_Charges)='' 
OR Total_Charges = ' '

DELETE FROM telecom_churn_deduped WHERE Churn = 'Unknown' OR Churn IS NULL OR TRIM(Churn)=''

UPDATE telecom_churn_deduped SET Payment_Method = 'Unknown' WHERE Payment_Method
 IS NULL OR TRIM(Payment_Method) = ''
 
 SELECT Customer_ID, COUNT(*) AS Duplicate_Count FROM telecom_churn_deduped GROUP BY 
 Customer_ID HAVING COUNT(*) > 1
 
SET SQL_SAFE_UPDATES = 0;
DELETE FROM telecom_churn_deduped WHERE Customer_ID='CUST-7296' AND (Total_Charges IS NULL 
OR TRIM(Total_Charges) = '')

DELETE FROM telecom_churn_deduped WHERE Customer_ID = 'CUST-7726' AND Monthly_Charges
 = '109.56'

DELETE FROM telecom_churn_deduped WHERE Customer_ID = 'CUST-7561' 
AND Monthly_Charges = '60.95'

DELETE FROM telecom_churn_deduped WHERE Customer_ID = 'CUST-7162' AND Monthly_Charges='59.42'

DELETE FROM telecom_churn_deduped WHERE Customer_ID = 'CUST-7506' AND Monthly_Charges='74.12'

DELETE FROM telecom_churn_deduped WHERE Customer_ID = 'CUST-7944' AND Monthly_Charges='49.12'

SELECT Customer_ID, COUNT(*) AS Duplicate_Count FROM telecom_churn_deduped GROUP BY 
Customer_ID HAVING COUNT(*) > 1

SELECT Customer_ID, Monthly_Charges, Tenure_Months, Total_Charges, Churn, Payment_Method
FROM telecom_churn_deduped  WHERE Customer_ID = 'CUST-7296'

SET SQL_SAFE_UPDATES = 0;
DELETE FROM telecom_churn_deduped WHERE Customer_ID = 'CUST-7296' AND Total_Charges='530.73'

SELECT Customer_ID, COUNT(*) AS Duplicate_Count FROM telecom_churn_deduped
GROUP BY Customer_ID HAVING COUNT(*) > 1

ALTER TABLE telecom_churn_deduped
  MODIFY COLUMN Customer_ID VARCHAR(20) PRIMARY KEY,
  MODIFY COLUMN Tenure_Months INT,
  MODIFY COLUMN Monthly_Charges DECIMAL(10,2),
  MODIFY COLUMN Total_Charges DECIMAL(10,2);
  
describe telecom_churn_deduped

 
select count(*) as Total_Clean_Customers from telecom_churn_deduped

SELECT Churn, COUNT(*) AS Count, ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM 
telecom_churn_deduped), 2) AS Percentage FROM telecom_churn_deduped GROUP BY Churn

SELECT 
    SUM(CASE WHEN Customer_ID IS NULL THEN 1 ELSE 0 END) AS Null_IDs,
    SUM(CASE WHEN Monthly_Charges IS NULL THEN 1 ELSE 0 END) AS Null_Monthly,
    SUM(CASE WHEN Total_Charges IS NULL THEN 1 ELSE 0 END) AS Null_Total,
    SUM(CASE WHEN Churn IS NULL THEN 1 ELSE 0 END) AS Null_Churn
FROM telecom_churn_deduped

select * from telecom_churn_deduped 