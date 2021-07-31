INSERT INTO orders 
(user_id) (SELECT id FROM users ORDER BY RAND() LIMIT 4);

SELECT id, name FROM users WHERE id IN (SELECT user_id FROM orders);

