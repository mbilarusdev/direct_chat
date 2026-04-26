package main

import (
	"time"

	"github.com/google/uuid"
)

type Chat struct {
	ID           uuid.UUID `db:"id"`
	Title        string    `db:"title"`
	AdminID      string    `db:"admin_id"`
	ClientID     string    `db:"client_id"`
	LastPTS      int64     `db:"last_pts"`
	AdminReadPTS int64     `db:"admin_read_pts"` 
	UserReadPTS  int64     `db:"user_read_pts"`
	CreatedAt    time.Time `db:"created_at"`
}

type Message struct {
	ID        uuid.UUID `db:"id"`
	ChatID    uuid.UUID `db:"chat_id"`
	SenderID  string    `db:"sender_id"`
	Text      string    `db:"text"`
	PTS       int64     `db:"pts"`
	CreatedAt time.Time `db:"created_at"`
}

type ChatUpdate struct {
	ID        uuid.UUID `db:"id"`
	ChatID    uuid.UUID `db:"chat_id"`
	PTS       int64     `db:"pts"`
	Type      string    `db:"type"`
	Payload   string    `db:"payload"`
}