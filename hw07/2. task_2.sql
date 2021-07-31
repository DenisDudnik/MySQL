SELECT 
p.name AS Product, c.name AS Category 
FROM 
products p
JOIN
catalogs c 
ON
c.id = p.catalog_id;