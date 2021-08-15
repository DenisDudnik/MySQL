USE edb;
CREATE OR REPLACE VIEW groups_desc AS
SELECT
    structure_groups.group_id AS gr_id,
    list_of_groups.name AS gr_name,
    meters.name AS meter_name,
    structure_groups.sign AS sign
FROM
    structure_groups
    JOIN list_of_groups ON list_of_groups.id=structure_groups.group_id
    JOIN meters ON meters.id=structure_groups.meter_id
;
    

CREATE OR REPLACE VIEW meters_desc AS
SELECT
    meters.id AS meter_id,
    meters.name AS meter_name,
    companies.name AS comp_name,
    objects.name AS obj_name,
    groups_in_objects.name AS gr_name,
    meters.point_name AS point_name,
    meters.serial_num AS sn
FROM
    meters
    JOIN companies ON companies.id=meters.company_id
    JOIN objects ON objects.id=meters.object_id
    JOIN groups_in_objects ON groups_in_objects.id=meters.group_in_object_id
    ;