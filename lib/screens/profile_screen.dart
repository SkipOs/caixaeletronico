import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ProfileScreen extends StatefulWidget {
  final String numeroConta;

  const ProfileScreen({super.key, required this.numeroConta});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService _apiService = ApiService('http://18.216.40.254:8080');

  String? _nome;
  String? _email;
  String? _cpf;
  String? _dataNascimento;
  bool _isLoading = false;
  String? _mensagemErro;

  @override
  void initState() {
    super.initState();
    _obterPerfilUsuario();
  }

  Future<void> _obterPerfilUsuario() async {
    setState(() {
      _isLoading = true;
      _mensagemErro = null; // Resetando a mensagem de erro ao iniciar a busca
    });

    try {
      final usuario = await _apiService.obterPerfilUsuario(widget.numeroConta);

      if (usuario != null) {
        setState(() {
          _nome = usuario['nome'] ?? '';
          _email = usuario['email'] ?? '';
          _cpf = usuario['cpf'] ?? '';
          _dataNascimento = usuario['dataNascimento'] ?? '';
        });
      } else {
        setState(() {
          _mensagemErro = 'Erro ao obter detalhes do usuário';
        });
      }
    } catch (e) {
      setState(() {
        _mensagemErro = 'Erro ao conectar ao serviço: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _excluirConta() async {
    setState(() {
      _isLoading = true;
      _mensagemErro = null; // Resetando a mensagem de erro ao iniciar a exclusão
    });

    try {
      final mensagem = await _apiService.excluirConta(widget.numeroConta);

      setState(() {
        _mensagemErro = mensagem;
      });
    } catch (e) {
      setState(() {
        _mensagemErro = 'Erro ao excluir a conta: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  

 /* void _navegarParaAtualizacao() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AtualizacaoUsuarioScreen(numeroConta: widget.numeroConta)),
    );
  }

  void _navegarParaMudancaSenha() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MudancaSenhaScreen(numeroConta: widget.numeroConta)),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil do Usuário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_mensagemErro != null) ...[
                    Text(
                      _mensagemErro!,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 20),
                  ],
                  Text('Nome: ${_nome ?? 'Não disponível'}', style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 10),
                  Text('Email: ${_email ?? 'Não disponível'}', style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 10),
                  Text('CPF: ${_cpf ?? 'Não disponível'}', style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 10),
                  Text('Data de Nascimento: ${_dataNascimento ?? 'Não disponível'}', style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 20),
                  /*TextButton(
                    onPressed: _navegarParaAtualizacao,
                    child: const Text('Atualizar Informações'),
                  ),
                  TextButton(
                    onPressed: _navegarParaMudancaSenha,
                    child: const Text('Mudar Senha'),
                  ),*/
                  ElevatedButton(
                    onPressed: _excluirConta,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Excluir Conta'),
                  ),
                ],
              ),
      ),
    );
  }
}
