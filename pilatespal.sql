CREATE DATABASE pilatespal;

CREATE TABLE exercises (
    id SERIAL4 PRIMARY KEY,
    name VARCHAR(100),
    image_url VARCHAR(400),
    level VARCHAR(20),
    muscle_groups VARCHAR(100),
    reps VARCHAR(50),
    description VARCHAR(500),
    user_id INTEGER,
    program_id INTEGER,
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (program_id) REFERENCES programs (id)
);



INSERT INTO exercises (name, image_url, level, muscle_groups, reps, description) values ('','','','','','');


CREATE TABLE programs (
    id SERIAL4 PRIMARY KEY,
    user_id INTEGER,
    FOREIGN KEY (user_id) REFERENCES users (id)
);


CREATE TABLE users (
    id SERIAL4 PRIMARY KEY,
    email VARCHAR(300),
    password_digest VARCHAR(400),
    program_id INTEGER,
    FOREIGN KEY (program_id) REFERENCES programs (id)
);

CREATE TABLE likes (
    id SERIAL4 PRIMARY KEY,
    user_id INTEGER,
    exercise_id INTEGER,
    FOREIGN KEY (exercise_id) REFERENCES exercises (id),
    FOREIGN KEY (user_id) REFERENCES users (id)
);

CREATE TABLE comments (
    id SERIAL4 PRIMARY KEY,
    content TEXT NOT NULL,
    exercise_id INTEGER NOT NULL,
    user_id INTEGER,
    comment_time VARCHAR(100),
    FOREIGN KEY (exercise_id) REFERENCES exercises (id) ON DELETE RESTRICT,
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE RESTRICT
);