package main

import (
	"context"
	"encoding/json"
	pb "gateway/proto"
	"net/http"

	"github.com/gorilla/websocket"
)

var upgrader = websocket.Upgrader{
	CheckOrigin: func(r *http.Request) bool { return true },
}

type WSRequest struct {
	Action string          `json:"action"`
	Data   json.RawMessage `json:"data"`
}

func handleWS(hub *Hub, chatClient *ChatClient, config *Config) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		token := r.URL.Query().Get("token")
		userID, _, err := validateToken(token, config.SecretKey)
		if err != nil {
			http.Error(w, "Unauthorized", 401)
			return
		}

		conn, err := upgrader.Upgrade(w, r, nil)
		if err != nil { return }
		
		hub.Register(userID, conn)
		defer func() {
			hub.Unregister(userID, conn)
			conn.Close()
		}()

		ctx := context.Background()

		for {
			var req WSRequest
			if err := conn.ReadJSON(&req); err != nil { break }

			switch req.Action {
			case "sync":
				var d pb.SyncRequest
				json.Unmarshal(req.Data, &d)
				d.UserId = userID
				resp, err := chatClient.Client.Sync(ctx, &d)
				if err == nil { conn.WriteJSON(resp) }

			case "send":
				var d pb.SendMessageRequest
				json.Unmarshal(req.Data, &d)
				d.SenderId = userID
				resp, err := chatClient.Client.SendMessage(ctx, &d)
				if err == nil {
					conn.WriteJSON(resp)
					hub.Broadcast(resp.ReceiverId, resp)
				}

			case "update":
				var d pb.UpdateMessageRequest
				json.Unmarshal(req.Data, &d)
				resp, err := chatClient.Client.UpdateMessage(ctx, &d)
				if err == nil {
					conn.WriteJSON(resp)
					hub.Broadcast(resp.ReceiverId, resp)
				}

			case "delete":
				var d pb.DeleteMessageRequest
				json.Unmarshal(req.Data, &d)
				resp, err := chatClient.Client.DeleteMessage(ctx, &d)
				if err == nil {
					conn.WriteJSON(resp)
					hub.Broadcast(resp.ReceiverId, resp)
				}
			case "mark_read":
				var d pb.MarkReadRequest
				json.Unmarshal(req.Data, &d)
				d.UserId = userID
				resp, err := chatClient.Client.MarkRead(ctx, &d)
				if err == nil {
					conn.WriteJSON(resp)
				}

			case "delete_chat":
				var d pb.DeleteChatRequest
				json.Unmarshal(req.Data, &d)
				resp, err := chatClient.Client.DeleteChat(ctx, &d)
				if err == nil { conn.WriteJSON(resp) }
			}
		}
	}
}
