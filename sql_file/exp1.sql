 SELECT DISTINCT t0.indicator_code, t0.indicator_name
FROM `bigquery-public-data`.`world_bank_wdi`.`indicators_data` AS t0
WHERE LOWER(t0.indicator_name) LIKE '%gdp per capita%'
LIMIT 20;
