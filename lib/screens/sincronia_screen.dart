import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../services/api_service.dart';
import '../dao/cliente_dao.dart';
import '../dao/produto_dao.dart';
import '../dao/pedido_dao.dart';
import '../dao/usuario_dao.dart';
import '../models/cliente.dart';
import '../models/produto.dart';
import '../models/pedido.dart';
import '../models/usuario.dart';
import '../models/base_model.dart';

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
  final _storageService = StorageService();
  bool _isLoading = false;
  String _status = '';

  @override
  void initState() {
    super.initState();
    _carregarConfiguracoes();
  }

  Future<void> _carregarConfiguracoes() async {
    final url = await _storageService.loadString('api_url');
    _apiService = ApiService(baseUrl: url);
  }

  Future<void> _sincronizarEntidade<T extends BaseModel>({
    required Future<List<T>> Function() getFromApi,
    required Future<List<T>> Function() getFromLocal,
    required Future<T?> Function(int) getLocalById,
    required Future<int> Function(T) insertLocal,
    required Future<int> Function(T) updateLocal,
    required Future<void> Function(T) postToApi,
    required String nomeEntidade,
  }) async {
    setState(() {
      _isLoading = true;
      _status = 'Sincronizando $nomeEntidade...';
    });

    try {
      // 1. Buscar dados do servidor e locais
      final itensApi = await getFromApi();
      final itensLocal = await getFromLocal();

      // 2. Atualizar/Inserir dados locais a partir da API
      for (final itemApi in itensApi) {
        final itemLocal = itemApi.id != null ? await getLocalById(itemApi.id!) : null;

        if (itemLocal == null) {
          // Item existe na API mas não localmente, então insere
          await insertLocal(itemApi);
        } else {
          // Item existe em ambos, verifica qual é o mais recente
          final dtApi = itemApi.ultimaAlteracao ?? DateTime(1970);
          final dtLocal = itemLocal.ultimaAlteracao ?? DateTime(1970);
          if (dtApi.isAfter(dtLocal)) {
            await updateLocal(itemApi);
          }
        }
      }

      // 3. Enviar dados locais novos para a API
      for (final itemLocal in itensLocal) {
        if (itemLocal.id == null) {
          await postToApi(itemLocal);
        }
      }

      setState(() {
        _status = '$nomeEntidade sincronizados com sucesso!';
      });
    } catch (e) {
      setState(() {
        _status = 'Erro ao sincronizar $nomeEntidade: ${e.toString()}';
      });
    }
  }

  Future<void> _sincronizarClientes() async {
    await _sincronizarEntidade<Cliente>(
      getFromApi: _apiService.getClientes,
      getFromLocal: _clienteDao.getAll,
      getLocalById: _clienteDao.getById,
      insertLocal: _clienteDao.insert,
      updateLocal: _clienteDao.update,
      postToApi: _apiService.postCliente,
      nomeEntidade: 'Clientes',
    );
  }

  Future<void> _sincronizarProdutos() async {
    await _sincronizarEntidade<Produto>(
      getFromApi: _apiService.getProdutos,
      getFromLocal: _produtoDao.getAll,
      getLocalById: _produtoDao.getById,
      insertLocal: _produtoDao.insert,
      updateLocal: _produtoDao.update,
      postToApi: _apiService.postProduto,
      nomeEntidade: 'Produtos',
    );
  }

  Future<void> _sincronizarPedidos() async {
    await _sincronizarEntidade<Pedido>(
      getFromApi: _apiService.getPedidos,
      getFromLocal: _pedidoDao.getAll,
      getLocalById: _pedidoDao.getById,
      insertLocal: _pedidoDao.insert,
      updateLocal: _pedidoDao.update,
      postToApi: _apiService.postPedido,
      nomeEntidade: 'Pedidos',
    );
  }

  Future<void> _sincronizarUsuarios() async {
    await _sincronizarEntidade<Usuario>(
      getFromApi: _apiService.getUsuarios,
      getFromLocal: _usuarioDao.getAll,
      getLocalById: _usuarioDao.getById,
      insertLocal: _usuarioDao.insert,
      updateLocal: _usuarioDao.update,
      postToApi: _apiService.postUsuario,
      nomeEntidade: 'Usuários',
    );
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