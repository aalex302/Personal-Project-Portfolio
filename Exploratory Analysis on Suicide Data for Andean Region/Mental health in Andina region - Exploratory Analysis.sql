
--define and count countries per region

WITH region AS (
SELECT country,
CASE WHEN country IN('Argentina','Ecuador','Colombia','Peru','Venezuela','Bolivia','Chile') THEN 'Andina'
	WHEN country IN('Germany','Belgium','France','Spain', 'Ireland', 'Italy','Switzerland','Netherlands','Portugal') THEN 'SouthWestern Europe'
	WHEN country IN('Denmark','Finland','Iceland','Norway','Sweden','United Kingdom') THEN 'Northern Europe'
	END AS re
from crude
	where country IN ('Argentina','Ecuador','Colombia','Peru','Venezuela','Bolivia','Chile',
				'Germany','Belgium','France','Spain', 'Ireland', 'Italy','Switzerland','Netherlands','Portugal', 
				 'Denmark','Finland','Iceland','Norway','Sweden','United Kingdom')
)
SELECT COUNT(DISTINCT crude.country), re
from crude
INNER JOIN region
USING(country)
GROUP BY re

--list countries per region
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
SELECT DISTINCT country, re
from crude
INNER JOIN region
USING(country)
ORDER BY re DESC

--looking for Bolivia and United Kingdom 
SELECT DISTINCT country
FROM crude
WHERE country ilike ('bolivia%')

SELECT DISTINCT country
FROM crude
WHERE country ilike ('united kingdom%')

--avg suicide rate per age and region

SELECT CASE WHEN country IN('Argentina','Ecuador','Colombia','Peru','Venezuela','Bolivia (Plurinational State of)','Chile') THEN 'Andean'
	WHEN country IN('Germany','Belgium','France','Spain', 'Ireland', 'Italy','Switzerland','Netherlands','Portugal') THEN 'SouthWestern Europe'
	WHEN country IN('Denmark','Finland','Iceland','Norway','Sweden','United Kingdom of Great Britain and Northern Ireland') THEN 'Northern Europe'
	END AS region,
	ROUND(AVG("+80"),2) AS"+80", ROUND(AVG("70to79"),2)AS "7079", ROUND(AVG("60to69"),2)AS "6069"
, ROUND(AVG("50to59"),2) AS "5059",ROUND(AVG("40to49"),2) AS "4049",ROUND(AVG("30to39"),2) AS "3039", ROUND(AVG("20to29"),2) AS "2029", ROUND(AVG("10to19"),2) AS "1019"

FROM crude
WHERE country IN ('Argentina','Ecuador','Colombia','Peru','Venezuela','Bolivia (Plurinational State of)','Chile',
				'Germany','Belgium','France','Spain', 'Ireland', 'Italy','Switzerland','Netherlands','Portugal', 
				 'Denmark','Finland','Iceland','Norway','Sweden','United Kingdom of Great Britain and Northern Ireland')
GROUP BY region

--avg crude suicide rate per region and sex

SELECT sex, ROUND (AVG("2016"),2) AS "2016_suicide_rate", 
	CASE WHEN country IN('Argentina','Ecuador','Colombia','Peru','Venezuela','Bolivia (Plurinational State of)','Chile') THEN 'Andean'
	WHEN country IN('Germany','Belgium','France','Spain', 'Ireland', 'Italy','Switzerland','Netherlands','Portugal') THEN 'SouthWestern Europe'
	WHEN country IN('Denmark','Finland','Iceland','Norway','Sweden','United Kingdom of Great Britain and Northern Ireland') THEN 'Northern Europe'
	END AS region
FROM age_standarized
WHERE country IS NOT NULL AND country IN ('Argentina','Ecuador','Colombia','Peru','Venezuela','Bolivia (Plurinational State of)','Chile',
				'Germany','Belgium','France','Spain', 'Ireland', 'Italy','Switzerland','Netherlands','Portugal', 
				 'Denmark','Finland','Iceland','Norway','Sweden','United Kingdom of Great Britain and Northern Ireland') AND sex <>'Both sexes'
GROUP BY region, sex
ORDER BY "2016_suicide_rate" DESC

--avg crude suicide rate, outpatiens_facilities,mental_hospitals, community-based residential facilities and hospital mental health units

