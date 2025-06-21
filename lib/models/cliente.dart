import 'base_model.dart';

class Cliente implements BaseModel {
  @override
  int? id;
  String nome;
  String tipo; // F - Física / J - Jurídica
  String cpfCnpj;
  String? email;
  String? telefone;
  String? cep;
  String? endereco;
  String? bairro;
  String? cidade;
  String? uf;
  @override
  DateTime? ultimaAlteracao;

  Cliente({
    this.id,
    required this.nome,
    required this.tipo,
    required this.cpfCnpj,
    this.email,
    this.telefone,
    this.cep,
    this.endereco,
    this.bairro,
    this.cidade,
    this.uf,
    this.ultimaAlteracao,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'],
      nome: json['nome'],
      tipo: json['tipo'],
      cpfCnpj: json['cpfCnpj'],
      email: json['email'],
      telefone: json['telefone'],
      cep: json['cep'],
      endereco: json['endereco'],
      bairro: json['bairro'],
      cidade: json['cidade'],
      uf: json['uf'],
      ultimaAlteracao: json['ultimaAlteracao'] == null
          ? null
          : DateTime.parse(json['ultimaAlteracao']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'tipo': tipo,
      'cpfCnpj': cpfCnpj,
      'email': email,
      'telefone': telefone,
      'cep': cep,
      'endereco': endereco,
      'bairro': bairro,
      'cidade': cidade,
      'uf': uf,
      'ultimaAlteracao': ultimaAlteracao?.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Cliente && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
} 