{{ config(
    materialized='table'
) }}

WITH cities_countries_states AS (
    SELECT DISTINCT
        c."City" AS CityName,
        COALESCE(s."StateName", 'No State') AS StateName,
        COALESCE(t."CountryName", 'No Country') AS CountryName,
        t."CountryCode" AS CountryCode
    FROM {{ ref('cities') }} c
    LEFT JOIN {{ ref('dt_state') }} s
        ON c."State" = s."StateName"
        OR c."State" = s."EnglishStateName"
    LEFT JOIN {{ ref('dt_country') }} t
        ON c."Country" = t."CountryName"
        OR c."Country" = t."CountryCode"
)

SELECT
    {{ dbt_utils.generate_surrogate_key([
        'CityName',
        'StateName',
        'CountryName',
        'CountryCode'
    ]) }} AS "CityKey",
    CityName,
    {{ dbt_utils.generate_surrogate_key([
        'StateName',
        'CountryName',
        'CountryCode'
    ]) }} AS "StateKey",
    {{ dbt_utils.generate_surrogate_key([
        'CountryName',
        'CountryCode'
    ]) }} AS "CountryKey"
FROM cities_countries_states

UNION ALL

SELECT
    'default_city_key' AS "CityKey",
    'No City' AS CityName,
    'default_state' AS "StateKey",
    'default_country' AS "CountryKey"
