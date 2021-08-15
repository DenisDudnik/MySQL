USE edb;

-- ������ ���������� ��������� � ��������� ������
SELECT count(meter_id) FROM structure_groups WHERE group_id = 2;


-- ������ ����������� ������� ��������, ��������� � ��������� ������, � ������ ����� ��������� �� ���������� ���� � ��������
SELECT md.meter_id, int_val* IF(sg.sign = '+', 1, -1) AS val 
    FROM meters_data md
    JOIN structure_groups sg ON sg.meter_id = md.meter_id 
        WHERE 
            md.meter_id IN (SELECT sg.meter_id FROM structure_groups WHERE sg.group_id = 1) 
            AND 
            md.value_date = '2021-08-01' 
            AND 
            md.int_num = 1 
    GROUP BY md.meter_id 
;

-- ������ ���������� ��������� � ������� ��������� ������, � ������� ������ ������ �� ������������ ���� � ��������
SELECT count(*)
    FROM meters_data md
        WHERE 
            md.meter_id IN (SELECT sg.meter_id FROM structure_groups sg WHERE sg.group_id = 1) 
            AND 
            md.value_date = '2021-08-01' 
            AND 
            md.int_num = 1
;


-- ������ ����������� ������ (������������� ���������) �� ������������ ���� � ��������
SELECT sum(int_val_with_sign) AS gr_sum FROM    -- �������� ����� �������� �� ���������
                (
                SELECT int_val * IF(sg.sign = '+', 1, -1) AS int_val_with_sign -- �������� �������� �� �������� �� ���������, �������� � ������, � ������ �����
                FROM meters_data md
                JOIN structure_groups sg ON sg.meter_id = md.meter_id 
                    WHERE 
                        md.meter_id IN (SELECT sg.meter_id FROM structure_groups WHERE sg.group_id = 1) 
                        AND 
                        md.value_date = '2021-08-01' 
                        AND 
                        md.int_num = 1 
                GROUP BY md.meter_id 
                ) sm ;


-- ��������� ����������� �� ������ �� ���������� ���� � �������� � ������� (��� ������� ������ �� ���� �������� - ��������� ������ � �������)
INSERT INTO groups_data (value_date, int_num, group_id, int_val, dt, user_id) VALUES('2021-08-01', 1, 1, 2000000.555555, NOW(), 3) 
    ON DUPLICATE KEY UPDATE int_val = 2000000.555555, dt = NOW(), user_id = 3;


-- ����� ���������, ������� ����������� ����������� ������ �� ������������ ���� � ��������, ��������� ������� ��������� ������ � ������, �� ������� ���������
-- ��������� ������, � ���������� ��� ������ � �������
CALL calc_group(4, '2021-08-01', 1);


-- ������ ��������� ������ � ����������� ���� �� ������
SELECT * FROM groups_desc WHERE gr_id = 1;


-- ������ �������� ��������� � ����������� ���� �� ������
SELECT * FROM meters_desc;

