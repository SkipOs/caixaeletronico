import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseURL;

  ApiService(this._baseURL);

  Future<Map<String, dynamic>?> cadastrarUsuarioConta(
      Map<String, dynamic> usuarioContaData) async {
    var url = Uri.parse('$_baseURL/usuario');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(usuarioContaData),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      print('Erro ao cadastrar usuário e conta: ${response.body}');
      return null;
    }
  }

  Future<int?> login(Map<String, dynamic> loginData) async {
    var url = Uri.parse('$_baseURL/login');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(loginData),
    );

    if (response.statusCode == 200) {
      // Se o login for bem-sucedido, retorna o idConta (número da conta)
      return int.parse(response.body);
    } else {
      // Exibe uma mensagem de erro adequada
      print('Erro ao logar: ${response.body}');
      return null;
    }
  }

  Future<bool> transferir(Map<String, dynamic> transferenciaData) async {
    var url = Uri.parse('$_baseURL/transferencia');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(transferenciaData),
    );

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      return responseData['success'] ?? true; // Ajuste se necessário
    } else {
      print('Erro ao transferir: ${response.body}');
      return false;
    }
  }

  Future<Map<String, dynamic>> transferirPix(
      Map<String, dynamic> transferenciaData) async {
    var url = Uri.parse('$_baseURL/transferencia');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(transferenciaData),
    );

    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      // Assumindo que o retorno é um objeto JSON sem colchetes
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      print('Erro ao transferir: ${response.body}');
      return {'success': false, 'message': 'Erro ao realizar transferência.'};
    }
  }

  Future<bool> realizarDeposito(Map<String, dynamic> depositoData) async {
    var url = Uri.parse('$_baseURL/deposito');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(depositoData),
    );

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      return responseData['success'] ?? true; // Ajuste se necessário
    } else {
      print('Erro ao realizar depósito: ${response.body}');
      return false;
    }
  }

  Future<Map<String, dynamic>> realizarSaque(
      Map<String, dynamic> saqueData) async {
    var url = Uri.parse('$_baseURL/saque');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(saqueData),
    );

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      return responseData; // Ajuste conforme o formato da resposta
    } else {
      print('Erro ao realizar saque: ${response.body}');
      return {'error': 'Erro ao realizar saque'};
    }
  }

  Future<Map<String, dynamic>?> consultarSaldo(int idConta) async {
    var url = Uri.parse('$_baseURL/saldo?idConta=$idConta');
    var response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      // Retorna null ou lança uma exceção dependendo de como você deseja lidar com erros
      return null;
    }
  }

  Future<String?> obterDetalhesUsuario(String numeroConta) async {
    var url = Uri.parse('$_baseURL/detalhes-usuario?numeroConta=$numeroConta');
    var response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body) as Map<String, dynamic>;
      return responseData['nome'] as String?;
    } else {
      print('Erro ao obter detalhes do usuário: ${response.body}');
      return null;
    }
  }

  Future<Map<String, dynamic>?> obterExtrato(String numeroConta) async {
    var url = Uri.parse('$_baseURL/extrato');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'numeroConta': numeroConta}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>?;
    } else {
      print('Erro ao obter extrato: ${response.body}');
      return null;
    }
  }

  Future<Map<String, dynamic>?> realizarPagamento(
      Map<String, dynamic> pagamentoData) async {
    var url = Uri.parse(
        '$_baseURL/pagamento'); // Criar endpoint específico se necessário
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(pagamentoData),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>?;
    } else {
      print('Erro ao realizar pagamento: ${response.body}');
      return {'success': false, 'message': 'Erro ao realizar pagamento.'};
    }
  }

  Future<String> atualizarUsuario(Map<String, dynamic> dadosAtualizacao) async {
    var url = Uri.parse('$_baseURL/atualizar');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(dadosAtualizacao),
    );

    if (response.statusCode == 200) {
      return 'Usuário atualizado com sucesso!';
    } else {
      print('Erro ao atualizar usuário: ${response.body}');
      return 'Erro ao atualizar usuário';
    }
  }

  Future<String> excluirConta(String numeroConta) async {
    var url = Uri.parse('$_baseURL/excluir');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'numeroConta': numeroConta}),
    );

    if (response.statusCode == 200) {
      return 'Conta excluída com sucesso!';
    } else {
      print('Erro ao excluir conta: ${response.body}');
      return 'Erro ao excluir conta';
    }
  }

  Future<Map<String, dynamic>?> obterPerfilUsuario(String numeroConta) async {
    var url = Uri.parse('$_baseURL/detalhes-usuario?numeroConta=$numeroConta');
    var response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      print('Erro ao obter detalhes do usuário: ${response.body}');
      return null;
    }
  }
}
