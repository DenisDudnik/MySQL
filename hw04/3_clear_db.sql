SELECT * FROM users WHERE id NOT IN (SELECT user_id FROM profiles);

SELECT * FROM users_communities WHERE user_id NOT IN (SELECT user_id FROM profiles);

SELECT * FROM photo_albums WHERE user_id NOT IN (SELECT user_id FROM profiles);

SELECT * FROM messages WHERE from_user_id NOT IN (SELECT user_id FROM profiles) OR to_user_id NOT IN (SELECT user_id FROM profiles);

SELECT * FROM media WHERE user_id NOT IN (SELECT user_id FROM profiles);

SELECT * FROM likes WHERE user_id NOT IN (SELECT user_id FROM profiles);

SELECT * FROM friend_requests WHERE initiator_user_id NOT IN (SELECT user_id FROM profiles) OR target_user_id NOT IN (SELECT user_id FROM profiles);

SELECT * FROM communities WHERE admin_user_id NOT IN (SELECT user_id FROM profiles);

SELECT * FROM photos WHERE media_id IN (SELECT id FROM media WHERE user_id NOT IN (SELECT user_id FROM profiles));

DELETE FROM users_communities WHERE user_id NOT IN (SELECT user_id FROM profiles);

DELETE FROM photo_albums WHERE user_id NOT IN (SELECT user_id FROM profiles);

DELETE FROM messages WHERE from_user_id NOT IN (SELECT user_id FROM profiles) OR to_user_id NOT IN (SELECT user_id FROM profiles);

DELETE FROM likes WHERE user_id NOT IN (SELECT user_id FROM profiles);

DELETE FROM friend_requests WHERE initiator_user_id NOT IN (SELECT user_id FROM profiles) OR target_user_id NOT IN (SELECT user_id FROM profiles);

DELETE FROM communities WHERE admin_user_id NOT IN (SELECT user_id FROM profiles);

DELETE FROM photos WHERE media_id IN (SELECT id FROM media WHERE user_id NOT IN (SELECT user_id FROM profiles));

DELETE FROM media WHERE user_id NOT IN (SELECT user_id FROM profiles);

DELETE FROM users WHERE id NOT IN (SELECT user_id FROM profiles);

SELECT * FROM users WHERE id NOT IN (SELECT user_id FROM profiles);