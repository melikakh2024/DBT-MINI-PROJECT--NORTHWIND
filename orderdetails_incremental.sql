{{ config(
    materialized='incremental',
    strategy='append'
) }}
SELECT
  od."OrderID",
  od."ProductID",
  od."UnitPrice",
  od."Quantity",
  od."Discount",
  p."SupplierID",
  od."ProductID"::text || '-' || od."OrderID"::text AS "OrderLine",
  od."SRC_ModifiedDate"
FROM {{ source('northwind_db','OrderDetails') }} od join {{ source('northwind_db','Products')}} p ON od."ProductID"=p."ProductID"

{% if is_incremental() %}
WHERE od."SRC_ModifiedDate" >
      (SELECT MAX(o."SRC_ModifiedDate") FROM {{ this }} o)
{% endif %}
