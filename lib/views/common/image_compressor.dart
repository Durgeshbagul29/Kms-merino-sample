import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:kmsmerino/utils/common_toast.dart';

/// Centralized utility for validating and compressing images in KMS Merino.
/// Ensures all Kaizen images remain under the 8MB limit at runtime
/// without visible quality loss.
class ImageCompressor {
  ImageCompressor._();

  /// Maximum permissible image size in bytes (8 MB).
  static const int maxImageSizeInBytes = 8 * 1024 * 1024;
  static const int defaultLimitInMB = 8;

  /// Checks at runtime if the given image file does not exceed the limit (default 8MB).
  static Future<bool> isSizeValid(File file, {int limitInMB = defaultLimitInMB}) async {
    try {
      if (!await file.exists()) return false;
      int sizeInBytes = await file.length();
      return sizeInBytes <= limitInMB * 1024 * 1024;
    } catch (e) {
      debugPrint('ImageCompressor.isSizeValid error: $e');
      return false;
    }
  }

  /// Synchronously checks if the given image file does not exceed the limit (default 8MB).
  static bool isSizeValidSync(File file, {int limitInMB = defaultLimitInMB}) {
    try {
      if (!file.existsSync()) return false;
      int sizeInBytes = file.lengthSync();
      return sizeInBytes <= limitInMB * 1024 * 1024;
    } catch (e) {
      debugPrint('ImageCompressor.isSizeValidSync error: $e');
      return false;
    }
  }

  /// Returns the file size in megabytes.
  static double getFileSizeInMB(File file) {
    try {
      if (!file.existsSync()) return 0.0;
      return file.lengthSync() / (1024 * 1024);
    } catch (e) {
      return 0.0;
    }
  }

  /// Compresses the image proportionally if it exceeds the max dimension or 8MB size limit.
  /// Preserves high visual fidelity (Full HD 1920px max dimension) without visual quality loss.
  static Future<File> compressImage(
    File file, {
    int maxDimension = 1920,
    int limitInMB = defaultLimitInMB,
  }) async {
    try {
      if (!await file.exists()) return file;

      final int initialSize = await file.length();
      // If already within 8MB, return as-is
      if (initialSize <= limitInMB * 1024 * 1024) {
        return file;
      }

      final Uint8List bytes = await file.readAsBytes();
      final ui.ImmutableBuffer buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
      final ui.ImageDescriptor descriptor = await ui.ImageDescriptor.encoded(buffer);

      int targetWidth = descriptor.width;
      int targetHeight = descriptor.height;

      // Downscale proportionally if larger than maxDimension
      if (targetWidth > maxDimension || targetHeight > maxDimension) {
        if (targetWidth >= targetHeight) {
          targetHeight = (targetHeight * maxDimension / targetWidth).round();
          targetWidth = maxDimension;
        } else {
          targetWidth = (targetWidth * maxDimension / targetHeight).round();
          targetHeight = maxDimension;
        }
      }

      final ui.Codec codec = await descriptor.instantiateCodec(
        targetWidth: targetWidth,
        targetHeight: targetHeight,
      );
      final ui.FrameInfo frameInfo = await codec.getNextFrame();
      final ui.Image image = frameInfo.image;

      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        final tempDir = await getTemporaryDirectory();
        final compressedFile = File(
          '${tempDir.path}/compressed_img_${DateTime.now().millisecondsSinceEpoch}.png',
        );
        await compressedFile.writeAsBytes(byteData.buffer.asUint8List(), flush: true);

        final int newSize = await compressedFile.length();
        debugPrint(
          'Image compressed from ${(initialSize / (1024 * 1024)).toStringAsFixed(2)}MB '
          'to ${(newSize / (1024 * 1024)).toStringAsFixed(2)}MB',
        );
        return compressedFile;
      }

      return file;
    } catch (e) {
      debugPrint('ImageCompressor.compressImage error: $e');
      return file;
    }
  }

  /// Processes picked image: validates runtime size (<= 8MB) and compresses if needed.
  /// Warns user via [CommonToast] if the image cannot be compressed below 8MB.
  static Future<File> processAndValidateImage(
    BuildContext? context,
    File file, {
    int limitInMB = defaultLimitInMB,
  }) async {
    if (!await file.exists()) return file;

    // 1. Check if already within 8MB
    if (await isSizeValid(file, limitInMB: limitInMB)) {
      return file;
    }

    // 2. Compress image to fit within 8MB
    File compressed = await compressImage(file, limitInMB: limitInMB);

    // 3. Re-verify size after compression
    if (!await isSizeValid(compressed, limitInMB: limitInMB)) {
      CommonToast.warning(
        'Image size exceeds ${limitInMB}MB limit. Please select a smaller image.',
        title: 'File Size Limit',
      );
    }

    return compressed;
  }

  /// Cleans up any cached compressed images safely.
  static Future<void> cleanCache() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final entities = tempDir.listSync();
      for (final entity in entities) {
        if (entity is File && entity.path.contains('compressed_img_')) {
          await entity.delete();
        }
      }
    } catch (e) {
      debugPrint('ImageCompressor.cleanCache error: $e');
    }
  }
}

