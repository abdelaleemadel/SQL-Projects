/* 
Exploring Covid19 data starting from 24th of Feb 2020 till 26th of Aug 2022*/

SELECT *
FROM  sql_exploration.covid_deaths
ORDER BY 3,4 desc


-- Selecting the columns that are going to be used

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM  sql_exploration.covid_deaths
WHERE continent is not null
ORDER BY location, date


-- Total_Cases vs Total_Deaths
-- Shows the probability of dying of a covid positive cases in each country

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
FROM  sql_exploration.covid_deaths
WHERE continent is not null
ORDER BY location, date


-- Total_Cases vs Total_Deaths
-- Shows the probability of dying of a covid positive cases in Egypt

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
FROM  sql_exploration.covid_deaths
WHERE continent is not null
and location like '%Egypt%'
ORDER BY location, date




-- The percentage of population infected with Covid
 
SELECT location, date, total_cases, population, (total_cases/population)*100 as infection_percentage
FROM  sql_exploration.covid_deaths
WHERE continent is not null
ORDER BY location, date



-- Countries with highest infection rate 

SELECT location, population, MAX(total_cases) as highest_infection_count, MAX((total_cases/population))*100 as highest_infection_rate
FROM  sql_exploration.covid_deaths 
WHERE continent is not null
GROUP BY location, population
ORDER BY highest_infection_rate desc



-- Countries with highest death count  

SELECT location, MAX(total_deaths) as total_deaths_count
FROM  sql_exploration.covid_deaths
WHERE  continent is not null
GROUP BY location
ORDER BY total_deaths_count desc



-- Continents death counts

SELECT continent, SUM(country_total_deaths) as continent_total_death
FROM (
  SELECT MAX(total_deaths) as country_total_deaths, location, continent
  FROM sql_exploration.covid_deaths
  WHERE continent is not null
  GROUP BY location, continent
  ORDER BY 2 desc) 
GROUP BY continent
ORDER BY 2 desc




-- Global death rate by day

SELECT date, SUM(new_cases) as new_cases, SUM(new_deaths) as new_deaths, (SUM(new_deaths)/SUM(new_cases)*100) as death_rate
FROM sql_exploration.covid_deaths
WHERE continent is not null
GROUP BY date
ORDER BY death_rate desc

-------------------------------------------------------------
-- covid vaccination 

SELECT *
FROM sql_exploration.covid_vaccinations 



-- Joining covid death with covid vaccinations
SELECT *
FROM sql_exploration.covid_deaths d 
JOIN sql_exploration.covid_vaccinations v
  ON d.location = v.location 
  AND d.date = v.date 
WHERE d.continent is not null


-- Total population vs Vaccinations 


SELECT d.continent, d.location, d.population, v.new_vaccinations
, SUM(v.new_vaccinations) OVER(PARTITION BY d.location ORDER BY d.location, d.date) as total_vac
FROM sql_exploration.covid_deaths d 
JOIN sql_exploration.covid_vaccinations v
  ON d.location = v.location 
  AND d.date = v.date 
WHERE d.continent is not null
ORDER BY 2,3




--Creating a table with the previous query



create view `portfolio-project-364006.sql_exploration.populationvac` as
select d.continent, d.location, d.date, d.population, v.new_vaccinations,
SUM( v.new_vaccinations) OVER (partition by d.location order by d.location,
d.date) as Rolling_people
from `portfolio-project-364006.sql_exploration.covid_deaths` d
join `portfolio-project-364006.sql_exploration.covid_vaccinations` v
	On d.location = v.location
	and d.date = v.date
where d.continent is not null



SELECT *
FROM `portfolio-project-364006.sql_exploration.populationvac`



-- Percentage of vaccinations per populations 

WITH popvac
AS
(
  SELECT d.continent, d.location, d.population, v.new_vaccinations
, SUM(v.new_vaccinations) OVER(PARTITION BY d.location ORDER BY d.location, d.date) as total_vac
FROM sql_exploration.covid_deaths d 
JOIN sql_exploration.covid_vaccinations v
  ON d.location = v.location 
  AND d.date = v.date 
WHERE d.continent is not null
)

SELECT *, (total_vac/population)*100 as vaccination_percentage
FROM popvac
