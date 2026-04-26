import 'package:drift/drift.dart';

class Chats extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().nullable()();
  TextColumn get adminId => text()();
  TextColumn get clientId => text()();

  Int64Column get lastPts => int64().withDefault(Constant(BigInt.zero))();
  Int64Column get adminReadPts => int64().withDefault(Constant(BigInt.zero))();
  Int64Column get userReadPts => int64().withDefault(Constant(BigInt.zero))();

  @override
  Set<Column> get primaryKey => {id};
}
