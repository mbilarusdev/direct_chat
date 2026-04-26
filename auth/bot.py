from aiogram import Bot, Dispatcher, types
from aiogram.filters import Command, CommandObject
from sqlalchemy import select, update
from database import async_session
from models import User
from config import settings

bot = Bot(token=settings.TELEGRAM_BOT_TOKEN)
dp = Dispatcher()

@dp.message(Command("start"))
async def cmd_start(message: types.Message, command: CommandObject):
    link_code = command.args
    if not link_code:
        await message.answer("Используйте ссылку из личного кабинета.")
        return

    async with async_session() as session:
        res = await session.execute(select(User).where(User.tg_link_code == link_code))
        user = res.scalar_one_or_none()

        if user:
            await session.execute(
                update(User)
                .where(User.id == user.id)
                .values(tg_chat_id=str(message.chat.id), tg_link_code=None)
            )
            await session.commit()
            await message.answer(f"Уведомления подключены для {user.username}!")
        else:
            await message.answer("Ссылка недействительна или уже использована.")

async def send_tg_notification(user_id: str, text: str):
    async with async_session() as session:
        res = await session.execute(select(User.tg_chat_id).where(User.id == user_id))
        tg_id = res.scalar_one_or_none()
        if tg_id:
            try:
                await bot.send_message(chat_id=tg_id, text=f"✉️ {text}")
            except Exception as e:
                print(f"Ошибка TG: {e}")