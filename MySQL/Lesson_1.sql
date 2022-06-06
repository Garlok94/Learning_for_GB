DROP DATABASE IF EXISTS social_network;
CREATE DATABASE social_network;
USE social_network;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    firstname VARCHAR(50),
    lastname VARCHAR(50), 
    email VARCHAR(120) UNIQUE,
 	password_hash VARCHAR(100),
	phone BIGINT UNSIGNED UNIQUE, 
	
    INDEX users_firstname_lastname_idx(firstname, lastname)
);

DROP TABLE IF EXISTS profiles;
CREATE TABLE profiles (
	user_id BIGINT UNSIGNED NOT NULL UNIQUE,
    gender CHAR(1),
    birthday DATE,
	photo_id BIGINT UNSIGNED NULL,
    created_at DATETIME DEFAULT NOW(),
    hometown VARCHAR(100),
    friends VARCHAR(100)
	
);

ALTER TABLE profiles ADD CONSTRAINT fk_user_id
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON UPDATE CASCADE 
    ON DELETE RESTRICT; 

DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
	id SERIAL, 
	from_user_id BIGINT UNSIGNED NOT NULL,
    to_user_id BIGINT UNSIGNED NOT NULL,
    body TEXT,
    created_at DATETIME DEFAULT NOW(), 

    FOREIGN KEY (from_user_id) REFERENCES users(id),
    FOREIGN KEY (to_user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS friend_requests;
CREATE TABLE friend_requests (
	initiator_user_id BIGINT UNSIGNED NOT NULL,
    target_user_id BIGINT UNSIGNED NOT NULL,
    `status` ENUM('requested', 'approved', 'declined', 'unfriended'), 
	requested_at DATETIME DEFAULT NOW(),
	updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP, 
	
    PRIMARY KEY (initiator_user_id, target_user_id),
    FOREIGN KEY (initiator_user_id) REFERENCES users(id),
    FOREIGN KEY (target_user_id) REFERENCES users(id)-- ,
);

DROP TABLE IF EXISTS communities;
CREATE TABLE communities(
	id SERIAL,
	name VARCHAR(150),
	admin_user_id BIGINT UNSIGNED NOT NULL,
	
	INDEX communities_name_idx(name), 
	foreign key (admin_user_id) references users(id)
);

DROP TABLE IF EXISTS users_communities;
CREATE TABLE users_communities(
	user_id BIGINT UNSIGNED NOT NULL,
	community_id BIGINT UNSIGNED NOT NULL,
  
	PRIMARY KEY (user_id, community_id), 
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (community_id) REFERENCES communities(id)
);

DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types(
	id SERIAL,
    name VARCHAR(255), 
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
);

DROP TABLE IF EXISTS photo_albums;
CREATE TABLE photo_albums (
	id SERIAL,
	name varchar(255) DEFAULT NULL,
    user_id BIGINT UNSIGNED DEFAULT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
  	PRIMARY KEY (id)
);

DROP TABLE IF EXISTS photos;
CREATE TABLE photos (
	id SERIAL,
	album_id BIGINT unsigned NULL,
	media_id BIGINT unsigned NOT NULL,

	FOREIGN KEY (album_id) REFERENCES photo_albums(id),
    FOREIGN KEY (media_id) REFERENCES media(id)
);

ALTER TABLE social_network.likes 
ADD CONSTRAINT likes_fk 
FOREIGN KEY (media_id) REFERENCES social_network.media(id);

ALTER TABLE social_network.likes 
ADD CONSTRAINT likes_fk_1 
FOREIGN KEY (user_id) REFERENCES social_network.users(id);

ALTER TABLE social_network.profiles 
ADD CONSTRAINT profiles_fk_1 
FOREIGN KEY (photo_id) REFERENCES media(id);


DROP TABLE IF EXISTS towns;
CREATE TABLE towns (
	id SERIAL,
    name_of_town VARCHAR(255)


);


DROP TABLE IF EXISTS friends_list;
CREATE TABLE friends_list (
    id SERIAL,
    friend_id BIGINT UNSIGNED DEFAULT NULL,
    firstname_of_friend VARCHAR(50),
    lastname_of_friend VARCHAR(50),
    friend_hometown VARCHAR(100),
    

DROP TABLE IF EXISTS video_albums;
CREATE TABLE video_albums (
	id SERIAL,
	name VARCHAR(255) DEFAULT NULL,
    user_id BIGINT UNSIGNED DEFAULT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
  	PRIMARY KEY (id)
);

DROP TABLE IF EXISTS videos;
CREATE TABLE videos (
	id SERIAL,
	album_id BIGINT unsigned NULL,
	media_id BIGINT unsigned NOT NULL,

	FOREIGN KEY (album_id) REFERENCES video_albums(id),
    FOREIGN KEY (media_id) REFERENCES media(id)
);

DROP TABLE IF EXISTS music_albums;
CREATE TABLE music_albums (
	id SERIAL,
	playlist_id BIGINT unsigned NULL,
	playlist_name varchar(255) DEFAULT NULL,
    user_id BIGINT UNSIGNED DEFAULT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
  	PRIMARY KEY (id)
);

DROP TABLE IF EXISTS music;
CREATE TABLE music (
	id SERIAL,
	singers VARCHAR(50),
	album_id BIGINT unsigned NULL,
	media_id BIGINT unsigned NOT NULL,

	FOREIGN KEY (album_id) REFERENCES music_albums(id),
    FOREIGN KEY (media_id) REFERENCES media(id)
);

