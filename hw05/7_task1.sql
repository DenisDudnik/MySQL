SELECT round(avg(datediff(curdate(), birthday_at))/365.25) AS age_avg FROM users;