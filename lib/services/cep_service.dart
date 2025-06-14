import 'dart:convert';
import 'package:http/http.dart' as http;

class CepService {
  static const String _baseUrl = 'https://viacep.com.br/ws';

  Future<Map<String, dynamic>> buscarCep(String cep) async {
    final response = await http.get(Uri.parse('$_baseUrl/$cep/json'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['erro'] == true) {
        throw Exception('CEP não encontrado');
      }
      return data;
    } else {
      throw Exception('Falha ao buscar CEP: ${response.statusCode}');
    }
  }
} 