import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:grip/pages/toastutill.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FileDownloader {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> downloadImage({
    required String url,
    required String fileName,
    required BuildContext context,
  }) async {
    try {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdk = androidInfo.version.sdkInt;

      // 🔐 Request notification permission for Android 13+
      if (sdk >= 33) {
        await Permission.notification.request();
      }

      // Determine save directory based on Android version
      String savePath;
      if (sdk >= 29) {
        // Android 10+ - Use app-specific directory
        final directory = await getApplicationDocumentsDirectory();
        final downloadDir = Directory('${directory.path}/Download');
        if (!downloadDir.existsSync()) {
          downloadDir.createSync(recursive: true);
        }
        savePath = '${downloadDir.path}/$fileName';
      } else {
        // Android <10 - Use legacy public storage
        final permissionStatus = await Permission.storage.request();
        if (!permissionStatus.isGranted) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(content: Text('Storage permission Required')),
          // );
          ToastUtil.showToast(context, 'Storage permission Required');

          return;
        }

        final directory = await getExternalStorageDirectory();
        if (directory == null) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(content: Text(' Unable to access storage')),
          // );
          ToastUtil.showToast(context, 'Unable to access storage');
          return;
        }
        savePath = '${directory.path}/$fileName';
      }

      // ⏳ Download with Progress Notification
      int lastProgress = -1;

      await Dio().download(
        url,
        savePath,
        onReceiveProgress: (received, total) async {
          if (total != -1) {
            int progress = ((received / total) * 100).toInt();
            if (progress != lastProgress) {
              lastProgress = progress;

              await _notificationsPlugin.show(
                0,
                'Downloading...',
                '$progress%',
                NotificationDetails(
                  android: AndroidNotificationDetails(
                    'download_channel',
                    'File Downloads',
                    channelDescription: 'Progress for file downloads',
                    importance: Importance.low,
                    priority: Priority.low,
                    onlyAlertOnce: true,
                    showProgress: true,
                    maxProgress: 100,
                    progress: progress,
                    ongoing: true,
                  ),
                ),
              );
            }
          }
        },
      );

      // ✅ Completion Notification
      await _notificationsPlugin.show(
        0,
        '✅ Download Complete',
        'Saved: $fileName',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'download_channel',
            'File Downloads',
            channelDescription: 'Completed download',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
      );

      // Show save location info
      ToastUtil.showToast(context, ' File saved Successfully');
    } catch (e) {}
  }
}
