
WITH
    src_products_categories
    AS
    (
        SELECT p."ProductID",
            p."ProductName",
            p."QuantityPerUnit",
            p."UnitPrice",
            p."Discontinued",
            cat."CategoryID",
            cat."CategoryName"
        FROM {{ source
    
    ('northwind_db', 'Products') }} p JOIN 
             {{ source
('northwind_db', 'Categories') }} cat 
               ON p."CategoryID" = cat."CategoryID"
  )
SELECT {{ dbt_utils
.generate_surrogate_key
(
              ['s."ProductID"', 's."ProductName"']
         ) }} AS "ProductKey",
           s."ProductID" AS "ProductID",
         s."ProductName" AS "ProductName",
         s."QuantityPerUnit" AS "QuantityPerUnit",
         s."UnitPrice" AS "UnitPrice",
         s."Discontinued" AS "Discontinued",
         MD5
(CONCAT
(s."CategoryID", s."CategoryName")) AS "CategoryKey"
  FROM   src_products_categories s