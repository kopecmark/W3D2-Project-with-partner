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
  FOREIGN KEY (parent_reply) REFERENCES replies(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS question_likes;
CREATE TABLE question_likes(
  id INTEGER PRIMARY KEY,
  user_id INTEGER,
  question_id INTEGER,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO users
VALUES (1, 'Jane', 'Smith'),
  (2, 'John', 'Patrick'),
  (3, 'Patrick', 'Stewart'),
  (4, 'Joanne', 'Samsonite');

INSERT INTO questions
VALUES (1, 'Cat''s are great', 'Wow they are so amazing I can''t stop thinking about them', 1),
  (2, 'Star Trek', 'What will Patrick Stewart be in the next series?', 3),
  (3, 'Apple', 'Are they overpriced? The answer is yes.', 2),
  (4, 'App Academy', 'Will they let us catch up on sleep? I sure hope so.', 1);

INSERT INTO replies
VALUES (1, 3, NULL, 1, 'Of course they are.'),
  (2, 4, NULL, 4, 'Hells no.'),
  (3, 4, 2, 3, 'I firmly agree with your unbiased response.');

INSERT INTO question_follows
VALUES (1, 2, 1),
  (2, 2, 2),
  (3, 4, 3);

INSERT INTO question_likes
VALUES (1, 1, 2),
  (2, 3, 2),
  (3, 4, 3);
