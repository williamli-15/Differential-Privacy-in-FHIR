-- finds the 25th and 75th percentile cholesterol values for cholesterol observations, grouped by LOINC name
SELECT
WITH DIFFERENTIAL_PRIVACY
  OPTIONS (
    epsilon = 0.6,
    delta = 1e-7,
    privacy_unit_column = subject.patientId
  )
  cc.display loinc_name,
  round(PERCENTILE_CONT(o.value.quantity.value, 0.25, contribution_bounds_per_row => (0, 10000)), 1) AS median_chol,
  round(PERCENTILE_CONT(o.value.quantity.value, 0.75, contribution_bounds_per_row => (0, 10000)), 1) AS p90_chol
FROM
  `bigquery-public-data.fhir_synthea.observation` o, 
o.code.coding cc
WHERE
  lower(cc.display) like '%cholesterol%'
GROUP BY 1
ORDER BY 1 desc
