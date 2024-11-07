import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:html_unescape/html_unescape.dart';

class EncryptionService {
  // Singleton instance
  static final EncryptionService _instance = EncryptionService._internal();
  factory EncryptionService() => _instance;

  late encrypt.Key _key;
  late encrypt.IV _iv;
  bool _initialized = false;

  EncryptionService._internal();

  Future<void> initialize() async {
    try {
      // Initialize the Key and IV from HEX strings
      _key = encrypt.Key.fromBase16('56bc6fbc79c8de6031076f4cf1540fddfe42f96ed5841940e079bad93617e632');
      _iv = encrypt.IV.fromBase16('f9a72833ccc2f7c28ae9f4b39a2e6452');
      _initialized = true;
    } catch (e) {
      print('Initialization error: $e');
      throw Exception('Failed to initialize EncryptionService');
    }
  }

  bool get isInitialized => _initialized;

  // Encrypt data
  Future<String> encryptData(String data) async {
    if (!_initialized) {
      throw Exception("EncryptionService not initialized");
    }
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    final encrypted = encrypter.encrypt(data, iv: _iv);
    return encrypted.base16; // Use base16 for HEX encoding
  }

  Future<String> decryptData(String encryptedData) async {
    if (!_initialized) {
      throw Exception("EncryptionService not initialized");
    }
    try {
      // Step 1: Decode HTML entities
      HtmlUnescape unescape = HtmlUnescape();
      String decodedData = unescape.convert(encryptedData.replaceAll('&#x2F;', '/'));
      // Debug: Print the decoded data to ensure it looks correct
      print("Decoded Data: $decodedData");
      // Step 2: Decrypt the decoded data
      final encrypter = encrypt.Encrypter(encrypt.AES(_key));
      // Debug: Print key and IV to ensure they are correct
      print("Key: ${_key.base16}");
      print("IV: ${_iv.base16}");
      final decrypted = encrypter.decrypt16(decodedData, iv: _iv); // Assuming base16 (HEX) encoding
      // Debug: Print decrypted result
      print("Decrypted Data: $decrypted");
      return decrypted;
    } catch (e) {
      // Log the error
      print("Error during decryption: $e");
      rethrow; // Rethrow the exception to handle it further up the stack if needed
    }
  }

}
