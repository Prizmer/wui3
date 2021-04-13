-- View: parent_objects_for_progruz

-- DROP VIEW parent_objects_for_progruz;

CREATE OR REPLACE VIEW parent_objects_for_progruz AS 
 WITH parent_obj2 AS (
         WITH parent_obj AS (
                 SELECT objects_2.guid AS obj_guid,
                    objects_2.name AS obj_name,
                    objects_2.level,
                    objects_2.guid_parent AS parent1_guid
                   FROM objects objects_2
                )
         SELECT objects_1.guid AS obj_guid2,
            objects_1.name AS obj_name2,
            objects_1.level AS level2,
            objects_1.guid_parent AS parent_guid2,
            parent_obj.obj_name
           FROM objects objects_1,
            parent_obj
          WHERE objects_1.guid_parent::text = parent_obj.obj_guid::text
        )
 SELECT parent_obj2.obj_name AS obj_name2,
    parent_obj2.obj_name2 AS obj_name1,
    objects.name AS obj_name0,
    abonents.name AS ab_name,
    objects.guid AS obj_guid,
    abonents.guid AS ab_guid
   FROM abonents,
    objects,
    parent_obj2
  WHERE abonents.guid_objects::text = objects.guid::text AND objects.guid_parent::text = parent_obj2.obj_guid2::text;

ALTER TABLE parent_objects_for_progruz
  OWNER TO postgres;
