import 'package:flutter/services.dart';

class DatabaseService {
  static const MethodChannel _channel = MethodChannel('com.example.forca_vendas/database');

  Future<void> initDatabase() async {
    try {
      await _channel.invokeMethod('initDatabase');
    } on PlatformException catch (e) {
      print("Failed to init database: '${e.message}'.");
    }
  }

  Future<int> insert(String table, Map<String, dynamic> data) async {
    try {
      final int result = await _channel.invokeMethod('insert', {
        'table': table,
        'data': data,
      });
      return result;
    } on PlatformException catch (e) {
      print("Failed to insert into $table: '${e.message}'.");
      return -1;
    }
  }

  Future<int> update(String table, Map<String, dynamic> data, String where, List<dynamic> whereArgs) async {
    try {
      final int result = await _channel.invokeMethod('update', {
        'table': table,
        'data': data,
        'where': where,
        'whereArgs': whereArgs.map((arg) => arg.toString()).toList(),
      });
      return result;
    } on PlatformException catch (e) {
      print("Failed to update $table: '${e.message}'.");
      return -1;
    }
  }
  
  Future<List<Map<String, dynamic>>> query(String table, {String? where, List<dynamic>? whereArgs}) async {
    try {
      final List<dynamic>? result = await _channel.invokeMethod('query', {
        'table': table,
        'where': where,
        'whereArgs': whereArgs?.map((arg) => arg.toString()).toList(),
      });
      if (result == null) return [];
      return result.map((map) => Map<String, dynamic>.from(map)).toList();
    } on PlatformException catch (e) {
      print("Failed to query $table: '${e.message}'.");
      return [];
    }
  }

  Future<int> delete(String table, String where, List<dynamic> whereArgs) async {
    try {
      final int result = await _channel.invokeMethod('delete', {
        'table': table,
        'where': where,
        'whereArgs': whereArgs.map((arg) => arg.toString()).toList(),
      });
      return result;
    } on PlatformException catch (e) {
      print("Failed to delete from $table: '${e.message}'.");
      return -1;
    }
  }
} 