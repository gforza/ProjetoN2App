import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../models/cliente.dart';

class ClienteDao {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> insert(Cliente cliente) async {
    final db = await _dbHelper.db;
    return await db.insert('clientes', cliente.toJson());
  }

  Future<int> update(Cliente cliente) async {
    final db = await _dbHelper.db;
    return await db.update(
      'clientes',
      cliente.toJson(),
      where: 'id = ?',
      whereArgs: [cliente.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.db;
    return await db.delete(
      'clientes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Cliente?> getById(int id) async {
    final db = await _dbHelper.db;
    final List<Map<String, dynamic>> maps = await db.query(
      'clientes',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return Cliente.fromJson(maps.first);
  }

  Future<List<Cliente>> getAll() async {
    final db = await _dbHelper.db;
    final List<Map<String, dynamic>> maps = await db.query('clientes');
    return List.generate(maps.length, (i) => Cliente.fromJson(maps[i]));
  }

  Future<List<Cliente>> searchByName(String nome) async {
    final db = await _dbHelper.db;
    final List<Map<String, dynamic>> maps = await db.query(
      'clientes',
      where: 'nome LIKE ?',
      whereArgs: ['%$nome%'],
    );
    return List.generate(maps.length, (i) => Cliente.fromJson(maps[i]));
  }

  Future<Cliente?> getByCpfCnpj(String cpfCnpj) async {
    final db = await _dbHelper.db;
    final List<Map<String, dynamic>> maps = await db.query(
      'clientes',
      where: 'cpfCnpj = ?',
      whereArgs: [cpfCnpj],
    );

    if (maps.isEmpty) return null;
    return Cliente.fromJson(maps.first);
  }
} 