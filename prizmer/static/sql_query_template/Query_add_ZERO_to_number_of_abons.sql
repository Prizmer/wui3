UPDATE objects
   SET  name='Квартира '::text||right('00'::text||substring(objects.name from 10), 3)
 WHERE objects.name LIKE '%Квартира%';
