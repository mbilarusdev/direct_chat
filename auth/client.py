import grpc
import proto.chat_pb2 as chat_pb2
import proto.chat_pb2_grpc as chat_pb2_grpc
from config import settings

class ChatGrpcClient:
    def __init__(self):
        self.channel = grpc.aio.insecure_channel(settings.CHATS_ADDR)
        self.stub = chat_pb2_grpc.ChatServiceStub(self.channel)

    async def create_chat_room(self, admin_id: str, client_id: str, title: str) -> str:
        request = chat_pb2.CreateChatRequest(
            admin_id=admin_id, client_id=client_id, title=title
        )
        response = await self.stub.CreateChat(request)
        return response.chat_id