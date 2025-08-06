CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL
);

INSERT INTO users (name, email, password) VALUES
('Alice', 'alice@example.com', 'hashed'),
('Bob', 'bob@example.com', 'hashed');
