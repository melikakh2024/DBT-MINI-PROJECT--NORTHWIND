  WITH customers AS (
      SELECT *
      FROM   {{ ref('customers_snapshot') }}  
  ),
  cities AS (
      SELECT ci."CityKey" AS "CityKey",
             ci."CityName" AS "CityName"
      FROM   {{ ref('dt_city') }} ci
  )
  SELECT {{ dbt_utils.generate_surrogate_key(['c."CustomerID"']) }} As "CustomerKey" ,
         c."CustomerID" AS "CustomerID",
         c."CompanyName" AS "CompanyName",
         c."Address" AS "Address",
         c."PostalCode" AS "PostalCode",
         ci."CityKey"
  FROM   customers c LEFT JOIN
         cities ci ON c."City" = ci."CityName"
