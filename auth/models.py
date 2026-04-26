import uuid
from datetime import datetime
from sqlalchemy import Column, String, DateTime
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import declarative_base

Base = declarative_base()

class User(Base):
    __tablename__ = "users"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    username = Column(String, unique=True, nullable=True)
    password_hash = Column(String, nullable=True)
    role = Column(String, nullable=False, default="user")
    chat_id = Column(String, nullable=True)
    tg_chat_id = Column(String, nullable=True)
    tg_link_code = Column(String, nullable=True)
    created_at = Column(DateTime, default=datetime.now)
