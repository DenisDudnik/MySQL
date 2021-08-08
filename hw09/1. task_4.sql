USE example;
DROP TABLE IF EXISTS temp;
CREATE TABLE temp (created_at date);
INSERT INTO temp (created_at) VALUES
  ('2018-08-01'),
  ('2018-07-04'),
  ('2016-08-16'),
  ('2018-05-01'),
  ('2019-08-04'),
  ('2018-08-16'),
  ('2020-08-01'),
  ('2014-08-04'),
  ('2011-08-16'),
  ('2010-08-17');

SELECT created_at FROM temp ORDER BY created_at DESC;

DELETE FROM temp WHERE created_at NOT IN (SELECT * FROM (SELECT created_at FROM temp ORDER BY created_at DESC LIMIT 5) t);

SELECT * FROM temp ORDER BY created_at DESC;

