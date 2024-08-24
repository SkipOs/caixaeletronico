import 'package:flutter/material.dart';
import '../services/api_service.dart';

class TransferScreen extends StatefulWidget {
  final String numeroConta;

  const TransferScreen({super.key, required this.numeroConta});

  @override
  _TransferScreenState createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final TextEditingController _valorController = TextEditingController();
  final TextEditingController _contaDestinoController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final ApiService _apiService = ApiService('http://localhost:8080');
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _valorController.dispose();
    _contaDestinoController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _handleTransfer() async {
    final valor = _valorController.text;
    final contaDestino = _contaDestinoController.text;
    final senha = _senhaController.text;

    if (valor.isEmpty || contaDestino.isEmpty || senha.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor, preencha todos os campos.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final result = await _apiService.transferir(
        widget.numeroConta,
        contaDestino,
        valor,
        senha,
      );

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transferência realizada com sucesso!')),
        );
        _valorController.clear();
        _contaDestinoController.clear();
        _senhaController.clear();
        Navigator.pop(context);
      } else {
        setState(() {
          _errorMessage = result['message'];
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
        title: const Text('Transferência'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Saldo Atual: R\$ 12.123,98', // Este valor deve ser obtido dinamicamente se possível
              style: TextStyle(fontSize: 24),
            ),
            TextField(
              controller: _valorController,
              decoration:
                  const InputDecoration(labelText: 'Valor de Transferência'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _contaDestinoController,
              decoration: const InputDecoration(
                  labelText: 'Número da Conta de Destino'),
            ),
            TextField(
              controller: _senhaController,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _handleTransfer,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Realizar Transferência'),
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
