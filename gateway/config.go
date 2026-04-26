package main

import (
	"log"
	"os"

	"github.com/joho/godotenv"
)

type Config struct {
	AppPort         string
	ChatServiceAddr string
	SecretKey       string
}

func LoadConfig() *Config {
	err := godotenv.Load("../.env")
	if err != nil {
		log.Printf("Предупреждение: .env не найден в ../.env, используем системные переменные")
	}

	return &Config{
		AppPort:         os.Getenv("GATEWAY_PORT"),
		ChatServiceAddr: "localhost:" + os.Getenv("CHATS_PORT"),
		SecretKey:       os.Getenv("SECRET_KEY"),
	}
}
