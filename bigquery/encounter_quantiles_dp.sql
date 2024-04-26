-- calculates quantiles of the number of encounters per patient within each encounter class
SELECT
WITH DIFFERENTIAL_PRIVACY OPTIONS (
  epsilon = 0.7,
  delta = 1e-7,
  privacy_unit_column = patient_id
)
  encounter_class,
  round(PERCENTILE_CONT(num_encounters, 0.5, contribution_bounds_per_row => (0, 10000)), 1) AS median_encounters,
  round(PERCENTILE_CONT(dp_num_encounters, 0.9, contribution_bounds_per_row => (0, 10000)), 1) AS p90_encounters
FROM (
  SELECT
    class.code AS encounter_class,
    subject.patientId AS patient_id,
    COUNT(DISTINCT id) AS num_encounters 
  FROM
    `bigquery-public-data.fhir_synthea.encounter`
  GROUP BY
    encounter_class, patient_id
)
GROUP BY encounter_class ORDER BY encounter_class;
