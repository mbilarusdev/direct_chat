from google.protobuf.internal import containers as _containers
from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from collections.abc import Iterable as _Iterable, Mapping as _Mapping
from typing import ClassVar as _ClassVar, Optional as _Optional, Union as _Union

DESCRIPTOR: _descriptor.FileDescriptor

class CreateChatRequest(_message.Message):
    __slots__ = ("admin_id", "client_id", "title")
    ADMIN_ID_FIELD_NUMBER: _ClassVar[int]
    CLIENT_ID_FIELD_NUMBER: _ClassVar[int]
    TITLE_FIELD_NUMBER: _ClassVar[int]
    admin_id: str
    client_id: str
    title: str
    def __init__(self, admin_id: _Optional[str] = ..., client_id: _Optional[str] = ..., title: _Optional[str] = ...) -> None: ...

class CreateChatResponse(_message.Message):
    __slots__ = ("chat_id",)
    CHAT_ID_FIELD_NUMBER: _ClassVar[int]
    chat_id: str
    def __init__(self, chat_id: _Optional[str] = ...) -> None: ...

class DeleteChatRequest(_message.Message):
    __slots__ = ("chat_id",)
    CHAT_ID_FIELD_NUMBER: _ClassVar[int]
    chat_id: str
    def __init__(self, chat_id: _Optional[str] = ...) -> None: ...

class DeleteChatResponse(_message.Message):
    __slots__ = ("success",)
    SUCCESS_FIELD_NUMBER: _ClassVar[int]
    success: bool
    def __init__(self, success: bool = ...) -> None: ...

class SendMessageRequest(_message.Message):
    __slots__ = ("chat_id", "sender_id", "text")
    CHAT_ID_FIELD_NUMBER: _ClassVar[int]
    SENDER_ID_FIELD_NUMBER: _ClassVar[int]
    TEXT_FIELD_NUMBER: _ClassVar[int]
    chat_id: str
    sender_id: str
    text: str
    def __init__(self, chat_id: _Optional[str] = ..., sender_id: _Optional[str] = ..., text: _Optional[str] = ...) -> None: ...

class UpdateMessageRequest(_message.Message):
    __slots__ = ("chat_id", "message_id", "new_text")
    CHAT_ID_FIELD_NUMBER: _ClassVar[int]
    MESSAGE_ID_FIELD_NUMBER: _ClassVar[int]
    NEW_TEXT_FIELD_NUMBER: _ClassVar[int]
    chat_id: str
    message_id: str
    new_text: str
    def __init__(self, chat_id: _Optional[str] = ..., message_id: _Optional[str] = ..., new_text: _Optional[str] = ...) -> None: ...

class DeleteMessageRequest(_message.Message):
    __slots__ = ("chat_id", "message_id")
    CHAT_ID_FIELD_NUMBER: _ClassVar[int]
    MESSAGE_ID_FIELD_NUMBER: _ClassVar[int]
    chat_id: str
    message_id: str
    def __init__(self, chat_id: _Optional[str] = ..., message_id: _Optional[str] = ...) -> None: ...

class MessageActionResponse(_message.Message):
    __slots__ = ("pts", "receiver_id")
    PTS_FIELD_NUMBER: _ClassVar[int]
    RECEIVER_ID_FIELD_NUMBER: _ClassVar[int]
    pts: int
    receiver_id: str
    def __init__(self, pts: _Optional[int] = ..., receiver_id: _Optional[str] = ...) -> None: ...

class MarkReadRequest(_message.Message):
    __slots__ = ("chat_id", "user_id", "pts")
    CHAT_ID_FIELD_NUMBER: _ClassVar[int]
    USER_ID_FIELD_NUMBER: _ClassVar[int]
    PTS_FIELD_NUMBER: _ClassVar[int]
    chat_id: str
    user_id: str
    pts: int
    def __init__(self, chat_id: _Optional[str] = ..., user_id: _Optional[str] = ..., pts: _Optional[int] = ...) -> None: ...

class MarkReadResponse(_message.Message):
    __slots__ = ("success",)
    SUCCESS_FIELD_NUMBER: _ClassVar[int]
    success: bool
    def __init__(self, success: bool = ...) -> None: ...

class SyncRequest(_message.Message):
    __slots__ = ("chat_id", "last_pts", "user_id")
    CHAT_ID_FIELD_NUMBER: _ClassVar[int]
    LAST_PTS_FIELD_NUMBER: _ClassVar[int]
    USER_ID_FIELD_NUMBER: _ClassVar[int]
    chat_id: str
    last_pts: int
    user_id: str
    def __init__(self, chat_id: _Optional[str] = ..., last_pts: _Optional[int] = ..., user_id: _Optional[str] = ...) -> None: ...

class SyncResponse(_message.Message):
    __slots__ = ("current_pts", "read_pts", "full_reload", "messages")
    CURRENT_PTS_FIELD_NUMBER: _ClassVar[int]
    READ_PTS_FIELD_NUMBER: _ClassVar[int]
    FULL_RELOAD_FIELD_NUMBER: _ClassVar[int]
    MESSAGES_FIELD_NUMBER: _ClassVar[int]
    current_pts: int
    read_pts: int
    full_reload: bool
    messages: _containers.RepeatedCompositeFieldContainer[Message]
    def __init__(self, current_pts: _Optional[int] = ..., read_pts: _Optional[int] = ..., full_reload: bool = ..., messages: _Optional[_Iterable[_Union[Message, _Mapping]]] = ...) -> None: ...

class Message(_message.Message):
    __slots__ = ("id", "sender_id", "text", "pts", "chat_id")
    ID_FIELD_NUMBER: _ClassVar[int]
    SENDER_ID_FIELD_NUMBER: _ClassVar[int]
    TEXT_FIELD_NUMBER: _ClassVar[int]
    PTS_FIELD_NUMBER: _ClassVar[int]
    CHAT_ID_FIELD_NUMBER: _ClassVar[int]
    id: str
    sender_id: str
    text: str
    pts: int
    chat_id: str
    def __init__(self, id: _Optional[str] = ..., sender_id: _Optional[str] = ..., text: _Optional[str] = ..., pts: _Optional[int] = ..., chat_id: _Optional[str] = ...) -> None: ...

class NotificationRequest(_message.Message):
    __slots__ = ("user_id", "message_text")
    USER_ID_FIELD_NUMBER: _ClassVar[int]
    MESSAGE_TEXT_FIELD_NUMBER: _ClassVar[int]
    user_id: str
    message_text: str
    def __init__(self, user_id: _Optional[str] = ..., message_text: _Optional[str] = ...) -> None: ...

class NotificationResponse(_message.Message):
    __slots__ = ("success",)
    SUCCESS_FIELD_NUMBER: _ClassVar[int]
    success: bool
    def __init__(self, success: bool = ...) -> None: ...
