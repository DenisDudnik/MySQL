-- ��������

-- SELECT (
--             (SELECT count(*) FROM friend_requests WHERE initiator_user_id = u.id)  -- ���������� �� �������� � ������
--             + 
--             (SELECT count(*) FROM media WHERE user_id = u.id)   -- ���������� �� ���������� �����
--             + 
--             (SELECT count(*) FROM likes WHERE user_id = u.id)   -- ���������� �� ������
--             + 
--             (SELECT count(*) FROM messages WHERE from_user_id = u.id)   -- ���������� �� ��������� ����������
--         ) AS s, id 
-- FROM users u
-- ORDER BY s
-- LIMIT 10;

SELECT id 
FROM users u
ORDER BY (
            (SELECT count(*) FROM friend_requests WHERE initiator_user_id = u.id)  -- ���������� �� �������� � ������
            + 
            (SELECT count(*) FROM media WHERE user_id = u.id)   -- ���������� �� ���������� �����
            + 
            (SELECT count(*) FROM likes WHERE user_id = u.id)   -- ���������� �� ������
            + 
            (SELECT count(*) FROM messages WHERE from_user_id = u.id)   -- ���������� �� ��������� ����������
        )
LIMIT 10;