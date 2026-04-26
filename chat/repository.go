package main

import (
	pb "chat/proto"
	"context"
	"database/sql"
	"fmt"

	"github.com/google/uuid"
)

type Repository struct {
	db *sql.DB
}

func (r *Repository) UpdateMessage(ctx context.Context, chatID uuid.UUID, messageID uuid.UUID, newText string) (int64, error) {
	tx, err := r.db.BeginTx(ctx, nil)
	if err != nil {
		return 0, err
	}
	defer tx.Rollback()

	var newPTS int64
	err = tx.QueryRowContext(ctx, 
		`UPDATE chats SET last_pts = last_pts + 1 WHERE id = $1 RETURNING last_pts`, 
		chatID).Scan(&newPTS)
	if err != nil {
		return 0, err
	}

	_, err = tx.ExecContext(ctx, 
		`UPDATE messages SET text = $1, pts = $2 WHERE id = $3 AND chat_id = $4`, 
		newText, newPTS, messageID, chatID)
	if err != nil {
		return 0, err
	}

	payload := fmt.Sprintf(`{"message_id": "%s", "new_text": "%s"}`, messageID, newText)
	_, err = tx.ExecContext(ctx, 
		`INSERT INTO chat_updates (id, chat_id, pts, type, payload) VALUES ($1, $2, $3, $4, $5)`, 
		uuid.New(), chatID, newPTS, "EDIT_MESSAGE", payload)

	if err := tx.Commit(); err != nil {
		return 0, err
	}
	return newPTS, nil
}

func (r *Repository) DeleteMessage(ctx context.Context, chatID uuid.UUID, messageID uuid.UUID) (int64, error) {
	tx, err := r.db.BeginTx(ctx, nil)
	if err != nil {
		return 0, err
	}
	defer tx.Rollback()

	var newPTS int64
	err = tx.QueryRowContext(ctx, `UPDATE chats SET last_pts = last_pts + 1 WHERE id = $1 RETURNING last_pts`, chatID).Scan(&newPTS)
	if err != nil {
		return 0, err
	}

	_, err = tx.ExecContext(ctx, `DELETE FROM messages WHERE id = $1 AND chat_id = $2`, messageID, chatID)
	if err != nil {
		return 0, err
	}

	payload := fmt.Sprintf(`{"message_id": "%s"}`, messageID)
	_, err = tx.ExecContext(ctx, 
		`INSERT INTO chat_updates (id, chat_id, pts, type, payload) VALUES ($1, $2, $3, $4, $5)`, 
		uuid.New(), chatID, newPTS, "DELETE_MESSAGE", payload)

	if err := tx.Commit(); err != nil {
		return 0, err
	}
	return newPTS, nil
}

func (r *Repository) DeleteChat(ctx context.Context, chatID uuid.UUID) error {
	tx, err := r.db.BeginTx(ctx, nil)
	if err != nil {
		return err
	}
	defer tx.Rollback()

	_, _ = tx.ExecContext(ctx, `DELETE FROM chat_updates WHERE chat_id = $1`, chatID)
	_, _ = tx.ExecContext(ctx, `DELETE FROM messages WHERE chat_id = $1`, chatID)
	
	_, err = tx.ExecContext(ctx, `DELETE FROM chats WHERE id = $1`, chatID)
	if err != nil {
		return err
	}

	return tx.Commit()
}

func (r *Repository) CreateChat(ctx context.Context, adminID, clientID, title string) (string, error) {
	newID := uuid.New()
	query := `INSERT INTO chats (id, admin_id, client_id, title, last_pts) VALUES ($1, $2, $3, $4, 0)`
	_, err := r.db.ExecContext(ctx, query, newID, adminID, clientID, title)
	return newID.String(), err
}

