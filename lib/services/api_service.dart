import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/usuario.dart';
import '../models/cliente.dart';
import '../models/produto.dart';
import '../models/pedido.dart';

class ApiService {
  final String baseUrl;
  final http.Client _client;
  
  ApiService({
    required this.baseUrl,
    http.Client? client,
  }) : _client = client ?? http.Client();

  // Usuários
  Future<List<Usuario>> getUsuarios() async {
    final response = await _client.get(Uri.parse('$baseUrl/usuarios'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Usuario.fromJson(json)).toList();
    }
    throw Exception('Falha ao carregar usuários');
  }

  Future<Usuario?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/usuarios/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nome': username,
        'senha': password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return Usuario.fromJson(data);
    }
    return null;
  }

  // Clientes
  Future<List<Cliente>> getClientes() async {
    final response = await _client.get(Uri.parse('$baseUrl/clientes'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Cliente.fromJson(json)).toList();
    }
    throw Exception('Falha ao carregar clientes');
  }

  Future<void> postCliente(Cliente cliente) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/clientes'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(cliente.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Falha ao criar cliente');
    }
  }

  // Produtos
  Future<List<Produto>> getProdutos() async {
    final response = await _client.get(Uri.parse('$baseUrl/produtos'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Produto.fromJson(json)).toList();
    }
    throw Exception('Falha ao carregar produtos');
  }

  Future<void> postProduto(Produto produto) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/produtos'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(produto.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Falha ao criar produto');
    }
  }

  // Pedidos
  Future<List<Pedido>> getPedidos() async {
    final response = await _client.get(Uri.parse('$baseUrl/pedidos'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Pedido.fromJson(json)).toList();
    }
    throw Exception('Falha ao carregar pedidos');
  }

  Future<void> postPedido(Pedido pedido) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/pedidos'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(pedido.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Falha ao criar pedido');
    }
  }

  Future<void> postUsuario(Usuario usuario) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/usuarios'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(usuario.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Falha ao criar usuário');
    }
  }
} 