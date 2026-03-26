with
    supplier
    as
    (
        select
            "SupplierID",
            "Address" ,
            "PostalCode",
            "City"
        from {{source
    ('northwind_db','Suppliers')}}
)
select
    {{dbt_utils
.generate_surrogate_key
(['s."SupplierID"'])}} as "SupplierKey",
s."SupplierID",
s."Address", 
s."PostalCode",
ci."CityName"
from supplier s left join {{ ref
('dt_city')}} ci on s."City"=ci."CityName"

union all
select
    'default-SupplierId' as  "SupplierKey",
    '0' as "SupplierID",
    'No Address' as "Address",
    '0' as "postalCode",
    '0' as "CityCode"