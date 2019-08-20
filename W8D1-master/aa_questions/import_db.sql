PRAGMA foreign_keys = ON;

DROP TABLE question_likes;
DROP TABLE replies;
DROP TABLE question_follows;
DROP TABLE questions;
DROP TABLE users;

CREATE TABLE
  users(
    id INTEGER PRIMARY KEY,
    fname VARCHAR(255) NOT NULL,
    lname VARCHAR(255) NOT NULL
  );

CREATE TABLE
  questions(
    id INTEGER PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    body VARCHAR(255) NOT NULL,
    user_id INTEGER REFERENCES users
  );



CREATE TABLE
  question_follows(
    id INTEGER PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    question_id INTEGER REFERENCES questions
  );

CREATE TABLE
  replies(
    id INTEGER PRIMARY KEY,
    body TEXT NOT NULL,
    parent_reply REFERENCES replies(id),
    user_id INTEGER REFERENCES users,
    question_id INTEGER REFERENCES questions
  );

CREATE TABLE
  question_likes(
    id INTEGER PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    question_id INTEGER REFERENCES questions(id)
  );

INSERT INTO
    users(fname, lname)
VALUES
    ('John','Smith'),
    ('Hugo', 'Visconti');

INSERT INTO
    questions(title, body, user_id)

VALUES
    ('Help!','How do I sql?',
    (SELECT id FROM users WHERE users.lname = 'Smith') ),

    ('How does insert work?',
    'I''m having trouble getting the ...',
    (SELECT id FROM users WHERE users.lname = 'Visconti') );

INSERT INTO
    question_follows(user_id,question_id)

VALUES
    ( (SELECT id FROM users WHERE users.lname = 'Smith'),
    (SELECT id FROM questions WHERE questions.title = 'Help!') ),

    ( (SELECT id FROM users WHERE users.lname = 'Visconti'),
    (SELECT id FROM questions WHERE questions.title = 'How does insert work?') );

INSERT INTO
  replies(body, parent_reply, user_id, question_id)
VALUES
  ('Please refer to the reading for this section',
  NULL,
  (SELECT id FROM users WHERE users.lname = 'Visconti'),
  (SELECT id FROM questions WHERE title = 'Help!')
  ),
  ('I don''t know',
  (SELECT id FROM replies WHERE question_id = 1),
  (SELECT id FROM users WHERE users.lname = 'Smith'),
  (SELECT id FROM questions WHERE title = 'How does insert work?')
  );

INSERT INTO
  question_likes(user_id, question_id)
  VALUES
    ( (SELECT id FROM users WHERE users.lname = 'Visconti'),
    (SELECT id FROM questions WHERE questions.title = 'Help!') ),

    ( (SELECT id FROM users WHERE users.lname = 'Smith'),
    (SELECT id FROM questions WHERE questions.title = 'How does insert work?') );
