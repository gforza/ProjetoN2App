class Cliente {
  final int? id;
  final String nome;
  final String tipo; // F - Física / J - Jurídica
  final String cpfCnpj;
  final String? email;
  final String? telefone;
  final String? cep;
  final String? endereco;
  final String? bairro;
  final String? cidade;
  final String? uf;
  final String? ultimaAlteracao;

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
      ultimaAlteracao: json['ultimaAlteracao'],
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
      'ultimaAlteracao': ultimaAlteracao,
    };
  }
} 