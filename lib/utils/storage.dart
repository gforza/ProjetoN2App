import 'dart:convert';
import '../database/database_helper.dart';

class Storage {
  static final DatabaseHelper _db = DatabaseHelper();

  static Future<List<Map<String, dynamic>>> readJsonFile(String fileName) async {
    final db = await _db.db;
    final tableName = fileName.replaceAll('.json', '');
    final result = await db.query(tableName);
    return result;
  }

  static Future<void> writeJsonFile(String fileName, List<Map<String, dynamic>> data) async {
    final db = await _db.db;
    final tableName = fileName.replaceAll('.json', '');
    await db.delete(tableName);
    for (var item in data) {
      await db.insert(tableName, item);
    }
  }
} 