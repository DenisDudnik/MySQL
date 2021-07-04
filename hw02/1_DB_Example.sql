drop database if exists example; 

create database example;

use example;

drop table if exists users;

create table users (
id serial primary key,
name varchar(255) not null comment 'User name',
key index_of_user_name(name)
) comment = 'User list'; 

insert into users values
(default, 'Pupkin'),
(default, 'Vasechkin');

insert into users (name) values
('BlackKoshak');

select * from users;