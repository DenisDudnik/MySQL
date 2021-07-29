SELECT gender FROM profiles WHERE user_id IN (SELECT user_id FROM likes)
GROUP BY gender 
ORDER BY count(*) DESC
LIMIT 1;


-- проверка ниже

-- SELECT gender, count(*) FROM profiles WHERE user_id IN (SELECT user_id FROM likes)
-- GROUP BY gender 
-- ORDER BY count(*) DESC;