class Produto {
  final int? id;
  final String nome;
  final String unidade; // un, cx, kg, lt, ml
  final double qtdEstoque;
  final double precoVenda;
  final int status; // 0 - Ativo / 1 - Inativo
  final double? custo;
  final String? codigoBarra;
  final String? ultimaAlteracao;

  Produto({
    this.id,
    required this.nome,
    required this.unidade,
    required this.qtdEstoque,
    required this.precoVenda,
    required this.status,
    this.custo,
    this.codigoBarra,
    this.ultimaAlteracao,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'],
      nome: json['nome'],
      unidade: json['unidade'],
      qtdEstoque: json['qtdEstoque'].toDouble(),
      precoVenda: json['precoVenda'].toDouble(),
      status: json['Status'],
      custo: json['custo']?.toDouble(),
      codigoBarra: json['codigoBarra'],
      ultimaAlteracao: json['ultimaAlteracao'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'unidade': unidade,
      'qtdEstoque': qtdEstoque,
      'precoVenda': precoVenda,
      'Status': status,
      'custo': custo,
      'codigoBarra': codigoBarra,
      'ultimaAlteracao': ultimaAlteracao,
    };
  }
} 