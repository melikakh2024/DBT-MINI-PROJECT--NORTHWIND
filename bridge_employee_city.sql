select
    e."EmployeeKey",
    c."CityKey"
from {{ref
('dt_employee')}} e join {{ref
('dt_city')}} c on e."CityKey"=c."CityKey"