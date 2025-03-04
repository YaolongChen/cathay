import 'package:drift/drift.dart';

@DataClassName('LocalPlaylist')
class Playlists extends Table {
  late final id = text()();

  TextColumn get name => text()();

  TextColumn get coverUri => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
