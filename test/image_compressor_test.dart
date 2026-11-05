import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:kmsmerino/views/common/image_compressor.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ImageCompressor Unit Tests', () {
    late Directory tempDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('image_compressor_test');
    });

    tearDown(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('isSizeValid returns true for files under 8MB', () async {
      final file = File('${tempDir.path}/small_test.jpg');
      // Create a 1MB mock file
      await file.writeAsBytes(List.filled(1024 * 1024, 0));

      final isValid = await ImageCompressor.isSizeValid(file);
      expect(isValid, isTrue);
      expect(ImageCompressor.isSizeValidSync(file), isTrue);
      expect(ImageCompressor.getFileSizeInMB(file), closeTo(1.0, 0.05));
    });

    test('isSizeValid returns false for files exceeding 8MB', () async {
      final file = File('${tempDir.path}/large_test.jpg');
      // Create an 8.5MB mock file
      await file.writeAsBytes(List.filled((8.5 * 1024 * 1024).toInt(), 0));

      final isValid = await ImageCompressor.isSizeValid(file);
      expect(isValid, isFalse);
      expect(ImageCompressor.isSizeValidSync(file), isFalse);
      expect(ImageCompressor.getFileSizeInMB(file), closeTo(8.5, 0.05));
    });

    test('isSizeValid returns false for non-existent file', () async {
      final file = File('${tempDir.path}/non_existent.jpg');
      final isValid = await ImageCompressor.isSizeValid(file);
      expect(isValid, isFalse);
      expect(ImageCompressor.isSizeValidSync(file), isFalse);
    });

    test('cleanCache runs safely without exceptions', () async {
      expect(() => ImageCompressor.cleanCache(), returnsNormally);
    });
  });
}

