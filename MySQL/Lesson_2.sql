DROP DATABASE IF EXISTS vk;
CREATE DATABASE vk;
USE vk;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    firstname VARCHAR(50),
    lastname VARCHAR(50) COMMENT 'Фамиль', -- COMMENT на случай, если имя неочевидное
    email VARCHAR(120) UNIQUE,
 	password_hash VARCHAR(100), -- 123456 => vzx;clvgkajrpo9udfxvsldkrn24l5456345t
	phone BIGINT UNSIGNED UNIQUE, 
	
    INDEX users_firstname_lastname_idx(firstname, lastname)
) COMMENT 'юзеры';

DROP TABLE IF EXISTS `profiles`;
CREATE TABLE `profiles` (
	user_id BIGINT UNSIGNED NOT NULL UNIQUE,
    gender CHAR(1),
    birthday DATE,
	photo_id BIGINT UNSIGNED NULL,
    created_at DATETIME DEFAULT NOW(),
#    is_active BOOL DEFAULT TRUE(),
    hometown VARCHAR(100)
	
    -- , FOREIGN KEY (photo_id) REFERENCES media(id) -- пока рано, т.к. таблицы media еще нет
);

ALTER TABLE `profiles` ADD CONSTRAINT fk_user_id
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON UPDATE CASCADE -- (значение по умолчанию)
    ON DELETE RESTRICT; -- (значение по умолчанию)

DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
	id SERIAL, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
	from_user_id BIGINT UNSIGNED NOT NULL,
    to_user_id BIGINT UNSIGNED NOT NULL,
    body TEXT,
    created_at DATETIME DEFAULT NOW(), -- можно будет даже не упоминать это поле при вставке

    FOREIGN KEY (from_user_id) REFERENCES users(id),
    FOREIGN KEY (to_user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS friend_requests;
CREATE TABLE friend_requests (
	-- id SERIAL, -- изменили на составной ключ (initiator_user_id, target_user_id)
	initiator_user_id BIGINT UNSIGNED NOT NULL,
    target_user_id BIGINT UNSIGNED NOT NULL,
    `status` ENUM('requested', 'approved', 'declined', 'unfriended'), # DEFAULT 'requested',
    -- `status` TINYINT(1) UNSIGNED, -- в этом случае в коде хранили бы цифирный enum (0, 1, 2, 3...)
	requested_at DATETIME DEFAULT NOW(),
	updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP, -- можно будет даже не упоминать это поле при обновлении
	
    PRIMARY KEY (initiator_user_id, target_user_id),
    FOREIGN KEY (initiator_user_id) REFERENCES users(id),
    FOREIGN KEY (target_user_id) REFERENCES users(id)-- ,
    -- CHECK (initiator_user_id <> target_user_id)
);
-- чтобы пользователь сам себе не отправил запрос в друзья
-- ALTER TABLE friend_requests 
-- ADD CHECK(initiator_user_id <> target_user_id);

DROP TABLE IF EXISTS communities;
CREATE TABLE communities(
	id SERIAL,
	name VARCHAR(150),
	admin_user_id BIGINT UNSIGNED NOT NULL,
	
	INDEX communities_name_idx(name), -- индексу можно давать свое имя (communities_name_idx)
	foreign key (admin_user_id) references users(id)
);

DROP TABLE IF EXISTS users_communities;
CREATE TABLE users_communities(
	user_id BIGINT UNSIGNED NOT NULL,
	community_id BIGINT UNSIGNED NOT NULL,
  
	PRIMARY KEY (user_id, community_id), -- чтобы не было 2 записей о пользователе и сообществе
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (community_id) REFERENCES communities(id)
);

DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types(
	id SERIAL,
    name VARCHAR(255), -- записей мало, поэтому в индексе нет необходимости
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS media;
CREATE TABLE media(
	id SERIAL,
    media_type_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
  	body text,
    filename VARCHAR(255),
    -- file blob,    	
    size INT,
	metadata JSON,
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (media_type_id) REFERENCES media_types(id)
);

DROP TABLE IF EXISTS likes;
CREATE TABLE likes(
	id SERIAL,
    user_id BIGINT UNSIGNED NOT NULL,
    media_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT NOW()

    -- PRIMARY KEY (user_id, media_id) – можно было и так вместо id в качестве PK
  	-- слишком увлекаться индексами тоже опасно, рациональнее их добавлять по мере необходимости (напр., провисают по времени какие-то запросы)  

/* намеренно забыли, чтобы позднее увидеть их отсутствие в ER-диаграмме
    , FOREIGN KEY (user_id) REFERENCES users(id)
    , FOREIGN KEY (media_id) REFERENCES media(id)
*/
);

DROP TABLE IF EXISTS `photo_albums`;
CREATE TABLE `photo_albums` (
	`id` SERIAL,
	`name` varchar(255) DEFAULT NULL,
    `user_id` BIGINT UNSIGNED DEFAULT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
  	PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `photos`;
CREATE TABLE `photos` (
	id SERIAL,
	`album_id` BIGINT unsigned NULL,
	`media_id` BIGINT unsigned NOT NULL,

	FOREIGN KEY (album_id) REFERENCES photo_albums(id),
    FOREIGN KEY (media_id) REFERENCES media(id)
);

DROP TABLE IF EXISTS `video_albums`;
CREATE TABLE `video_albums` (
	`id` SERIAL,
	`name` varchar(255) DEFAULT NULL,
    `user_id` BIGINT UNSIGNED DEFAULT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
  	PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `videos`;
CREATE TABLE `videos` (
	id SERIAL,
	`album_id` BIGINT unsigned NULL,
	`media_id` BIGINT unsigned NOT NULL,

	FOREIGN KEY (album_id) REFERENCES video_albums(id),
    FOREIGN KEY (media_id) REFERENCES media(id)
);

DROP TABLE IF EXISTS `music_albums`;
CREATE TABLE `music_albums` (
	`id` SERIAL,
	`name` varchar(255) DEFAULT NULL,
    `user_id` BIGINT UNSIGNED DEFAULT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
  	PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `music`;
CREATE TABLE `music` (
	id SERIAL,
	`album_id` BIGINT unsigned NULL,
	`media_id` BIGINT unsigned NOT NULL,

	FOREIGN KEY (album_id) REFERENCES music_albums(id),
    FOREIGN KEY (media_id) REFERENCES media(id)
);

DROP TABLE IF EXISTS `memories_albums`;
CREATE TABLE `memories_albums` (
	`id` SERIAL,
	`name` varchar(255) DEFAULT NULL,
    `user_id` BIGINT UNSIGNED DEFAULT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
  	PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `memories`;
CREATE TABLE `memories` (
	id SERIAL,
	`album_id` BIGINT unsigned NULL,
	`media_id` BIGINT unsigned NOT NULL,

	FOREIGN KEY (album_id) REFERENCES memories_albums(id),
    FOREIGN KEY (media_id) REFERENCES media(id)
);

ALTER TABLE vk.likes 
ADD CONSTRAINT likes_fk 
FOREIGN KEY (media_id) REFERENCES vk.media(id);

ALTER TABLE vk.likes 
ADD CONSTRAINT likes_fk_1 
FOREIGN KEY (user_id) REFERENCES vk.users(id);

ALTER TABLE vk.profiles 
ADD CONSTRAINT profiles_fk_1 
FOREIGN KEY (photo_id) REFERENCES media(id);


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `communities`
--

DROP TABLE IF EXISTS `communities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `communities` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `admin_user_id` bigint(20) unsigned NOT NULL,
  UNIQUE KEY `id` (`id`),
  KEY `communities_name_idx` (`name`),
  KEY `admin_user_id` (`admin_user_id`),
  CONSTRAINT `communities_ibfk_1` FOREIGN KEY (`admin_user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `communities`
--

LOCK TABLES `communities` WRITE;
/*!40000 ALTER TABLE `communities` DISABLE KEYS */;
INSERT INTO `communities` VALUES (1,'voluptatibus',1),(2,'dicta',2),(3,'magni',3),(4,'voluptas',4),(5,'rerum',5),(6,'quia',6),(7,'mollitia',7),(8,'omnis',8),(9,'quos',9),(10,'culpa',10),(11,'autem',11),(12,'voluptatibus',12),(13,'sit',13),(14,'veritatis',14),(15,'sit',15),(16,'dolorum',16),(17,'et',17),(18,'fugit',18),(19,'placeat',19),(20,'nihil',20);
/*!40000 ALTER TABLE `communities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `friend_requests`
--

DROP TABLE IF EXISTS `friend_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `friend_requests` (
  `initiator_user_id` bigint(20) unsigned NOT NULL,
  `target_user_id` bigint(20) unsigned NOT NULL,
  `status` enum('requested','approved','declined','unfriended') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `requested_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`initiator_user_id`,`target_user_id`),
  KEY `target_user_id` (`target_user_id`),
  CONSTRAINT `friend_requests_ibfk_1` FOREIGN KEY (`initiator_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `friend_requests_ibfk_2` FOREIGN KEY (`target_user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `friend_requests`
--

LOCK TABLES `friend_requests` WRITE;
/*!40000 ALTER TABLE `friend_requests` DISABLE KEYS */;
INSERT INTO `friend_requests` VALUES (1,1,'approved','2007-05-29 03:34:03','2020-04-07 11:36:25'),(2,2,'declined','2014-03-25 16:53:13','1983-04-03 19:32:25'),(3,3,'requested','1986-06-24 11:37:41','2021-08-22 19:20:07'),(4,4,'declined','1987-04-24 16:09:29','2019-11-20 01:12:30'),(5,5,'approved','2021-05-02 22:50:19','1987-12-04 17:27:54'),(6,6,'unfriended','2001-04-02 09:13:45','2016-04-28 12:23:18'),(7,7,'unfriended','2002-01-06 20:40:19','1990-03-23 06:44:31'),(8,8,'unfriended','1975-02-03 15:53:41','1994-10-21 19:02:34'),(9,9,'unfriended','1972-10-28 08:58:20','1994-03-10 10:52:11'),(10,10,'approved','2003-11-22 23:17:21','1992-03-02 05:35:16'),(11,11,'unfriended','2019-12-03 14:46:29','1996-05-02 12:09:09'),(12,12,'declined','2011-01-12 05:13:42','1985-09-21 17:17:16'),(13,13,'approved','1972-12-08 20:32:42','1983-02-19 07:43:18'),(14,14,'unfriended','1996-12-19 17:56:07','2016-10-13 07:10:22'),(15,15,'approved','1979-03-06 05:19:02','1982-10-26 08:34:39'),(16,16,'unfriended','1997-05-20 03:38:34','1989-11-12 01:11:33'),(17,17,'requested','1993-08-31 14:23:46','1977-06-12 06:43:01'),(18,18,'requested','1986-09-08 05:19:37','1971-04-24 18:44:32'),(19,19,'unfriended','1981-04-25 15:38:00','1988-05-14 11:30:39'),(20,20,'requested','1982-01-18 12:29:43','2015-01-27 18:06:31');
/*!40000 ALTER TABLE `friend_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `likes`
--

DROP TABLE IF EXISTS `likes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `likes` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `media_id` bigint(20) unsigned NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `likes`
--

LOCK TABLES `likes` WRITE;
/*!40000 ALTER TABLE `likes` DISABLE KEYS */;
INSERT INTO `likes` VALUES (1,1,1,'2008-06-06 10:04:39'),(2,2,2,'1971-11-30 21:16:00'),(3,3,3,'1985-02-06 05:41:21'),(4,4,4,'2013-10-28 16:05:49'),(5,5,5,'1987-09-11 07:20:18'),(6,6,6,'1974-06-12 08:07:42'),(7,7,7,'2018-04-18 23:17:27'),(8,8,8,'1972-08-06 02:43:39'),(9,9,9,'2000-04-27 05:52:46'),(10,10,10,'1981-12-02 05:57:37'),(11,11,11,'2000-01-20 21:55:22'),(12,12,12,'2019-01-27 07:26:19'),(13,13,13,'1989-11-04 21:12:31'),(14,14,14,'1993-09-30 14:51:32'),(15,15,15,'1995-03-18 20:47:17'),(16,16,16,'2012-09-21 06:31:51'),(17,17,17,'1987-05-30 12:18:27'),(18,18,18,'1986-06-15 10:57:51'),(19,19,19,'1981-09-28 08:16:07'),(20,20,20,'2015-08-15 23:35:23');
/*!40000 ALTER TABLE `likes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `media`
--

DROP TABLE IF EXISTS `media`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `media` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `media_type_id` bigint(20) unsigned NOT NULL,
  `user_id` bigint(20) unsigned NOT NULL,
  `body` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `filename` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `size` int(11) DEFAULT NULL,
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`metadata`)),
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  UNIQUE KEY `id` (`id`),
  KEY `user_id` (`user_id`),
  KEY `media_type_id` (`media_type_id`),
  CONSTRAINT `media_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `media_ibfk_2` FOREIGN KEY (`media_type_id`) REFERENCES `media_types` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `media`
--

LOCK TABLES `media` WRITE;
/*!40000 ALTER TABLE `media` DISABLE KEYS */;
INSERT INTO `media` VALUES (1,1,1,'Eaque dolor velit ut. Ducimus qui quisquam nulla repellendus corrupti. Officiis autem earum voluptates. Veniam sunt voluptas exercitationem sed asperiores unde consequuntur optio.','iusto',0,NULL,'1970-11-26 21:35:59','1995-01-20 13:19:37'),(2,2,2,'Iure ea eum quasi. Et dolores praesentium voluptas sit. Dolorem id rem et id. Sed quis commodi error fuga delectus. Facere odit atque rerum possimus rerum velit voluptas.','vel',7467639,NULL,'1993-10-08 06:59:15','2021-05-21 07:55:22'),(3,3,3,'Ratione officiis tenetur debitis enim voluptatem. Dolor rerum distinctio error magnam deserunt. Qui totam numquam excepturi delectus quaerat numquam.','adipisci',3,NULL,'2010-08-19 23:57:58','1994-08-11 22:09:18'),(4,4,4,'Quas et quos qui. Dolor corporis voluptatem ut iste.','quo',5240,NULL,'1985-08-19 03:54:55','2021-03-17 16:31:57'),(5,5,5,'Illum molestiae aut facere veritatis praesentium rerum. Quas sed qui alias eos. Dolor facere quasi autem iure iste.','eum',64065746,NULL,'2016-05-29 21:59:52','1976-08-18 07:13:11'),(6,6,6,'Dignissimos deleniti voluptatem qui sit. Sit rerum cupiditate hic repudiandae aspernatur rerum. Ea qui non illo neque.','eveniet',0,NULL,'1986-03-05 11:49:59','1983-06-24 07:20:09'),(7,7,7,'Corporis ut iste qui dignissimos sed odio perspiciatis. Qui sit libero deserunt sint vel occaecati saepe. Animi odit ipsam enim harum sed perferendis. Sapiente dolorem rerum quaerat ullam.','eligendi',43776,NULL,'2007-04-29 22:23:12','2010-07-27 22:38:31'),(8,8,8,'Earum aut expedita aut est et dolore. Sint amet sint velit sed nesciunt beatae. Sunt accusamus voluptatem nam eum quis.','impedit',6786315,NULL,'2003-09-17 13:53:30','1973-05-26 15:30:10'),(9,9,9,'Nostrum est aut illo quod delectus quasi. Repellendus optio esse rerum qui est explicabo. Magnam dignissimos quas accusamus.','voluptas',2413712,NULL,'2016-04-23 10:24:00','1994-01-16 14:28:19'),(10,10,10,'Aut quod nostrum odio nihil illum itaque aspernatur. Reprehenderit aliquid et harum veniam omnis quidem earum. Odio sit adipisci odio est sit sunt.','qui',53,NULL,'2013-06-16 02:57:25','1973-07-11 22:37:36'),(11,11,11,'Sit ullam iusto et numquam sint aspernatur aspernatur. Sint ea id laudantium. Porro illum quod aut perferendis aut.','rerum',7408801,NULL,'1973-02-25 16:00:57','2008-03-23 12:48:59'),(12,12,12,'Veniam eum ut tempora nesciunt ut. Et quaerat id in id. Rerum quo qui ut cupiditate illum aut dolore.','vel',37800,NULL,'1974-12-31 16:42:22','1978-04-15 11:06:28'),(13,13,13,'At mollitia officia qui architecto molestiae aut. Illum odio pariatur aut in illo. Fugiat minus repellat eveniet nobis.','et',919621,NULL,'1972-05-19 23:10:42','2009-08-27 07:56:14'),(14,14,14,'Repellendus nesciunt qui optio assumenda deleniti et dolor. Modi molestiae voluptatum esse deserunt officiis magnam explicabo. Quis minus voluptates quisquam eveniet eaque dicta rem dolores.','soluta',0,NULL,'2001-12-29 06:17:18','1970-01-05 06:58:01'),(15,15,15,'Itaque odio nisi officiis commodi. Ut temporibus nisi ullam pariatur ipsam perferendis aliquam. Harum enim dolores eum sunt quidem nostrum porro quo. Temporibus quaerat non eveniet in repellendus.','sequi',0,NULL,'1990-11-08 22:49:46','1997-09-17 01:06:56'),(16,16,16,'Omnis architecto excepturi atque quae deleniti perspiciatis. Ipsa odit eos natus dolores quo recusandae. Consequatur unde sed culpa vel ut id.','eius',597844863,NULL,'2012-01-07 06:45:01','1976-12-15 04:22:06'),(17,17,17,'Eum et iste deleniti enim consectetur et non. Amet occaecati qui nihil assumenda sit. Rem architecto asperiores ut. Iste quibusdam id est porro omnis ut ullam.','nobis',2,NULL,'1984-10-16 02:20:32','1992-03-01 13:48:30'),(18,18,18,'Facere nihil sequi quisquam molestiae a ad et et. Veniam eum quam culpa repudiandae reiciendis voluptas nisi. Nam praesentium omnis vel necessitatibus id molestiae.','sed',418210,NULL,'1998-06-16 16:47:38','2019-01-15 09:30:37'),(19,19,19,'Est repellendus voluptatibus est qui dolor inventore. Eum et rerum est sapiente eaque rerum vel consequatur. Recusandae consequuntur est sunt. Perferendis eum corrupti voluptatem quam magnam necessitatibus quis itaque.','voluptatum',0,NULL,'2011-01-28 20:03:37','2016-06-12 15:33:37'),(20,20,20,'Vitae quo aut incidunt minima et nostrum dolore. Aut eveniet qui voluptatem natus quidem quaerat harum. At est dolore consectetur quia eos soluta recusandae. Officia dolores ipsam reprehenderit quia autem similique.','molestias',2153367,NULL,'2018-05-17 01:50:44','1974-01-12 19:07:05');
/*!40000 ALTER TABLE `media` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `media_types`
--

DROP TABLE IF EXISTS `media_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `media_types` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `media_types`
--

LOCK TABLES `media_types` WRITE;
/*!40000 ALTER TABLE `media_types` DISABLE KEYS */;
INSERT INTO `media_types` VALUES (1,'velit','2007-02-15 14:58:20','1974-07-20 22:30:41'),(2,'nihil','2010-11-06 15:59:46','2010-04-25 23:48:43'),(3,'eveniet','2018-09-10 07:31:48','1972-06-24 01:07:41'),(4,'provident','2001-05-05 05:47:29','1997-11-18 19:33:54'),(5,'recusandae','1983-06-28 12:22:57','1996-08-10 21:10:42'),(6,'sit','2004-04-30 04:32:57','2018-05-17 04:04:35'),(7,'nam','1992-08-08 04:30:34','1998-03-19 02:50:57'),(8,'ex','2010-03-11 08:34:42','1972-05-04 16:05:10'),(9,'tempora','1976-11-28 18:39:05','2016-04-21 04:01:41'),(10,'tenetur','2021-05-08 17:51:41','2000-05-03 01:11:58'),(11,'autem','1977-11-08 01:58:28','1986-08-26 21:19:51'),(12,'magnam','1978-10-10 19:37:37','2014-04-26 19:09:00'),(13,'optio','1998-07-13 22:03:14','2016-01-10 13:20:50'),(14,'omnis','2012-07-11 14:09:46','2012-03-13 21:45:58'),(15,'libero','1987-11-17 09:43:05','1993-07-04 03:53:22'),(16,'dolor','2001-02-04 08:12:11','2011-07-25 20:23:16'),(17,'quia','1983-08-02 18:52:27','1978-02-10 21:17:04'),(18,'temporibus','2001-12-08 19:50:28','1995-05-20 05:43:58'),(19,'eligendi','1988-04-04 17:43:47','2014-10-29 04:08:27'),(20,'earum','2009-10-08 16:51:46','1974-12-30 01:00:08');
/*!40000 ALTER TABLE `media_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `memories`
--

DROP TABLE IF EXISTS `memories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `memories` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `album_id` bigint(20) unsigned DEFAULT NULL,
  `media_id` bigint(20) unsigned NOT NULL,
  UNIQUE KEY `id` (`id`),
  KEY `album_id` (`album_id`),
  KEY `media_id` (`media_id`),
  CONSTRAINT `memories_ibfk_1` FOREIGN KEY (`album_id`) REFERENCES `memories_albums` (`id`),
  CONSTRAINT `memories_ibfk_2` FOREIGN KEY (`media_id`) REFERENCES `media` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `memories`
--

LOCK TABLES `memories` WRITE;
/*!40000 ALTER TABLE `memories` DISABLE KEYS */;
INSERT INTO `memories` VALUES (1,1,1),(2,2,2),(3,3,3),(4,4,4),(5,5,5),(6,6,6),(7,7,7),(8,8,8),(9,9,9),(10,10,10),(11,11,11),(12,12,12),(13,13,13),(14,14,14),(15,15,15),(16,16,16),(17,17,17),(18,18,18),(19,19,19),(20,20,20);
/*!40000 ALTER TABLE `memories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `memories_albums`
--

DROP TABLE IF EXISTS `memories_albums`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `memories_albums` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `memories_albums_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `memories_albums`
--

LOCK TABLES `memories_albums` WRITE;
/*!40000 ALTER TABLE `memories_albums` DISABLE KEYS */;
INSERT INTO `memories_albums` VALUES (1,'quia',1),(2,'hic',2),(3,'impedit',3),(4,'ut',4),(5,'sint',5),(6,'repellat',6),(7,'ullam',7),(8,'tenetur',8),(9,'voluptate',9),(10,'non',10),(11,'labore',11),(12,'nostrum',12),(13,'facere',13),(14,'soluta',14),(15,'a',15),(16,'illum',16),(17,'ut',17),(18,'magni',18),(19,'maiores',19),(20,'veniam',20);
/*!40000 ALTER TABLE `memories_albums` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `messages` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `from_user_id` bigint(20) unsigned NOT NULL,
  `to_user_id` bigint(20) unsigned NOT NULL,
  `body` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  UNIQUE KEY `id` (`id`),
  KEY `from_user_id` (`from_user_id`),
  KEY `to_user_id` (`to_user_id`),
  CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`from_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `messages_ibfk_2` FOREIGN KEY (`to_user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `messages`
--

LOCK TABLES `messages` WRITE;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
INSERT INTO `messages` VALUES (1,1,1,'Voluptatum ea rerum veniam illum. Suscipit tempora quia accusantium dolores ut ducimus. Fugiat dolor nihil sapiente possimus aut iusto nostrum.','2017-12-25 01:00:18'),(2,2,2,'Distinctio corrupti eius deleniti. Et rerum non maxime quia aperiam. Consectetur amet nobis aperiam.','1994-08-18 20:43:23'),(3,3,3,'Quam recusandae libero sint ipsum voluptate sint. Rerum quos sit quam quis. Temporibus sint quae distinctio velit maxime dolore mollitia architecto. Inventore similique blanditiis ut laboriosam possimus.','1985-09-22 20:41:16'),(4,4,4,'Quo voluptas totam praesentium ullam et ex. Sed ratione minima a cumque vero.','1995-10-24 13:13:30'),(5,5,5,'Maxime numquam praesentium repellat aut sequi officiis qui. Modi error dolores aut expedita quibusdam quasi. Omnis sed omnis aspernatur.','2016-09-18 20:20:29'),(6,6,6,'Expedita quis sunt quam magnam possimus quas ducimus hic. Quidem commodi in a corrupti. Eligendi blanditiis deleniti iure.','1997-08-11 11:55:11'),(7,7,7,'Cum et alias sapiente voluptates in in. Occaecati repellat numquam possimus quibusdam qui vitae. Maxime rerum ducimus dolor dolores quasi totam. Nam sunt tempore dolorem quia soluta nulla.','1979-10-04 09:02:59'),(8,8,8,'Nam labore mollitia nihil nihil. Enim dolor repellat officia illo perspiciatis at aliquam. Maiores cum et quas fugiat et aperiam quod dignissimos.','1986-10-26 13:20:37'),(9,9,9,'Ratione voluptatibus tempore vel sunt sed dolor. Autem alias laboriosam eaque velit. Delectus sunt qui porro similique.','1992-07-04 20:49:24'),(10,10,10,'Eius autem soluta consequatur quae quia dolorem qui. Ex id qui et hic excepturi. Sed aut nisi nam quasi. Ut illo ducimus aperiam quasi.','1972-01-23 00:28:58'),(11,11,11,'Asperiores quasi mollitia similique voluptates. Eius reiciendis fuga ratione enim dolores perspiciatis. Debitis aut aliquid odio.','1996-05-10 03:51:43'),(12,12,12,'Occaecati et a aut aut corrupti et alias. Modi soluta voluptatem enim eligendi fugit omnis. Tenetur praesentium quia culpa est aut laborum. Ab molestiae fugit molestiae cumque iusto.','1973-07-22 00:02:09'),(13,13,13,'Reprehenderit consequuntur iure inventore ut id nihil. Quos sed quam voluptatem. Autem quos quia eius eaque optio. Occaecati cum dolorem dolorem tenetur dolores et et modi.','1997-06-06 00:01:09'),(14,14,14,'Quos dolores enim nemo. Harum omnis dolores aut ad. Consectetur totam sunt aliquam ut et iure velit.','2013-10-25 23:16:48'),(15,15,15,'Expedita reprehenderit velit maxime in cumque distinctio. Illum libero voluptas consectetur ratione porro ab dolorem. Repellendus velit est expedita rem eius exercitationem repellat minus. Praesentium eveniet repudiandae tempora sed omnis quia sunt.','1986-05-07 11:18:23'),(16,16,16,'Commodi itaque quia labore. Et eaque voluptatum consequatur eius. Quo quas dignissimos eveniet est harum iure culpa facere.','2018-12-14 21:13:57'),(17,17,17,'Eos nisi magnam repellat quia maxime saepe deleniti. Consectetur sit et cupiditate et hic.','1982-11-27 21:24:43'),(18,18,18,'Corporis quia est incidunt. Nihil aperiam sunt facere quia eligendi repudiandae. Est dolorem aperiam nisi. Et sapiente consequatur quaerat animi unde est sint.','2009-08-21 20:12:57'),(19,19,19,'Molestias voluptate alias et aperiam assumenda. Sapiente nobis aut dolorem facilis praesentium numquam fuga. Excepturi dolorem unde eos aliquam quod omnis eum.','1985-07-05 09:28:25'),(20,20,20,'Praesentium laudantium provident illo eum excepturi sed illum sunt. Deleniti non similique eaque et ut eos. Voluptatem quo enim illum impedit eveniet voluptatem sed. Qui fugiat aliquam molestias facere.','1998-05-06 05:19:18');
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `music`
--

DROP TABLE IF EXISTS `music`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `music` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `album_id` bigint(20) unsigned DEFAULT NULL,
  `media_id` bigint(20) unsigned NOT NULL,
  UNIQUE KEY `id` (`id`),
  KEY `album_id` (`album_id`),
  KEY `media_id` (`media_id`),
  CONSTRAINT `music_ibfk_1` FOREIGN KEY (`album_id`) REFERENCES `music_albums` (`id`),
  CONSTRAINT `music_ibfk_2` FOREIGN KEY (`media_id`) REFERENCES `media` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `music`
--

LOCK TABLES `music` WRITE;
/*!40000 ALTER TABLE `music` DISABLE KEYS */;
INSERT INTO `music` VALUES (1,1,1),(2,2,2),(3,3,3),(4,4,4),(5,5,5),(6,6,6),(7,7,7),(8,8,8),(9,9,9),(10,10,10),(11,11,11),(12,12,12),(13,13,13),(14,14,14),(15,15,15),(16,16,16),(17,17,17),(18,18,18),(19,19,19),(20,20,20);
/*!40000 ALTER TABLE `music` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `music_albums`
--

DROP TABLE IF EXISTS `music_albums`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `music_albums` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `music_albums_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `music_albums`
--

LOCK TABLES `music_albums` WRITE;
/*!40000 ALTER TABLE `music_albums` DISABLE KEYS */;
INSERT INTO `music_albums` VALUES (1,'magni',1),(2,'asperiores',2),(3,'aut',3),(4,'sunt',4),(5,'esse',5),(6,'voluptas',6),(7,'qui',7),(8,'qui',8),(9,'minus',9),(10,'rerum',10),(11,'repudiandae',11),(12,'aut',12),(13,'voluptatem',13),(14,'placeat',14),(15,'adipisci',15),(16,'corrupti',16),(17,'delectus',17),(18,'sed',18),(19,'illum',19),(20,'quibusdam',20);
/*!40000 ALTER TABLE `music_albums` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `photo_albums`
--

DROP TABLE IF EXISTS `photo_albums`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `photo_albums` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `photo_albums_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `photo_albums`
--

LOCK TABLES `photo_albums` WRITE;
/*!40000 ALTER TABLE `photo_albums` DISABLE KEYS */;
INSERT INTO `photo_albums` VALUES (1,'eligendi',1),(2,'voluptatibus',2),(3,'tempore',3),(4,'deserunt',4),(5,'aliquid',5),(6,'ab',6),(7,'quo',7),(8,'ut',8),(9,'eos',9),(10,'dignissimos',10),(11,'dolor',11),(12,'ut',12),(13,'aut',13),(14,'nisi',14),(15,'consectetur',15),(16,'quisquam',16),(17,'repudiandae',17),(18,'eligendi',18),(19,'nostrum',19),(20,'culpa',20);
/*!40000 ALTER TABLE `photo_albums` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `photos`
--

DROP TABLE IF EXISTS `photos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `photos` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `album_id` bigint(20) unsigned DEFAULT NULL,
  `media_id` bigint(20) unsigned NOT NULL,
  UNIQUE KEY `id` (`id`),
  KEY `album_id` (`album_id`),
  KEY `media_id` (`media_id`),
  CONSTRAINT `photos_ibfk_1` FOREIGN KEY (`album_id`) REFERENCES `photo_albums` (`id`),
  CONSTRAINT `photos_ibfk_2` FOREIGN KEY (`media_id`) REFERENCES `media` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `photos`
--

LOCK TABLES `photos` WRITE;
/*!40000 ALTER TABLE `photos` DISABLE KEYS */;
INSERT INTO `photos` VALUES (1,1,1),(2,2,2),(3,3,3),(4,4,4),(5,5,5),(6,6,6),(7,7,7),(8,8,8),(9,9,9),(10,10,10),(11,11,11),(12,12,12),(13,13,13),(14,14,14),(15,15,15),(16,16,16),(17,17,17),(18,18,18),(19,19,19),(20,20,20);
/*!40000 ALTER TABLE `photos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `profiles`
--

DROP TABLE IF EXISTS `profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `profiles` (
  `user_id` bigint(20) unsigned NOT NULL,
  `gender` char(1) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `birthday` date DEFAULT NULL,
  `photo_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `hometown` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `profiles`
--

LOCK TABLES `profiles` WRITE;
/*!40000 ALTER TABLE `profiles` DISABLE KEYS */;
INSERT INTO `profiles` VALUES (1,'f','1983-02-26',1,'1976-02-15 07:43:53',NULL),(2,'f','1975-07-25',2,'1977-10-21 20:35:02',NULL),(3,'m','2018-01-30',3,'1998-08-30 07:40:34',NULL),(4,'m','2015-10-02',4,'1977-09-03 10:41:41',NULL),(5,'f','1977-04-14',5,'1993-04-23 16:43:25',NULL),(6,'f','2020-04-07',6,'1992-12-24 03:12:52',NULL),(7,'f','2011-10-09',7,'2005-07-22 02:41:17',NULL),(8,'f','1992-12-10',8,'2018-05-08 08:39:24',NULL),(9,'f','2017-11-08',9,'2017-04-21 13:10:07',NULL),(10,'m','2008-09-28',10,'1972-07-31 09:33:18',NULL),(11,'f','1996-02-10',11,'1997-08-11 19:38:14',NULL),(12,'m','1973-04-13',12,'1984-12-30 16:00:48',NULL),(13,'m','2010-10-09',13,'1983-11-04 11:00:44',NULL),(14,'m','1993-04-23',14,'2011-07-22 20:16:41',NULL),(15,'m','2011-09-15',15,'1979-06-23 19:03:03',NULL),(16,'m','1977-07-17',16,'1996-10-23 16:58:27',NULL),(17,'f','1993-05-15',17,'1976-10-11 11:26:31',NULL),(18,'f','1974-09-29',18,'1983-10-18 20:39:45',NULL),(19,'f','1983-07-11',19,'2011-11-12 20:42:15',NULL),(20,'m','2013-11-22',20,'2016-04-17 06:28:21',NULL);
/*!40000 ALTER TABLE `profiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `firstname` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `lastname` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Фамиль',
  `email` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password_hash` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `phone` (`phone`),
  KEY `users_firstname_lastname_idx` (`firstname`,`lastname`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='юзеры';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Vivian','Jacobs','parker.domingo@example.com','6498da2730cc745c75b98420c353f1434bf25127',53854629443),(2,'Dejon','Frami','cbosco@example.net','fdda19b93a84050c46420759cc5051c45f0c80b1',50953131485),(3,'Vern','Roob','abotsford@example.com','11cee6e8ebb1a8b691a5965b8b583bcc23ca278d',45337413605),(4,'Jaquelin','Nienow','jason.ernser@example.org','a5a1771c8cfdb1d09bc608d269ef4eff5ed71b9d',48847427759),(5,'Kennedi','Von','hschowalter@example.com','11cfb52220a9a8bb5e37bb99a60d5e85d4a81861',53171955407),(6,'Elaina','Quigley','aurelio51@example.net','9abcf2f8b79be500da2b61480deaa6e53569d5dd',24969363207),(7,'Ari','Beatty','conroy.vernon@example.net','fd07c8b4ec5133453cbecfd2cbfdd77ed929b16f',58769920710),(8,'Filiberto','Kling','dixie45@example.net','fd937377e600607649e075a02c5a50cce364cfbd',64093271144),(9,'Haskell','Harvey','annie.berge@example.net','34fcf6e7340fa123679fc6f52e19b964972b0ada',50536201330),(10,'Tierra','Rau','kshlerin.mellie@example.org','6e6032239115e7614e4affaa121d1a522510429d',42506616748),(11,'Nathanial','Jaskolski','brett25@example.org','7c9c81a45500daee9e0531dcf8ce05d9b2f98c5d',48517691818),(12,'Henry','Friesen','omonahan@example.com','4afa2198fa36d77d8051711fe77702dd78990636',36216024109),(13,'Jake','Schamberger','block.brendon@example.org','c40b37f357fec1df7a05c6083dde1a31c31f36aa',81232955385),(14,'Reece','McClure','isabelle.volkman@example.com','ae22853bdb659ac9a478816f8bcb74bd46847823',56693682433),(15,'Dulce','Ortiz','damon39@example.com','96b113df89fbdd93017399c72623e0adde90295f',94640912441),(16,'Hope','Bailey','volkman.laurel@example.org','899796ae8c00d56f5e8e270cdbf1b719c5add263',76846916219),(17,'Jacynthe','Pfannerstill','veum.albin@example.net','c4dd15b5cf9dbcc70381806bcaca5c917bd2c917',62216594079),(18,'Bert','Hahn','stefanie.durgan@example.org','588b552fde7f0ab984fecbfa0074194d7ff66af9',32982388166),(19,'Frederik','Stark','guiseppe.harvey@example.net','f3ebc04e6ae1b406a78fc7a580d84d5857b103f8',99109770762),(20,'Ulices','Klein','jterry@example.net','3e9ba108bf486fab766102447d1b026a58e62df0',21460856706);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_communities`
--

DROP TABLE IF EXISTS `users_communities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_communities` (
  `user_id` bigint(20) unsigned NOT NULL,
  `community_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`user_id`,`community_id`),
  KEY `community_id` (`community_id`),
  CONSTRAINT `users_communities_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `users_communities_ibfk_2` FOREIGN KEY (`community_id`) REFERENCES `communities` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_communities`
--

LOCK TABLES `users_communities` WRITE;
/*!40000 ALTER TABLE `users_communities` DISABLE KEYS */;
INSERT INTO `users_communities` VALUES (1,1),(2,2),(3,3),(4,4),(5,5),(6,6),(7,7),(8,8),(9,9),(10,10),(11,11),(12,12),(13,13),(14,14),(15,15),(16,16),(17,17),(18,18),(19,19),(20,20);
/*!40000 ALTER TABLE `users_communities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `video_albums`
--

DROP TABLE IF EXISTS `video_albums`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `video_albums` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `video_albums_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `video_albums`
--

LOCK TABLES `video_albums` WRITE;
/*!40000 ALTER TABLE `video_albums` DISABLE KEYS */;
INSERT INTO `video_albums` VALUES (1,'eos',1),(2,'et',2),(3,'qui',3),(4,'est',4),(5,'sint',5),(6,'nam',6),(7,'earum',7),(8,'labore',8),(9,'officia',9),(10,'perspiciatis',10),(11,'fuga',11),(12,'voluptatem',12),(13,'voluptas',13),(14,'voluptatem',14),(15,'quo',15),(16,'voluptatibus',16),(17,'consequuntur',17),(18,'maxime',18),(19,'aspernatur',19),(20,'est',20);
/*!40000 ALTER TABLE `video_albums` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `videos`
--

DROP TABLE IF EXISTS `videos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `videos` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `album_id` bigint(20) unsigned DEFAULT NULL,
  `media_id` bigint(20) unsigned NOT NULL,
  UNIQUE KEY `id` (`id`),
  KEY `album_id` (`album_id`),
  KEY `media_id` (`media_id`),
  CONSTRAINT `videos_ibfk_1` FOREIGN KEY (`album_id`) REFERENCES `video_albums` (`id`),
  CONSTRAINT `videos_ibfk_2` FOREIGN KEY (`media_id`) REFERENCES `media` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `videos`
--

LOCK TABLES `videos` WRITE;
/*!40000 ALTER TABLE `videos` DISABLE KEYS */;
INSERT INTO `videos` VALUES (1,1,1),(2,2,2),(3,3,3),(4,4,4),(5,5,5),(6,6,6),(7,7,7),(8,8,8),(9,9,9),(10,10,10),(11,11,11),(12,12,12),(13,13,13),(14,14,14),(15,15,15),(16,16,16),(17,17,17),(18,18,18),(19,19,19),(20,20,20);
/*!40000 ALTER TABLE `videos` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- #2 Написать скрипт, возвращающий список имен (только firstname) пользователей без повторений в алфавитном порядке

SELECT firstname FROM `users` -- скрипт для вывода таблицы юзеры по имени
GROUP BY firstname
ORDER BY firstname ASC;

-- #3 Написать скрипт, отмечающий несовершеннолетних пользователей как неактивных (поле is_active = false). 
-- Предварительно добавить такое поле в таблицу profiles со значением по умолчанию = true (или 1)

ALTER TABLE profiles ADD COLUMN is_active BIT DEFAULT 1;
UPDATE profiles, 
(SELECT user_id, birthday, (((YEAR(CURRENT_DATE)-YEAR(birthday))-(RIGHT(CURRENT_DATE,5)<RIGHT(birthday,5)))<18) AS age FROM profiles) AS age_table
SET profiles.is_active = 0
WHERE age_table.age = 1
AND profiles.user_id = age_table.user_id;

SELECT user_id, birthday, (((YEAR(CURRENT_DATE)-YEAR(birthday))-(RIGHT(CURRENT_DATE,5)<RIGHT(birthday,5)))<18) AS age,
((YEAR(CURRENT_DATE)-YEAR(birthday))<18) AS age2, is_active 
FROM profiles
ORDER BY user_id;
SELECT * FROM profiles;

-- #4 Написать скрипт, удаляющий сообщения «из будущего» (дата больше сегодняшней)

INSERT INTO messages (from_user_id, to_user_id, body, created_at) VALUES
('1','20','From the future.','2022-09-19 04:35:46');

SELECT from_user_id, to_user_id, body, created_at # проверка добавилось ли сообщение из будущего
FROM messages;

SELECT * FROM messages WHERE created_at < CURRENT_DATE();  -- выводит только те сообщения, которые созданы раньше, чем сегодня. Без удаления

DELETE FROM messages   # удаляем "Сообщение из будущего"
WHERE YEAR(created_at) > YEAR(CURRENT_DATE);

SELECT from_user_id, to_user_id, body, created_at # проверка, удалилось ли сообщение из будущего
FROM messages;




