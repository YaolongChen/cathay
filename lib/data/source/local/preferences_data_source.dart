import 'package:shared_preferences/shared_preferences.dart';

class PreferencesDataSource {
  PreferencesDataSource({SharedPreferencesAsync? sharedPreferences})
    : _sharedPreferences = sharedPreferences ?? SharedPreferencesAsync();

  final SharedPreferencesAsync _sharedPreferences;
}
