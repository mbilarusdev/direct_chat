package main

import (
	"database/sql"
	"log"
	"net"
	"os"

	pb "chat/proto"

	_ "github.com/lib/pq"
	"google.golang.org/grpc"
)

func main() {
	dbAddr := os.Getenv("DATABASE_URL")
	db, err := sql.Open("postgres", dbAddr)
	if err != nil {
		log.Fatalf("DB error: %v", err)
	}

	repo := &Repository{db: db}
	handler := &ChatHandler{repo: repo}

	lis, err := net.Listen("tcp", ":50051")
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}

	s := grpc.NewServer()
	pb.RegisterChatServiceServer(s, handler)

	log.Println("Go Chat Service started on :50051")
	if err := s.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
