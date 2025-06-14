import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../dao/cliente_dao.dart';
import '../dao/produto_dao.dart';
import '../dao/pedido_dao.dart';
import '../dao/usuario_dao.dart';
import '../models/cliente.dart';
import '../models/produto.dart';
import '../models/pedido.dart';
import '../models/usuario.dart';

class SincroniaScreen extends StatefulWidget {
  const SincroniaScreen({super.key});

  @override
  State<SincroniaScreen> createState() => _SincroniaScreenState();
}

class _SincroniaScreenState extends State<SincroniaScreen> {
  late ApiService _apiService;
  final _clienteDao = ClienteDao();
  final _produtoDao = ProdutoDao();
  final _pedidoDao = PedidoDao();
  final _usuarioDao = UsuarioDao();
  bool _isLoading = false;
  String _status = '';

  @override
  void initState() {
    super.initState();
    _carregarConfiguracoes();
  }

  Future<void> _carregarConfiguracoes() async {
    final prefs = await SharedPreferences.getInstance();
    final url = prefs.getString('api_url') ?? '';
    _apiService = ApiService(baseUrl: url);
  }

  Future<void> _sincronizarClientes() async {
    setState(() {
      _isLoading = true;
      _status = 'Sincronizando clientes...';
    });

    try {
      // Buscar clientes do servidor
      final clientesServidor = await _apiService.getClientes();
      final clientesLocal = await _clienteDao.getAll();

      // Atualizar clientes locais
      for (var cliente in clientesServidor) {
        final clienteLocal = clientesLocal.firstWhere(
          (c) => c.id == cliente.id,
          orElse: () => cliente,
        );

        if (clienteLocal.ultimaAlteracao != cliente.ultimaAlteracao) {
          await _clienteDao.update(cliente);
        }
      }

      // Enviar clientes locais para o servidor
      for (var cliente in clientesLocal) {
        if (cliente.id == null) {
          await _apiService.postCliente(cliente);
        }
      }

      setState(() {
        _status = 'Clientes sincronizados com sucesso!';
      });
    } catch (e) {
      setState(() {
        _status = 'Erro ao sincronizar clientes: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _sincronizarProdutos() async {
    setState(() {
      _isLoading = true;
      _status = 'Sincronizando produtos...';
    });

    try {
      // Buscar produtos do servidor
      final produtosServidor = await _apiService.getProdutos();
      final produtosLocal = await _produtoDao.getAll();

      // Atualizar produtos locais
      for (var produto in produtosServidor) {
        final produtoLocal = produtosLocal.firstWhere(
          (p) => p.id == produto.id,
          orElse: () => produto,
        );

        if (produtoLocal.ultimaAlteracao != produto.ultimaAlteracao) {
          await _produtoDao.update(produto);
        }
      }

      // Enviar produtos locais para o servidor
      for (var produto in produtosLocal) {
        if (produto.id == null) {
          await _apiService.postProduto(produto);
        }
      }

      setState(() {
        _status = 'Produtos sincronizados com sucesso!';
      });
    } catch (e) {
      setState(() {
        _status = 'Erro ao sincronizar produtos: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _sincronizarPedidos() async {
    setState(() {
      _isLoading = true;
      _status = 'Sincronizando pedidos...';
    });

    try {
      // Buscar pedidos do servidor
      final pedidosServidor = await _apiService.getPedidos();
      final pedidosLocal = await _pedidoDao.getAll();

      // Atualizar pedidos locais
      for (var pedido in pedidosServidor) {
        final pedidoLocal = pedidosLocal.firstWhere(
          (p) => p.id == pedido.id,
          orElse: () => pedido,
        );

        if (pedidoLocal.ultimaAlteracao != pedido.ultimaAlteracao) {
          await _pedidoDao.update(pedido);
        }
      }

      // Enviar pedidos locais para o servidor
      for (var pedido in pedidosLocal) {
        if (pedido.id == null) {
          await _apiService.postPedido(pedido);
        }
      }

      setState(() {
        _status = 'Pedidos sincronizados com sucesso!';
      });
    } catch (e) {
      setState(() {
        _status = 'Erro ao sincronizar pedidos: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _sincronizarUsuarios() async {
    setState(() {
      _isLoading = true;
      _status = 'Sincronizando usuários...';
    });

    try {
      // Buscar usuários do servidor
      final usuariosServidor = await _apiService.getUsuarios();
      final usuariosLocal = await _usuarioDao.getAll();

      // Atualizar usuários locais
      for (var usuario in usuariosServidor) {
        final usuarioLocal = usuariosLocal.firstWhere(
          (u) => u.id == usuario.id,
          orElse: () => usuario,
        );

        if (usuarioLocal.ultimaAlteracao != usuario.ultimaAlteracao) {
          await _usuarioDao.update(usuario);
        }
      }

      // Enviar usuários locais para o servidor
      for (var usuario in usuariosLocal) {
        if (usuario.id == null) {
          await _apiService.postUsuario(usuario);
        }
      }

      setState(() {
        _status = 'Usuários sincronizados com sucesso!';
      });
    } catch (e) {
      setState(() {
        _status = 'Erro ao sincronizar usuários: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _sincronizarTudo() async {
    setState(() {
      _isLoading = true;
      _status = 'Iniciando sincronização completa...';
    });

    try {
      await _sincronizarClientes();
      await _sincronizarProdutos();
      await _sincronizarPedidos();
      await _sincronizarUsuarios();

      setState(() {
        _status = 'Sincronização completa realizada com sucesso!';
      });
    } catch (e) {
      setState(() {
        _status = 'Erro na sincronização completa: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sincronização'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Status da Sincronização',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(_status),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _sincronizarTudo,
                    icon: const Icon(Icons.sync),
                    label: const Text('Sincronizar Tudo'),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Sincronização Individual',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _sincronizarClientes,
                    icon: const Icon(Icons.people),
                    label: const Text('Sincronizar Clientes'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _sincronizarProdutos,
                    icon: const Icon(Icons.inventory),
                    label: const Text('Sincronizar Produtos'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _sincronizarPedidos,
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text('Sincronizar Pedidos'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _sincronizarUsuarios,
                    icon: const Icon(Icons.person),
                    label: const Text('Sincronizar Usuários'),
                  ),
                ],
              ),
            ),
    );
  }
} 