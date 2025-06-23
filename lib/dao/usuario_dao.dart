import '../models/usuario.dart';
import '../services/database_service.dart';

class UsuarioDao {
  final DatabaseService _dbService = DatabaseService();

  Future<int> insert(Usuario usuario) async {
    return await _dbService.insert('usuarios', usuario.toJson());
  }

  Future<int> update(Usuario usuario) async {
    return await _dbService.update(
      'usuarios',
      usuario.toJson(),
      where: 'id = ?',
      whereArgs: [usuario.id.toString()],
    );
  }

  Future<int> delete(int id) async {
    return await _dbService.delete(
      'usuarios',
      where: 'id = ?',
      whereArgs: [id.toString()],
    );
  }

  Future<Usuario?> getById(int id) async {
    final List<Map<String, dynamic>> maps = await _dbService.query(
      'usuarios',
      where: 'id = ?',
      whereArgs: [id.toString()],
    );

    if (maps.isNotEmpty) {
      return Usuario.fromJson(maps.first);
    }
    return null;
  }

  Future<Usuario?> getByNome(String nome) async {
    final List<Map<String, dynamic>> maps = await _dbService.query(
      'usuarios',
      where: 'nome = ?',
      whereArgs: [nome],
    );

    if (maps.isNotEmpty) {
      return Usuario.fromJson(maps.first);
    }
    return null;
  }

  Future<List<Usuario>> getAll() async {
    final List<Map<String, dynamic>> maps = await _dbService.query('usuarios');
    return List.generate(maps.length, (i) {
      return Usuario.fromJson(maps[i]);
    });
  }

  Future<Usuario?> validateLogin(String nome, String senha) async {
    final List<Map<String, dynamic>> maps = await _dbService.query(
      'usuarios',
      where: 'nome = ? AND senha = ?',
      whereArgs: [nome, senha],
    );

    if (maps.isNotEmpty) {
      return Usuario.fromJson(maps.first);
    }
    return null;
  }

  Future<Usuario?> buscarPorNome(String nome) async {
    final List<Map<String, dynamic>> maps = await _dbService.query(
      'usuarios',
      where: 'nome = ?',
      whereArgs: [nome],
    );

    if (maps.isNotEmpty) {
      return Usuario.fromJson(maps.first);
    }
    return null;
  }

  Future<List<Usuario>> listarTodos() async {
    final List<Map<String, dynamic>> maps = await _dbService.query('usuarios');
    return List.generate(maps.length, (i) {
      return Usuario.fromJson(maps[i]);
    });
  }
} 