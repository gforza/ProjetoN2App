import '../models/pedido.dart';
import '../models/pedido_item.dart' as item;
import '../models/pedido_pagamento.dart' as pagamento;
import '../services/database_service.dart';

class PedidoDao {
  final DatabaseService _dbService = DatabaseService();

  Future<int> insert(Pedido pedido) async {
    // Inserir pedido
    final pedidoId = await _dbService.insert('pedidos', {
      'idCliente': pedido.idCliente,
      'idUsuario': pedido.idUsuario,
      'totalPedido': pedido.totalPedido,
      'ultimaAlteracao': pedido.ultimaAlteracao?.toIso8601String(),
    });

    if (pedidoId > 0) {
      // Inserir itens
      for (var item in pedido.itens) {
        await _dbService.insert('pedido_itens', {
          'idPedido': pedidoId,
          'idProduto': item.idProduto,
          'quantidade': item.quantidade,
          'totalItem': item.totalItem,
        });
      }

      // Inserir pagamentos
      for (var pag in pedido.pagamentos) {
        await _dbService.insert('pedido_pagamentos', {
          'idPedido': pedidoId,
          'valor': pag.valor,
        });
      }
    }

    return pedidoId;
  }

  Future<int> update(Pedido pedido) async {
    if (pedido.id == null) return -1;

    // Atualizar pedido
    final result = await _dbService.update(
      'pedidos',
      {
        'idCliente': pedido.idCliente,
        'idUsuario': pedido.idUsuario,
        'totalPedido': pedido.totalPedido,
        'ultimaAlteracao': pedido.ultimaAlteracao?.toIso8601String(),
      },
      'id = ?',
      [pedido.id],
    );

    if (result > 0) {
      // Deletar itens e pagamentos antigos
      await _dbService.delete(
        'pedido_itens',
        'idPedido = ?',
        [pedido.id],
      );
      await _dbService.delete(
        'pedido_pagamentos',
        'idPedido = ?',
        [pedido.id],
      );

      // Inserir novos itens
      for (var item in pedido.itens) {
        await _dbService.insert('pedido_itens', {
          'idPedido': pedido.id,
          'idProduto': item.idProduto,
          'quantidade': item.quantidade,
          'totalItem': item.totalItem,
        });
      }

      // Inserir novos pagamentos
      for (var pag in pedido.pagamentos) {
        await _dbService.insert('pedido_pagamentos', {
          'idPedido': pedido.id,
          'valor': pag.valor,
        });
      }
    }

    return result;
  }

  Future<int> delete(int id) async {
    // Deletar itens e pagamentos
    await _dbService.delete(
      'pedido_itens',
      'idPedido = ?',
      [id],
    );
    await _dbService.delete(
      'pedido_pagamentos',
      'idPedido = ?',
      [id],
    );

    // Deletar pedido
    return await _dbService.delete(
      'pedidos',
      'id = ?',
      [id],
    );
  }

  Future<Pedido?> getById(int id) async {
    final List<Map<String, dynamic>> pedidoMaps = await _dbService.query(
      'pedidos',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (pedidoMaps.isEmpty) return null;

    final pedidoMap = pedidoMaps.first;
    final List<Map<String, dynamic>> itemMaps = await _dbService.query(
      'pedido_itens',
      where: 'idPedido = ?',
      whereArgs: [id],
    );
    final List<Map<String, dynamic>> pagamentoMaps = await _dbService.query(
      'pedido_pagamentos',
      where: 'idPedido = ?',
      whereArgs: [id],
    );

    return Pedido(
      id: pedidoMap['id'] as int,
      idCliente: pedidoMap['idCliente'] as int,
      idUsuario: pedidoMap['idUsuario'] as int,
      totalPedido: (pedidoMap['totalPedido'] as num).toDouble(),
      ultimaAlteracao: pedidoMap['ultimaAlteracao'] == null
          ? null
          : DateTime.parse(pedidoMap['ultimaAlteracao'] as String),
      itens: itemMaps.map((map) => item.PedidoItem.fromJson(map)).toList(),
      pagamentos: pagamentoMaps.map((map) => pagamento.PedidoPagamento.fromJson(map)).toList(),
    );
  }

  Future<List<Pedido>> getAll() async {
    final List<Map<String, dynamic>> pedidoMaps = await _dbService.query('pedidos');
    List<Pedido> pedidos = [];

    for (var pedidoMap in pedidoMaps) {
      final id = pedidoMap['id'] as int;
      final List<Map<String, dynamic>> itemMaps = await _dbService.query(
        'pedido_itens',
        where: 'idPedido = ?',
        whereArgs: [id],
      );
      final List<Map<String, dynamic>> pagamentoMaps = await _dbService.query(
        'pedido_pagamentos',
        where: 'idPedido = ?',
        whereArgs: [id],
      );

      pedidos.add(Pedido(
        id: id,
        idCliente: pedidoMap['idCliente'] as int,
        idUsuario: pedidoMap['idUsuario'] as int,
        totalPedido: (pedidoMap['totalPedido'] as num).toDouble(),
        ultimaAlteracao: pedidoMap['ultimaAlteracao'] == null
            ? null
            : DateTime.parse(pedidoMap['ultimaAlteracao'] as String),
        itens: itemMaps.map((map) => item.PedidoItem.fromJson(map)).toList(),
        pagamentos: pagamentoMaps.map((map) => pagamento.PedidoPagamento.fromJson(map)).toList(),
      ));
    }

    return pedidos;
  }

  Future<List<Pedido>> getByCliente(int idCliente) async {
    final List<Map<String, dynamic>> pedidoMaps = await _dbService.query(
      'pedidos',
      where: 'idCliente = ?',
      whereArgs: [idCliente],
    );
    List<Pedido> pedidos = [];

    for (var pedidoMap in pedidoMaps) {
      final id = pedidoMap['id'] as int;
      final List<Map<String, dynamic>> itemMaps = await _dbService.query(
        'pedido_itens',
        where: 'idPedido = ?',
        whereArgs: [id],
      );
      final List<Map<String, dynamic>> pagamentoMaps = await _dbService.query(
        'pedido_pagamentos',
        where: 'idPedido = ?',
        whereArgs: [id],
      );

      pedidos.add(Pedido(
        id: id,
        idCliente: pedidoMap['idCliente'] as int,
        idUsuario: pedidoMap['idUsuario'] as int,
        totalPedido: (pedidoMap['totalPedido'] as num).toDouble(),
        ultimaAlteracao: pedidoMap['ultimaAlteracao'] == null
            ? null
            : DateTime.parse(pedidoMap['ultimaAlteracao'] as String),
        itens: itemMaps.map((map) => item.PedidoItem.fromJson(map)).toList(),
        pagamentos: pagamentoMaps.map((map) => pagamento.PedidoPagamento.fromJson(map)).toList(),
      ));
    }

    return pedidos;
  }
} 