import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/transferencia_request.dart';
import '../models/usuario_conta_request.dart';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<String> registerUser(UsuarioContaRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/usuario'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(request.toJson()),
    );
    return response.body;
  }

  Future<http.Response> login(String numeroConta, String nome, String senha) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),  // Corrigido para o endpoint correto
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'numeroConta': numeroConta, 'nome': nome, 'senha': senha}),
    );
    return response;
  }

  Future<String> transferir(TransferenciaRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/transferencia'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(request.toJson()),
    );
    return response.body;
  }
}
