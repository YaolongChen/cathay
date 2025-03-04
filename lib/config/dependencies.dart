import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:media_store/media_store.dart';
import 'package:uuid/uuid.dart';
import 'package:just_audio/just_audio.dart';

import '../data/repository/app_settings_repository.dart';
import '../data/repository/sys_permission_repository.dart';
import '../domain/repository/i_playlist_repository.dart';
import '../data/data_source/drift_playlist_data_source.dart';
import '../data/data_source/drift_song_data_source.dart';
import '../data/data_source/image_file_data_source.dart';
import '../data/data_source/media_store_song_data_source.dart';
import '../data/drift/app_database.dart';
import '../data/http/app_http_client.dart';
import '../data/kv_store/kv_store.dart';
import '../data/repository/playlist_repository.dart';
import '../data/repository/song_repository.dart';

final mediaStoreProvider = Provider<MediaStore>((ref) {
  return MediaStore();
});

final deviceInfoPluginProvider = Provider<DeviceInfoPlugin>((ref) {
  return DeviceInfoPlugin();
});

final imagePickerProvider = Provider<ImagePicker>((ref) {
  return ImagePicker();
});

final uuidProvider = Provider<Uuid>((ref) {
  return const Uuid();
});

final audioPlayerProvider = Provider<AudioPlayer>((ref) {
  return AudioPlayer();
});

final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final httpClientProvider = Provider<AppHttpClient>((ref) {
  return AppHttpClient();
});

final kvStoreProvider = Provider<KVStore>((ref) {
  return KVStore();
});

final imageFileDataSourceProvider = Provider<ImageFileDataSource>((ref) {
  final imagePicker = ref.read(imagePickerProvider);
  return ImageFileDataSource(imagePicker: imagePicker);
});

final driftPlaylistDataSourceProvider = Provider<DriftPlaylistDataSource>((
  ref,
) {
  final db = ref.read(databaseProvider);
  return DriftPlaylistDataSource(db: db);
});

final driftSongDataSourceProvider = Provider<DriftSongDataSource>((ref) {
  final db = ref.read(databaseProvider);
  return DriftSongDataSource(db: db);
});

final mediaStoreSongProvider = Provider<MediaStoreSongDataSource>((ref) {
  final mediaStore = ref.read(mediaStoreProvider);
  return MediaStoreSongDataSource(mediaStore: mediaStore);
});

final playlistRepositoryProvider = Provider<IPlaylistRepository>((ref) {
  final driftPlaylistDataSource = ref.read(driftPlaylistDataSourceProvider);
  final uuid = ref.read(uuidProvider);
  return PlaylistRepositoryImpl(
    driftDataSource: driftPlaylistDataSource,
    uuid: uuid,
  );
});

final songRepositoryProvider = Provider<SongRepository>((ref) {
  final driftSongDataSource = ref.read(driftSongDataSourceProvider);
  final mediaStoreSongDataSource = ref.read(mediaStoreSongProvider);
  final kvStore = ref.read(kvStoreProvider);
  return SongRepository(
    driftSongDataSource: driftSongDataSource,
    mediaStoreSongDataSource: mediaStoreSongDataSource,
    kvStore: kvStore,
  );
});

final sysPermissionRepositoryProvider = Provider<SysPermissionRepository>((
  ref,
) {
  final deviceInfoPlugin = ref.read(deviceInfoPluginProvider);
  return SysPermissionRepository(deviceInfoPlugin: deviceInfoPlugin);
});

final appSettingsRepositoryProvider = Provider<AppSettingsRepository>((ref) {
  return AppSettingsRepository();
});
