-- Task #1
-- Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.

SELECT 
	u.name
FROM 
	users AS u
INNER JOIN 
	orders AS o ON (o.user_id = u.id)
GROUP BY 
	u.name
HAVING 
	COUNT(o.id) > 0;

-- Task #2
-- Выведите список товаров products и разделов catalogs, который соответствует товару.

SELECT 
	p.name AS Products, c.name AS Catalogs
FROM 
	products AS p
INNER JOIN 
	catalogs AS c ON (p.catalog_id = c.id)
GROUP BY 
	p.id; 

-- Task #3
-- (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). 
-- Поля from, to и label содержат английские названия городов, поле name — русское. Выведите список рейсов flights с русскими названиями городов.

SELECT
	id AS flight_id,
	(SELECT name FROM cities WHERE label = `from`) AS `from`,
	(SELECT name FROM cities WHERE label = `to`) AS `to`
FROM
	flights
ORDER BY
	flight_id;
