-- Q1: Find out the total number of crimes recorded. 
SELECT 
	count(CASE_NUMBER) As Crime_Count
FROM 
	chicago_crime;

-- Result --
	-- Crime_Count
-- 490

-- Q2: List community areas with per capita income less than 11000 $.
SELECT 
	COMMUNITY_AREA_NAME
FROM 
	chicagocensusdata
WHERE
	PER_CAPITA_INCOME < 11000;

-- Result --
	-- COMMUNITY_AREA_NAME
-- West Garfield Park
-- South Lawndale
-- Fuller Park
-- Riverdale

-- Q3: List the case numbers for crimes involving minors.

SELECT 
	CASE_NUMBER, PRIMARY_TYPE, DESCRIPTION 
FROM 
	chicago_crime
WHERE 
	PRIMARY_TYPE LIKE '%MINOR%' OR
    DESCRIPTION LIKE '%MINOR%';

-- Result --
-- CASE_NUMBER	PRIMARY_TYPE			DESCRIPTION
-- HK238408		LIQUOR LAW VIOLATION	ILLEGAL CONSUMPTION BY MINOR
-- HL266884		LIQUOR LAW VIOLATION	SELL/GIVE/DEL LIQUOR TO MINOR

-- Q4 List all kidnapping crimes involving a child.

SELECT 
	CASE_NUMBER, PRIMARY_TYPE, DESCRIPTION 
FROM 
	chicago_crime
WHERE 
	PRIMARY_TYPE LIKE '%kidnap%' 
    AND
    DESCRIPTION LIKE '%child%';

-- Result --
-- CASE_NUMBER		PRIMARY_TYPE	DESCRIPTION
-- HN144152			KIDNAPPING		CHILD ABDUCTION/STRANGER

-- Q5 What kind of crimes were recorded at schools?

SELECT 
	PRIMARY_TYPE, DESCRIPTION, LOCATION_DESCRIPTION 
FROM 
	chicago_crime
WHERE 
	LOCATION_DESCRIPTION LIKE '%SCHOOL%';

-- Result --
-- PRIMARY_TYPE				DESCRIPTION						LOCATION_DESCRIPTION
-- PUBLIC PEACE VIOLATION	BOMB THREAT						SCHOOL; PUBLIC; BUILDING
-- PUBLIC PEACE VIOLATION	BOMB THREAT						SCHOOL; PRIVATE; BUILDING
-- BATTERY					SIMPLE							SCHOOL; PUBLIC; BUILDING
-- NARCOTICS				POSS: HEROIN(WHITE)				SCHOOL; PUBLIC; GROUNDS
-- BATTERY					SIMPLE							SCHOOL; PUBLIC; GROUNDS
-- BATTERY					PRO EMP HANDS NO/MIN INJURY		SCHOOL; PUBLIC; BUILDING
-- BATTERY					SIMPLE							SCHOOL; PUBLIC; BUILDING
-- CRIMINAL TRESPASS		TO LAND							SCHOOL; PUBLIC; GROUNDS
-- CRIMINAL DAMAGE			TO VEHICLE						SCHOOL; PUBLIC; GROUNDS
-- NARCOTICS				MANU/DEL:CANNABIS 10GM OR LESS	SCHOOL; PUBLIC; BUILDING
-- ASSAULT					PRO EMP HANDS NO/MIN INJURY		SCHOOL; PUBLIC; GROUNDS
-- BATTERY					SIMPLE							SCHOOL; PUBLIC; GROUNDS

-- Q6: List the average safety score for all types of schools?

SELECT 
	AVG(SAFETY_SCORE) As Average_Safety_Score 
FROM 
	chicagopublicschools;

-- Result
-- Average_Safety_Score
-- 49.5049

-- Q7: List 5 community areas with highest % of housholds below poverty line.

SELECT 
	COMMUNITY_AREA_NAME, PERCENT_HOUSEHOLDS_BELOW_POVERTY
FROM 
	chicago_crime_data.chicagocensusdata
order by 
	PERCENT_HOUSEHOLDS_BELOW_POVERTY DESC;

-- Result:
-- COMMUNITY_AREA_NAME  	PERCENT_HOUSEHOLDS_BELOW_POVERTY
-- Riverdale				56.5
-- Fuller Park				51.2
-- Englewood				46.6
-- North Lawndale			43.1
-- East Garfield Park		42.4

-- Q8 Which community area(s)(mention only the community area number) is most crime prone?

SELECT COMMUNITY_AREA_NUMBER
FROM (
    SELECT COMMUNITY_AREA_NUMBER, COUNT(CASE_NUMBER) AS num_cases
    FROM chicago_crime
    GROUP BY COMMUNITY_AREA_NUMBER
) AS counts
WHERE 	
	num_cases = (
				SELECT MAX(freq)
				FROM (
					SELECT COUNT(CASE_NUMBER) AS freq
					FROM chicago_crime
					GROUP BY COMMUNITY_AREA_NUMBER
					) AS max_counts
				);

-- Result
-- COMMUNITY_AREA_NUMBER
-- 25 

-- Q9- Use a sub-query to find the name of the community area with the highest hardship index.

SELECT 
	COMMUNITY_AREA_NAME
FROM 
	chicagocensusdata
where 
	HARDSHIP_INDEX = (
					SELECT 
						max(HARDSHIP_INDEX)
					FROM 
						chicagocensusdata);

-- Result-- 
-- COMMUNITY_AREA_NAME
-- Riverdale

-- Q10- Use a sub-query to determine the Community Area Name with most number of Crimes.

-- Result--
SELECT 
	COMMUNITY_AREA_NAME
FROM
	chicagocensusdata CD
WHERE 
	CD.COMMUNITY_AREA_NUMBER IN (
								SELECT COMMUNITY_AREA_NUMBER
								FROM (
								SELECT 
									COMMUNITY_AREA_NUMBER, COUNT(CASE_NUMBER) AS num_cases
								FROM 
									chicago_crime
								GROUP BY 
									COMMUNITY_AREA_NUMBER
									) AS counts
								WHERE num_cases = (
													SELECT MAX(freq)
													FROM (
														SELECT 
															COUNT(CASE_NUMBER) AS freq
														FROM 
															chicago_crime
														GROUP BY 
															COMMUNITY_AREA_NUMBER
														) AS max_counts
													)
									);

-- Result--
-- COMMUNITY_AREA_NAME
-- Austin
