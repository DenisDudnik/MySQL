DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at VARCHAR(20),
  updated_at VARCHAR(20)
) COMMENT = 'Покупатели';

INSERT INTO users (name, birthday_at, created_at, updated_at) VALUES
  ('Геннадий', '1990-10-05', DATE_FORMAT(NOW(), '%d.%m.%Y %k:%i'), DATE_FORMAT(NOW(), '%d.%m.%Y %k:%i')),
  ('Наталья', '1984-11-12', DATE_FORMAT(NOW(), '%d.%m.%Y %k:%i'), DATE_FORMAT(NOW(), '%d.%m.%Y %k:%i')),
  ('Александр', '1985-05-20', DATE_FORMAT(NOW(), '%d.%m.%Y %k:%i'), DATE_FORMAT(NOW(), '%d.%m.%Y %k:%i')),
  ('Сергей', '1988-02-14', DATE_FORMAT(NOW(), '%d.%m.%Y %k:%i'), DATE_FORMAT(NOW(), '%d.%m.%Y %k:%i')),
  ('Иван', '1998-01-12', DATE_FORMAT(NOW(), '%d.%m.%Y %k:%i'), DATE_FORMAT(NOW(), '%d.%m.%Y %k:%i')),
  ('Мария', '1992-08-29', DATE_FORMAT(NOW(), '%d.%m.%Y %k:%i'), DATE_FORMAT(NOW(), '%d.%m.%Y %k:%i'));
  
ALTER TABLE users 
    add COLUMN created_at_n DATETIME,
    add COLUMN updated_at_n DATETIME;
    
UPDATE users 
SET created_at_n = str_to_date(created_at, '%d.%m.%Y %k:%i')
WHERE created_at_n IS NULL;

UPDATE users 
SET updated_at_n = str_to_date(updated_at, '%d.%m.%Y %k:%i')
WHERE updated_at_n IS NULL;

ALTER TABLE users 
    drop COLUMN created_at,
    drop COLUMN updated_at;
    
ALTER TABLE users 
    CHANGE created_at_n created_at datetime,
    CHANGE updated_at_n updated_at datetime;