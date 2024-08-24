import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/api_service.dart';
import '../screens/statement_screen.dart';
import '../screens/withdraw_screen.dart';
import '../screens/transfer_screen.dart';
import '../screens/deposit_screen.dart';
import '../screens/pix_screen.dart';
import 'package:provider/provider.dart';
import '../services/saldo_provider.dart';

class HomeScreen extends StatefulWidget {
  final String numeroConta;

  const HomeScreen({super.key, required this.numeroConta});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService('http://localhost:8080');
  bool _isLoading = false;
  String _saldo = '';
  String _nome = 'Nome do Usuário';
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchSaldo();
    _fetchNome();
  }

  Future<void> _fetchSaldo() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final result = await _apiService.getSaldo(widget.numeroConta);

    setState(() {
      _isLoading = false;
      if (result['success']) {
        _saldo = result['valor'].toString();
      } else {
        _errorMessage = result['message'];
      }
    });
  }

  Future<void> _fetchNome() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://localhost:8080/usuario/nome?numeroConta=${widget.numeroConta}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _nome = data['nome'];
        });
      } else {
        setState(() {
          _errorMessage = 'Não foi possível obter o nome do usuário';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao conectar ao serviço: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final saldoProvider = Provider.of<SaldoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Bem-vindo, $_nome',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage.isNotEmpty
                    ? Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red),
                      )
                    : Column(
                        children: [
                          Text(
                            'Saldo: ${saldoProvider.saldoVisivel ? _saldo : '********'}',
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
                        ],
                      ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3, // Alterando para 3 colunas
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _buildMenuButton(
                    context,
                    Icons.receipt,
                    'Extrato',
                    StatementScreen(numeroConta: widget.numeroConta),
                  ),
                  _buildMenuButton(
                    context,
                    Icons.money_off,
                    'Saque',
                    WithdrawScreen(numeroConta: widget.numeroConta),
                  ),
                  _buildMenuButton(
                    context,
                    Icons.transfer_within_a_station,
                    'Transferência',
                    TransferScreen(numeroConta: widget.numeroConta),
                  ),
                  _buildMenuButton(
                    context,
                    Icons.add,
                    'Depósito',
                    DepositScreen(numeroConta: widget.numeroConta),
                  ),
                  _buildMenuButton(
                    context,
                    Icons.payment,
                    'PIX',
                    PixScreen(numeroConta: widget.numeroConta),
                  ),
                  // Você pode adicionar mais botões conforme necessário
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(
      BuildContext context, IconData icon, String label, Widget screen) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(
            vertical: 8.0, horizontal: 8.0), // Reduzindo o padding
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(8), // Bordas levemente arredondadas
        ),
        minimumSize: const Size(80, 80), // Tamanho mínimo menor
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: Colors.white), // Ícone menor
          const SizedBox(height: 4), // Reduzindo o espaçamento
          Text(label,
              style: const TextStyle(
                  color: Colors.white, fontSize: 12)), // Texto menor
        ],
      ),
    );
  }
}
