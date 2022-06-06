-- Практическое задание по теме “Транзакции, переменные, представления”

-- Задание №1
-- В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. 
-- Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.

SELECT * FROM shop.users;

START TRANSACTION; 

INSERT INTO sample.users
SELECT * FROM shop.users WHERE id = 1;

DELETE FROM shop.users WHERE id = 1 LIMIT 1;

COMMIT;

-- Задание №2 
-- Создайте представление, которое выводит название name товарной позиции из таблицы products и соответствующее название каталога name из таблицы catalogs.

CREATE OR REPLACE VIEW products_catalogs AS 
SELECT
	p.name AS products,
	c.name AS catalog
FROM 
	products AS p 
JOIN
	catalogs AS c
ON
	p.catalog_id = c.id;
	
-- Задание №4
-- (по желанию) Пусть имеется любая таблица с календарным полем created_at. 
-- Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих записей.

DELETE 
	posts
FROM 
	posts
JOIN
	(SELECT
		created_at
	FROM
		posts
	ORDER BY
		created_at DESC
		LIMIT 5, 1) AS delpost
ON
	post.created_at <= delpost.created_at;
	
-- Практическое задание по теме “Администрирование MySQL”

-- Задание №1
-- Создайте двух пользователей которые имеют доступ к базе данных shop. 
-- Первому пользователю shop_read должны быть доступны только запросы на чтение данных, 
-- второму пользователю shop — любые операции в пределах базы данных shop.

CREATE USER 'shop_read'@'localhost';
GRAND SELECT, SHOW VIEW ON shop.* TO 'shop_read'@'localhost' IDENTIFIED BY '';
CREATE USER 'shop'@'localhost';
GRAND ALL ON shop.* TO 'shop'@'localhost' IDENTIFIED BY '';


-- Практическое задание по теме “Хранимые процедуры и функции, триггеры"

-- Задание №1
-- Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. 
-- С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
-- с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".

DROP PROCEDURE IF EXISTS hello;
delimiter //
CREATE PROCEDURE hello()
BEGIN
	CASE 
		WHEN CURTIME() BETWEEN '06:00:00' AND '12:00:00' THEN
			SELECT 'Доброе утро';
		WHEN CURTIME() BETWEEN '12:00:00' AND '18:00:00' THEN
			SELECT 'Добрый день';
		WHEN CURTIME() BETWEEN '18:00:00' AND '00:00:00' THEN
			SELECT 'Добрый вечер';
		ELSE
			SELECT 'Доброй ночи';
	END CASE;
END //
delimiter ;

CALL hello();

-- Задание №2
-- В таблице products есть два текстовых поля: name с названием товара и description с его описанием. 
-- Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. 
-- Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. 
-- При попытке присвоить полям NULL-значение необходимо отменить операцию.

-- В случае NULL будут присвоенны значения по умолчанию

DROP TRIGGER IF EXISTS nullTrigger;
delimiter //
CREATE TRIGGER nullTrigger BEFORE INSERT ON products
FOR EACH ROW
BEGIN
	IF(ISNULL(NEW.name)) THEN
		SET NEW.name = 'NoName';
	END IF;
	IF(ISNULL(NEW.description)) THEN
		SET NEW.description = 'No Desc';
	END IF;
END //
delimiter ;

INSERT INTO products (name, description, price, catalog_id)
VALUES (NULL, NULL, 20000, 12); -- FAIL ! Trigger Warning
