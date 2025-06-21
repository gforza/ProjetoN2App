import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../models/usuario.dart';
import '../models/cliente.dart';
import '../models/produto.dart';
import '../models/pedido.dart';

class ApiService {
  final String baseUrl;
  final HttpClient _client;

  ApiService({
    required this.baseUrl,
    HttpClient? client,
  }) : _client = client ?? HttpClient();

  Future<String> _processResponse(HttpClientResponse response) async {
    final completer = Completer<String>();
    final contents = StringBuffer();
    response.transform(utf8.decoder).listen((data) {
      contents.write(data);
    }, onDone: () => completer.complete(contents.toString()));
    return completer.future;
  }

  Future<List<T>> _get<T>(
      String path, T Function(Map<String, dynamic>) fromJson) async {
    final request = await _client.getUrl(Uri.parse('$baseUrl$path'));
    final response = await request.close();

    if (response.statusCode == 200) {
      final responseBody = await _processResponse(response);
      final List<dynamic> jsonList = json.decode(responseBody);
      return jsonList.map((json) => fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar dados de $path');
    }
  }

  Future<void> _post<T>(String path, Map<String, dynamic> data) async {
    final request = await _client.postUrl(Uri.parse('$baseUrl$path'));
    request.headers.set('Content-Type', 'application/json; charset=UTF-8');
    request.write(json.encode(data));
    final response = await request.close();

    if (response.statusCode != 201) {
      throw Exception('Falha ao criar em $path');
    }
  }

  // Usuários
  Future<List<Usuario>> getUsuarios() => _get('/usuarios', Usuario.fromJson);
  Future<void> postUsuario(Usuario usuario) =>
      _post('/usuarios', usuario.toJson());

  Future<Usuario?> login(String username, String password) async {
    final request = await _client.postUrl(Uri.parse('$baseUrl/usuarios/login'));
    request.headers.set('Content-Type', 'application/json; charset=UTF-8');
    request.write(json.encode({'nome': username, 'senha': password}));
    final response = await request.close();

    if (response.statusCode == 200) {
      final responseBody = await _processResponse(response);
      final Map<String, dynamic> data = json.decode(responseBody);
      return Usuario.fromJson(data);
    }
    return null;
  }

  // Clientes
  Future<List<Cliente>> getClientes() => _get('/clientes', Cliente.fromJson);
  Future<void> postCliente(Cliente cliente) =>
      _post('/clientes', cliente.toJson());

  // Produtos
  Future<List<Produto>> getProdutos() => _get('/produtos', Produto.fromJson);
  Future<void> postProduto(Produto produto) =>
      _post('/produtos', produto.toJson());

  // Pedidos
  Future<List<Pedido>> getPedidos() => _get('/pedidos', Pedido.fromJson);
  Future<void> postPedido(Pedido pedido) => _post('/pedidos', pedido.toJson());
} 