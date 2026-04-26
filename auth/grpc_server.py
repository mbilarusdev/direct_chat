import grpc
import proto.chat_pb2 as chat_pb2
import proto.chat_pb2_grpc as chat_pb2_grpc
from bot import send_tg_notification
from config import settings

class NotificationServicer(chat_pb2_grpc.NotificationServiceServicer):
    async def SendTelegramType(self, request, _):
        success = await send_tg_notification(request.user_id, request.message_text)
        return chat_pb2.NotificationResponse(success=success)

async def serve_grpc():
    server = grpc.aio.server()
    chat_pb2_grpc.add_NotificationServiceServicer_to_server(NotificationServicer(), server)
    server.add_insecure_port(f'[::]:{settings.NOTIFY_PORT}') 
    await server.start()
    await server.wait_for_termination()
