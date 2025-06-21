import 'base_model.dart';

class Produto implements BaseModel {
  @override
  int? id;
  String nome;
  String unidade; // un, cx, kg, lt, ml
  double qtdEstoque;
  double precoVenda;
  int status; // 0 - Ativo / 1 - Inativo
  double? custo;
  String? codigoBarra;
  @override
  DateTime? ultimaAlteracao;

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
      status: json['status'] is String
          ? int.parse(json['status'])
          : json['status'],
      custo: json['custo']?.toDouble(),
      codigoBarra: json['codigoBarra'],
      ultimaAlteracao: json['ultimaAlteracao'] == null
          ? null
          : DateTime.parse(json['ultimaAlteracao']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'unidade': unidade,
      'qtdEstoque': qtdEstoque,
      'precoVenda': precoVenda,
      'status': status,
      'custo': custo,
      'codigoBarra': codigoBarra,
      'ultimaAlteracao': ultimaAlteracao?.toIso8601String(),
    };
  }
} 