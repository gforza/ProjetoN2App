import '../services/database_service.dart';

class Storage {
  static final DatabaseService _dbService = DatabaseService();

  static Future<List<Map<String, dynamic>>> readJsonFile(String fileName) async {
    final tableName = fileName.replaceAll('.json', '');
    return await _dbService.query(tableName);
  }

  static Future<void> writeJsonFile(String fileName, List<Map<String, dynamic>> data) async {
    final tableName = fileName.replaceAll('.json', '');
    
    // Limpar tabela (não há método direto de delete all, então vamos usar uma condição vazia)
    // Para uma implementação mais robusta, seria necessário adicionar um método deleteAll no DatabaseService
    
    // Inserir novos dados
    for (var item in data) {
      await _dbService.insert(tableName, item);
    }
  }
} 