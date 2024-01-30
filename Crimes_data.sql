USE [Crimes - Portfolio project]

SELECT * FROM Crimes_2019;

SELECT * FROM Crimes_2020;

SELECT * 
INTO Crimes
FROM Crimes_2019 
UNION
SELECT * FROM Crimes_2020
UNION
SELECT * FROM Crimes_2021
UNION
SELECT * FROM Crimes_2022
UNION
SELECT * FROM Crimes_2023;

SELECT * FROM Crimes;

SELECT
    ID,
    Case_Number,
	Date,
    CAST(Date AS DATE) AS Crime_Date,
    CAST(Date AS TIME) AS Crime_Time,
    DATENAME(MONTH, Date) AS Month,
    DATENAME(DAY, Date) AS Day,
    DATENAME(WEEKDAY, Date) AS Weekday,
    CASE
        WHEN DATEPART(MONTH, Date) IN (12, 1, 2) THEN 'Winter'
        WHEN DATEPART(MONTH, Date) IN (3, 4, 5) THEN 'Spring'
        WHEN DATEPART(MONTH, Date) IN (6, 7, 8) THEN 'Summer'
        WHEN DATEPART(MONTH, Date) IN (9, 10, 11) THEN 'Fall'
        ELSE 'Unknown'
    END AS Season,
    Year,
    Block,
    IUCR,
	Primary_Type,
    Description,
    ISNULL(Location_Description, 'NA') AS Location_DescriptionFull,
    Arrest,
    Domestic,
    Beat,
    District,
    ISNULL(Ward, 0.0) AS Ward_Full,
    ISNULL(Community_Area, 0.0) AS Community_Area_full,
    ISNULL(CAST(Latitude AS varchar), 'NA') AS Latitude_full,
    ISNULL(CAST(Longitude AS varchar), 'NA') AS Longitude_full,
    ISNULL(Location, 'NA') AS Location_full,
    ISNULL(Census_Tracts, 0.0) AS Census_Tracts_Full
INTO Crimes_final
FROM 
    Crimes
ORDER BY 
   Crime_Date ASC;

SELECT * FROM Crimes_final;

SELECT * FROM Crimes_final
WHERE YEAR(Crime_Date) <> 2019;

SELECT Case_Number FROM Crimes_final
WHERE YEAR(Crime_Date) <> 2019
GROUP BY Case_Number
HAVING COUNT(Case_Number) > 1;

SELECT Arrest, COUNT(Arrest) 
FROM Crimes_final
WHERE Arrest = '1' AND YEAR(Crime_Date) <> 2019 
GROUP BY Arrest, Case_Number
HAVING COUNT(Case_Number) = 1;

SELECT * FROM [CommAreas-1]

SELECT * FROM Chicago_PD_IUCR_Codes


SELECT * INTO Crimes_copy
FROM Crimes_final

SELECT DISTINCT Location_DescriptionFull FROM Crimes_copy
ORDER BY Location_DescriptionFull ASC

UPDATE Crimes_copy
SET Location_DescriptionFull = REPLACE(Location_DescriptionFull, ' / ', '/')
WHERE Location_DescriptionFull LIKE '% / %';

UPDATE Crimes_copy
SET Location_DescriptionFull = REPLACE(Location_DescriptionFull, 'PARKING LOT/GARAGE(NON.RESID.)', 'PARKING LOT/GARAGE (NON RESIDENTIAL)')

SELECT DISTINCT Location_DescriptionFull FROM Crimes_final
ORDER BY Location_DescriptionFull ASC

UPDATE Crimes_final
SET Location_DescriptionFull = REPLACE(Location_DescriptionFull, ' / ', '/')
WHERE Location_DescriptionFull LIKE '% / %';

UPDATE Crimes_final
SET Location_DescriptionFull = REPLACE(Location_DescriptionFull, 'CHA PARKING LOT/GROUNDS/GROUNDS', 'CHA PARKING LOT/GROUNDS')

SELECT DISTINCT Primary_Type FROM Crimes_final
ORDER BY Primary_Type ASC

UPDATE Crimes_final
SET Primary_Type = REPLACE(Primary_Type, 'CRIM SEXUAL ASSAULT', 'CRIMINAL SEXUAL ASSAULT');

SELECT DISTINCT Primary_Type FROM Crimes_final
ORDER BY Primary_Type ASC

UPDATE Crimes_final
SET Description = REPLACE(Description, 'UNLAWFUL USE/SALE AIR RIFLE', 'UNLAWFUL USE / SALE OF AIR RIFLE');

SELECT DISTINCT Description FROM Crimes_final
ORDER BY Description ASC

ALTER TABLE Crimes_copy
ADD Lockdown INT;

UPDATE Crimes_copy
SET Lockdown =
	CASE
		WHEN Crime_Date >= '2020-03-21' AND Crime_Date <= '2020-06-09' THEN 1
		ELSE 0
	END;

SELECT * FROM Crimes_copy
WHERE Lockdown = 1

ALTER TABLE Crimes_final
ADD Lockdown INT;

UPDATE Crimes_final
SET Lockdown =
	CASE
		WHEN Crime_Date >= '2020-03-21' AND Crime_Date <= '2020-06-09' THEN 1
		ELSE 0
	END;

SELECT * FROM Crimes_final
WHERE Lockdown = 1