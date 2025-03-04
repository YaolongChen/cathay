import 'package:media_store/entity/audio.dart';
import 'package:media_store/media_store.dart';

class MediaStoreSongDataSource {
  MediaStoreSongDataSource({required this.mediaStore});

  final MediaStore mediaStore;

  Future<String> getVersion() {
    return mediaStore.getVersion();
  }

  Future<List<Audio>> getAudios() async {
    return await mediaStore.getAudios();
  }
}
