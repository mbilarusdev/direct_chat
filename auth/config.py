from pydantic import BaseSettings

class Settings(BaseSettings):
    AUTH_PORT: int
    NOTIFY_PORT: int
    DATABASE_URL: str
    CHATS_PORT: int
    SECRET_KEY: str
    TELEGRAM_BOT_TOKEN: str
    ALGORITHM: str = "HS256"

    @property
    def ASYNC_DATABASE_URL(self) -> str:
        return self.DATABASE_URL.replace("postgresql://", "postgresql+asyncpg://", 1)

    @property
    def CHATS_ADDR(self) -> str:
        return f"localhost:{self.CHATS_PORT}"

    class Config:
        env_file = "../.env"
        env_file_encoding = "utf-8"

settings = Settings()