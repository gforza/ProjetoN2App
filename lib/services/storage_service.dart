import 'package:flutter/services.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  static const MethodChannel _channel = MethodChannel('com.example.forca_vendas/database');

  Future<void> saveString(String key, String value) async {
    try {
      await _channel.invokeMethod('saveString', {'key': key, 'value': value});
    } on PlatformException catch (e) {
      print("Failed to save string: '${e.message}'.");
    }
  }

  Future<String> loadString(String key) async {
    try {
      final String result = await _channel.invokeMethod('loadString', {'key': key});
      return result;
    } on PlatformException catch (e) {
      print("Failed to load string: '${e.message}'.");
      return "";
    }
  }
} 