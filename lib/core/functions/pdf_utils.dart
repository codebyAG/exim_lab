import 'dart:io';
import 'dart:developer' as developer;
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

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

      // 4. Write the bytes to the file (Extracting)
      await file.writeAsBytes(bytes, flush: true);

      // 5. Open the file via OpenFilex
      final result = await OpenFilex.open(file.path);
      if (result.type != ResultType.done) {
        throw 'App could not open PDF. Result: ${result.message}';
      }
    } catch (e) {
      developer.log("❌ Error opening PDF: $e", name: "PDF_UTILS");
      rethrow;
    }
  }
}
