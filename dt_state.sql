WITH
  states
  AS
  (
    SELECT DISTINCT
      t."StateName",
      t."EnglishStateName",
      t."StateType",
      t."StateCode",
      t."StateCapital",
      t."RegionName",
      t."RegionCode",
      t."CountryName",
      t."CountryCode"
    FROM {{ ref
  ('territories') }} t
),

countries AS
(
    SELECT DISTINCT
  t."CountryName",
  t."CountryCode"
FROM {{ ref
('territories') }} t
),

state_entries AS
(
    SELECT
  {{ dbt_utils
.generate_surrogate_key
(["s.\"StateName\"", "s.\"CountryName\"", "s.\"CountryCode\""]) }} AS "StateKey",
        s."StateName" AS "StateName",
        COALESCE
(s."EnglishStateName", s."StateName") AS "EnglishStateName",
        s."StateType" AS "StateType",
        COALESCE
(s."StateCode", 'None') AS "StateCode",
        s."StateCapital" AS "StateCapital",
        COALESCE
(s."RegionName", 'No Region') AS "RegionName",
        COALESCE
(s."RegionCode", 'No Region') AS "RegionCode",
        {{ dbt_utils.generate_surrogate_key
(["s.\"CountryName\"", "s.\"CountryCode\""]) }} AS "CountryKey"
    FROM states s
),

default_state_entries AS
(
    SELECT
  {{ dbt_utils
.generate_surrogate_key
(["'No State'", "c.\"CountryName\"", "c.\"CountryCode\""]) }} AS "StateKey",
        CONCAT
(c."CountryName", ' - No State') AS "StateName",
        CONCAT
(c."CountryName", ' - No State') AS "EnglishStateName",
        'default' AS "StateType",
        'N/A' AS "StateCode",
        'N/A' AS "StateCapital",
        'No Region' AS "RegionName",
        'No Region' AS "RegionCode",
        {{ dbt_utils.generate_surrogate_key
(["'No State'", "c.\"CountryName\"", "c.\"CountryCode\""]) }} AS "CountryKey"
    FROM countries c

    UNION ALL

SELECT
  {{ dbt_utils
.generate_surrogate_key
(["'No State'", "'Singapore'", "'SG'"]) }} AS "StateKey",
        'Singapore - No State' AS "StateName",
        'Singapore - No State' AS "EnglishStateName",
        'default' AS "StateType",
        'N/A' AS "StateCode",
        'N/A' AS "StateCapital",
        'No Region' AS "RegionName",
        'No Region' AS "RegionCode",
(SELECT "CountryKey"
FROM {{ ref
('dt_country') }} WHERE "CountryName"='Singapore') AS "CountryKey"
)

  SELECT *
  FROM state_entries

UNION ALL

  SELECT *
  FROM default_state_entries