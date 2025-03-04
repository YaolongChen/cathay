import 'package:shared_preferences/shared_preferences.dart';

class KVStore {
  final _sp = SharedPreferencesAsync();

  Future<void> _remove(String key) {
    return _sp.remove(key);
  }

  Future<void> _setString(String key, String value) {
    return _sp.setString(key, value);
  }

  Future<String?> _getString(String key) {
    return _sp.getString(key);
  }
}
