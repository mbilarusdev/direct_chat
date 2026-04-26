import uuid

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from database import get_db 
from models import User
from client import ChatGrpcClient 
from security import get_admin_id_from_token
from pydantic import BaseModel
from jose import jwt
from datetime import datetime, timedelta
from passlib.context import CryptContext
from config import settings
from sqlalchemy import select

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

router = APIRouter()
grpc_client = ChatGrpcClient()

from .bot import send_tg_notification

class NotifySchema(BaseModel):
    user_id: str
    text: str

@router.post("/internal/notify")
async def notify_user(data: NotifySchema):
    await send_tg_notification(data.user_id, data.text)
    return {"status": "ok"}

class ClientCreateSchema(BaseModel):
    company_name: str

@router.post("/clients/create")
async def create_client(
    data: ClientCreateSchema, 
    db: AsyncSession = Depends(get_db),
    admin_id: str = Depends(get_admin_id_from_token)
):
    link_code = str(uuid.uuid4()) 
    new_user = User(
        username=data.company_name, 
        role="user",
        tg_link_code=link_code
    )
    db.add(new_user)
    await db.flush()
    
   
    token_payload = {
        "sub": str(new_user.id),
        "role": "user",
        "exp": datetime.now() + timedelta(days=365)
    }
    user_token = jwt.encode(token_payload, settings.SECRET_KEY, algorithm=settings.ALGORITHM)
    
    try:
        chat_id = await grpc_client.create_chat_room(
            admin_id=admin_id,
            client_id=str(new_user.id),
            title=data.company_name
        )
        new_user.chat_id = chat_id
        await db.commit()
    except Exception as e:
        await db.rollback()
        raise HTTPException(status_code=500, detail=f"Go Service Error: {e}")

    return {
        "invite_link": f"https://vdesk.com/chat/{chat_id}?token={user_token}",
        "tg_link": f"https://t.me/DirectChatNotificationsBot?start={link_code}",
        "user_id": str(new_user.id),
        "chat_id": chat_id
    }

class LoginSchema(BaseModel):
    username: str
    password: str

@router.post("/auth/login")
async def login(data: LoginSchema, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(User).where(User.username == data.username))
    user = result.scalar_one_or_none()
    
    if not user or not pwd_context.verify(data.password, user.password_hash):
        raise HTTPException(status_code=401, detail="Invalid credentials")
    
    if user.role != "admin":
        raise HTTPException(status_code=403, detail="Access denied")

    payload = {
        "sub": str(user.id),
        "role": user.role,
        "exp": datetime.now() + timedelta(days=365)
    }
    token = jwt.encode(payload, settings.SECRET_KEY, algorithm=settings.ALGORITHM)
    
    return {"access_token": token, "token_type": "bearer"}