DELIMITER //

USE shop//

DROP TRIGGER IF EXISTS check_products_insert//
DROP TRIGGER IF EXISTS check_products_update//

CREATE TRIGGER check_products_insert BEFORE INSERT ON products
FOR EACH ROW
BEGIN
    IF NEW.name IS NULL AND NEW.description IS NULL 
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'You should fill products name and/or description!';
    END IF;
END//

CREATE TRIGGER check_products_update BEFORE UPDATE ON products
FOR EACH ROW
BEGIN
    IF NEW.name IS NULL AND NEW.description IS NULL 
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'You should fill products name and/or description!';
    END IF;
END//

DELIMITER ;

INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  (NULL, NULL, 7990.00, 1); 