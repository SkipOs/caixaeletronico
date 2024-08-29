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

  // Controladores para os campos de atualização
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfController = TextEditingController();
  final _dataNascimentoController = TextEditingController();

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
          _nome = usuario['nome'];
          _email = usuario['email'];
          _cpf = usuario['cpf'];
          _dataNascimento = usuario['dataNascimento'];

          // Atualiza os controladores com os valores existentes
          _nomeController.text = _nome ?? '';
          _emailController.text = _email ?? '';
          _cpfController.text = _cpf ?? '';
          _dataNascimentoController.text = _dataNascimento ?? '';
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

  Future<void> _atualizarPerfil() async {
    setState(() {
      _isLoading = true;
      _mensagemErro = null;
    });

    try {
      final resposta = await _apiService.atualizarPerfil({
        'numeroConta': widget.numeroConta,
        'nome': _nomeController.text,
        'email': _emailController.text,
        'cpf': _cpfController.text,
        'dataNascimento': _dataNascimentoController.text,
      });

      if (resposta == 'Perfil atualizado com sucesso!') {
        // Atualiza os detalhes do perfil
        _obterPerfilUsuario();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil atualizado com sucesso')),
        );
      } else {
        setState(() {
          _mensagemErro = resposta;
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

  void _mostrarDialogoMudancaSenha() {
  showDialog(
    context: context,
    builder: (context) {
      var _novaSenhaController = TextEditingController();
      var _confirmarSenhaController = TextEditingController();
      var _senhaAtualController = TextEditingController();

      return AlertDialog(
        title: const Text('Mudar Senha'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _senhaAtualController,
              decoration: const InputDecoration(labelText: 'Senha Atual'),
              obscureText: true,
            ),
            TextField(
              controller: _novaSenhaController,
              decoration: const InputDecoration(labelText: 'Nova Senha'),
              obscureText: true,
            ),
            TextField(
              controller: _confirmarSenhaController,
              decoration: const InputDecoration(labelText: 'Confirmar Nova Senha'),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (_novaSenhaController.text == _confirmarSenhaController.text) {
                try {
                  final resposta = await _apiService.atualizarSenhaUsuario({
                    'numeroConta': widget.numeroConta,
                    'senhaAtual': _senhaAtualController.text,
                    'novaSenha': _novaSenhaController.text,
                  });

                  if (resposta == 'Senha alterada com sucesso') {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Senha alterada com sucesso')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(resposta)),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao conectar ao serviço: $e')),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('As senhas não coincidem')),
                );
              }
            },
            child: const Text('Salvar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
        ],
      );
    },
  );
}


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
                  TextField(
                    controller: _nomeController,
                    decoration: const InputDecoration(labelText: 'Nome'),
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: _cpfController,
                    decoration: const InputDecoration(labelText: 'CPF'),
                  ),
                  TextField(
                    controller: _dataNascimentoController,
                    decoration: const InputDecoration(labelText: 'Data de Nascimento'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _atualizarPerfil,
                    child: const Text('Atualizar Informações'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _mostrarDialogoMudancaSenha,
                    child: const Text('Mudar Senha'),
                  ),
                ],
              ),
      ),
    );
  }
}
