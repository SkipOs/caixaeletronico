import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/api_service.dart';
import 'package:provider/provider.dart';
import '../services/saldo_provider.dart';

class WithdrawScreen extends StatefulWidget {
  final String numeroConta;

  const WithdrawScreen({super.key, required this.numeroConta});

  @override
  _WithdrawScreenState createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final TextEditingController _valorController = TextEditingController();
  final ApiService _apiService =
      ApiService('http://localhost:8080'); // Ajuste para ambiente de produção
  bool _isLoading = false;
  String _saldo = '';
  String _errorMessage = '';

  @override
  void dispose() {
    _valorController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchSaldo();
  }

  Future<void> _fetchSaldo() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      var saldoResponse =
          await _apiService.consultarSaldo(int.parse(widget.numeroConta));

      if (saldoResponse != null && saldoResponse.containsKey('saldo')) {
        setState(() {
          _saldo = saldoResponse['saldo'].toString();
          _errorMessage = '';
        });
      } else {
        setState(() {
          _errorMessage = 'Erro ao obter saldo.';
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

  Future<void> _handleWithdraw() async {
    final valor = _valorController.text;
    final valorDouble = double.tryParse(valor);

    if (valor.isEmpty || valorDouble == null || valorDouble <= 0) {
      setState(() {
        _errorMessage = 'Por favor, insira um valor válido para o saque.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _fetchSaldo();
    });

    try {
      var result = await _apiService.realizarSaque({
        'idConta': widget.numeroConta,
        'valorSaque': valorDouble,
      });

      if (result.containsKey('error')) {
        setState(() {
          _errorMessage = result['error'];
        });
      } else {
        // Assume que o resultado é um Map com notas e quantidades
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Saque realizado com sucesso!')),
        );
        _valorController.clear();
        _fetchSaldo();
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
    final saldoProvider = Provider.of<SaldoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saque'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Saldo: R\$ ${saldoProvider.saldoVisivel ? _saldo : '******,**'}',
              style: const TextStyle(fontSize: 24),
            ),
            TextButton(
              onPressed: () {
                saldoProvider.toggleSaldoVisibility();
              },
              child: Text(saldoProvider.saldoVisivel
                  ? 'Esconder Saldo'
                  : 'Mostrar Saldo'),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _valorController,
              decoration: const InputDecoration(
                labelText: 'Valor',
                hintText: 'Insira o valor do saque',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
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
