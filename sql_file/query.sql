WITH gdp_data AS (
  --obtener GDP Data (NY.GDP.PCAP.CD / GDP per capita)
  SELECT country_code, country_name, year, value as gdp_per_capita
  FROM `bigquery-public-data.world_bank_wdi.indicators_data`
  WHERE indicator_code = 'NY.GDP.PCAP.CD'
    AND country_code IN ('MEX', 'BRA', 'ARG', 'COL', 'CHL', 'PER')
    AND year >= 2010
),

internet_data AS (
  --obtener Internet Data (IT.NET.USER.ZS / % of population using the Internet)
  SELECT country_code, year, value as internet_penetration
  FROM `bigquery-public-data.world_bank_wdi.indicators_data`
  WHERE indicator_code = 'IT.NET.USER.ZS'
    AND country_code IN ('MEX', 'BRA', 'ARG', 'COL', 'CHL', 'PER')
    AND year >= 2010
)

SELECT
  t1.country_name,
  t1.country_code,
  t1.year,

-- Limpieza 
  ROUND(t1.gdp_per_capita, 2) AS gdp_per_capita,
  ROUND(t2.internet_penetration, 2) AS internet_pct,

  -- 2 nuevas metricas (digital_efficiency_index / economy_segment)
  
  ROUND(t2.internet_penetration / (t1.gdp_per_capita / 1000), 2) AS digital_efficiency_index,
  --Cuántos puntos de adopción digital existen por cada $1,000 USD de GDP per capita.

  CASE WHEN t1.gdp_per_capita > 15000 THEN 'High Income' ELSE 'Developing' END AS economy_segment
  --separar segmentos 

FROM gdp_data t1
JOIN internet_data t2
--unes tablas
  ON t1.country_code = t2.country_code AND t1.year = t2.year
  --emparejas tablas
ORDER BY t1.country_name, t1.year DESC;
--ordenas antes de devolver