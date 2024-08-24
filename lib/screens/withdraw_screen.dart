import 'package:flutter/material.dart';
import '../services/api_service.dart';

class WithdrawScreen extends StatefulWidget {
  final String numeroConta;

  const WithdrawScreen({super.key, required this.numeroConta});

  @override
  _WithdrawScreenState createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final TextEditingController _valorController = TextEditingController();
  final ApiService _apiService = ApiService('http://localhost:8080');
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _valorController.dispose();
    super.dispose();
  }

  Future<void> _handleWithdraw() async {
    final valor = _valorController.text;
    if (valor.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor, insira o valor do saque.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final result = await _apiService.saque(widget.numeroConta, valor);

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Saque realizado com sucesso!')),
        );
        _valorController.clear();
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
        title: const Text('Saque'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _valorController,
              decoration: const InputDecoration(
                labelText: 'Valor',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: const [
                // Adicione formatação se necessário
              ],
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _isLoading ? null : _handleWithdraw,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Saque'),
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
