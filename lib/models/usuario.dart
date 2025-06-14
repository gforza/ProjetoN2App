class Usuario {
  final int? id;
  final String nome;
  final String senha;
  final String? ultimaAlteracao;

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
      ultimaAlteracao: json['ultimaAlteracao'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'senha': senha,
      'ultimaAlteracao': ultimaAlteracao,
    };
  }
} 