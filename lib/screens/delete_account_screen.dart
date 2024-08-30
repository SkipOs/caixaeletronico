import 'package:flutter/material.dart';
import '../services/api_service.dart';

class DeactivateAccountScreen extends StatefulWidget {
  final String numeroConta;

  const DeactivateAccountScreen({super.key, required this.numeroConta});

  @override
  _DeactivateAccountScreenState createState() => _DeactivateAccountScreenState();
}

class _DeactivateAccountScreenState extends State<DeactivateAccountScreen> {
  final TextEditingController _senhaController1 = TextEditingController();
  final TextEditingController _senhaController2 = TextEditingController();
  final ApiService _apiService = ApiService('http://18.216.40.254:8080');
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _senhaController1.dispose();
    _senhaController2.dispose();
    super.dispose();
  }

  Future<void> _handleDeactivateAccount() async {
  final senha1 = _senhaController1.text;
  final senha2 = _senhaController2.text;

  if (senha1.isEmpty || senha2.isEmpty) {
    setState(() {
      _errorMessage = 'Por favor, preencha todos os campos.';
    });
    return;
  }

  if (senha1 != senha2) {
    setState(() {
      _errorMessage = 'As senhas não coincidem. Tente novamente.';
    });
    return;
  }

  setState(() {
    _isLoading = true;
    _errorMessage = '';
  });

  try {
    // Chamar o método excluirConta com número da conta e senha
    final response = await _apiService.excluirConta({
      'numeroConta': widget.numeroConta,
      'senha': senha1
    });

    if (response?['message'] == 'Conta inativada com sucesso!') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Conta desativada com sucesso!')),
      );
      Navigator.of(context).pop();
      Navigator.pop(context); // Volta para a tela anterior após sucesso
      Navigator.pop(context);
    } else {
      setState(() {
        _errorMessage = response?['error'] ?? 'Erro Desconhecido';
      });
    }
  } catch (e) {
    setState(() {
      _errorMessage = 'Erro ao conectar ao serviço: $e';
    });
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Desativar Conta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _senhaController1,
              decoration: const InputDecoration(labelText: 'Digite sua Senha'),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _senhaController2,
              decoration: const InputDecoration(labelText: 'Confirme sua Senha'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _handleDeactivateAccount,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Desativar Conta'),
            ),
            if (_errorMessage.isNotEmpty) ...[
              const SizedBox(height: 16.0),
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
