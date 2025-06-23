import '../models/produto.dart';
import '../services/database_service.dart';

class ProdutoDao {
  final DatabaseService _dbService = DatabaseService();

  Future<int> insert(Produto produto) async {
    return await _dbService.insert('produtos', produto.toJson());
  }

  Future<int> update(Produto produto) async {
    return await _dbService.update(
      'produtos',
      produto.toJson(),
      where: 'id = ?',
      whereArgs: [produto.id.toString()],
    );
  }

  Future<int> delete(int id) async {
    return await _dbService.delete(
      'produtos',
      where: 'id = ?',
      whereArgs: [id.toString()],
    );
  }

  Future<Produto?> getById(int id) async {
    final List<Map<String, dynamic>> maps = await _dbService.query(
      'produtos',
      where: 'id = ?',
      whereArgs: [id.toString()],
    );

    if (maps.isNotEmpty) {
      return Produto.fromJson(maps.first);
    }
    return null;
  }

    Future<List<Produto>> getAtivos() async {
    final List<Map<String, dynamic>> maps = await _dbService.query(
      'produtos',
      where: 'status = ?',
      whereArgs: ['0'],
    );
    return List.generate(maps.length, (i) {
      return Produto.fromJson(maps[i]);
    });
  }

  Future<List<Produto>> getAll() async {
    final List<Map<String, dynamic>> maps = await _dbService.query('produtos');
    return List.generate(maps.length, (i) {
      return Produto.fromJson(maps[i]);
    });
  }
} 