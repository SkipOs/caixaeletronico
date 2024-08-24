class TransferenciaRequest {
  final int idContaRemetente;
  final String numeroContaDestinatario;
  final double valorTransferencia;

  TransferenciaRequest({
    required this.idContaRemetente,
    required this.numeroContaDestinatario,
    required this.valorTransferencia,
  });

  factory TransferenciaRequest.fromJson(Map<String, dynamic> json) {
    return TransferenciaRequest(
      idContaRemetente: json['idContaRemetente'],
      numeroContaDestinatario: json['numeroContaDestinatario'],
      valorTransferencia: json['valorTransferencia'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idContaRemetente': idContaRemetente,
      'numeroContaDestinatario': numeroContaDestinatario,
      'valorTransferencia': valorTransferencia,
    };
  }
}
