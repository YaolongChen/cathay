import 'package:drift/drift.dart';

@DataClassName('LocalSong')
class Songs extends Table {
  late final id = text()();

  TextColumn get name => text()();

  /// milliseconds
  Int64Column get duration => int64()();

  TextColumn get artist => text()();

  /// bytes
  Int64Column get size => int64()();

  TextColumn get uri => text()();

  TextColumn get albumUri => text()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}
