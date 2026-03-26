{{ 
    config(
        materialized='incremental',
        strategy='append'
    )
}}
SELECT
    s."CustomerID" AS "CustomerID",
    s."EmployeeID" AS "EmployeeID",
    s."OrderDate" AS "OrderDate",
    s."RequiredDate" AS "DueDate",
    s."ShippedDate" AS "ShippedDate",
    s."ShipVia" AS "ShipperID",
    s."OrderID" AS "OrderNo",
    s."Freight" AS "Freight",
    s."SRC_ModifiedDate" AS "TGT_ModifiedDate"
FROM {{ source('northwind_db', 'Orders') }} s

{% if is_incremental() %}
WHERE s."SRC_ModifiedDate" > (
    SELECT COALESCE(MAX(o."TGT_ModifiedDate"), '1970-01-01')
    FROM {{ this }} o
)
{% endif %}