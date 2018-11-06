PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS users;
CREATE TABLE users(
  id INTEGER PRIMARY KEY,
  first_name VARCHAR(255),
  last_name VARCHAR(255)
);

DROP TABLE IF EXISTS questions;
CREATE TABLE questions(
  id INTEGER PRIMARY KEY,
  title VARCHAR(255),
  body VARCHAR(255),
  author INTEGER,
  FOREIGN KEY (author) REFERENCES users(id)
);

DROP TABLE IF EXISTS question_follows;
CREATE TABLE question_follows(
  id INTEGER PRIMARY KEY,
  questions INTEGER,
  users INTEGER,
  FOREIGN KEY (questions) REFERENCES questions(id),
  FOREIGN KEY (users) REFERENCES users(id)
);

DROP TABLE IF EXISTS replies;
CREATE TABLE replies(
  id INTEGER PRIMARY KEY,
  question_ref INTEGER NOT NULL,
  parent_reply INTEGER,
  user_id INTEGER,
  body VARCHAR(255),

  FOREIGN KEY (question_ref) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (parent_reply) REFERENCES replies(id)
);

DROP TABLE IF EXISTS question_likes;
CREATE TABLE question_likes(
  id INTEGER PRIMARY KEY,
  user_id INTEGER,
  question_id INTEGER,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);
