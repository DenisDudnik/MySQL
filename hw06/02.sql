SELECT count(*) FROM likes
WHERE media_id IN (
                    SELECT id FROM media 
                    WHERE user_id IN 
                                (SELECT * FROM 
                                    (SELECT id FROM users
                                     ORDER BY (SELECT birthday FROM profiles WHERE user_id = id) DESC
                                     LIMIT 10
                                    ) tmp
                                )
                    );
            