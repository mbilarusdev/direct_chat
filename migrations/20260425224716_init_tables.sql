-- +goose Up
-- Таблица пользователей (нужна Python Auth сервису)
CREATE TABLE users (
    id UUID PRIMARY KEY,
    username VARCHAR(255) UNIQUE,
    password_hash TEXT,
    role VARCHAR(50) NOT NULL DEFAULT 'user',
    chat_id TEXT,
    tg_chat_id TEXT,                 -- ID пользователя в Telegram
    tg_link_code TEXT,               -- Код для глубокой ссылки бота
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица чатов (нужна Go Chat сервису)
CREATE TABLE chats (
    id UUID PRIMARY KEY,
    admin_id TEXT NOT NULL,
    client_id TEXT NOT NULL,
    title TEXT,
    last_pts BIGINT DEFAULT 0,
    admin_read_pts BIGINT DEFAULT 0,
    user_read_pts BIGINT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица сообщений
CREATE TABLE messages (
    id UUID PRIMARY KEY,
    chat_id UUID REFERENCES chats(id) ON DELETE CASCADE,
    sender_id TEXT NOT NULL,
    text TEXT NOT NULL,
    pts BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица обновлений PTS
CREATE TABLE chat_updates (
    id UUID PRIMARY KEY,
    chat_id UUID REFERENCES chats(id) ON DELETE CASCADE,
    pts BIGINT NOT NULL,
    type TEXT NOT NULL,
    payload TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- +goose Down
DROP TABLE chat_updates;
DROP TABLE messages;
DROP TABLE chats;
DROP TABLE users;
