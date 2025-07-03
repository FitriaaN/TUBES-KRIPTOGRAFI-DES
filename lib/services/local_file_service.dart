import 'dart:convert';
import 'dart:io';
import 'package:tubes_kripto/utils/custom_encryption.dart';

class LocalFileService {
  static Future<void> writeUserData(
    Map<String, dynamic> data,
    String filename,
  ) async {
    final file = File('lib/data/$filename.json');
    final jsonString = jsonEncode(data);
    final encrypted = CustomEncryption.encrypt(jsonString);
    await file.writeAsString(encrypted);
  }

  static Future<Map<String, dynamic>?> readUserData(String filename) async {
    final file = File('lib/data/$filename.json');
    if (!await file.exists()) return null;
    final encrypted = await file.readAsString();
    final decrypted = CustomEncryption.decrypt(encrypted);
    return jsonDecode(decrypted);
  }
}
