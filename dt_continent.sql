
WITH
    continents
    AS
    (
        SELECT DISTINCT t."ContinentName"
        FROM {{ ref
    ('territories') }} t
  )
SELECT {{ dbt_utils
.generate_surrogate_key
([
           'c."ContinentName"'
         ]) }} AS "ContinentKey",
         c."ContinentName"
  FROM   continents c