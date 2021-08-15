USE edb;

-- Запрос количества счетчиков в расчетной группе
SELECT count(meter_id) FROM structure_groups WHERE group_id = 2;


-- Запрос потребления каждого счетчика, входящего в расчетную группу, с учетом знака вхождения за конкретные дату и интервал
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

-- Запрос количества счетчиков в составе расчетной группы, с которых пришли данные за определенную дату и интервал
SELECT count(*)
    FROM meters_data md
        WHERE 
            md.meter_id IN (SELECT sg.meter_id FROM structure_groups sg WHERE sg.group_id = 1) 
            AND 
            md.value_date = '2021-08-01' 
            AND 
            md.int_num = 1
;


-- Запрос потребления группы (суммированием счетчиков) за определенный день и интервал
SELECT sum(int_val_with_sign) AS gr_sum FROM    -- Получаем сумму значений по счетчикам
                (
                SELECT int_val * IF(sg.sign = '+', 1, -1) AS int_val_with_sign -- Получаем значения за интервал по счетчикам, входящим в группу, с учетом знака
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


-- Добавляем потребление по группе за опреденный день и интервал в таблицу (при наличии данных за этот интервал - обновляем данные в таблице)
INSERT INTO groups_data (value_date, int_num, group_id, int_val, dt, user_id) VALUES('2021-08-01', 1, 1, 2000000.555555, NOW(), 3) 
    ON DUPLICATE KEY UPDATE int_val = 2000000.555555, dt = NOW(), user_id = 3;


-- Вызов процедуры, которая расчитывает потребление группы за определенную дату и интервал, проверяет сколько счетчиков входит в группу, от скольки счетчиков
-- поступили данные, и записывает эти данные в таблицу
CALL calc_group(4, '2021-08-01', 1);


-- Запрос структуры группы в читабельном виде из Вьюшки
SELECT * FROM groups_desc WHERE gr_id = 1;


-- Запрос описания счетчиков в читабельном виде из Вьюшки
SELECT * FROM meters_desc;

