import 'package:drift/drift.dart';
import 'package:frontend/database/local_db.dart';
import 'package:frontend/database/table/message.dart';
import 'package:frontend/generated/chat.pb.dart' as pb;

part 'messages_dao.g.dart';

@DriftAccessor(tables: [Messages])
class MessagesDao extends DatabaseAccessor<LocalDatabase>
    with _$MessagesDaoMixin {
  MessagesDao(super.db);

  Future<void> clearChat(String chatId) {
    return (delete(messages)..where((t) => t.chatId.equals(chatId))).go();
  }

  Stream<List<Message>> watchMessages(String chatId) {
    return (select<Messages, Message>(messages)
          ..where((tbl) => tbl.chatId.equals(chatId))
          ..orderBy([
            (t) => OrderingTerm(expression: t.pts, mode: OrderingMode.desc),
          ]))
        .map((row) => row)
        .watch();
  }

  Future<void> insertOrUpdateMessages(List<pb.Message> msgs) async {
    await batch((b) {
      b.insertAll(
        messages,
        msgs.map(
          (m) => MessagesCompanion.insert(
            id: m.id,
            chatId: m.chatId,
            senderId: m.senderId,
            textContent: m.text,
            pts: BigInt.parse(m.pts.toString()),
          ),
        ),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  Future<void> deleteMessage(String id) {
    return (delete<Messages, Message>(
      messages,
    )..where((t) => t.id.equals(id))).go();
  }
}
