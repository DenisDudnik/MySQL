DROP TABLE IF EXISTS logs;
create table logs (
    created_at DATETIME NOT NULL,
    table_name VARCHAR(45) NOT NULL,
    rec_id BIGINT NOT NULL,
    name_value VARCHAR(45) NOT NULL
) ENGINE = ARCHIVE;

DROP TRIGGER IF EXISTS watchlog_users;
delimiter //
CREATE TRIGGER watchlog_users AFTER INSERT ON users
    FOR EACH ROW
    BEGIN
        INSERT INTO logs (created_at, table_name, rec_id, name_value)
        VALUES (NOW(), 'users', NEW.id, NEW.name);
    END //
delimiter ;

DROP TRIGGER IF EXISTS watchlog_catalogs;
delimiter //
CREATE TRIGGER watchlog_catalogs AFTER INSERT ON catalogs
    FOR EACH ROW
    BEGIN
        INSERT INTO logs (created_at, table_name, rec_id, name_value)
        VALUES (NOW(), 'catalogs', NEW.id, NEW.name);
    END //
delimiter ;

delimiter //
CREATE TRIGGER watchlog_products AFTER INSERT ON products
    FOR EACH ROW
    BEGIN
        INSERT INTO logs (created_at, table_name, rec_id, name_value)
        VALUES (NOW(), 'products', NEW.id, NEW.name);
    END //
delimiter ;