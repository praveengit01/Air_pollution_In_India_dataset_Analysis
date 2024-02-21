Use air_pollution;

-- Retrieve the names of all cities in the dataset.

select * from cities;

-- Find the average AQI (Air Quality Index) for each city across all pollutants.

select c.CityName, avg(aq.AQI) as Average_AQI
from cities c
join airquality aq on c.CityID = aq.CityID
join pollutants p on aq.PollutantID = aq.PollutantID
group by c.cityname;

-- List the months in which the AQI in Delhi exceeded 320.

select c.cityName, month(aq.month) as Exceeding_Month
from cities c
join airquality aq on c.CityID = aq.CityID
where c.CityName = 'Delhi' and aq.AQI > 320;

-- Count the number of pollutants measured in the dataset.

select count(*) as Num_of_pollutant
from pollutants;

-- Get the AQI for all pollutants in Delhi for the month of January 2022.

select p.PollutantName, aq.AQI
from airquality aq
join cities c on aq.CityID = c.CityID
join pollutants p on aq.pollutantID = p.pollutantID
where c.cityName = 'Delhi' and month(aq.month) = 1 and year(aq.month) = 2022;

-- Calculate the maximum AQI recorded across all cities and pollutants.

select max(aq.AQI) as Maximum_AQI
from airquality aq;

-- Find the city with the highest average AQI over the entire time period

select c.cityname
from cities c
Inner join (
          select cityID, avg(AQI) as Average_AQI
          From airquality
          group by cityID
          )
As avgAQITable on c.cityID = avgAQITable.CityID
order by Average_AQI desc
Limit 1;

-- Calculate the total AQI recorded in each city over the entire time period

select C.CityName, sum(aq.AQI) as Total_AQI
from airquality aq
Inner Join cities c on aq.cityid = c.cityid
group by c.cityname;

-- Identify the pollutant with the highest average AQI across all cities

SELECT p.PollutantName
FROM Pollutants p
INNER JOIN (
    SELECT PollutantID, AVG(AQI) AS AvgAQI
    FROM AirQuality
    GROUP BY PollutantID
) AS AvgAQITable ON p.PollutantID = AvgAQITable.PollutantID
ORDER BY AvgAQI DESC
LIMIT 1;

-- Retrieve the top 5 cities with the highest average AQI for a specific pollutant

select c.cityname, avg(aq.AQI) as Average_AQI
from airquality aq
Inner join cities c on aq.cityID = c.cityID
where aq.PollutantID = 1
group by c.cityname
order by Average_AQI
limit 5;

-- Determine the month with the lowest AQI for each city 
SELECT c.CityName, MONTH(aqi.Month) AS LowestAQIMonth
FROM AirQuality aqi
INNER JOIN Cities c ON aqi.CityID = c.CityID
INNER JOIN (
           SELECT CityID, 
           MONTH(MinMonth) AS MinMonth
    FROM (
        SELECT CityID, 
               MIN(AQI) AS MinAQI,
               MIN(Month) AS MinMonth
        FROM AirQuality
        GROUP BY CityID
    ) AS MinAQITable
) AS LowestAQITable ON aqi.CityID = LowestAQITable.CityID AND MONTH(aqi.Month) = LowestAQITable.MinMonth;

-- Find the month-year combination with the lowest overall AQI across all cities and pollutants

SELECT MONTH(Month) AS Month, YEAR(Month) AS Year, MIN(AQI) AS MinAQI
FROM AirQuality
GROUP BY MONTH(Month), YEAR(Month)
ORDER BY MinAQI
LIMIT 1;


-- Calculate the percentage change in AQI for each city from January 2022 to December 2023

SELECT c.CityName, 
    (MAX(CASE WHEN YEAR(Month) = 2023 AND MONTH(Month) = 12 THEN AQI ELSE 0 END) -
    MIN(CASE WHEN YEAR(Month) = 2022 AND MONTH(Month) = 1 THEN AQI ELSE 0 END)) / 
    MIN(CASE WHEN YEAR(Month) = 2022 AND MONTH(Month) = 1 THEN AQI ELSE 0 END) * 100 
    AS PercentageChange
FROM AirQuality aqi
INNER JOIN Cities c ON aqi.CityID = c.CityID
GROUP BY c.CityName;
















