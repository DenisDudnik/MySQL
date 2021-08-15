DROP DATABASE IF EXISTS edb;

CREATE DATABASE edb;

USE edb;


DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    login VARCHAR(120) UNIQUE NOT NULL,
    name VARCHAR(255),
    email VARCHAR(120) UNIQUE,
    phone BIGINT UNSIGNED UNIQUE,
    description text,
    password_hash VARCHAR(100),
    dt DATETIME DEFAULT NOW() ON UPDATE NOW(),

    INDEX users_login_idx(login),
    INDEX users_id_idx(id)
) DEFAULT CHARSET=UTF8MB4;


DROP TABLE IF EXISTS config;

CREATE TABLE config (
    name VARCHAR(255) NOT NULL COMMENT 'Название владельца системы',
    description text COMMENT 'Описание владельца системы', 
    int_in_sys INT UNSIGNED NOT NULL DEFAULT 30 COMMENT 'Интервал учета потребления в системе (в минутах)',
    dt DATETIME DEFAULT NOW() ON UPDATE NOW(),
    user_id BIGINT UNSIGNED NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id)
) DEFAULT CHARSET=UTF8MB4;


DROP TABLE IF EXISTS meters_types;

CREATE TABLE meters_types (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    manufacturer VARCHAR(120) NOT NULL DEFAULT 'UNKNOWN',
    model VARCHAR(64) NOT NULL DEFAULT 'UNKNOWN',
    modification VARCHAR(120) UNIQUE NOT NULL,
    description text,
    dt DATETIME DEFAULT NOW() ON UPDATE NOW(),
    user_id BIGINT UNSIGNED NOT NULL,

    INDEX meter_id_idx(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
) DEFAULT CHARSET=UTF8MB4;


DROP TABLE IF EXISTS data_providers;

CREATE TABLE data_providers (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
    description text,
    dt DATETIME DEFAULT NOW() ON UPDATE NOW(),
    user_id BIGINT UNSIGNED NOT NULL,

    INDEX providers_id_idx(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
) DEFAULT CHARSET=UTF8MB4;


DROP TABLE IF EXISTS companies;

CREATE TABLE companies (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    pos BIGINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Для ручной сортировки по соображениям пользователя',
    name VARCHAR(255) UNIQUE NOT NULL,
    description text,
    dt DATETIME DEFAULT NOW() ON UPDATE NOW(),
    user_id BIGINT UNSIGNED NOT NULL,

    INDEX companies_id_idx(id),
    INDEX companies_name_idx(name),
    FOREIGN KEY (user_id) REFERENCES users(id)
) DEFAULT CHARSET=UTF8MB4;


DROP TABLE IF EXISTS objects;

CREATE TABLE objects (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    company_id BIGINT UNSIGNED NOT NULL,
    pos BIGINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Для ручной сортировки по соображениям пользователя',
    name VARCHAR(255) NOT NULL,
    description text,
    dt DATETIME DEFAULT NOW() ON UPDATE NOW(),
    user_id BIGINT UNSIGNED NOT NULL,

    INDEX objects_id_idx(id),
    INDEX objects_name_idx(name),
    UNIQUE INDEX object_type_idx(company_id, name) COMMENT 'Сочетание Компания + Объект должно быть уникально',
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (company_id) REFERENCES companies(id)
) DEFAULT CHARSET=UTF8MB4;


DROP TABLE IF EXISTS groups_in_objects;

CREATE TABLE groups_in_objects (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    company_id BIGINT UNSIGNED NOT NULL,
    object_id BIGINT UNSIGNED NOT NULL,
    lvl VARCHAR(120) NOT NULL COMMENT 'Уровень группы внутри объекта (уровень напряжения, уровень давления воды или газа, этаж в доме и т.д.)',
    pos BIGINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Для ручной сортировки по соображениям пользователя',
    name VARCHAR(255) NOT NULL COMMENT 'Название группы. Внутри одного уровня может быть несколько групп',
    description text,
    dt DATETIME DEFAULT NOW() ON UPDATE NOW(),
    user_id BIGINT UNSIGNED NOT NULL,

    INDEX groups_in_objects_id_idx(id),
    INDEX groups_in_objects_name_idx(name),
    UNIQUE INDEX group_type_idx(company_id, object_id, lvl, name) COMMENT 'Сочетание Компания + Объект + Уровень + Группа должно быть уникально',
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (company_id) REFERENCES companies(id),
    FOREIGN KEY (object_id) REFERENCES objects(id)
) DEFAULT CHARSET=UTF8MB4;


DROP TABLE IF EXISTS meters;

CREATE TABLE meters (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    company_id BIGINT UNSIGNED NOT NULL,
    object_id BIGINT UNSIGNED NOT NULL,
    group_in_object_id BIGINT UNSIGNED NOT NULL,
    point_name VARCHAR(120) NOT NULL COMMENT 'Название точки установки счетчика (номер присоединения, номер квартиры, точная отметка на длине газопровода)',
    type_id BIGINT UNSIGNED NOT NULL COMMENT 'Тип счетчика',
    name VARCHAR(255) NOT NULL COMMENT 'Название потребителя (можно указать откуда и куда идет потребление через этот счетчик)',
    km INT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Коэффициент преобразования счетчика (например, температурный коэффициент счетчика газа)',
    i1 INT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Уровень на входе преобразователя, через который подключен счетчик (например, высокий ток у трансформатора тока)',
    i2 INT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Уровень на выходе преобразователя, через который подключен счетчик (например, низкий ток у трансформатора тока)',
    u1 INT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Уровень на входе преобразователя, через который подключен счетчик (например, высокое напряжение у трансформатора напряжения)',
    u2 INT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Уровень на выходе преобразователя, через который подключен счетчик (например, низкое напряжение у трансформатора напряжения)',
    int_frame INT UNSIGNED NOT NULL DEFAULT 30 COMMENT 'Интервал учета, настроенный на счетчике (минут). Должен совпадать с интервалом системы или быть его ровной частью (например, при системной настройке 30 мин. интервал счетчика может быть 1, 2, 3, 5, 6, 10, 15, 30)', 
    verify_date DATE DEFAULT '1970-01-01' COMMENT 'Дата поверки счетчика',
    verify_int INT UNSIGNED NOT NULL DEFAULT 48 COMMENT 'Межповерочный интервал (месяцев)',
    serial_num BIGINT UNSIGNED NOT NULL UNIQUE COMMENT 'Серийный номер счетчика (пока считаем, что у всех производителей и типов счетчиков номера отличаются)',
    description text,
    dt DATETIME DEFAULT NOW() ON UPDATE NOW(),
    user_id BIGINT UNSIGNED NOT NULL,

    INDEX meters_id_idx(id),
    UNIQUE INDEX meters_map_idx(company_id, object_id, group_in_object_id, point_name) COMMENT 'Сочетание Компания + Объект + Группа + Точка установки должно быть уникально',
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (company_id) REFERENCES companies(id),
    FOREIGN KEY (object_id) REFERENCES objects(id),
    FOREIGN KEY (group_in_object_id) REFERENCES groups_in_objects(id),
    FOREIGN KEY (type_id) REFERENCES meters_types(id)
) DEFAULT CHARSET=UTF8MB4;


DELIMITER //

DROP TRIGGER IF EXISTS check_verify_date_update //

CREATE TRIGGER check_verify_date_update BEFORE UPDATE ON meters
FOR EACH ROW
BEGIN
    IF NEW.serial_num != OLD.serial_num AND NEW.verify_date IS NULL
    THEN SET NEW.verify_date = '1970-01-01';
    END IF;
END //

DROP TRIGGER IF EXISTS check_verify_date_insert //

CREATE TRIGGER check_verify_date_insert BEFORE INSERT ON meters
FOR EACH ROW
BEGIN
    IF NEW.verify_date IS NULL
    THEN SET NEW.verify_date = '1970-01-01';
    END IF;
END //

DELIMITER ;


DROP TABLE IF EXISTS meters_data;

CREATE TABLE meters_data (
    value_date DATE NOT NULL COMMENT 'Дата за которую зафиксировано потребление', 
    int_num INT UNSIGNED NOT NULL COMMENT 'Номер интервала (по настройкам системы) за который зафиксировано потребление',
    int_val DECIMAL(18,6) COMMENT 'Потребление за интервал (с учетом коэффициентов). Если интервал счетчика меньше интервала системы, то в одну строку сложится сумма интервалов счетчика', 
    indication DECIMAL(18,6) COMMENT 'Показания счетчика на конец интервала',
    data_provider_id BIGINT UNSIGNED NOT NULL COMMENT 'Источник данных (счетчик, оператор)',
    meter_id BIGINT UNSIGNED NOT NULL COMMENT 'С какой точки измерения пришли данные',
    serial_num BIGINT UNSIGNED NOT NULL COMMENT 'Какой сер. номер был у счетчика в этот момент (со временем бывает замена счетчиков, а привязка должна быть к номеру реальному)',
    dt DATETIME DEFAULT NOW() ON UPDATE NOW(),
    user_id BIGINT UNSIGNED NOT NULL,

    UNIQUE INDEX data_idx(value_date, int_num, meter_id),
    FOREIGN KEY (data_provider_id) REFERENCES data_providers(id),
    FOREIGN KEY (meter_id) REFERENCES meters(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
) DEFAULT CHARSET=UTF8MB4;


DROP TABLE IF EXISTS list_of_groups;

CREATE TABLE list_of_groups (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    company_id BIGINT UNSIGNED NOT NULL,
    object_id BIGINT UNSIGNED NOT NULL,
    pos BIGINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Для ручной сортировки по соображениям пользователя', 
    name VARCHAR(255) NOT NULL COMMENT 'Название расчетной (балансовой) группы', 
    description text,
    dt DATETIME DEFAULT NOW() ON UPDATE NOW(),
    user_id BIGINT UNSIGNED NOT NULL,

    INDEX groups_id_idx(id),
    UNIQUE INDEX groups_name_idx(company_id, object_id, name) COMMENT 'Сочетание Компания + Объект + Балансовая группа должно быть уникально', 
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (company_id) REFERENCES companies(id),
    FOREIGN KEY (object_id) REFERENCES objects(id)
) DEFAULT CHARSET=UTF8MB4;


DROP TABLE IF EXISTS structure_groups;

CREATE TABLE structure_groups (
    group_id BIGINT UNSIGNED NOT NULL COMMENT 'Балансовая группа',
    meter_id BIGINT UNSIGNED NOT NULL COMMENT 'Счетчик входящий в балансовую группу',
    sign VARCHAR(1) NOT NULL DEFAULT '+' COMMENT 'Знак вхождения счетчика в балансовую группу',
    dt DATETIME DEFAULT NOW() ON UPDATE NOW(),
    user_id BIGINT UNSIGNED NOT NULL,

    UNIQUE INDEX groups_id_idx(group_id, meter_id, sign) COMMENT 'Сочетание Балансовая группа + Счетчик + Знак вхождения должно быть уникально', 
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (meter_id) REFERENCES meters(id),
    FOREIGN KEY (group_id) REFERENCES list_of_groups(id)
) DEFAULT CHARSET=UTF8MB4;


DROP TABLE IF EXISTS groups_data;

CREATE TABLE groups_data (
    value_date DATE NOT NULL COMMENT 'Дата за которую зафиксировано потребление', 
    int_num INT UNSIGNED NOT NULL COMMENT 'Номер интервала (по настройкам системы) за который зафиксировано потребление',
    group_id BIGINT UNSIGNED NOT NULL COMMENT 'Балансовая группа', 
    int_val DECIMAL(18,6) COMMENT 'Потребление за интервал',  
    frame_mb INT UNSIGNED COMMENT 'Количество ожидаемых интервалов со счетчиков (равно количеству счетчиков в балансовой группе)', 
    frame_real INT UNSIGNED COMMENT 'Количество полученных интервалов со счетчиков (если меньше ожидаемых, то нужно пересчитать int_val при получении новых данных со счетчиков)', 
    dt DATETIME DEFAULT NOW() ON UPDATE NOW(),
    user_id BIGINT UNSIGNED NOT NULL,

    UNIQUE INDEX gr_data_idx(value_date, int_num, group_id),
    FOREIGN KEY (group_id) REFERENCES list_of_groups(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
) DEFAULT CHARSET=UTF8MB4;

DELIMITER //

DROP PROCEDURE IF EXISTS calc_group //
CREATE PROCEDURE calc_group (IN gr_id bigint unsigned, date_cor date, int_cor int unsigned)
BEGIN
    DECLARE gr_sum DECIMAL(18,6);
    DECLARE fr_mb int unsigned;
    DECLARE fr_real int unsigned;

    SELECT count(meter_id) INTO @fr_mb FROM structure_groups WHERE group_id = gr_id;

    SELECT count(*) INTO @fr_real
    FROM meters_data md
        WHERE 
            md.meter_id IN (SELECT sg.meter_id FROM structure_groups sg WHERE sg.group_id = gr_id) 
            AND 
            md.value_date = date_cor 
            AND 
            md.int_num = int_cor;

    SELECT sum(int_val_with_sign) INTO @gr_sum FROM    -- Получаем сумму значений по счетчикам
                (
                SELECT int_val * IF(sg.sign = '+', 1, -1) AS int_val_with_sign -- Получаем значения за интервал по счетчикам, входящим в группу, с учетом знака
                FROM meters_data md
                JOIN structure_groups sg ON sg.meter_id = md.meter_id 
                    WHERE 
                        md.meter_id IN (SELECT sg.meter_id FROM structure_groups WHERE sg.group_id = gr_id) 
                        AND 
                        md.value_date = date_cor 
                        AND 
                        md.int_num = int_cor 
                GROUP BY md.meter_id 
                ) sm ;

    INSERT INTO groups_data (value_date, int_num, group_id, int_val, frame_mb, frame_real, dt, user_id) VALUES(date_cor, int_cor, gr_id, @gr_sum, @fr_mb, @fr_real, NOW(), 3) 
    ON DUPLICATE KEY UPDATE int_val = @gr_sum, dt = NOW(), user_id = 3, frame_mb = @fr_mb, frame_real = @fr_real;

END //

DELIMITER ;
