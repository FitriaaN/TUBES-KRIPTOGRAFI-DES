import 'dart:convert';
import 'dart:math';

class EncryptionHelper {

  static const String _defaultKey = "QuickBites2024!";

  /// Enkripsi menggunakan XOR dengan salt
  static String xorEncrypt(String input, String key) {
    try {
      List<int> result = [];
      for (int i = 0; i < input.length; i++) {
        result.add(input.codeUnitAt(i) ^ key.codeUnitAt(i % key.length));
      }
      return result.map((e) => e.toRadixString(16).padLeft(2, '0')).join();
    } catch (e) {
      print('Encryption error: $e');
      return input;
    }
  }

  /// Dekripsi XOR
  static String xorDecrypt(String hex, String key) {
    try {
      List<int> bytes = [];
      for (int i = 0; i < hex.length; i += 2) {
        bytes.add(int.parse(hex.substring(i, i + 2), radix: 16));
      }
      List<int> decrypted = [];
      for (int i = 0; i < bytes.length; i++) {
        decrypted.add(bytes[i] ^ key.codeUnitAt(i % key.length));
      }
      return String.fromCharCodes(decrypted);
    } catch (e) {
      print('Decryption error: $e');
      return hex;
    }
  }

  /// Generate salt untuk keamanan tambahan
  static String generateSalt() {
    var random = Random();
    var salt = '';
    for (int i = 0; i < 8; i++) {
      salt += random.nextInt(256).toRadixString(16).padLeft(2, '0');
    }
    return salt;
  }

  /// Hash password dengan salt
  static Map<String, String> hashPassword(String password) {
    String salt = generateSalt();
    String salted = password + salt;
    String hashed = xorEncrypt(salted, _defaultKey);
    
    return {
      'hash': hashed,
      'salt': salt,
    };
  }

  /// Verifikasi password
  static bool verifyPassword(String password, String storedHash, String salt) {
    try {
      String salted = password + salt;
      String computed = xorEncrypt(salted, _defaultKey);
      return computed == storedHash;
    } catch (e) {
      print('Password verification error: $e');
      return false;
    }
  }

  /// Enkripsi data umum
  static String encryptData(String data, {String? customKey}) {
    String key = customKey ?? _defaultKey;
    return xorEncrypt(data, key);
  }

  /// Dekripsi data umum
  static String decryptData(String encryptedData, {String? customKey}) {
    String key = customKey ?? _defaultKey;
    return xorDecrypt(encryptedData, key);
  }
}
