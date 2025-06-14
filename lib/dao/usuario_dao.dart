import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../models/usuario.dart';

class UsuarioDao {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> insert(Usuario usuario) async {
    final db = await _dbHelper.db;
    return await db.insert('usuarios', usuario.toJson());
  }

  Future<int> update(Usuario usuario) async {
    final db = await _dbHelper.db;
    return await db.update(
      'usuarios',
      usuario.toJson(),
      where: 'id = ?',
      whereArgs: [usuario.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.db;
    return await db.delete(
      'usuarios',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Usuario?> getById(int id) async {
    final db = await _dbHelper.db;
    final List<Map<String, dynamic>> maps = await db.query(
      'usuarios',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return Usuario.fromJson(maps.first);
  }

  Future<Usuario?> getByNome(String nome) async {
    final db = await _dbHelper.db;
    final List<Map<String, dynamic>> maps = await db.query(
      'usuarios',
      where: 'nome = ?',
      whereArgs: [nome],
    );

    if (maps.isEmpty) return null;
    return Usuario.fromJson(maps.first);
  }

  Future<List<Usuario>> getAll() async {
    final db = await _dbHelper.db;
    final List<Map<String, dynamic>> maps = await db.query('usuarios');
    return List.generate(maps.length, (i) => Usuario.fromJson(maps[i]));
  }

  Future<Usuario?> validateLogin(String nome, String senha) async {
    final db = await _dbHelper.db;
    final List<Map<String, dynamic>> maps = await db.query(
      'usuarios',
      where: 'nome = ? AND senha = ?',
      whereArgs: [nome, senha],
    );

    if (maps.isEmpty) return null;
    return Usuario.fromJson(maps.first);
  }

  Future<Usuario?> buscarPorNome(String nome) async {
    final db = await _dbHelper.db;
    final List<Map<String, dynamic>> maps = await db.query(
      'usuarios',
      where: 'nome = ?',
      whereArgs: [nome],
    );

    if (maps.isEmpty) return null;

    return Usuario.fromJson(maps.first);
  }

  Future<List<Usuario>> listarTodos() async {
    final db = await _dbHelper.db;
    final List<Map<String, dynamic>> maps = await db.query('usuarios');

    return List.generate(maps.length, (i) => Usuario.fromJson(maps[i]));
  }
} 