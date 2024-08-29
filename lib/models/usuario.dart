class Usuario {
  final String nome;
  final String senha;
  final int idConta;
  final double salario;

  Usuario({
    required this.nome,
    required this.senha,
    required this.idConta,
    required this.salario,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      nome: json['nome'],
      senha: json['senha'],
      idConta: json['id_conta'],
      salario: json['salario'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'senha': senha,
      'id_conta': idConta,
      'salario': salario,
    };
  }
}
