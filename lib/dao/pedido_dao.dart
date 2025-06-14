import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../models/pedido.dart';
import '../models/pedido_item.dart' as item;
import '../models/pedido_pagamento.dart' as pagamento;

class PedidoDao {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> insert(Pedido pedido) async {
    final db = await _dbHelper.db;
    int pedidoId = 0;

    await db.transaction((txn) async {
      // Inserir pedido
      pedidoId = await txn.insert('pedidos', {
        'idCliente': pedido.idCliente,
        'idUsuario': pedido.idUsuario,
        'totalPedido': pedido.totalPedido,
        'ultimaAlteracao': pedido.ultimaAlteracao,
      });

      // Inserir itens
      for (var item in pedido.itens) {
        await txn.insert('pedido_itens', {
          'idPedido': pedidoId,
          'idProduto': item.idProduto,
          'quantidade': item.quantidade,
          'totalItem': item.totalItem,
        });
      }

      // Inserir pagamentos
      for (var pagamento in pedido.pagamentos) {
        await txn.insert('pedido_pagamentos', {
          'idPedido': pedidoId,
          'valor': pagamento.valor,
        });
      }
    });

    return pedidoId;
  }

  Future<int> update(Pedido pedido) async {
    final db = await _dbHelper.db;
    int result = 0;

    await db.transaction((txn) async {
      // Atualizar pedido
      result = await txn.update(
        'pedidos',
        {
          'idCliente': pedido.idCliente,
          'idUsuario': pedido.idUsuario,
          'totalPedido': pedido.totalPedido,
          'ultimaAlteracao': pedido.ultimaAlteracao,
        },
        where: 'id = ?',
        whereArgs: [pedido.id],
      );

      // Deletar itens e pagamentos antigos
      await txn.delete(
        'pedido_itens',
        where: 'idPedido = ?',
        whereArgs: [pedido.id],
      );
      await txn.delete(
        'pedido_pagamentos',
        where: 'idPedido = ?',
        whereArgs: [pedido.id],
      );

      // Inserir novos itens
      for (var item in pedido.itens) {
        await txn.insert('pedido_itens', {
          'idPedido': pedido.id,
          'idProduto': item.idProduto,
          'quantidade': item.quantidade,
          'totalItem': item.totalItem,
        });
      }

      // Inserir novos pagamentos
      for (var pagamento in pedido.pagamentos) {
        await txn.insert('pedido_pagamentos', {
          'idPedido': pedido.id,
          'valor': pagamento.valor,
        });
      }
    });

    return result;
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.db;
    int result = 0;

    await db.transaction((txn) async {
      // Deletar itens e pagamentos
      await txn.delete(
        'pedido_itens',
        where: 'idPedido = ?',
        whereArgs: [id],
      );
      await txn.delete(
        'pedido_pagamentos',
        where: 'idPedido = ?',
        whereArgs: [id],
      );

      // Deletar pedido
      result = await txn.delete(
        'pedidos',
        where: 'id = ?',
        whereArgs: [id],
      );
    });

    return result;
  }

  Future<Pedido?> getById(int id) async {
    final db = await _dbHelper.db;
    final List<Map<String, dynamic>> pedidoMaps = await db.query(
      'pedidos',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (pedidoMaps.isEmpty) return null;

    final pedidoMap = pedidoMaps.first;
    final List<Map<String, dynamic>> itemMaps = await db.query(
      'pedido_itens',
      where: 'idPedido = ?',
      whereArgs: [id],
    );
    final List<Map<String, dynamic>> pagamentoMaps = await db.query(
      'pedido_pagamentos',
      where: 'idPedido = ?',
      whereArgs: [id],
    );

    return Pedido(
      id: pedidoMap['id'] as int,
      idCliente: pedidoMap['idCliente'] as int,
      idUsuario: pedidoMap['idUsuario'] as int,
      totalPedido: pedidoMap['totalPedido'] as double,
      ultimaAlteracao: pedidoMap['ultimaAlteracao'] as String?,
      itens: itemMaps.map((map) => item.PedidoItem.fromJson(map)).toList(),
      pagamentos: pagamentoMaps.map((map) => pagamento.PedidoPagamento.fromJson(map)).toList(),
    );
  }

  Future<List<Pedido>> getAll() async {
    final db = await _dbHelper.db;
    final List<Map<String, dynamic>> pedidoMaps = await db.query('pedidos');
    List<Pedido> pedidos = [];

    for (var pedidoMap in pedidoMaps) {
      final id = pedidoMap['id'] as int;
      final List<Map<String, dynamic>> itemMaps = await db.query(
        'pedido_itens',
        where: 'idPedido = ?',
        whereArgs: [id],
      );
      final List<Map<String, dynamic>> pagamentoMaps = await db.query(
        'pedido_pagamentos',
        where: 'idPedido = ?',
        whereArgs: [id],
      );

      pedidos.add(Pedido(
        id: id,
        idCliente: pedidoMap['idCliente'] as int,
        idUsuario: pedidoMap['idUsuario'] as int,
        totalPedido: pedidoMap['totalPedido'] as double,
        ultimaAlteracao: pedidoMap['ultimaAlteracao'] as String?,
        itens: itemMaps.map((map) => item.PedidoItem.fromJson(map)).toList(),
        pagamentos: pagamentoMaps.map((map) => pagamento.PedidoPagamento.fromJson(map)).toList(),
      ));
    }

    return pedidos;
  }

  Future<List<Pedido>> getByCliente(int idCliente) async {
    final db = await _dbHelper.db;
    final List<Map<String, dynamic>> pedidoMaps = await db.query(
      'pedidos',
      where: 'idCliente = ?',
      whereArgs: [idCliente],
    );
    List<Pedido> pedidos = [];

    for (var pedidoMap in pedidoMaps) {
      final id = pedidoMap['id'] as int;
      final List<Map<String, dynamic>> itemMaps = await db.query(
        'pedido_itens',
        where: 'idPedido = ?',
        whereArgs: [id],
      );
      final List<Map<String, dynamic>> pagamentoMaps = await db.query(
        'pedido_pagamentos',
        where: 'idPedido = ?',
        whereArgs: [id],
      );

      pedidos.add(Pedido(
        id: id,
        idCliente: pedidoMap['idCliente'] as int,
        idUsuario: pedidoMap['idUsuario'] as int,
        totalPedido: pedidoMap['totalPedido'] as double,
        ultimaAlteracao: pedidoMap['ultimaAlteracao'] as String?,
        itens: itemMaps.map((map) => item.PedidoItem.fromJson(map)).toList(),
        pagamentos: pagamentoMaps.map((map) => pagamento.PedidoPagamento.fromJson(map)).toList(),
      ));
    }

    return pedidos;
  }
} 