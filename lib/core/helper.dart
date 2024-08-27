import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class Helper {
  Future<bool> accessRequest() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
    if (androidDeviceInfo.version.sdkInt >= 33) {
      await Permission.photos.request();
      if (await Permission.photos.isGranted == false) {
        debugPrint('I would be pop dialog for alert message.');
        return false;
      }

      if (await Permission.photos.isGranted == false) {
        if (await Permission.photos.isPermanentlyDenied) {
          openAppSettings();
          return false;
        } else if (!await Permission.photos.isGranted) {
          return false;
        }
      }
    } else {
      await Permission.storage.request();

      if (await Permission.storage.isGranted == false) {
        if (await Permission.storage.isPermanentlyDenied) {
          openAppSettings();

          return false;
        } else if (!await Permission.storage.isGranted) {
          return false;
        }
      }
    }

    return true;
  }
}
