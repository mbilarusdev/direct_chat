package main

import (
	pb "chat/proto"
	"context"

	"github.com/google/uuid"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

type ChatHandler struct {
	pb.UnimplementedChatServiceServer
	repo *Repository
}


func (h *ChatHandler) CreateChat(ctx context.Context, req *pb.CreateChatRequest) (*pb.CreateChatResponse, error) {
	chatID, err := h.repo.CreateChat(ctx, req.AdminId, req.ClientId, req.Title)
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to create chat: %v", err)
	}
	return &pb.CreateChatResponse{ChatId: chatID}, nil
}

func (h *ChatHandler) SendMessage(ctx context.Context, req *pb.SendMessageRequest) (*pb.MessageActionResponse, error) {
	chatID, err := uuid.Parse(req.ChatId)
	if err != nil {
		return nil, status.Errorf(codes.InvalidArgument, "invalid chat_id format: %v", err)
	}

	pts, receiverID, err := h.repo.AddMessage(ctx, chatID, req.SenderId, req.Text)
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to send message: %v", err)
	}

	return &pb.MessageActionResponse{
		Pts:        pts,
		ReceiverId: receiverID,
	}, nil
}

func (h *ChatHandler) UpdateMessage(ctx context.Context, req *pb.UpdateMessageRequest) (*pb.MessageActionResponse, error) {
	chatID, _ := uuid.Parse(req.ChatId)
	msgID, _ := uuid.Parse(req.MessageId)
	
	pts, err := h.repo.UpdateMessage(ctx, chatID, msgID, req.NewText)
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to update message: %v", err)
	}
	return &pb.MessageActionResponse{Pts: pts}, nil
}

func (h *ChatHandler) DeleteMessage(ctx context.Context, req *pb.DeleteMessageRequest) (*pb.MessageActionResponse, error) {
	chatID, _ := uuid.Parse(req.ChatId)
	msgID, _ := uuid.Parse(req.MessageId)
	
	pts, err := h.repo.DeleteMessage(ctx, chatID, msgID)
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to delete message: %v", err)
	}
	return &pb.MessageActionResponse{Pts: pts, ChatId: req.ChatId}, nil
}

func (h *ChatHandler) DeleteChat(ctx context.Context, req *pb.DeleteChatRequest) (*pb.DeleteChatResponse, error) {
	chatID, _ := uuid.Parse(req.ChatId)
	err := h.repo.DeleteChat(ctx, chatID)
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to delete chat: %v", err)
	}
	return &pb.DeleteChatResponse{Success: true}, nil
}

func (h *ChatHandler) MarkRead(ctx context.Context, req *pb.MarkReadRequest) (*pb.MarkReadResponse, error) {
	chatID, _ := uuid.Parse(req.ChatId)
	err := h.repo.MarkRead(ctx, chatID, req.UserId, req.Pts)
	if err != nil {
		return nil, err
	}
	return &pb.MarkReadResponse{Success: true}, nil
}

func (h *ChatHandler) Sync(ctx context.Context, req *pb.SyncRequest) (*pb.SyncResponse, error) {
	chatID, err := uuid.Parse(req.ChatId)
	if err != nil {
		return nil, status.Errorf(codes.InvalidArgument, "invalid chat_id")
	}
	
	msgs, currPTS, peerReadPTS, fullReload, err := h.repo.GetSyncData(ctx, chatID, req.UserId, req.LastPts)
	if err != nil {
		return nil, status.Errorf(codes.Internal, "Sync error: %v", err)
	}

	return &pb.SyncResponse{
		CurrentPts: currPTS,
		ReadPts:    peerReadPTS,
		FullReload: fullReload,
		Messages:   msgs,
		ChatId: req.ChatId,
	}, nil
}