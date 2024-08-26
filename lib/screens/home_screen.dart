import 'package:flutter/material.dart';
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
  String _nome =
      'Nome do Usuário'; // Inicialmente vazio ou com algum placeholder
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchSaldo();
    _fetchNomeUsuario();
  }

  Future<void> _fetchNomeUsuario() async {
    try {
      final nomeUsuario =
          await _apiService.obterDetalhesUsuario(widget.numeroConta);

      if (nomeUsuario != null) {
        setState(() {
          _nome = nomeUsuario;
          _errorMessage = ''; // Limpar mensagens de erro, se houver
        });
      } else {
        setState(() {
          _errorMessage = 'Erro ao obter nome do usuário.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao conectar ao serviço: $e';
      });
    }
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

  @override
  Widget build(BuildContext context) {
    var saldoProvider = Provider.of<SaldoProvider>(context);
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
                            'Saldo: R\$ ${saldoProvider.saldoVisivel ? _saldo : '******,**'}',
                            style: const TextStyle(fontSize: 24),
                          ),
                          TextButton(
                            onPressed: () {
                              _fetchSaldo();
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
                crossAxisCount: 3,
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
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        minimumSize: const Size(80, 80),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: Colors.white),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }
}
