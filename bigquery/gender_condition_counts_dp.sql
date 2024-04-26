-- counts the number of occurrences of the condition "Viral sinusitis (disorder)", grouped by gender

SELECT
WITH DIFFERENTIAL_PRIVACY
  OPTIONS (
    epsilon = 0.5,
    delta = 1e-7,
    privacy_unit_column = p.id
  )
  gender,
  code.text AS condition,
  COUNT(*) AS condition_count
FROM
  `bigquery-public-data.fhir_synthea.condition` c
JOIN
  `bigquery-public-data.fhir_synthea.patient` p
  ON c.subject.patientId = p.id
WHERE
  code.text = 'Viral sinusitis (disorder)'
GROUP BY
  gender,
  code.text;

-- Query results may differ slightly with each run
-- due to noise being applied
