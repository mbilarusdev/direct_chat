// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messages_dao.dart';

// ignore_for_file: type=lint
mixin _$MessagesDaoMixin on DatabaseAccessor<LocalDatabase> {
  $ChatsTable get chats => attachedDatabase.chats;
  $MessagesTable get messages => attachedDatabase.messages;
  MessagesDaoManager get managers => MessagesDaoManager(this);
}

class MessagesDaoManager {
  final _$MessagesDaoMixin _db;
  MessagesDaoManager(this._db);
  $$ChatsTableTableManager get chats =>
      $$ChatsTableTableManager(_db.attachedDatabase, _db.chats);
  $$MessagesTableTableManager get messages =>
      $$MessagesTableTableManager(_db.attachedDatabase, _db.messages);
}
