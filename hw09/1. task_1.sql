-- DROP TABLE IF EXISTS sample.users;

-- CREATE TABLE sample.users (
--   id SERIAL PRIMARY KEY,
--   name VARCHAR(255) COMMENT '��� ����������',
--   birthday_at DATE COMMENT '���� ��������',
--   created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
--   updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
-- ) COMMENT = '����������';

START TRANSACTION;
SELECT * FROM shop.users WHERE id=1;
INSERT INTO sample.users SELECT * FROM shop.users WHERE id=1;
DELETE FROM shop.users WHERE id=1;
COMMIT;

SELECT * FROM sample.users;
SELECT * FROM shop.users;

-- INSERT INTO sample.users (name, birthday_at) VALUES
--   ('��������', '1990-10-05'),
--   ('�������', '1984-11-12'),
--   ('���������', '1985-05-20'),
--   ('������', '1988-02-14'),
--   ('����', '1998-01-12'),
--   ('�����', '1992-08-29');

