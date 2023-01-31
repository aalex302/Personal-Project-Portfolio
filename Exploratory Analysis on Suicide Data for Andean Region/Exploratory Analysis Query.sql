
--define and count countries per region

WITH region AS (
SELECT country,
CASE WHEN country IN('Argentina','Ecuador','Colombia','Peru','Venezuela','Bolivia','Chile') THEN 'Andean'
	WHEN country IN('Germany','Belgium','France','Spain', 'Ireland', 'Italy','Switzerland','Netherlands','Portugal') THEN 'SouthWestern Europe'
	WHEN country IN('Denmark','Finland','Iceland','Norway','Sweden','United Kingdom') THEN 'Northern Europe'
	END AS re
FROM crude
	WHERE country IN ('Argentina','Ecuador','Colombia','Peru','Venezuela','Bolivia','Chile',
				'Germany','Belgium','France','Spain', 'Ireland', 'Italy','Switzerland','Netherlands','Portugal', 
				 'Denmark','Finland','Iceland','Norway','Sweden','United Kingdom')
)
SELECT COUNT(DISTINCT crude.country), re
FROM crude
INNER JOIN region
USING(country)
Group by re

--avg suicide rate per age and region
SELECT CASE WHEN country IN('Argentina','Ecuador','Colombia','Peru','Venezuela','Bolivia','Chile') THEN 'Andean'
	WHEN country IN('Germany','Belgium','France','Spain', 'Ireland', 'Italy','Switzerland','Netherlands','Portugal') THEN 'SouthWestern Europe'
	WHEN country IN('Denmark','Finland','Iceland','Norway','Sweden','United Kingdom') THEN 'Northern Europe'
	END AS region,
	ROUND(AVG("+80"),2) AS"+80", ROUND(AVG("70to79"),2)AS "7079", ROUND(AVG("60to69"),2)AS "6069"
, ROUND(AVG("50to59"),2) AS "5059",ROUND(AVG("40to49"),2) AS "4049",ROUND(AVG("30to39"),2) AS "3039", ROUND(AVG("20to29"),2) AS "2029", ROUND(AVG("10to19"),2) AS "1019"

FROM crude
GROUP BY region

--avg suicide rate per age. region and sex
SELECT sex, CASE WHEN country IN('Argentina','Ecuador','Colombia','Peru','Venezuela','Bolivia','Chile') THEN 'Andean'
	WHEN country IN('Germany','Belgium','France','Spain', 'Ireland', 'Italy','Switzerland','Netherlands','Portugal') THEN 'SouthWestern Europe'
	WHEN country IN('Denmark','Finland','Iceland','Norway','Sweden','United Kingdom') THEN 'Northern Europe'
	END AS region,
ROUND(AVG("+80"),2) AS"+80", ROUND(AVG("70to79"),2)AS "7079", ROUND(AVG("60to69"),2)AS "6069"
, ROUND(AVG("50to59"),2) AS "5059",ROUND(AVG("40to49"),2) AS "4049",ROUND(AVG("30to39"),2) AS "3039", ROUND(AVG("20to29"),2) AS "2029", ROUND(AVG("10to19"),2) AS "1019"

FROM crude
WHERE country IN ('Argentina','Ecuador','Colombia','Peru','Venezuela','Bolivia','Chile',
				'Germany','Belgium','France','Spain', 'Ireland', 'Italy','Switzerland','Netherlands','Portugal', 
				 'Denmark','Finland','Iceland','Norway','Sweden','United Kingdom')
GROUP BY region, sex
ORDER BY region ASC

--avg suicide rate in 2016 vs outpatiens_facilities,mental_hospitals, community-based residential facilities and hospital mental health units
WITH re AS (
SELECT country,
CASE WHEN country IN('Argentina','Ecuador','Colombia','Peru','Venezuela','Bolivia','Chile') THEN 'Andean'
	WHEN country IN('Germany','Belgium','France','Spain', 'Ireland', 'Italy','Switzerland','Netherlands','Portugal') THEN 'SouthWestern Europe'
	WHEN country IN('Denmark','Finland','Iceland','Norway','Sweden','United Kingdom') THEN 'Northern Europe'
	END AS region
FROM crude
	where country IS NOT NULL AND country IN ('Argentina','Ecuador','Colombia','Peru','Venezuela','Bolivia','Chile',
				'Germany','Belgium','France','Spain', 'Ireland', 'Italy','Switzerland','Netherlands','Portugal', 
				 'Denmark','Finland','Iceland','Norway','Sweden','United Kingdom')
)
SELECT region, round(AVG("2016"),2) AS "2016", round(AVG(outpatient_facilities),2) AS avg_outpatient, round(AVG(mental_hospitals),2) AS avg_mentalh,
round(AVG(health_units),2) AS avg_hunits, round(AVG(residential_facilities),2)AS avg_community_res
from age_standardized as a
LEFT JOIN re
USING (country)
LEFT JOIN facilities
USING(country)
GROUP BY region;

--average mental health providers and facilities. Also standard deviation and median for andina region

WITH re AS (
SELECT country,
CASE WHEN country IN('Argentina','Ecuador','Colombia','Peru','Venezuela','Bolivia','Chile') THEN 'Andina'
	WHEN country IN('Germany','Belgium','France','Spain', 'Ireland', 'Italy','Switzerland','Netherlands','Portugal') THEN 'SouthWestern Europe'
	WHEN country IN('Denmark','Finland','Iceland','Norway','Sweden','United Kingdom') THEN 'Northern Europe'
	END AS region
FROM crude
	WHERE country IS NOT NULL AND country IN ('Argentina','Ecuador','Colombia','Peru','Venezuela','Bolivia','Chile',
				'Germany','Belgium','France','Spain', 'Ireland', 'Italy','Switzerland','Netherlands','Portugal', 
				 'Denmark','Finland','Iceland','Norway','Sweden','United Kingdom')
)
SELECT region,percentile_disc(0.5) WITHIN GROUP (order by psychologists),
ROUND(AVG(psychologists),2) AS avg_psychologist, 
ROUND(stddev(psychologists),2) AS stddev_psychologist, 
ROUND(AVG(outpatient_facilities),2) as avg_outpatient, 
ROUND(AVG(mental_hospitals),2) AS avg_mentalh,
ROUND(AVG(health_units),2) AS avg_hunits, round(AVG(residential_facilities),2)AS avg_community_res
FROM re
INNER JOIN hr
USING(country)
LEFT join facilities
USING(country)
GROUP BY region
