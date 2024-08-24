import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/usuario_conta_request.dart';

class ApiService {
  final String _baseUrl;

  ApiService(this._baseUrl);

  Future<Map<String, dynamic>> login(
      String numeroConta, String nome, String senha) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'numeroConta': numeroConta, 'senha': senha}),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'data': json.decode(response.body)};
      } else {
        return {
          'success': false,
          'message': 'Login falhou: conta ou senha inválidos'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Erro ao conectar ao serviço: $e'};
    }
  }

  Future<Map<String, dynamic>> registerUser(UsuarioContaRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/usuario'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'data': json.decode(response.body)};
      } else {
        return {'success': false, 'message': 'Registro falhou'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Erro ao conectar ao serviço: $e'};
    }
  }

  Future<Map<String, dynamic>> getSaldo(String numeroConta) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/saldo?numeroConta=$numeroConta'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return {'success': true, 'data': json.decode(response.body)};
      } else {
        return {'success': false, 'message': 'Não foi possível obter o saldo'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Erro ao conectar ao serviço: $e'};
    }
  }

  Future<Map<String, dynamic>> getExtrato(String numeroConta) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/extrato?numeroConta=$numeroConta'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Falha ao carregar extrato');
    }
  }

  Future<Map<String, dynamic>> saque(String numeroConta, String valor) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/saque'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'numeroConta': numeroConta,
        'valor': valor,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Falha ao realizar saque');
    }
  }

  Future<Map<String, dynamic>> transferir(
    String numeroContaOrigem,
    String numeroContaDestino,
    String valor,
    String senha,
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/transferencia'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'numeroContaOrigem': numeroContaOrigem,
        'numeroContaDestino': numeroContaDestino,
        'valor': valor,
        'senha': senha,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Falha ao realizar transferência');
    }
  }

  Future<Map<String, dynamic>> deposito(
    String numeroConta,
    String valor,
    String senha,
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/deposito'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'numeroConta': numeroConta,
        'valor': valor,
        'senha': senha,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Falha ao realizar depósito');
    }
  }

  Future<Map<String, dynamic>> urubudopix(String qrCodeData) async {
    final decodedData = jsonDecode(qrCodeData);
    final response = await http.post(
      Uri.parse('$_baseUrl/transferencia'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'idContaRemetente': decodedData['idContaRemetente'],
        'numeroContaDestinatario': decodedData['numeroContaDestinatario'],
        'valorTransferencia': decodedData['amount'],
      }),
    );

    if (response.statusCode == 200) {
      return {'success': true, 'message': 'Pagamento realizado com sucesso!'};
    } else {
      return {'success': false, 'message': response.body};
    }
  }
}
