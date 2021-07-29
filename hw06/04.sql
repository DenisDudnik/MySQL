-- Проверка

-- SELECT (
--             (SELECT count(*) FROM friend_requests WHERE initiator_user_id = u.id)  -- активности по запросам в друзья
--             + 
--             (SELECT count(*) FROM media WHERE user_id = u.id)   -- активности по добавлению медиа
--             + 
--             (SELECT count(*) FROM likes WHERE user_id = u.id)   -- активности по лайкам
--             + 
--             (SELECT count(*) FROM messages WHERE from_user_id = u.id)   -- активности по исходящим сообщениям
--         ) AS s, id 
-- FROM users u
-- ORDER BY s
-- LIMIT 10;

SELECT id 
FROM users u
ORDER BY (
            (SELECT count(*) FROM friend_requests WHERE initiator_user_id = u.id)  -- активности по запросам в друзья
            + 
            (SELECT count(*) FROM media WHERE user_id = u.id)   -- активности по добавлению медиа
            + 
            (SELECT count(*) FROM likes WHERE user_id = u.id)   -- активности по лайкам
            + 
            (SELECT count(*) FROM messages WHERE from_user_id = u.id)   -- активности по исходящим сообщениям
        )
LIMIT 10;