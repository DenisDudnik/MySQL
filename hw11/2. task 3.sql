db.shop.insert({product: 'Intel Core i3-8100'}, {category: 'Процессоры'}, {description: 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.'}, {price: 7890.00}, {qty: 1})
db.shop.insert({product: 'ASUS ROG MAXIMUS X HERO'}, {category: 'Материнские платы'}, {description: 'Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX'}, {price: 19310.00}, {qty: 2})
db.shop.insert({product: 'AMD FX-8320'}, {category: 'Процессоры'}, {description: 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.'}, {price: 7120.00}, {qty: 1})

db.shop.find({category: 'Процессоры'}) 