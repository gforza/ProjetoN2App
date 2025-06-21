import 'package:flutter/material.dart';
import '../models/pedido.dart';
import '../models/pedido_item.dart';
import '../models/pedido_pagamento.dart';
import '../models/cliente.dart';
import '../models/produto.dart';
import '../dao/pedido_dao.dart';
import '../dao/cliente_dao.dart';
import '../dao/produto_dao.dart';

class CadastroPedidoScreen extends StatefulWidget {
  const CadastroPedidoScreen({super.key});

  @override
  State<CadastroPedidoScreen> createState() => _CadastroPedidoScreenState();
}

class _CadastroPedidoScreenState extends State<CadastroPedidoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pedidoDao = PedidoDao();
  final _clienteDao = ClienteDao();
  final _produtoDao = ProdutoDao();
  bool _isLoading = false;

  Cliente? _clienteSelecionado;
  List<Cliente> _clientes = [];
  List<PedidoItem> _itens = [];
  List<PedidoPagamento> _pagamentos = [];
  double _totalPedido = 0.0;
  double _totalPago = 0.0;

  @override
  void initState() {
    super.initState();
    _carregarClientes();
  }

  Future<void> _carregarClientes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final clientes = await _clienteDao.getAll();
      if (mounted) {
        setState(() {
          _clientes = clientes;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar clientes: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _adicionarItem() async {
    try {
    final produtos = await _produtoDao.getAtivos();
      if (!mounted) return;

    if (produtos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não há produtos ativos disponíveis'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final produto = await showDialog<Produto>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Selecione um Produto'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: produtos.length,
            itemBuilder: (context, index) {
              final produto = produtos[index];
              return ListTile(
                title: Text(produto.nome),
                subtitle: Text('R\$ ${produto.precoVenda.toStringAsFixed(2)}'),
                onTap: () => Navigator.pop(context, produto),
              );
            },
          ),
        ),
      ),
    );

    if (produto != null) {
        final quantidadeController = TextEditingController();
      final quantidade = await showDialog<double>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Quantidade'),
          content: TextField(
              controller: quantidadeController,
            keyboardType: TextInputType.number,
              autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Quantidade',
              border: OutlineInputBorder(),
            ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  final valor = double.tryParse(quantidadeController.text);
                  if (valor != null && valor > 0) {
                    Navigator.pop(context, valor);
              }
            },
                child: const Text('Adicionar'),
          ),
            ],
        ),
      );

      if (quantidade != null) {
        setState(() {
          _itens.add(PedidoItem(
            idPedido: 0,
            idProduto: produto.id!,
            quantidade: quantidade,
            totalItem: quantidade * produto.precoVenda,
          ));
          _calcularTotal();
        });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao buscar produtos: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _adicionarPagamento() async {
    final valorController = TextEditingController();
    final valor = await showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Valor do Pagamento'),
        content: TextField(
          controller: valorController,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Valor',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              final valor = double.tryParse(valorController.text);
            if (valor != null && valor > 0) {
              Navigator.pop(context, valor);
            }
          },
            child: const Text('Adicionar'),
        ),
        ],
      ),
    );

    if (valor != null) {
      setState(() {
        _pagamentos.add(PedidoPagamento(
          idPedido: 0,
          valor: valor,
        ));
        _calcularTotalPago();
      });
    }
  }

  void _calcularTotal() {
    _totalPedido = _itens.fold(0, (sum, item) => sum + item.totalItem);
  }

  void _calcularTotalPago() {
    _totalPago = _pagamentos.fold(0, (sum, pagamento) => sum + pagamento.valor);
  }

  Future<void> _salvarPedido() async {
    if (_formKey.currentState!.validate()) {
      if (_clienteSelecionado == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Selecione um cliente'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (_itens.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Adicione pelo menos um item'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (_totalPago < _totalPedido) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('O valor pago é menor que o total do pedido'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        final pedido = Pedido(
          idCliente: _clienteSelecionado!.id!,
          idUsuario: 1, // TODO: Pegar ID do usuário logado
          totalPedido: _totalPedido,
          itens: _itens,
          pagamentos: _pagamentos,
          ultimaAlteracao: DateTime.now(),
        );

        await _pedidoDao.insert(pedido);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Pedido salvo com sucesso'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao salvar pedido: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Pedido'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16.0),
                      children: [
                        DropdownButtonFormField<Cliente>(
                              decoration: const InputDecoration(
                                labelText: 'Cliente',
                                border: OutlineInputBorder(),
                              ),
                              value: _clienteSelecionado,
                          items: _clientes.map((cliente) {
                                return DropdownMenuItem(
                                  value: cliente,
                                  child: Text(cliente.nome),
                                );
                              }).toList(),
                              onChanged: (cliente) {
                                setState(() {
                                  _clienteSelecionado = cliente;
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Selecione um cliente';
                                }
                                return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Itens do Pedido',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: _adicionarItem,
                                      icon: const Icon(Icons.add),
                                      label: const Text('Adicionar Item'),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                if (_itens.isEmpty)
                                  const Center(
                                    child: Text('Nenhum item adicionado'),
                                  )
                                else
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: _itens.length,
                                    itemBuilder: (context, index) {
                                      final item = _itens[index];
                                      return ListTile(
                                        title: FutureBuilder<Produto?>(
                                          future: _produtoDao.getById(item.idProduto),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return Text(snapshot.data!.nome);
                                            }
                                            return const Text('Carregando...');
                                          },
                                        ),
                                        subtitle: Text(
                                          '${item.quantidade} x R\$ ${(item.totalItem / item.quantidade).toStringAsFixed(2)} = R\$ ${item.totalItem.toStringAsFixed(2)}',
                                        ),
                                        trailing: IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () {
                                            setState(() {
                                              _itens.removeAt(index);
                                              _calcularTotal();
                                            });
                                          },
                                        ),
                                      );
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Pagamentos',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: _adicionarPagamento,
                                      icon: const Icon(Icons.add),
                                      label: const Text('Adicionar Pagamento'),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                if (_pagamentos.isEmpty)
                                  const Center(
                                    child: Text('Nenhum pagamento adicionado'),
                                  )
                                else
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: _pagamentos.length,
                                    itemBuilder: (context, index) {
                                      final pagamento = _pagamentos[index];
                                      return ListTile(
                                        title: Text('R\$ ${pagamento.valor.toStringAsFixed(2)}'),
                                        trailing: IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () {
                                            setState(() {
                                              _pagamentos.removeAt(index);
                                              _calcularTotalPago();
                                            });
                                          },
                                        ),
                                      );
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Resumo',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Total do Pedido:'),
                                    Text(
                                      'R\$ ${_totalPedido.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Total Pago:'),
                                    Text(
                                      'R\$ ${_totalPago.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Troco:'),
                                    Text(
                                      'R\$ ${(_totalPago - _totalPedido).toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _salvarPedido,
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : const Text('Salvar Pedido'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
} 