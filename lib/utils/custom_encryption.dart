import 'package:tubes_kripto/helpers/des_helper.dart';

class CustomEncryption {
  static final _key = "A1B2C3D4E5F60708";

  static String encrypt(String plainText) {
    final des = LocalDES(_key);
    final hex =
        plainText.codeUnits
            .map((e) => e.toRadixString(16).padLeft(2, '0'))
            .join();
    final padded = hex.padRight(16, '0').substring(0, 16);
    return des.encrypt(padded);
  }

  static String decrypt(String binary) {
    final des = LocalDES(_key);
    final decrypted = des.encrypt(binary); // DES symmetric
    final hex = des.bin2hex(decrypted);
    final codes = List.generate(
      hex.length ~/ 2,
      (i) => int.parse(hex.substring(i * 2, i * 2 + 2), radix: 16),
    );
    return String.fromCharCodes(codes).trim();
  }
}
