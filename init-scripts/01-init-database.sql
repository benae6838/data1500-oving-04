-- ============================================================================
-- DATA1500 - Oppgavesett 1.5: Databasemodellering og implementasjon
-- Initialiserings-skript for PostgreSQL
-- ============================================================================

-- Opprett grunnleggende tabeller
CREATE TABLE IF NOT EXISTS user (
    username VARCHAR(40) PRIMARY KEY,
    password VARCHAR(40) NOT NULL
);

CREATE TABLE IF NOT EXISTS student (
    username VARCHAR(40) PRIMARY KEY REFERENCES user(username),
    firstname VARCHAR(40) NOT NULL,
    lastname VARCHAR(40) NOT NULL
);

CREATE TABLE IF NOT EXISTS teacher (
    username VARCHAR(40) PRIMARY KEY REFERENCES user(username),
    firstname VARCHAR(40) NOT NULL,
    lastname VARCHAR(40) NOT NULL
);

CREATE TABLE IF NOT EXISTS groups (
    group_id SERIAL PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS classroom (
    classroom_id SERIAL PRIMARY KEY,
    classroom_name VARCHAR(40) UNIQUE,
    teacher_username VARCHAR(40) NOT NULL REFERENCES teacher(username)
);

CREATE TABLE IF NOT EXISTS message (
    message_number SERIAL PRIMARY KEY,
    classroom_id INT NOT NULL REFERENCES classroom(classroom_id),
    message_text TEXT NOT NULL,
    teacher_username VARCHAR(40) NOT NULL REFERENCES teacher(username),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS forum (
    forum_number SERIAL PRIMARY KEY,
    classroom_id INT NOT NULL REFERENCES classroom(classroom_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    forum_title VARCHAR(50) NOT NULL,
    forum_text TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS comment (
    comment_number SERIAL PRIMARY KEY,
    forum_number INT REFERENCES forum(forum_number),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    comment_title VARCHAR(50) NOT NULL,
    comment_text TEXT NOT NULL,
    username VARCHAR(40) NOT NULL REFERENCES user(username)
);

CREATE TABLE IF NOT EXISTS answer (
    answer_number SERIAL PRIMARY KEY,
    comment_number INT NOT NULL REFERENCES comment(comment_number),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    answer_title VARCHAR(50) NOT NULL,
    answer_text TEXT NOT NULL,
    username VARCHAR(40) NOT NULL REFERENCES user(username)
);

CREATE TABLE IF NOT EXISTS group_classroom_access (
    group_id INT NOT NULL REFERENCES groups(group_id),
    classroom_id INT NOT NULL REFERENCES classroom(classroom_id),
    PRIMARY KEY (group_id, classroom_id)
);


-- Sett inn testdata
INSERT INTO user (username, password)
VALUES ('alice01', 'password123'), ('bert98', '63949472'), ('teacher101', 'userpassowrd');

INSERT INTO student (username, firstname, lastname)
VALUES ('alice01', 'Alice', 'Anderson'), ('bert98', 'Bert', 'Ernie');

INSERT INTO teacher (username, firstname, lastname)
VALUE ('teacher101', 'Leonora', 'Carlson');

INSERT INTO groups (group_id) VALUES (1), (2);

INSERT INTO classroom (classroom_name, teacher_username)
VALUES ('Math101', 'teacher101'),
       ('Physics101', 'teacher101');

INSERT INTO group_classroom_access (group_id, classroom_id)
VALUES (1, 1), (2, 2);

INSERT INTO message (classroom_id, message_text, teacher_username)
VALUES (1, 'Welcome to Math101', 'teacher101');

INSERT INTO forum (classroom_id, forum_title, forum_text)
VALUES (1, 'Introductions', 'Say hello to your classmates!');

INSERT INTO comment (forum_number, comment_title, comment_text, username)
VALUES (1, 'Hi everyone', 'Excited to be here!', 'alice01');

INSERT INTO answer (comment_number, answer_title, answer_text, username)
VALUES (1, 'Welcome!', 'Glad to have you here!', 'teacher101');


-- Eventuelt: Opprett indekser for ytelse



-- Vis at initialisering er fullført
SELECT 'Database initialisert!' as status;