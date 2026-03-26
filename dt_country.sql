WITH
  countries
  AS
  (
    SELECT DISTINCT
      t."CountryName",
      t."CountryCode",
      t."CountryCapital",
      t."Population",
      t."Subdivision",
      t."ContinentName"
    FROM {{ ref
  
  
  
  
  ('territories') }} t
),

singapore AS
(
    SELECT
  'Singapore'       AS "CountryName",
  'SG'              AS "CountryCode",
  'Singapore'       AS "CountryCapital",
  Null          AS "Population",
  NULL              AS "Subdivision",
  'Asia'            AS "ContinentName"
)

SELECT
  {{ dbt_utils
.generate_surrogate_key
([
        'c."CountryName"', 'c."CountryCode"'
    ]) }} AS "CountryKey",
    c."CountryName",
    c."CountryCode",
    c."CountryCapital",
    c."Population",
    c."Subdivision",
    {{ dbt_utils.generate_surrogate_key
([
        'c."ContinentName"'
    ]) }} AS "ContinentKey"

FROM countries c

UNION ALL

SELECT
  {{ dbt_utils
.generate_surrogate_key
([
        's."CountryName"', 's."CountryCode"'
    ]) }} AS "CountryKey",
    s."CountryName",
    s."CountryCode",
    s."CountryCapital",
    s."Population",
    s."Subdivision",
    {{ dbt_utils.generate_surrogate_key
([
        's."ContinentName"'
    ]) }} AS "ContinentKey"

FROM singapore s
WHERE NOT EXISTS
(
    SELECT 1
FROM countries c
WHERE c."CountryName" = 'Singapore'
)