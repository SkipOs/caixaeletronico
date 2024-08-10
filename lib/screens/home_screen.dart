import 'package:flutter/material.dart';
// Certifique-se de que a importação da tela de retirada esteja correta
import 'withdraw_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key})
      : super(key: key); // Adicionado o `Key? key` e `const`

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'), // `const` adicionado
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            title: const Text('View Balance'), // `const` adicionado
            onTap: () {
              // Navegar para a tela de saldo
            },
          ),
          ListTile(
            title: const Text('Withdraw'), // `const` adicionado
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const WithdrawalScreen(), // `const` adicionado
                ),
              );
            },
          ),
          // Outras ListTiles para as outras opções do menu
        ],
      ),
    );
  }
}
