# DBT-MINI-PROJECT--NORTHWIND
creating datawarehouse using DBT 
<p align='center'>
<span style="font-size:22px"><b>Northwind Data warehouse</b></span></p>
<p align='center'>
<span style="font-size:14 px" >(Snowflake)</span></p>

<span style="font-size:18px">[source](fig/northwind_source.pdf)</span>

<span style="font-size:18px">[Target](fig/northwind_Target.pdf)</span>
#### NorthWind DataWareHouse Lineage

![NorthWind DataWareHouse Lineage](lineage.png)


<div style="border:2px solid #2c3e50; padding:10px; border-radius:5px; background-color:#f9f9f9;">
This data warehouse uses the </b>Northwind Postgres data base</b>
 along with two auxiliary files : a <b>Time CSV</b> for generating a time dimension and  an </b>
 <b>XML file</b> for adding Geography and city dimension in the target system . 
<b>DBT</b> was used for ETL process , and <b>snowflake</b>was chosen as target schema. 
The following parts describe the<b>Dimensions</b> ,<b>fact</b> , and mechanisms </b>Changing data Capture(CDC)</b> and <b>Slowly Changing dimensions (SCD)</b>
</div>
