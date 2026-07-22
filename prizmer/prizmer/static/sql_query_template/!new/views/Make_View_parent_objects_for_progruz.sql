-- View: public.parent_objects_for_progruz

DROP VIEW public.parent_objects_for_progruz;

CREATE OR REPLACE VIEW public.parent_objects_for_progruz
 AS
WITH RECURSIVE parent_obj AS (
    -- Базовый запрос: выбираем корневые объекты (те, у которых нет родителей или они NULL)
    SELECT 
        objects.guid,
        objects.name,
        objects.level,
        objects.guid_parent
    FROM 
        objects
    WHERE 
        objects.guid_parent IS NULL
    
    UNION ALL
    
    -- Рекурсивная часть: выбираем дочерние объекты
    SELECT 
        child.guid,
        child.name,
        child.level,
        child.guid_parent
    FROM 
        objects child
    JOIN 
        parent_obj parent ON child.guid_parent::text = parent.guid::text
)
SELECT 
    parent_obj.name AS parent_name,
    objects.name AS object_name,
    abonents.name AS abonent_name,
    objects.guid AS object_guid,
    abonents.guid AS abonent_guid
FROM 
    abonents
JOIN 
    objects ON abonents.guid_objects::text = objects.guid::text
LEFT JOIN 
    parent_obj ON objects.guid_parent::text = parent_obj.guid::text;

ALTER TABLE public.parent_objects_for_progruz
    OWNER TO postgres;

