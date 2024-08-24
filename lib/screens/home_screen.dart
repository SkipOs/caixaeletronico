import 'package:flutter/material.dart';
// Certifique-se de importar todas as telas corretamente
import 'withdraw_screen.dart';
import 'deposit_screen.dart';
import 'transfer_screen.dart';
import 'statement_screen.dart';/*
import 'pix_screen.dart';
import 'update_profile_screen.dart';
import 'delete_account_screen.dart';*/
import 'balance_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
           title: const Text('Ver Saldo'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BalanceScreen(currentBalance: 12123.98), // Passando um saldo fictício
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Saque'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WithdrawalScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Depósito'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DepositScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Transferência'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TransferScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Extrato'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StatementScreen(),
                ),
              );
            },
          ),/*
          ListTile(
            title: const Text('Pix'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PixScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Atualizar Perfil'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UpdateProfileScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Excluir Conta'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DeleteAccountScreen(),
                ),
              );
            },
          ),*/
        ],
      ),
    );
  }
}
