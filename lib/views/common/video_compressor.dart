import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_compress/video_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:kmsmerino/views/base/custom_loader.dart';
import 'package:kmsmerino/utils/common_toast.dart';

class VideoCompressor {
  /// Compresses the given video file with a loading indicator.
  /// Checks for 50MB size limit before compression.
  static Future<File?> compressVideoWithLoader(BuildContext context, File? videoFile) async {
    if (videoFile == null) return null;

    // Size check before compression
    if (!await isSizeValid(videoFile)) {
      CommonToast.warning('Video size must be less than 50MB', title: 'File Size Limit');
      return null;
    }

    // Show compression loader
    CustomLoader.show(
      context,
      progressIndicator: CircularProgressIndicator(color: Theme.of(context).primaryColor),
      loaderText: Text("\nCompressing video to save bandwidth...",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black, decoration: TextDecoration.none),
          textAlign: TextAlign.center),
    );

    try {
      final MediaInfo? info = await VideoCompress.compressVideo(
        videoFile.path,
        quality: VideoQuality.DefaultQuality,
        deleteOrigin: false,
        includeAudio: true,
      );
      CustomLoader.hide();

      if (info != null && info.file != null) {
        return info.file;
      } else {
        return videoFile; // Fallback to original if compression failed but no error thrown
      }
    } catch (e) {
      CustomLoader.hide();
      debugPrint('ERROR compressing video: $e');
      return videoFile; // Fallback to original on error
    }
  }

  /// Checks if the file size is within the limit (default 50MB).
  static Future<bool> isSizeValid(File file, {int limitInMB = 50}) async {
    int sizeInBytes = await file.length();
    return sizeInBytes <= limitInMB * 1024 * 1024;
  }

  /// Cleans up temporary compression files safely without triggering the known
  /// video_compress plugin bug (which passes kotlin.Unit to MethodChannel and crashes).
  static Future<void> cleanCache() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final videoCompressDir = Directory('${tempDir.path}/video_compress');
      if (await videoCompressDir.exists()) {
        await videoCompressDir.delete(recursive: true);
      }
    } catch (e) {
      debugPrint('Error cleaning video compress cache: $e');
    }
  }
}