func (r *Repository) AddMessage(ctx context.Context, chatID uuid.UUID, senderID, text string) (int64, string, error) {
	tx, err := r.db.BeginTx(ctx, nil)
	if err != nil {
		return 0, "", err
	}
	defer tx.Rollback()

	// 1. Апаем PTS
	var newPTS int64
	err = tx.QueryRowContext(ctx, 
		`UPDATE chats SET last_pts = last_pts + 1 WHERE id = $1 RETURNING last_pts`, 
		chatID).Scan(&newPTS)
	if err != nil {
		return 0, "", err
	}

	// 2. Определяем, кто получит уведомление (собеседник)
	var receiverID string
	err = tx.QueryRowContext(ctx, 
		`SELECT CASE WHEN admin_id = $1 THEN client_id ELSE admin_id END 
		 FROM chats WHERE id = $2`, senderID, chatID).Scan(&receiverID)
	if err != nil {
		return 0, "", err
	}

	// 3. Сохраняем сообщение
	msgQuery := `INSERT INTO messages (id, chat_id, sender_id, text, pts) VALUES ($1, $2, $3, $4, $5)`
	_, err = tx.ExecContext(ctx, msgQuery, uuid.New(), chatID, senderID, text, newPTS)
	if err != nil {
		return 0, "", err
	}

	// 4. Фиксируем апдейт
	updateQuery := `INSERT INTO chat_updates (id, chat_id, pts, type, payload) VALUES ($1, $2, $3, $4, $5)`
	_, err = tx.ExecContext(ctx, updateQuery, uuid.New(), chatID, newPTS, "NEW_MESSAGE", "")
	if err != nil {
		return 0, "", err
	}

	if err := tx.Commit(); err != nil {
		return 0, "", err
	}

	return newPTS, receiverID, nil
}

func (r *Repository) MarkRead(ctx context.Context, chatID uuid.UUID, userID string, pts int64) error {
	query := `
		UPDATE chats SET 
			admin_read_pts = CASE WHEN admin_id = $1 AND $2 > admin_read_pts THEN $2 ELSE admin_read_pts END,
			user_read_pts = CASE WHEN client_id = $1 AND $2 > user_read_pts THEN $2 ELSE user_read_pts END
		WHERE id = $3`
	_, err := r.db.ExecContext(ctx, query, userID, pts, chatID)
	return err
}

func (r *Repository) GetSyncData(ctx context.Context, chatID uuid.UUID, userID string, clientLastPTS int64) ([]*pb.Message, int64, int64, bool, error) {
	var currentPTS, adminRead, userRead int64
	var adminID string

	err := r.db.QueryRowContext(ctx, 
		`SELECT last_pts, admin_read_pts, user_read_pts, admin_id FROM chats WHERE id = $1`, 
		chatID).Scan(&currentPTS, &adminRead, &userRead, &adminID)
	if err != nil {
		return nil, 0, 0, false, err
	}

	var peerReadPTS int64
	if userID == adminID {
		peerReadPTS = userRead
	} else {
		peerReadPTS = adminRead
	}

	fullReload := (currentPTS - clientLastPTS) > 50
	var rows *sql.Rows
	if fullReload {
		rows, err = r.db.QueryContext(ctx, `SELECT id, sender_id, text, pts FROM messages WHERE chat_id = $1 ORDER BY pts DESC LIMIT 50`, chatID)
	} else {
		rows, err = r.db.QueryContext(ctx, `SELECT id, sender_id, text, pts FROM messages WHERE chat_id = $1 AND pts > $2 ORDER BY pts ASC`, chatID, clientLastPTS)
	}
	if err != nil {
		return nil, currentPTS, peerReadPTS, fullReload, err
	}
	defer rows.Close()

var msgs []*pb.Message
    for rows.Next() {
        var m pb.Message
        var id uuid.UUID
      
        if err := rows.Scan(&id, &m.SenderId, &m.Text, &m.Pts); err != nil {
            return nil, currentPTS, peerReadPTS, fullReload, err
        }
        m.Id = id.String()
        msgs = append(msgs, &m)
    }
    return msgs, currentPTS, peerReadPTS, fullReload, nil
}