drop database if exists example;

create database example;

use example;

drop table if exists flights;

create table flights (
id serial primary key,
from_city varchar(255) not null comment 'From',
to_city varchar(255) not null comment 'To'
) comment = 'Flights table';

insert into flights values
(default, 'Moscow', 'Omsk'),
(default, 'Novgorod', 'Kazan'),
(default, 'Irkutsk', 'Moscow'),
(default, 'Omsk', 'Irkutsk'),
(default, 'Moscow', 'Kazan');

drop table if exists cities;

create table cities (
id serial primary key,
label varchar(255) not null comment 'City_eng',
name_ru varchar(255) not null comment 'City_ru',
key index_of_city(label)
) comment = 'Rus names table';

insert into cities values
(default, 'Moscow', 'Москва'),
(default, 'Novgorod', 'Новгород'),
(default, 'Irkutsk', 'Иркутск'),
(default, 'Omsk', 'Омск'),
(default, 'Kazan', 'Казань');


select f.id, c_from.name_ru AS from_city, c_to.name_ru AS to_city 
from flights f 
JOIN cities c_from ON f.from_city = c_from.label
JOIN cities c_to ON f.to_city = c_to.label
;