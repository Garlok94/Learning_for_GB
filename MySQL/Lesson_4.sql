use vk;

-- Task №1
-- Пусть задан некоторый пользователь. 
-- Из всех пользователей соц. сети найдите человека, который больше всех общался с выбранным пользователем (написал ему сообщений).


SELECT
    from_user_id
    , COUNT(*) as send 
FROM messages 
WHERE to_user_id=1
GROUP BY from_user_id
ORDER BY send DESC
LIMIT 1;


-- Task №2 
-- Подсчитать общее количество лайков, которые получили пользователи младше 10 лет..


SELECT COUNT(*) as 'Likes' FROM profiles WHERE (YEAR(NOW())-YEAR(birthday)) < 10;


-- Task №3 
-- Определить кто больше поставил лайков (всего): мужчины или женщины.


SELECT gender, COUNT(*) as 'Likes' FROM profiles GROUP BY gender;
        
 