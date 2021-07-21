SELECT 
    * 
FROM 
    catalogs  
WHERE 
    id IN (5, 1, 2)
ORDER BY
    field(id, 5, 1, 2) 