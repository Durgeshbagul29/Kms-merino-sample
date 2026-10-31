import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kmsmerino/views/base/custom_loader.dart';
import 'package:kmsmerino/views/base/dialog_box_design.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

/// Requests storage permission based on platform and Android version
Future<bool> requestStoragePermission() async {
  // For Android 11+ (API 30) and newer versions, we need MANAGE_EXTERNAL_STORAGE permission
  if (Platform.isAndroid) {
    String sdkInt = Platform.version.split('.')[0].split(' ')[0].split('(')[0];
    int sdkVersion = int.tryParse(sdkInt) ?? 0;

    if (sdkVersion >= 30) {
      // Android 11+
      // Request MANAGE_EXTERNAL_STORAGE permission
      PermissionStatus status = await Permission.manageExternalStorage
          .request();
      if (status.isGranted) return true;

      if (status.isPermanentlyDenied) {
        openAppSettings();
      }
      return false;
    } else if (sdkVersion >= 29) {
      // Android 10 - scoped storage
      // For Android 10, we need WRITE_EXTERNAL_STORAGE for Downloads folder
      if (await Permission.storage.isGranted) return true;
      PermissionStatus status = await Permission.storage.request();
      if (status.isGranted) return true;
      if (status.isPermanentlyDenied) {
        openAppSettings();
      }
      return false;
    } else {
      // Android 9 and below
      // Traditional storage permission
      if (await Permission.storage.isGranted) return true;
      PermissionStatus status = await Permission.storage.request();
      if (status.isGranted) return true;
      if (status.isPermanentlyDenied) {
        openAppSettings();
      }
      return false;
    }
  }

  // For iOS
  if (await Permission.storage.isGranted) return true;
  PermissionStatus status = await Permission.storage.request();
  if (status.isGranted) return true;
  if (status.isPermanentlyDenied) {
    openAppSettings();
  }
  return false;
}

/// Gets appropriate file path for saving based on platform and Android version
/// [filename] The name of the file to be saved
Future<String> getFilePath(String filename) async {
  Directory? directory;

  if (Platform.isAndroid) {
    String sdkInt = Platform.version.split('.')[0].split(' ')[0].split('(')[0];
    int sdkVersion = int.tryParse(sdkInt) ?? 0;

    if (sdkVersion >= 30) {
      // Android 11+
      // Use Downloads directory for Android 11+
      try {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          // Fallback to app-specific directory
          directory = await getApplicationDocumentsDirectory();
        }
      } catch (e) {
        // Fallback to app-specific directory
        directory = await getApplicationDocumentsDirectory();
      }
    } else if (sdkVersion >= 29) {
      // Android 10
      // Use Downloads directory for Android 10
      try {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          // Fallback to app-specific directory
          directory = await getApplicationDocumentsDirectory();
        }
      } catch (e) {
        // Fallback to app-specific directory
        directory = await getApplicationDocumentsDirectory();
      }
    } else {
      // Use Downloads directory for older Android versions
      try {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          // Fallback to external storage
          directory = await getExternalStorageDirectory();
          directory ??= await getApplicationDocumentsDirectory();
        }
      } catch (e) {
        // Fallback to application documents directory
        directory = await getApplicationDocumentsDirectory();
      }
    }
  } else if (Platform.isIOS) {
    directory = await getApplicationDocumentsDirectory();
  } else {
    // For other platforms
    directory = await getApplicationDocumentsDirectory();
  }

  return '${directory.path}/$filename';
}

/// Downloads a file from URL and saves it to device
/// Shows loader during download and handles success/error cases
Future<void> downloadFromUrl(
  BuildContext context,
  String filename,
  String url,
) async {
  // 1ï¸âƒ£ Permission check for Android 10+
  if (Platform.isAndroid) {
    String sdkInt = Platform.version.split('.')[0].split(' ')[0].split('(')[0];
    int sdkVersion = int.tryParse(sdkInt) ?? 0;

    if (sdkVersion >= 29) {
      // Android 10+
      bool hasPermission = await requestStoragePermission();
      if (!hasPermission) {
        dialogBoxForFailure(
          context,
          'Permission Denied',
          'Storage permission is required to save files to Downloads folder',
        );
        return;
      }
    }
  }

  // 2ï¸âƒ£ Show loader
  CustomLoader.show(
    context,
    progressIndicator: CircularProgressIndicator(),
    loaderText: Text(
      "\nDownloading File...",
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        decoration: TextDecoration.none,
      ),
      textAlign: TextAlign.center,
    ),
  );

  try {
    // 3ï¸âƒ£ File path
    String savePath = await getFilePath(filename);

    Dio dio = Dio();

    // 4ï¸âƒ£ Download
    await dio.download(
      url,
      savePath,
      deleteOnError: true,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          debugPrint("Progress: ${(received / total * 100).toStringAsFixed(0)}%");
        }
      },
    );

    // 5ï¸âƒ£ Success - Open the downloaded file
    CustomLoader.hide();
    dialogBoxForFileDownloadSuccess(
      context,
      'File Downloaded Successfully',
      savePath,
    );

    // Optionally open the file after download
    // await OpenFile.open(savePath);
  } catch (e) {
    // 6ï¸âƒ£ Error handling
    CustomLoader.hide();
    dialogBoxForFailure(context, 'Download Failed', 'Please try again');
    if (kDebugMode) {
      debugPrint("Download error: $e");
    }
  }
}
