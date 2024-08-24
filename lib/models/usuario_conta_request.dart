import 'usuario.dart';
import 'conta.dart';

class UsuarioContaRequest {
  final Usuario usuario;
  final Conta conta;

  UsuarioContaRequest({
    required this.usuario,
    required this.conta,
  });

  factory UsuarioContaRequest.fromJson(Map<String, dynamic> json) {
    return UsuarioContaRequest(
      usuario: Usuario.fromJson(json['usuario']),
      conta: Conta.fromJson(json['conta']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usuario': usuario.toJson(),
      'conta': conta.toJson(),
    };
  }
}
