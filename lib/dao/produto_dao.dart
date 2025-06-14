import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../models/produto.dart';

class ProdutoDao {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> insert(Produto produto) async {
    final db = await _dbHelper.db;
    return await db.insert('produtos', produto.toJson());
  }

  Future<int> update(Produto produto) async {
    final db = await _dbHelper.db;
    return await db.update(
      'produtos',
      produto.toJson(),
      where: 'id = ?',
      whereArgs: [produto.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.db;
    return await db.delete(
      'produtos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Produto?> getById(int id) async {
    final db = await _dbHelper.db;
    final List<Map<String, dynamic>> maps = await db.query(
      'produtos',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return Produto.fromJson(maps.first);
  }

  Future<List<Produto>> getAll() async {
    final db = await _dbHelper.db;
    final List<Map<String, dynamic>> maps = await db.query('produtos');
    return List.generate(maps.length, (i) => Produto.fromJson(maps[i]));
  }

  Future<List<Produto>> getAtivos() async {
    final db = await _dbHelper.db;
    final List<Map<String, dynamic>> maps = await db.query(
      'produtos',
      where: 'status = ?',
      whereArgs: [0],
    );
    return List.generate(maps.length, (i) => Produto.fromJson(maps[i]));
  }

  Future<List<Produto>> searchByName(String nome) async {
    final db = await _dbHelper.db;
    final List<Map<String, dynamic>> maps = await db.query(
      'produtos',
      where: 'nome LIKE ?',
      whereArgs: ['%$nome%'],
    );
    return List.generate(maps.length, (i) => Produto.fromJson(maps[i]));
  }

  Future<Produto?> getByCodigoBarra(String codigoBarra) async {
    final db = await _dbHelper.db;
    final List<Map<String, dynamic>> maps = await db.query(
      'produtos',
      where: 'codigoBarra = ?',
      whereArgs: [codigoBarra],
    );

    if (maps.isEmpty) return null;
    return Produto.fromJson(maps.first);
  }
} 