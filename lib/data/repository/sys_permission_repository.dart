import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';

class SysPermissionRepository {
  SysPermissionRepository({required DeviceInfoPlugin deviceInfoPlugin})
    : _deviceInfoPlugin = deviceInfoPlugin;

  final _log = Logger('SysPermissionDataSource');
  final DeviceInfoPlugin _deviceInfoPlugin;

  Future<bool> checkReadAudioPermission() async {
    if (Platform.isAndroid && !kIsWeb) {
      final androidInfo = await _deviceInfoPlugin.androidInfo;

      final permissions =
          androidInfo.version.sdkInt >= 33
              ? [Permission.audio, Permission.photos, Permission.storage]
              : [Permission.storage];

      final permissionStatus = await Future.wait(
        permissions.map((e) => e.status),
      );

      return permissionStatus.every((e) => e.isGranted || e.isLimited);
    } else {
      return false;
    }
  }

  Future<void> requestReadAudioPermission() async {
    var authorized = false;

    if (Platform.isAndroid && !kIsWeb) {
      final androidInfo = await _deviceInfoPlugin.androidInfo;

      final permissions =
          androidInfo.version.sdkInt >= 33
              ? [Permission.audio, Permission.photos, Permission.storage]
              : [Permission.storage];

      final permissionStatus = await Future.wait(
        permissions.map((e) => e.status),
      );

      authorized = permissionStatus.every((e) => e.isGranted || e.isLimited);

      if (!authorized) {
        return _requestPermissions(permissions);
      }
    } else {
      throw UnsupportedError(
        'SysPermissionDataSource.requestReadAudioPermission unsupported current platform',
      );
    }
  }

  Future<void> _requestPermissions(List<Permission> permissions) async {
    final permissionStatus = await permissions.request();

    _log.info('requestPermissions: permissionStatus $permissionStatus');

    final allGranted = permissionStatus.entries.every(
      (e) =>
          e.value == PermissionStatus.granted ||
          e.value == PermissionStatus.limited,
    );

    if (allGranted) {
      return;
    }

    final permanentlyDeniedPermissions =
        permissionStatus.entries
            .where((e) => e.value == PermissionStatus.permanentlyDenied)
            .map((e) => e.key)
            .toList();

    if (permanentlyDeniedPermissions.isNotEmpty) {
      throw PermissionException.permanentlyDenied(
        permissions: permanentlyDeniedPermissions,
      );
    }

    final denied =
        permissionStatus.entries
            .where((e) => e.value == PermissionStatus.denied)
            .map((e) => e.key)
            .toList();

    if (denied.isNotEmpty) {
      throw PermissionException.denied(permissions: denied);
    }
  }
}

sealed class PermissionException implements Exception {
  const PermissionException();

  const factory PermissionException.denied({
    required List<Permission> permissions,
  }) = PermissionDeniedException._;

  const factory PermissionException.permanentlyDenied({
    required List<Permission> permissions,
  }) = PermissionPermanentlyDeniedException._;
}

class PermissionDeniedException extends PermissionException {
  final List<Permission> permissions;

  const PermissionDeniedException._({required this.permissions});

  @override
  String toString() {
    return 'PermissionDeniedException{permissions: $permissions}';
  }
}

class PermissionPermanentlyDeniedException extends PermissionException {
  final List<Permission> permissions;

  const PermissionPermanentlyDeniedException._({required this.permissions});

  @override
  String toString() {
    return 'PermissionPermanentlyDeniedException{permissions: $permissions}';
  }
}
