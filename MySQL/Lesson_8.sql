-- Практическое задание по теме “Оптимизация запросов”

-- Задание №1
-- Создайте таблицу logs типа Archive. 
-- Пусть при каждом создании записи в таблицах users, catalogs и products в таблицу logs помещается время и дата создания записи, 
-- название таблицы, идентификатор первичного ключа и содержимое поля name.

DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
	created_at DATETIME NOT NULL,
	table_name VARCHAR(45) NOT NULL,
	str_id BIGINT(20) NOT NULL,
	name_value VARCHAR(45) NOT NULL
) ENGINE = ARCHIVE;


-- Триггер users
DROP TRIGGER IF EXISTS watchlog_users;
delimiter //
CREATE TRIGGER watchlog_users AFTER INSERT ON users
FOR EACH ROW
BEGIN
	INSERT INTO logs (created_at, table_name, str_id, name_value)
	VALUES (NOW(), 'users', NEW.id, NEW.name);
END //
delimiter ;


-- Триггер catalogs
DROP TRIGGER IF EXISTS watchlog_catalogs;
delimiter //
CREATE TRIGGER watchlog_catalogs AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN
	INSERT INTO logs (created_at, table_name, str_id, name_value)
	VALUES (NOW(), 'catalogs', NEW.id, NEW.name);
END //
delimiter ;


-- Триггер products
delimiter //
CREATE TRIGGER watchlog_products AFTER INSERT ON products
FOR EACH ROW
BEGIN
	INSERT INTO logs (created_at, table_name, str_id, name_value)
	VALUES (NOW(), 'products', NEW.id, NEW.name);
END //
delimiter ;

-- Задание №2
-- (по желанию) Создайте SQL-запрос, который помещает в таблицу users миллион записей.

DROP TABLE IF EXISTS test_users; 
CREATE TABLE test_users (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255),
	birthday_at DATE,
	`created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
 	`updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


DROP PROCEDURE IF EXISTS insert_into_users ;
delimiter //
CREATE PROCEDURE insert_into_users ()
BEGIN
	DECLARE i INT DEFAULT 100;
	DECLARE j INT DEFAULT 0;
	WHILE i > 0 DO
		INSERT INTO test_users(name, birthday_at) VALUES (CONCAT('user_', j), NOW());
		SET j = j + 1;
		SET i = i - 1;
	END WHILE;
END //
delimiter ;

-- Практическое задание по теме “NoSQL”

-- Задание №1
-- В базе данных Redis подберите коллекцию для подсчета посещений с определенных IP-адресов.

SET '127.0.0.1' # установить число посещений указанного ip 
GET '127.0.0.1' # получить число посещений указанного ip 
INCR '127.0.0.1' # увеличить число посещений указанного ip на 1 

HINCRBY adresses '127.0.0.1' 1 # добавить одно посещение указанного ip
HGETALL adresses # вывести число посещений всех ip коллекции
HGET adresses '127.0.0.1' # вывести число посещений только данного ip 

-- Задание №2
-- При помощи базы данных Redis решите задачу поиска имени пользователя по электронному адресу и наоборот, 
-- поиск электронного адреса пользователя по его имени.

HSET emails 'igor' 'igor@mail.ru'
HSET emails 'olga' 'olga@mail.ru'
HGETALL emails
HGET emails 'igor'

HSET emails 'igor' 'igor@mail.ru' 'igor'
HSET emails 'olga' 'olga@mail.ru' 'olga'
HGETALL users
HGET users 'igor'

-- Задание №3
-- Организуйте хранение категорий и товарных позиций учебной базы данных shop в СУБД MongoDB.

db.createCollection ('catalogs')
db.createCollection ('products')
db.catalogs.insert ({name: 'процессоры'})
db.catalogs.insert ({name: 'карты'})
db.catalogs.find() # ищем нужные ключи для связи в каталогах
db.products.insert (
	{
	name: 'try_name_1',
	description: 'example_1',
	price: 100,
	catalog_id: newObject('') # вставляем ключ нужного нам каталога из db.catalogs.find() сюда
	}
);

db.products.insert (
	{
	name: 'try_name_2',
	description: 'example_2',
	price: 120,
	catalog_id: newObject('') # вставляем ключ нужного нам каталога из db.catalogs.find() сюда
	}
);

db.products.insert (
	{
	name: 'try_name_3',
	description: 'example_3',
	price: 300,
	catalog_id: newObject('') # вставляем ключ нужного нам каталога из db.catalogs.find() сюда
	}
);
