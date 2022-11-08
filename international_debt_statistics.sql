/* International Debt Statistics */


/*
In this porject We analyze the international debt data from the World Bank. 
Finding the countries mentioned in the data and some information related to the different debt
indicators and the amounts of debt 
*/


-- -1- First 10 Rows

SELECT *
FROM international_debt
LIMIT 10;
-- ---------------------------------------------

-- -2-The number of distinct countries

SELECT COUNT(DISTINCT(country_name)) AS total_distinct_countries
FROM international_debt;
-- -------------------------------------------------------------

-- -3-Distinct Debt Indicators

SELECT DISTINCT(indicator_code) AS distinct_debt_indicators
FROM international_debt
ORDER BY distinct_debt_indicators;
-- ---------------------------------------------------------

-- -4-Total amount of Debt

SELECT 
    ROUND(SUM(debt)/1000000, 2) as total_debt
FROM international_debt; 
-- ---------------------------------------------

-- 5-Country with the highest Debt

SELECT 
    country_name, SUM(debt) as total_debt
FROM international_debt
GROUP BY country_name
ORDER BY total_debt desc
LIMIT 1;
-- -------------------------------------------------------

-- -6-Average Debt across Indicator

SELECT 
    indicator_code as debt_indicator,
    indicator_name,
    AVG(debt) as average_debt
FROM international_debt
GROUP BY debt_indicator, indicator_name
ORDER BY average_debt desc
LIMIT 10;
-- --------------------------------------

-- -7-Highest amount of Principal repayments

SELECT 
    country_name, indicator_name
FROM international_debt
WHERE debt = (SELECT 
                 MAX(debt)
             FROM international_debt
             WHERE indicator_code = 'DT.AMT.DLXF.CD');
-- -------------------------------------------------------

-- -8-The most common debt indicator

SELECT indicator_code, COUNT(indicator_code) as indicator_count
FROM international_debt
GROUP BY indicator_code
ORDER BY indicator_count desc, indicator_code desc
LIMIT 20;
-- --------------------------------------------

-- Maximum debt for each country

SELECT country_name, MAX(debt) as maximum_debt
FROM international_debt
GROUP BY country_name
ORDER BY maximum_debt desc
LIMIT 10






























