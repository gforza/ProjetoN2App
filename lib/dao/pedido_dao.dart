import '../models/pedido.dart';
import '../models/pedido_item.dart';
import '../models/pedido_pagamento.dart';
import '../services/database_service.dart';

class PedidoDao {
  final DatabaseService _dbService = DatabaseService();

  Future<int> insert(Pedido pedido) async {
    final id = await _dbService.insert('pedidos', pedido.toJson());
    pedido.id = id;

    for (var item in pedido.itens) {
      item.idPedido = id;
      await _dbService.insert('pedido_itens', item.toJson());
    }

    for (var pag in pedido.pagamentos) {
      pag.idPedido = id;
      await _dbService.insert('pedido_pagamentos', pag.toJson());
    }
    return id;
  }

  Future<int> update(Pedido pedido) async {
    final result = await _dbService.update(
      'pedidos',
      pedido.toJson(),
      where: 'id = ?',
      whereArgs: [pedido.id.toString()],
    );

    await _dbService.delete(
      'pedido_itens',
      where: 'idPedido = ?',
      whereArgs: [pedido.id.toString()],
    );
    await _dbService.delete(
      'pedido_pagamentos',
      where: 'idPedido = ?',
      whereArgs: [pedido.id.toString()],
    );

    for (var item in pedido.itens) {
      item.idPedido = pedido.id!;
      await _dbService.insert('pedido_itens', item.toJson());
    }

    for (var pag in pedido.pagamentos) {
      pag.idPedido = pedido.id!;
      await _dbService.insert('pedido_pagamentos', pag.toJson());
    }

    return result;
  }

  Future<int> delete(int id) async {
    await _dbService.delete(
      'pedido_itens',
      where: 'idPedido = ?',
      whereArgs: [id.toString()],
    );
    await _dbService.delete(
      'pedido_pagamentos',
      where: 'idPedido = ?',
      whereArgs: [id.toString()],
    );
    return await _dbService.delete(
      'pedidos',
      where: 'id = ?',
      whereArgs: [id.toString()],
    );
  }

  Future<Pedido?> getById(int id) async {
    final List<Map<String, dynamic>> maps = await _dbService.query(
      'pedidos',
      where: 'id = ?',
      whereArgs: [id.toString()],
    );

    if (maps.isNotEmpty) {
      final pedido = Pedido.fromJson(maps.first);
      pedido.itens = await getItensPedido(id);
      pedido.pagamentos = await getPagamentosPedido(id);
      return pedido;
    }
    return null;
  }

  Future<List<Pedido>> getAll() async {
    final List<Map<String, dynamic>> maps = await _dbService.query('pedidos');
    List<Pedido> pedidos = [];
    for (var map in maps) {
      Pedido pedido = Pedido.fromJson(map);
      pedido.itens = await getItensPedido(pedido.id!);
      pedido.pagamentos = await getPagamentosPedido(pedido.id!);
      pedidos.add(pedido);
    }
    return pedidos;
  }

  Future<List<PedidoItem>> getItensPedido(int idPedido) async {
    final List<Map<String, dynamic>> maps = await _dbService.query(
      'pedido_itens',
      where: 'idPedido = ?',
      whereArgs: [idPedido.toString()],
    );
    return List.generate(maps.length, (i) {
      return PedidoItem.fromJson(maps[i]);
    });
  }

  Future<List<PedidoPagamento>> getPagamentosPedido(int idPedido) async {
    final List<Map<String, dynamic>> maps = await _dbService.query(
      'pedido_pagamentos',
      where: 'idPedido = ?',
      whereArgs: [idPedido.toString()],
    );
    return List.generate(maps.length, (i) {
      return PedidoPagamento.fromJson(maps[i]);
    });
  }
} 