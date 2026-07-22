Delete
from various_values
where id in
(
WITH b as
(
SELECT  min(various_values.id) as id,
meters.factory_number_manual::text||taken_params.name::text||various_values.date::text||various_values."time"::text   as key_str
FROM 
  public.various_values, 
  public.taken_params, 
  public.meters
WHERE 
  various_values.id_taken_params = taken_params.id AND
  taken_params.guid_meters = meters.guid 
 
  GROUP BY key_str HAVING COUNT(*) > 1
)

SELECT a.id
from
b,
(SELECT  various_values.id,
  meters.factory_number_manual::text||taken_params.name::text||various_values.date::text||various_values."time"::text as key_str
FROM 
  public.various_values, 
  public.taken_params, 
  public.meters
WHERE 
  various_values.id_taken_params = taken_params.id AND
  taken_params.guid_meters = meters.guid 
  ) as a

where b.key_str = a.key_str
and a.id <> b.id

)

