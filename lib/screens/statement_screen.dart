import 'package:flutter/material.dart';
import '../services/api_service.dart';

class StatementScreen extends StatefulWidget {
  final String numeroConta;

  const StatementScreen({super.key, required this.numeroConta});

  @override
  _StatementScreenState createState() => _StatementScreenState();
}

class _StatementScreenState extends State<StatementScreen> {
  final ApiService _apiService = ApiService(
      'http://18.216.40.254:8080'); // Ajuste para ambiente de produção
  bool _isLoading = true;
  List<Map<String, dynamic>> _transacoes = [];
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
      final result = await _apiService.obterExtrato(widget.numeroConta);

      if (result != null) {
        if (result.containsKey('extrato')) {
          final data = result['extrato'];
          if (data is List) {
            setState(() {
              _transacoes = List<Map<String, dynamic>>.from(data);
            });
          } else {
            setState(() {
              _errorMessage = 'Formato de dados inválido.';
            });
          }
        } else {
          setState(() {
            _errorMessage = result['message'] ?? 'Erro desconhecido.';
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Nenhuma Movimentação Registrada';
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
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                : _transacoes.isEmpty
                    ? const Center(child: Text('Nenhuma transação encontrada'))
                    : ListView.builder(
                        itemCount: _transacoes.length,
                        itemBuilder: (context, index) {
                          final transacao = _transacoes[index];
                          final idContaRemetente =
                              transacao['idContaRemetente'] as int?;
                          final idContaDestinatario =
                              transacao['idContaDestinatario'] as int?;
                          final nomeOutroDestinatario =
                              transacao['nomeOutroUsuario'] as String?;
                          final valor = transacao['valor'] as double?;
                          final data = transacao['data'] as String? ??
                              'Data não disponível';
                          final tipoMovimento =
                              transacao['tipoMovimento'] as String?;

                          String descricao;
                          if (idContaRemetente != null &&
                              idContaRemetente.toString() ==
                                  widget.numeroConta) {
                            descricao = tipoMovimento == 'TRANSFERENCIA'
                                ? 'Transferência enviada para ${nomeOutroDestinatario ?? 'Desconhecido'}'
                                : 'Movimento: $tipoMovimento';
                          } else if (idContaDestinatario != null &&
                              idContaDestinatario.toString() ==
                                  widget.numeroConta) {
                            descricao = tipoMovimento == 'TRANSFERENCIA'
                                ? 'Transferência recebida de ${nomeOutroDestinatario ?? 'Desconhecido'}'
                                : 'Movimento: $tipoMovimento';
                          } else {
                            descricao = transacao['descricao'] ??
                                'Descrição não disponível';
                          }

                          return ListTile(
                            title: Text(descricao),
                            subtitle: Text(data),
                            trailing: Text(valor != null
                                ? 'R\$ ${valor.toStringAsFixed(2)}'
                                : 'Valor não disponível'),
                          );
                        },
                      ),
      ),
    );
  }
}
