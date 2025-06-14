import 'package:flutter/material.dart';
import '../models/produto.dart';
import '../dao/produto_dao.dart';

class CadastroProdutoScreen extends StatefulWidget {
  const CadastroProdutoScreen({super.key});

  @override
  State<CadastroProdutoScreen> createState() => _CadastroProdutoScreenState();
}

class _CadastroProdutoScreenState extends State<CadastroProdutoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _unidadeController = TextEditingController();
  final _qtdEstoqueController = TextEditingController();
  final _precoVendaController = TextEditingController();
  final _custoController = TextEditingController();
  final _codigoBarraController = TextEditingController();
  final _produtoDao = ProdutoDao();
  bool _isLoading = false;
  bool _isAtivo = true;

  @override
  void dispose() {
    _nomeController.dispose();
    _unidadeController.dispose();
    _qtdEstoqueController.dispose();
    _precoVendaController.dispose();
    _custoController.dispose();
    _codigoBarraController.dispose();
    super.dispose();
  }

  Future<void> _salvarProduto() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final produto = Produto(
          nome: _nomeController.text,
          unidade: _unidadeController.text,
          qtdEstoque: double.parse(_qtdEstoqueController.text),
          precoVenda: double.parse(_precoVendaController.text),
          status: _isAtivo ? 0 : 1,
          custo: _custoController.text.isNotEmpty
              ? double.parse(_custoController.text)
              : null,
          codigoBarra: _codigoBarraController.text.isNotEmpty
              ? _codigoBarraController.text
              : null,
        );

        await _produtoDao.insert(produto);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Produto salvo com sucesso'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao salvar produto: ${e.toString()}'),
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
        title: const Text('Novo Produto'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nomeController,
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira o nome';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _unidadeController,
                      decoration: const InputDecoration(
                        labelText: 'Unidade (un, cx, kg, lt, ml)',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira a unidade';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _qtdEstoqueController,
                      decoration: const InputDecoration(
                        labelText: 'Quantidade em Estoque',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira a quantidade';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Por favor, insira um número válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _precoVendaController,
                      decoration: const InputDecoration(
                        labelText: 'Preço de Venda',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira o preço';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Por favor, insira um número válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _custoController,
                      decoration: const InputDecoration(
                        labelText: 'Custo (opcional)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          if (double.tryParse(value) == null) {
                            return 'Por favor, insira um número válido';
                          }
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _codigoBarraController,
                      decoration: const InputDecoration(
                        labelText: 'Código de Barras (opcional)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('Produto Ativo'),
                      value: _isAtivo,
                      onChanged: (value) {
                        setState(() {
                          _isAtivo = value;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _salvarProduto,
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : const Text('Salvar'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
} 