import 'package:drift/drift.dart';
import 'package:frontend/database/table/chat.dart';

class Messages extends Table {
  TextColumn get id => text()();
  TextColumn get chatId =>
      text().references(Chats, #id, onDelete: KeyAction.cascade)();
  TextColumn get senderId => text()();
  TextColumn get textContent => text()();

  Int64Column get pts => int64()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
