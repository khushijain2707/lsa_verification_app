import 'dart:convert';

import 'package:crypto/crypto.dart';

class CryptoUtils {
  static String generateLogicHash(String payload) {
    final bytes = utf8.encode(payload);
    final digest = sha256.convert(bytes);

    return digest.toString();
  }
}