WITH re AS (
SELECT country,
CASE WHEN country IN('Argentina','Ecuador','Colombia','Peru','Venezuela','Bolivia (Plurinational State of)','Chile') THEN 'Andean'
	WHEN country IN('Germany','Belgium','France','Spain', 'Ireland', 'Italy','Switzerland','Netherlands','Portugal') THEN 'SouthWestern Europe'
	WHEN country IN('Denmark','Finland','Iceland','Norway','Sweden','United Kingdom of Great Britain and Northern Ireland') THEN 'Northern Europe'
	END AS region
FROM crude
	WHERE country IS NOT NULL AND country IN ('Argentina','Ecuador','Colombia','Peru','Venezuela','Bolivia (Plurinational State of)','Chile',
				'Germany','Belgium','France','Spain', 'Ireland', 'Italy','Switzerland','Netherlands','Portugal', 
				 'Denmark','Finland','Iceland','Norway','Sweden','United Kingdom of Great Britain and Northern Ireland')
)
SELECT region, round(AVG("2016"),2) AS "2016", round(AVG(outpatient_facilities),2) as avg_outpatient, round(AVG(mental_hospitals),2) AS avg_mentalh,
round(AVG(health_units),2) AS avg_hunits, round(AVG(residential_facilities),2)AS avg_community_res
FROM age_standarized as a
RIGHT JOIN re
USING (country)
LEFT JOIN facilities
USING(country)
GROUP BY region;

--avg mental health providers 

WITH re AS (
SELECT country,
CASE WHEN country IN('Argentina','Ecuador','Colombia','Peru','Venezuela','Bolivia (Plurinational State of)','Chile') THEN 'Andean'
	WHEN country IN('Germany','Belgium','France','Spain', 'Ireland', 'Italy','Switzerland','Netherlands','Portugal') THEN 'SouthWestern Europe'
	WHEN country IN('Denmark','Finland','Iceland','Norway','Sweden','United Kingdom of Great Britain and Northern Ireland') THEN 'Northern Europe'
	END AS region
FROM crude
	WHERE country IS NOT NULL AND country IN ('Argentina','Ecuador','Colombia','Peru','Venezuela','Bolivia (Plurinational State of)','Chile',
				'Germany','Belgium','France','Spain', 'Ireland', 'Italy','Switzerland','Netherlands','Portugal', 
				 'Denmark','Finland','Iceland','Norway','Sweden','United Kingdom of Great Britain and Northern Ireland')
)

SELECT region,round(AVG(psychologists),2) AS avg_psychologist, round(stddev(psychologists),2) AS stddev_psychologist, percentile_disc(0.5) within group (order by psychologists) AS median_psychologist
FROM re
INNER JOIN hr
USING(country)
LEFT JOIN facilities
USING(country)
GROUP BY region

--standard deviation and median of mental health providers
WITH re AS (
SELECT country,
CASE WHEN country IN('Argentina','Ecuador','Colombia','Peru','Venezuela','Bolivia (Plurinational State of)','Chile') THEN 'Andean'
	WHEN country IN('Germany','Belgium','France','Spain', 'Ireland', 'Italy','Switzerland','Netherlands','Portugal') THEN 'SouthWestern Europe'
	WHEN country IN('Denmark','Finland','Iceland','Norway','Sweden','United Kingdom of Great Britain and Northern Ireland') THEN 'Northern Europe'
	END AS region
FROM crude
	WHERE country IS NOT NULL AND country IN ('Argentina','Ecuador','Colombia','Peru','Venezuela','Bolivia (Plurinational State of)','Chile',
				'Germany','Belgium','France','Spain', 'Ireland', 'Italy','Switzerland','Netherlands','Portugal', 
				 'Denmark','Finland','Iceland','Norway','Sweden','United Kingdom of Great Britain and Northern Ireland')
)
SELECT DISTINCT country,region
FROM re
INNER JOIN hr
USING(country)
ORDER BY region ASC


--avg mental health providers and crude suicide rate

WITH re AS (
SELECT country,
CASE WHEN country IN('Argentina','Ecuador','Colombia','Peru','Venezuela','Bolivia (Plurinational State of)','Chile') THEN 'Andean'
	WHEN country IN('Germany','Belgium','France','Spain', 'Ireland', 'Italy','Switzerland','Netherlands','Portugal') THEN 'SouthWestern Europe'
	WHEN country IN('Denmark','Finland','Iceland','Norway','Sweden','United Kingdom of Great Britain and Northern Ireland') THEN 'Northern Europe'
	END AS region
FROM crude
	WHERE country IS NOT NULL AND country IN ('Argentina','Ecuador','Colombia','Peru','Venezuela','Bolivia (Plurinational State of)','Chile',
				'Germany','Belgium','France','Spain', 'Ireland', 'Italy','Switzerland','Netherlands','Portugal', 
				 'Denmark','Finland','Iceland','Norway','Sweden','United Kingdom of Great Britain and Northern Ireland')
)
SELECT region,ROUND(AVG("2016") ,2) AS "2016 suicide_rate", percentile_disc(0.5) within group (order by psychologists) AS median_psychologist
FROM age_standarized
RIGHT JOIN re
USING(country)
INNER JOIN hr
USING(country)
GROUP BY region