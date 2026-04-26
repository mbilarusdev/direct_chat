import asyncio
import uvicorn
from fastapi import FastAPI
from grpc_server import serve_grpc
from endpoints import router as api_router
from config import settings
from bot import dp, bot 

app = FastAPI(title="Direct Chat Auth")

app.include_router(api_router, prefix="/api/v1")

async def run_server():
    """Функция для запуска FastAPI сервера"""
    config = uvicorn.Config(
        app,
        host="0.0.0.0", 
        port=settings.AUTH_PORT,
    )
    server = uvicorn.Server(config)
    await server.serve()

async def main():
    asyncio.create_task(dp.start_polling(bot))
    asyncio.create_task(serve_grpc()) 
    
    print(f"Auth & Bot service started on port {settings.AUTH_PORT}")
    await run_server()

if __name__ == "__main__":
    try:
        asyncio.run(main())
    except (KeyboardInterrupt, SystemExit):
        print("Service stopped.")
