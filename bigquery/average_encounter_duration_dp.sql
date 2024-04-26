-- retrieves the average duration of ambulatory encounters ('AMB')
SELECT
WITH DIFFERENTIAL_PRIVACY
  OPTIONS (
    epsilon = 0.5,
    delta = 1e-7,
    privacy_unit_column = subject.patientId
  )
  class.code encounter_class,
  ROUND(AVG(TIMESTAMP_DIFF(TIMESTAMP(period.end), TIMESTAMP(period.start), MINUTE)),1) as avg_minutes
FROM
  `bigquery-public-data.fhir_synthea.encounter`
WHERE
  period.end >= period.start
  AND class.code = 'AMB'
GROUP BY
  1
ORDER BY
  2 DESC
