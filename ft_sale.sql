{{ config(
    materialized='incremental',
    strategy='merge',
    unique_key=['"OrderNo"','"OrderLine"']
  )
}}
with ft_orders as (
select
o."OrderNo",
od."OrderLine",
od."ProductID",
od."SupplierID",
od."UnitPrice",
od."Quantity",
od."Discount",
o."CustomerID",
o."EmployeeID",
o."OrderDate",
o."DueDate",
o."ShippedDate",
o."ShipperID",
o."Freight"
from {{ ref('orderdetails_incremental') }} od join {{ ref('orders_incremental') }} o  ON  od."OrderID"=o."OrderNo"
)
select 
p."ProductKey"    as   "ProductKey",
E."EmployeeKey"   as   "EmployeeKey",
CU."CustomerKey"  as   "CustomerKey",
Sh."ShipperKey"   as   "ShipperKey",
S."SupplierKey"   as   "SupplierKey",
t1."Date"         as   "OrderDate",
t2."Date"         as   "DueDate",
t3."Date"         as   "ShippedDate",
ft."OrderNo",
ft."OrderLine",
ft."UnitPrice",
ft."Quantity",
ft."Discount",
ft."Freight",
ft."Quantity" * ft."UnitPrice" as "TotalSale" 

from ft_orders ft join {{ ref('dt_customer') }} CU ON ft."CustomerID" = CU."CustomerID"
                 join {{ ref('dt_product') }}  P  ON ft."ProductID" = P."ProductID"
                 join {{ ref('dt_shipper') }} SH  ON ft."ShipperID" = SH."ShipperID"
                 join {{ ref('dt_supplier')}} S   ON ft."SupplierID" = S."SupplierID"
                 join {{ ref('dt_time') }}    t1  ON ft."OrderDate"=t1."Date"
                 join {{ ref('dt_time') }}    t2  ON ft."DueDate"=t2."Date"
                 join {{ ref('dt_time') }}    t3  ON ft."ShippedDate"=t3."Date"
                 join {{ ref('dt_employee') }} E  ON ft."EmployeeID" = E."EmployeeID"



