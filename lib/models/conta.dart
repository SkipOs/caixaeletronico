class Conta {
  final String tipoConta;
  final String statusConta;
  final double valor;
  final String numeroConta;

  Conta({
    required this.tipoConta,
    required this.statusConta,
    required this.valor,
    required this.numeroConta,
  });

  factory Conta.fromJson(Map<String, dynamic> json) {
    return Conta(
      tipoConta: json['tipo'],
      statusConta: json['status'],
      valor: json['valor'],
      numeroConta: json['numero_conta'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tipo': tipoConta,
      'status': statusConta,
      'valor': valor,
      'numero_conta': numeroConta,
    };
  }
}
