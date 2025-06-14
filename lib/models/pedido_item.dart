class PedidoItem {
  final int? id;
  final int idPedido;
  final int idProduto;
  final double quantidade;
  final double totalItem;

  PedidoItem({
    this.id,
    required this.idPedido,
    required this.idProduto,
    required this.quantidade,
    required this.totalItem,
  });

  factory PedidoItem.fromJson(Map<String, dynamic> json) {
    return PedidoItem(
      id: json['id'],
      idPedido: json['idPedido'],
      idProduto: json['idProduto'],
      quantidade: json['quantidade'].toDouble(),
      totalItem: json['totalItem'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idPedido': idPedido,
      'idProduto': idProduto,
      'quantidade': quantidade,
      'totalItem': totalItem,
    };
  }
} 