USE vk;


-- Работаем с пользователем с id = 348


-- Найдем от кого из друзей было больше всего сообщений к нашему пользователю и посчитаем их количество

SELECT from_user_id, count(*) AS cnt 
FROM messages
WHERE to_user_id = 348 AND from_user_id IN 
                            (SELECT initiator_user_id FROM friend_requests
                            WHERE target_user_id = 348 AND request_status = 'approved'
                        UNION   
                            SELECT target_user_id FROM friend_requests
                            WHERE initiator_user_id = 348 AND request_status = 'approved'
                            )        
GROUP BY from_user_id 
ORDER BY cnt DESC 
LIMIT 1;






