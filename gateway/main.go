package main

import (
	"log"
	"net/http"
)

func main() {
	cfg := LoadConfig()
	hub := NewHub()
	chatClient := NewChatClient(cfg.ChatServiceAddr)

	http.HandleFunc("/ws", handleWS(hub, chatClient, cfg))

	log.Printf("Gateway Service started on :%s (connecting to Chat Service at %s)", cfg.AppPort, cfg.ChatServiceAddr)
	if err := http.ListenAndServe(":"+cfg.AppPort, nil); err != nil {
		log.Fatal(err)
	}
}
