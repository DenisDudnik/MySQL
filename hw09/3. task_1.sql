DELIMITER //

DROP FUNCTION IF EXISTS hello//

CREATE FUNCTION hello()
    RETURNS varchar(100) DETERMINISTIC
    BEGIN
        DECLARE hour_now int;
        SET hour_now = hour(now());
        CASE 
            WHEN hour_now BETWEEN 6 and 11 THEN
              RETURN '������ ����';
            WHEN hour_now BETWEEN 12 and 17 THEN
              RETURN '������ ����';
            WHEN hour_now BETWEEN 18 and 23 THEN
              RETURN '������ �����';
            ELSE
              RETURN '������ ����';
        END CASE;
    END//

SELECT hello()//
DELIMITER ;

