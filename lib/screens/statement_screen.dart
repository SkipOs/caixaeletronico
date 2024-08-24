import 'package:flutter/material.dart';
import '../services/api_service.dart';

class StatementScreen extends StatefulWidget {
  final String numeroConta;

  const StatementScreen({super.key, required this.numeroConta});

  @override
  _StatementScreenState createState() => _StatementScreenState();
}

class _StatementScreenState extends State<StatementScreen> {
  final ApiService _apiService = ApiService('http://localhost:8080');
  bool _isLoading = true;
  List<Map<String, String>> _transacoes = [];
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchTransacoes();
  }

  Future<void> _fetchTransacoes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final result = await _apiService.getExtrato(widget.numeroConta);

      if (result['success']) {
        setState(() {
          _transacoes = List<Map<String, String>>.from(result['data']);
        });
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
        title: const Text('Extrato'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage.isNotEmpty
                ? Center(
                    child: Text(_errorMessage,
                        style: const TextStyle(color: Colors.red)))
                : _transacoes.isEmpty
                    ? const Center(child: Text('Nenhuma transação encontrada'))
                    : ListView.builder(
                        itemCount: _transacoes.length,
                        itemBuilder: (context, index) {
                          final transacao = _transacoes[index];
                          return ListTile(
                            title: Text(transacao['descricao'] ??
                                'Descrição não disponível'),
                            subtitle: Text(
                                transacao['data'] ?? 'Data não disponível'),
                            trailing: Text(
                                transacao['valor'] ?? 'Valor não disponível'),
                          );
                        },
                      ),
      ),
    );
  }
}
