import '../models/cliente.dart';
import '../services/database_service.dart';

class ClienteDao {
  final DatabaseService _dbService = DatabaseService();

  Future<int> insert(Cliente cliente) async {
    return await _dbService.insert('clientes', cliente.toJson());
  }

  Future<int> update(Cliente cliente) async {
    return await _dbService.update(
      'clientes',
      cliente.toJson(),
      where: 'id = ?',
      whereArgs: [cliente.id.toString()],
    );
  }

  Future<int> delete(int id) async {
    return await _dbService.delete(
      'clientes',
      where: 'id = ?',
      whereArgs: [id.toString()],
    );
  }

  Future<Cliente?> getById(int id) async {
    final List<Map<String, dynamic>> maps = await _dbService.query(
      'clientes',
      where: 'id = ?',
      whereArgs: [id.toString()],
    );

    if (maps.isNotEmpty) {
      return Cliente.fromJson(maps.first);
    }
    return null;
  }

  Future<List<Cliente>> getAll() async {
    final List<Map<String, dynamic>> maps = await _dbService.query('clientes');
    return List.generate(maps.length, (i) {
      return Cliente.fromJson(maps[i]);
    });
  }
} 