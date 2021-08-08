USE shop;
CREATE VIEW name_tmp AS 
SELECT 
    products.name AS p_name, 
    (SELECT catalogs.name FROM catalogs WHERE catalogs.id=products.catalog_id) AS c_name 
FROM 
    products;