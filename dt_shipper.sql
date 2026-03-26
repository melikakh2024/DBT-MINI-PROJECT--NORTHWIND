Select
    {{dbt_utils
.generate_surrogate_key
(['"ShipperID"'])}} AS "ShipperKey",
    "ShipperID",
      "CompanyName"
 from {{source
('northwind_db','Shippers')}}   