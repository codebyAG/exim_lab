import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file_plus/open_file_plus.dart';

class PdfUtils {
  static Future<void> openAssetPdf(String assetPath) async {
    try {
      // 1. Load the data from assets
      final ByteData data = await rootBundle.load(assetPath);
      final List<int> bytes = data.buffer.asUint8List();

      // 2. Get the temporary directory
      final Directory tempDir = await getTemporaryDirectory();
      
      // 3. Create a file in the temporary directory
      final String fileName = assetPath.split('/').last;
      final File file = File('${tempDir.path}/$fileName');

      // 4. Write the bytes to the file
      await file.writeAsBytes(bytes, flush: true);

      // 5. Open the file
      await OpenFile.open(file.path);
    } catch (e) {
      throw 'Could not open PDF: $e';
    }
  }
}
