package main

import (
	"sync"

	"github.com/gorilla/websocket"
)

type Hub struct {
	mu          sync.RWMutex
	connections map[string][]*websocket.Conn
}

func NewHub() *Hub {
	return &Hub{connections: make(map[string][]*websocket.Conn)}
}

func (h *Hub) Register(userID string, conn *websocket.Conn) {
	h.mu.Lock()
	defer h.mu.Unlock()
	h.connections[userID] = append(h.connections[userID], conn)
}

func (h *Hub) Unregister(userID string, conn *websocket.Conn) {
	h.mu.Lock()
	defer h.mu.Unlock()
	if conns, ok := h.connections[userID]; ok {
		for i, c := range conns {
			if c == conn {
				h.connections[userID] = append(conns[:i], conns[i+1:]...)
				break
			}
		}
	}
}

func (h *Hub) Broadcast(userID string, data interface{}) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if conns, ok := h.connections[userID]; ok {
		for _, conn := range conns {
			conn.WriteJSON(data)
		}
	}
}
