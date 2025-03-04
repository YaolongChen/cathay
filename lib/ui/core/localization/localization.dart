import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalization {
  const AppLocalization(this.locale);

  final Locale locale;

  static AppLocalization of(BuildContext context) {
    return Localizations.of(context, AppLocalization);
  }

  static const _string = <String, String>{
    // common
    'confirm': 'Confirm',
    'cancel': 'Cancel',
    'check': 'Check',
    'delete': 'Delete',
    'unknownErrorTip': 'An unknown error has occurred, please try again.',
    'tracks': '{number} tracks',

    // specific
    'loadingErrorViewReloadButton': 'Reload',

    'playlistTitle': 'My Playlists',
    'playlistCreateSheetTitle': 'Create Your Playlist',
    'playlistNameHintText': 'Enter name of your playlist.',
    'playlistNameTooLongTip': 'The playlist name is too long.',
    'playlistNameEmptyTip': 'The playlist name cannot be empty.',

    'playlistDetailAddCoverToolTip': 'Add cover for you playlist.',
    'playlistDetailSongListEmptyTip':
        'There are no songs in your playlist yet. Please select songs for your playlist.',
    'playlistDetailSongListEmptySelectSongButtonText': 'Select Songs',

    'localSongsTitle': 'Local Songs',
    'localSongsStorageAudioPermissionDeniedTip':
        'Please request permission in the app, otherwise the app cannot obtain local audio files.',
    'localSongsStorageAudioPermissionDeniedRequestButtonText': 'Request',
    'localSongsStorageAudioPermissionPermanentlyDeniedTip':
        'Please allow the app to access audio files in the app settings.',
    'localSongsStorageAudioPermissionPermanentlyDeniedRequestButtonText':
        'Open Settings',
  };

  String _get(String label) {
    return _string[label] ?? label;
  }

  // common

  String get confirm => _get('confirm');

  String get cancel => _get('cancel');

  String get check => _get('check');

  String get delete => _get('delete');

  String get unknownErrorTip => _get('unknownErrorTip');

  // specific
  String get loadingErrorViewReloadButton =>
      _get('loadingErrorViewReloadButton');

  String get playlistTitle => _get('playlistTitle');

  String get playlistCreateSheetTitle => _get('playlistCreateSheetTitle');

  String get playlistNameHintText => _get('playlistNameHintText');

  String get playlistNameTooLongTip => _get('playlistNameTooLongTip');

  String get playlistNameEmptyTip => _get('playlistNameEmptyTip');

  String get playlistDetailAddCoverToolTip =>
      _get('playlistDetailAddCoverToolTip');

  String get playlistDetailSongListEmptyTip =>
      _get('playlistDetailSongListEmptyTip');

  String get playlistDetailSongListEmptySelectSongButtonText =>
      _get('playlistDetailSongListEmptySelectSongButtonText');

  String get localSongsTitle => _get('localSongsTitle');

  String get localSongsStorageAudioPermissionDeniedTip =>
      _get('localSongsStorageAudioPermissionDeniedTip');

  String get localSongsStorageAudioPermissionDeniedRequestButtonText =>
      _get('localSongsStorageAudioPermissionDeniedRequestButtonText');

  String get localSongsStorageAudioPermissionPermanentlyDeniedTip =>
      _get('localSongsStorageAudioPermissionPermanentlyDeniedTip');

  String
  get localSongsStorageAudioPermissionPermanentlyDeniedRequestButtonText =>
      _get(
        'localSongsStorageAudioPermissionPermanentlyDeniedRequestButtonText',
      );

  String tracks(int number) =>
      _get('tracks').replaceAll('{number}', number.toString());
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  @override
  bool isSupported(Locale locale) {
    return locale.languageCode == 'en';
  }

  @override
  Future<AppLocalization> load(Locale locale) {
    return SynchronousFuture(AppLocalization(locale));
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalization> old) {
    return false;
  }
}
