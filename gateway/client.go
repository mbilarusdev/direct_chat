package main

import (
	pb "gateway/proto"

	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
)

type ChatClient struct {
	Client pb.ChatServiceClient
}

func NewChatClient(addr string) *ChatClient {
	conn, err := grpc.NewClient(addr, grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		panic(err)
	}
	return &ChatClient{Client: pb.NewChatServiceClient(conn)}
}