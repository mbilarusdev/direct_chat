import 'dart:async';

import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';
import 'package:fixnum/fixnum.dart' as fixnum;
import 'package:frontend/data_source/local/chats_dao.dart';
import 'package:frontend/data_source/local/messages_dao.dart';
import 'package:frontend/database/table/chat.dart';
import 'package:frontend/database/table/message.dart';

part 'local_db.g.dart';

@DriftDatabase(tables: [Chats, Messages], daos: [ChatsDao, MessagesDao])
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase(super.e);

  @override
  int get schemaVersion => 1;

  static BigInt protoToBigInt(fixnum.Int64 value) =>
      BigInt.parse(value.toString());
}

DatabaseConnection connectWeb() {
  return DatabaseConnection.delayed(
    Future(() async {
      final result = await WasmDatabase.open(
        databaseName: 'vdesk_db',
        sqlite3Uri: Uri.parse('sqlite3.wasm'),
        driftWorkerUri: Uri.parse('drift_worker.js'),
      );
      return result.resolvedExecutor;
    }),
  );
}
