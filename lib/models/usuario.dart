import 'base_model.dart';

class Usuario implements BaseModel {
  @override
  int? id;
  String nome;
  String senha;
  @override
  DateTime? ultimaAlteracao;

  Usuario({
    this.id,
    required this.nome,
    required this.senha,
    this.ultimaAlteracao,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nome: json['nome'],
      senha: json['senha'],
      ultimaAlteracao: json['ultimaAlteracao'] == null
          ? null
          : DateTime.parse(json['ultimaAlteracao']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'senha': senha,
      'ultimaAlteracao': ultimaAlteracao?.toIso8601String(),
    };
  }
} 