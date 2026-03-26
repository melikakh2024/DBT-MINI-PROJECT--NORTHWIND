
WITH
  dt_product
  AS
  (
    SELECT *
    FROM {{ ref
  
    ('dt_product') }}
  ),
  dt_category AS
(
      SELECT *
FROM {{ ref
('dt_category') }} 
  )
SELECT p."ProductKey" AS "ProductKey",
  p."ProductName" AS "ProductName",
  p."QuantityPerUnit" AS "QuantityPerUnit",
  p."UnitPrice" AS "UnitPrice",
  p."Discontinued" AS "Discontinued",
  cat."CategoryKey" AS "CategoryKey",
  cat."CategoryName" AS "CategoryName",
  cat."Description" AS "CategoryDescription"
FROM dt_product p JOIN
  dt_category cat ON p."CategoryKey" = cat."CategoryKey"