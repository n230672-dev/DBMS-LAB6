USE Various;
SHOW TABLES;
SELECT *FROM Citizen;
SELECT *FROM Certificate_Type;
SELECT *FROM Certificate_Application;
SELECT *FROM Panchayat_Office;

#level1
SELECT application_id,
applicate_date
FROM Certificate_Application
WHERE applicate_date = (
    SELECT MAX(applicate_date)
    FROM Certificate_Application);

SELECT application_id,applicate_date
FROM Certificate_Application
WHERE applicate_date =(
SELECT MIN(applicate_date)
FROM Certificate_Application);

SELECT *FROM Certificate_Application
WHERE applicate_date = 
(SELECT MAX(applicate_date) FROM Certificate_Application);

SELECT *FROM Certificate_Application
WHERE applicate_date = 
(SELECT MIN(applicate_date) FROM Certificate_Application);

SELECT *FROM Citizen
WHERE citizen_id IN 
     (SELECT citizen_id FROM Certificate_Application WHERE application_status = 'approved');

#level2
SELECT *FROM Certificate_Application
WHERE applicate_date >
(SELECT MIN(applicate_date) FROM Certificate_Application);

SELECT *FROM Certificate_Application
WHERE applicate_date <
(SELECT MAX(applicate_date) FROM Certificate_Application);

SELECT *FROM Citizen
WHERE citizen_id IN 
     (SELECT citizen_id FROM Certificate_Application WHERE application_status = 'submitted');

SELECT *FROM Citizen
WHERE citizen_id NOT IN 
     (SELECT citizen_id FROM Certificate_Application WHERE application_status = 'approved');
     
     
SELECT *FROM Certificate_Type
WHERE certificate_type_id IN(SELECT certificate_type_id FROM Certificate_Application WHERE application_status= 'approved');

SELECT *FROM Certificate_Type
WHERE certificate_type_id NOT IN(SELECT certificate_type_id FROM Certificate_Application WHERE application_status= 'approved');

SELECT *FROM Certificate_Application
WHERE applicate_date = 
     (SELECT MIN(applicate_date) FROM Certificate_Application);
     
SELECT c.certificate_name,a.applicate_date
FROM Certificate_Application a
JOIN Certificate_Type c
ON a.certificate_id= c.certificate_type_id
WHERE a.applicate_date = (SELECT MAX(applicate_date) FROM Certificate_Application);

#level3

SELECT ct.certificate_name,
COUNT(ca.application_id) AS
application_count
FROM Certificate_Type ct
JOIN Certificate_Application ca
ON ct.certificate_type_id = ca.certificate_id
GROUP BY ct.certificate_type_id,ct.certificate_name
ORDER BY application_count DESC LIMIT 1;

SELECT po.office_name,
COUNT(ca.application_id) AS 
application_count
FROM Panchayat_Office po
JOIN Certificate_Application ca
ON po.office_id = ca.office_id
GROUP BY po.office_id ,po.office_name
ORDER BY application_count DESC LIMIT 1;

SELECT certificate_id,COUNT(*) AS total_applications
FROM Certificate_Application
GROUP BY certificate_id
HAVING COUNT(*) > (
       SELECT AVG(application_count)
       FROM(
       SELECT COUNT(*) AS application_count
       FROM Certificate_Application
       GROUP BY certificate_id
	)AS temp
);
    

SELECT P.office_name, COUNT(*) AS total_applications
FROM Certificate_Application A
JOIN Panchayat_Office P
ON A.office_id = P.office_id
GROUP BY P.office_name, P.office_id
HAVING COUNT(*) > ANY (
    SELECT COUNT(*)
    FROM Certificate_Application A2
    GROUP BY A2.office_id
);


SELECT office_id ,COUNT(*) AS total_applications
FROM Certificate_Application
GROUP BY office_id
HAVING COUNT(*) >= ALL(
     SELECT  COUNT(*)
     FROM Certificate_Application
     GROUP BY office_id
     );

SELECT C.certificate_name
FROM Certificate_Application A
JOIN Certificate_Type C
ON A.certificate_id = C.certificate_type_id
WHERE A.applicate_date = (
    SELECT MAX(applicate_date)
    FROM Certificate_Application
);

SELECT C.full_name
FROM Citizen C
WHERE C.citizen_id IN (
    SELECT A.citizen_id
    FROM Certificate_Application A
    GROUP BY A.citizen_id
    HAVING COUNT(*) > 1
);

SELECT application_status,COUNT(*)
AS total_applications
FROM Certificate_Application
GROUP BY application_status
HAVING COUNT(*) = (
    SELECT MAX(status_count)
    FROM(
       SELECT COUNT(*) AS status_count
       FROM Certificate_Application
       GROUP BY application_stATUS
       ) AS temp
	);