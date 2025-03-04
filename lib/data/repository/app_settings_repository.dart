import 'package:app_settings/app_settings.dart';

class AppSettingsRepository {
  Future<void> toAppSettings() {
    return AppSettings.openAppSettings(type: AppSettingsType.settings);
  }
}
