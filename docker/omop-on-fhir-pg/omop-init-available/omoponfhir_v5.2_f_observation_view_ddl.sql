CREATE VIEW public.f_observation_view AS
SELECT
  measurement.measurement_id AS observation_id,
  measurement.person_id,
  measurement.measurement_concept_id AS observation_concept_id,
  measurement.measurement_date AS observation_date,
  measurement.measurement_datetime AS observation_datetime,
  measurement.measurement_type_concept_id AS observation_type_concept_id,
  measurement.operator_concept_id AS observation_operator_concept_id,
  measurement.value_as_number,
  NULL AS value_as_string,
  measurement.value_as_concept_id,
  NULL AS qualifier_concept_id,
  measurement.unit_concept_id,
  measurement.range_low,
  measurement.range_high,
  measurement.provider_id,
  measurement.visit_occurrence_id,
  measurement.measurement_source_value AS observation_source_value,
  measurement.measurement_source_concept_id AS observation_source_concept_id,
  measurement.unit_source_value,
  measurement.value_source_value,
  NULL AS qualifier_source_value
FROM
  public.measurement
UNION ALL
SELECT
  (-observation.observation_id) AS observation_id,
  observation.person_id,
  observation.observation_concept_id,
  observation.observation_date,
  observation.observation_datetime,
  observation.observation_type_concept_id,
  NULL AS observation_operator_concept_id,
  observation.value_as_number,
  observation.value_as_string,
  observation.value_as_concept_id,
  observation.qualifier_concept_id,
  observation.unit_concept_id,
  NULL AS range_low,
  NULL AS range_high,
  observation.provider_id,
  observation.visit_occurrence_id,
  observation.observation_source_value,
  observation.observation_source_concept_id,
  observation.unit_source_value,
  NULL AS value_source_value,
  observation.qualifier_source_value
FROM
  public.observation;