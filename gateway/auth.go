package main

import (
	"fmt"

	"github.com/golang-jwt/jwt/v5"
)

func validateToken(tokenStr string, secret string) (string, string, error) {
	token, err := jwt.Parse(tokenStr, func(token *jwt.Token) (interface{}, error) {
		return []byte(secret), nil
	})

	if err != nil {
		return "", "", err
	}

	if claims, ok := token.Claims.(jwt.MapClaims); ok && token.Valid {
		sub, _ := claims["sub"].(string)
		role, _ := claims["role"].(string)
		return sub, role, nil
	}
	return "", "", fmt.Errorf("invalid token")
}