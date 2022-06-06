USE vk;

-- Task №1
-- Пусть задан некоторый пользователь. 
-- Из всех пользователей соц. сети найдите человека, который больше всех общался с выбранным пользователем (написал ему сообщений).

-- Вложенный запрос
SELECT from_user_id, COUNT(*) AS send 
FROM messages 
WHERE to_user_id=1
GROUP BY from_user_id
ORDER BY send DESC
LIMIT 1;

-- JOIN
SELECT 
	from_user_id
	, concat(u.firstname, ' ', u.lastname) AS name
	, count(*) AS 'messages count'
FROM messages m
JOIN users u ON u.id = m.from_user_id
WHERE to_user_id = 1
GROUP BY from_user_id
ORDER BY count(*) DESC
LIMIT 1;


-- Task №2 
-- Подсчитать общее количество лайков, которые получили пользователи младше 10 лет...

-- Вложенный запрос
SELECT COUNT(*) AS 'Likes' 
FROM profiles 
WHERE (YEAR(NOW())-YEAR(birthday)) < 10;

-- JOIN
SELECT COUNT(*) 
FROM likes l
JOIN media AS m ON l.media_id = m.id
JOIN profiles AS p ON p.user_id = m.user_id
WHERE  YEAR(CURDATE()) - YEAR(birthday) < 10;


-- Task №3 
-- Определить кто больше поставил лайков (всего): мужчины или женщины.

-- Вложенный запрос
SELECT gender, COUNT(*) 
AS 'Likes' 
FROM profiles 
GROUP BY gender;

-- JOIN
SELECT gender, COUNT(*)
FROM likes
JOIN profiles ON likes.user_id = profiles.user_id
GROUP BY gender;


