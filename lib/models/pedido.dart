import 'base_model.dart';
import 'pedido_item.dart';
import 'pedido_pagamento.dart';

class Pedido implements BaseModel {
  @override
  int? id;
  int idCliente;
  int idUsuario;
  double totalPedido;
  @override
  DateTime? ultimaAlteracao;
  List<PedidoItem> itens;
  List<PedidoPagamento> pagamentos;

  Pedido({
    this.id,
    required this.idCliente,
    required this.idUsuario,
    required this.totalPedido,
    this.ultimaAlteracao,
    required this.itens,
    required this.pagamentos,
  });

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      id: json['id'],
      idCliente: json['idCliente'],
      idUsuario: json['idUsuario'],
      totalPedido: json['totalPedido'].toDouble(),
      ultimaAlteracao: json['ultimaAlteracao'] == null
          ? null
          : DateTime.parse(json['ultimaAlteracao']),
      itens: (json['itens'] as List)
          .map((item) => PedidoItem.fromJson(item))
          .toList(),
      pagamentos: (json['pagamentos'] as List)
          .map((pagamento) => PedidoPagamento.fromJson(pagamento))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idCliente': idCliente,
      'idUsuario': idUsuario,
      'totalPedido': totalPedido,
      'ultimaAlteracao': ultimaAlteracao?.toIso8601String(),
      'itens': itens.map((item) => item.toJson()).toList(),
      'pagamentos': pagamentos.map((pagamento) => pagamento.toJson()).toList(),
    };
  }
} 