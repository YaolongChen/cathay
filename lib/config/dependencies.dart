import 'package:riverpod/riverpod.dart';

import '../data/source/local/preferences_data_source.dart';
import '../data/source/network/network_data_source.dart';

final preferencesDataSourceProvider = Provider(
  (ref) => PreferencesDataSource(),
);
final networkDataSourceProvider = Provider((ref) => NetworkDataSource());
