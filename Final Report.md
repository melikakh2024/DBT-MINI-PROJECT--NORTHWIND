<p align='center'>
<span style="font-size:22px"><b>Northwind Data warehouse</b></span></p>
<p align='center'>
<span style="font-size:14 px" >(Snowflake)</span></p>


<span style="font-size:18px">[source](fig/northwind_source.pdf)</span>
<span style="font-size:18px">[Target](fig/northwind_Target.pdf)</span>
#### NorthWind DataWareHouse Lineage
![NorthWind DataWareHouse Lineage](lineage.png)

<u><b>Introduction</b></u>
<div style="border:2px solid #2c3e50; padding:10px; border-radius:5px; background-color:#f9f9f9;">
This data warehouse uses the </b>Northwind Postgres data base</b> along with two auxiliary files : a <b>Time CSV</b> for generating a time dimension and  an </b>XML file</b> for adding Geography and city dimension in the target system . 
<b>DBT</b> was used for ETL process , and <b>snowflake</b>was chosen as target schema. 
The following parts describe the<b>Dimensions</b> ,<b>fact</b> , and mechanisms </b>Changing data Capture(CDC)</b> and <b>Slowly Changing dimensions (SCD)</b>
</div>

### [Customer Dimension](fig/dim_customer.png)
###### [click here to view full- size image](fig/dim_customer.png)
---------
This dimension was built from 'customer_snapshot' table.Columns were chosen to support analysis and to enable **Slowly Change Dimension(SCD) tracking** using DBT mechanisms.
**Surrogate Key:** 'Customerkey' was generated using 'dbt_utils.generate_surrogate_key' to uniquely identify each row . 
**Columns:** Includes 'CustomerID',CompanyName, Address, PostalCode, and CityKey. 
**CItyKey:** Obtained by joining with the 'dt_city' dimension to connect customer location data . 
**SCD Mechansim** Changes are tracked via snapshots stored in the 'schema' yaml, allowing historical tracking of customer information

### [Employee Dimension]
###### [click here to view full- size image](fig/employee.png)
--------

This dimension represents key attributes of employees for analytical purposes. It is derived from Employees table in the Northwind database and joined with the city to include dimension to citykey as a foreign key. 
**surrogate key:** Employee key  uniquely identifies each row and is generated using dbt_utils.generate_ key.
**Default Rows** are included to prevent null values and ensure stable ETL processing in fact table.
**Columns** include **EmployeeID**, **FullName**, **BirthYear**, **Title**, **HireDate**, **CityName**, **CityKey**, **Address**, **Region**, **PostalCode**, **Country**, and **SupervisionKey**

### [Product Dimension](fig/product.png)
###### Click to view full-size image: [Product Dimension](fig/product.png)

This dimension represents key attributes  sourced from the Products table in Northwind database and joined with the Categories table to include Category information. 
Columns are selected for analytical purposes and include `ProductKey`, `ProductName`, `QuantityPerUnit`, `UnitPrice`, `Discontinued`, and `CategoryKey`.
The surrogate key (**Product Key**, **ProductName**)  is generated using dbt_utils.generate_surrogate_key to uniquely identify each row. The Category key (**CategoryKey**) serves as a foreign key and is built using the MD5 method to uniquely identify each row in Category dimension. 

----
### Shipper dimension 
###### Click to view full-size image: [shipper Dimension](fig/Supplier.png)

This dimension represents two attributes derived from the Shippers table in the Northwind database. Columns are selected for analytical purposes involve **ShipperKey** and **CompanyName**.  
The surrogate key(**ShipperKey**) is generated using 'dbt_utils.generate_surrogate_key' to uniquely  identify each row.

---
### [Supplier Dimension](fig/Supplier.png)
###### Click to view full-size image: [supplier Dimension](fig/Supplier.png)

This dimension represents attributes sourced from the Suppliers table in the Northwind database.
Columns include `SupplierID`, `Address`, `PostalCode`, and `CityName`.
The **CityName** attribute is derived from joining with the City dimension.
Default rows are included in this dimension to ensure stable ETL processing in the fact table.
The surrogate key (**SupplierKey**) is generated using `dbt_utils.generate_surrogate_key` to uniquely identify each row.

------
#### The information in Auxiliary Files 
<div style="border:2px solid ; padding:10px; border-radius:5px; background-color:#f9f9f9;">
The Territories table is a supporting table used for the City dimension. Geography information is extracted from an XML file by a transformation run by **DBT** and is stored in the Territories table. Other auxiliary tables used to generate the City dimension are `dt_continent`, `dt_country`, and `dt_state`. The `dt_continent` table includes the columns `ContinentKey` and `ContinentName`. The `dt_country` table includes the columns `CountryKey`, `CountryName`, `CountryCode`, `CountryCapital`, `Population`, and `Subdivision`. Another auxiliary file is `cities.csv`, which populates the `Cities` table using the DBT seed mechanism. Thus, the `Cities` table and the `dt_country` table are used in constructing the City dimension. Importantly, the `Cities` table includes information for all countries. This table is left-joined with the `dt_country` and `dt_state` tables to build the City .
</div>

----
###  [Geography ](fig/cities.png) 
###### Click to view full-size image: [geography Dimension](fig/cities.png)

This dimension represents attributes sourced from the territories table in the Northwind database (auxiliary folder).
The surrogate key (**CityKey**) is generated using dbt_utils.generate_surrogate_key to uniquely identify each row.
Foreign keys (**StateKey** and **CountryKey**) are also generated as surrogate keys for each state and country.
Default rows are included to ensure stable ETL processing and prevent join disruptions with dt_country and dt_state.
A default entry is added for Singapore when no state or country data exists, ensuring consistent handling in downstream tables.

---![test](./fig/cities.png)س

