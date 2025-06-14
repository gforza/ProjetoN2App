class PedidoPagamento {
  final int? id;
  final int idPedido;
  final double valor;

  PedidoPagamento({
    this.id,
    required this.idPedido,
    required this.valor,
  });

  factory PedidoPagamento.fromJson(Map<String, dynamic> json) {
    return PedidoPagamento(
      id: json['id'],
      idPedido: json['idPedido'],
      valor: json['valor'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idPedido': idPedido,
      'valor': valor,
    };
  }
} 