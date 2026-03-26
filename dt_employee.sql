WITH
    employees
    AS
    (
        SELECT
            E."EmployeeID",
            E."FirstName" || ' ' || E."LastName" AS "FullName",
            EXTRACT(YEAR FROM E."BirthDate") AS "BirthYear",
            E."City" AS "CityName",
            E."Address" as  "Address",
            E."Region" as "Region",
            E."PostalCode" as "PostalCode",
            E."ReportsTo" as "SupervisionKey",
            E."Title" as "Title",
            E."HireDate" as "Hiredate",
            E."Country" as "Country"
        FROM {{ source
    
    
    
    
    
    
    
    
    
    
    
    
    
    
     
    ( 'northwind_db', 'Employees') }} E
),
cities AS
(
    SELECT
    ci."CityKey",
    ci."CityName"
FROM {{ ref
('dt_city') }} ci
),
Employee_final  As
(
SELECT
    {{ dbt_utils
.generate_surrogate_key
(['E."EmployeeID"']) }} AS "EmployeeKey",
E.*,ci."CityKey"
FROM Employees E
LEFT JOIN cities ci
ON E."CityName" = ci."CityName")
    select
        EF."EmployeeKey",
        EF."EmployeeID",
        EF."FullName",
        EF. "BirthYear",
        EF. "CityName",
        EF."Address",
        EF."Region",
        EF. "PostalCode",
        EF."Title",
        EF."Hiredate",
        EF. "Country",
        EF."CityKey",
        sup."EmployeeKey" as "SupervisionKey"
    from
        Employee_final EF
        left join Employee_final sup
        On sup."EmployeeID"=EF."SupervisionKey"


UNION ALL
    SELECT
        'default_employee' as "EmployeeKey",
        0 as "EmployeeID",
        'default_name' as "FullName",
        9999 as "BirthYear",
        'no city' as "CityName",
        'No Address' as "Address",
        'no region' as "Region",
        'NA' as "PostalCode",
        'noTitle' as "Title",
        '9999-01-01' as "HireDate",
        'No Country' as "Country",
        'NO CITY KEY' as "CityKey",
        'head' as "SupervisionKey"

