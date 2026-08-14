USE `test_db`;

CREATE TABLE
  `demo_users` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `email` VARCHAR(255) NOT NULL,
    `password` VARCHAR(255) NOT NULL,
    `created` DATETIME,
    `modified` DATETIME
  );

CREATE TABLE
  `demo_articles` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT NOT NULL,
    `title` VARCHAR(255) NOT NULL,
    `slug` VARCHAR(191) NOT NULL,
    `body` TEXT,
    `published` BOOLEAN DEFAULT FALSE,
    `created` DATETIME,
    `modified` DATETIME,
    UNIQUE KEY (`slug`),
    FOREIGN KEY `user_key` (`user_id`) REFERENCES `demo_users` (`id`)
  ) CHARSET = utf8mb4;

CREATE TABLE
  `demo_tags` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `title` VARCHAR(191),
    `created` DATETIME,
    `modified` DATETIME,
    UNIQUE KEY (`title`)
  ) CHARSET = utf8mb4;

CREATE TABLE
  `demo_article_tag` (
    `article_id` INT NOT NULL,
    `tag_id` INT NOT NULL,
    PRIMARY KEY (`article_id`, `tag_id`),
    FOREIGN KEY `tag_key` (`tag_id`) REFERENCES `demo_tags` (`id`),
    FOREIGN KEY `article_key` (`article_id`) REFERENCES `demo_articles` (`id`)
  );

INSERT INTO
  `demo_users` (`email`, `password`, `created`, `modified`)
VALUES
  ('test@example.com', 'secret', NOW(), NOW());

INSERT INTO
  `demo_articles` (`user_id`, `title`, `slug`, `body`, `published`, `created`, `modified`)
VALUES
  (1, 'First Post', 'first-post', 'This is the first post.', 1, NOW(), NOW());
