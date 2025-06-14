import 'package:flutter/material.dart';
import 'usuario_controller.dart';
import 'cliente_controller.dart';
import 'produto_controller.dart';
import '../models/usuario.dart';
import '../models/cliente.dart';
import '../models/produto.dart';

class AppController {
  static final AppController _instance = AppController._internal();
  factory AppController() => _instance;
  AppController._internal();

  // Controllers específicos
  final UsuarioController _usuarioController = UsuarioController();
  final ClienteController _clienteController = ClienteController();
  final ProdutoController _produtoController = ProdutoController();

  // Usuários
  Future<Usuario?> login(String username, String password) async {
    return await _usuarioController.login(username, password);
  }

  Future<List<Usuario>> getUsuarios() async {
    return await _usuarioController.getUsuarios();
  }

  Future<void> addUsuario(Usuario usuario) async {
    await _usuarioController.addUsuario(usuario);
  }

  Future<void> updateUsuario(Usuario usuario) async {
    await _usuarioController.updateUsuario(usuario);
  }

  Future<void> deleteUsuario(int id) async {
    await _usuarioController.deleteUsuario(id);
  }

  // Clientes
  Future<List<Cliente>> getClientes() async {
    return await _clienteController.getClientes();
  }

  Future<void> addCliente(Cliente cliente) async {
    await _clienteController.addCliente(cliente);
  }

  Future<void> updateCliente(Cliente cliente) async {
    await _clienteController.updateCliente(cliente);
  }

  Future<void> deleteCliente(int id) async {
    await _clienteController.deleteCliente(id);
  }

  Future<Cliente?> getClienteById(int id) async {
    return await _clienteController.getClienteById(id);
  }

  // Produtos
  Future<List<Produto>> getProdutos() async {
    return await _produtoController.getProdutos();
  }

  Future<void> addProduto(Produto produto) async {
    await _produtoController.addProduto(produto);
  }

  Future<void> updateProduto(Produto produto) async {
    await _produtoController.updateProduto(produto);
  }

  Future<void> deleteProduto(int id) async {
    await _produtoController.deleteProduto(id);
  }

  Future<Produto?> getProdutoById(int id) async {
    return await _produtoController.getProdutoById(id);
  }

  // Regras de negócio específicas
  Future<bool> validarLoginAdmin(String username, String password) async {
    return username == 'admin' && password == 'admin';
  }

  Future<bool> validarCredenciais(String username, String password) async {
    if (await validarLoginAdmin(username, password)) {
      return true;
    }
    final usuario = await login(username, password);
    return usuario != null;
  }

  Future<int> gerarNovoId(String tipo) async {
    switch (tipo) {
      case 'usuario':
        final usuarios = await getUsuarios();
        return usuarios.isEmpty ? 1 : usuarios.last.id! + 1;
      case 'cliente':
        final clientes = await getClientes();
        return clientes.isEmpty ? 1 : clientes.last.id! + 1;
      case 'produto':
        final produtos = await getProdutos();
        return produtos.isEmpty ? 1 : produtos.last.id! + 1;
      default:
        throw Exception('Tipo de ID inválido');
    }
  }
} 