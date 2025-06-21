import 'dart:async';
import 'dart:convert';
import 'dart:io';

class CepService {
  static const String _baseUrl = 'https://viacep.com.br/ws';
  final HttpClient _client = HttpClient();

  Future<String> _processResponse(HttpClientResponse response) async {
    final completer = Completer<String>();
    final contents = StringBuffer();
    response.transform(utf8.decoder).listen((data) {
      contents.write(data);
    }, onDone: () => completer.complete(contents.toString()));
    return completer.future;
  }

  Future<Map<String, dynamic>> buscarCep(String cep) async {
    final request = await _client.getUrl(Uri.parse('$_baseUrl/$cep/json'));
    final response = await request.close();

    if (response.statusCode == 200) {
      final responseBody = await _processResponse(response);
      final data = json.decode(responseBody);
      if (data['erro'] == true) {
        throw Exception('CEP não encontrado');
      }
      return data;
    } else {
      throw Exception('Falha ao buscar CEP: ${response.statusCode}');
    }
  }
} 