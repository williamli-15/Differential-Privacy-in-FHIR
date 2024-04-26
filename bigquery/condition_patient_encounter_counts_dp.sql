-- CTE for diabetics based on condition codes for prediabetes and diabetes
WITH Diabetics AS (
  SELECT subject.patientId AS person_ref
  FROM `bigquery-public-data.fhir_synthea.condition`,
       UNNEST(code.coding) coding
  WHERE coding.code IN ('15777000', '44054006')
),
-- CTE for HbA1c values
HbA1c_Values AS (
  SELECT subject.patientId AS person_ref,
         value.quantity.value AS hba1c_value
  FROM `bigquery-public-data.fhir_synthea.observation`,
       UNNEST(code.coding) coding
  WHERE coding.code = '4548-4'
),
-- Subquery for unique patient IDs with high HbA1c
High_HbA1c_Diabetics AS (
  SELECT DISTINCT d.person_ref
  FROM Diabetics d
  JOIN HbA1c_Values h ON d.person_ref = h.person_ref
  WHERE h.hba1c_value > 6.5
)
-- Apply differential privacy when counting
SELECT
WITH DIFFERENTIAL_PRIVACY OPTIONS (
    epsilon = 0.3,
    delta = 1e-7,
    privacy_unit_column = person_ref
) 
  COUNT(*) AS num_diabetics_with_high_hba1c
FROM High_HbA1c_Diabetics;
