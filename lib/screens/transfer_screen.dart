import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/api_service.dart';
import 'package:provider/provider.dart';
import '../services/saldo_provider.dart';

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
  final ApiService _apiService = ApiService(
      'http://18.216.40.254:8080'); // Ajuste para ambiente de produção
  bool _isLoading = false;
  String _saldo = '';
  String _errorMessage = '';

  @override
  void dispose() {
    _valorController.dispose();
    _contaDestinoController.dispose();
    _senhaController.dispose();
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

  Future<void> _handleTransfer() async {
    final valor = _valorController.text;
    final contaDestino = _contaDestinoController.text;
    final senha = _senhaController.text;
    final valorDouble = double.tryParse(valor);

    if (valor.isEmpty ||
        contaDestino.isEmpty ||
        senha.isEmpty ||
        valorDouble == null ||
        valorDouble <= 0) {
      setState(() {
        _errorMessage =
            'Por favor, preencha todos os campos com valores válidos.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final transferenciaData = {
        'idContaRemetente': widget.numeroConta,
        'numeroContaDestinatario': contaDestino,
        'valorTransferencia': valorDouble,
        'senha': senha,
      };

      final bool success = await _apiService.transferir(transferenciaData);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transferência realizada com sucesso!')),
        );
        _valorController.clear();
        _contaDestinoController.clear();
        _senhaController.clear();
        _fetchSaldo();
      } else {
        setState(() {
          _errorMessage =
              'Erro ao realizar a transferência. Verifique os dados e tente novamente.';
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
    var saldoProvider = Provider.of<SaldoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transferência'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Saldo Atual: R\$ ${saldoProvider.saldoVisivel ? _saldo : '******,**'}',
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
                labelText: 'Valor de Transferência',
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
            ),
            TextField(
              controller: _contaDestinoController,
              decoration: const InputDecoration(
                labelText: 'Número da Conta de Destino',
              ),
            ),
            TextField(
              controller: _senhaController,
              decoration: const InputDecoration(
                labelText: 'Senha',
              ),
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
