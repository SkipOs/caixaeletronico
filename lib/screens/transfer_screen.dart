import 'package:flutter/material.dart';

class TransferScreen extends StatelessWidget {
  const TransferScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transferência'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: TransferForm(),
      ),
    );
  }
}

class TransferForm extends StatelessWidget {
  const TransferForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Saldo Atual: R\$ 12.123,98',
          style: TextStyle(fontSize: 24),
        ),
        const TextField(
          decoration: InputDecoration(labelText: 'Valor de Transferência'),
          keyboardType: TextInputType.number,
        ),
        const TextField(
          decoration: InputDecoration(labelText: 'Número da Conta de Destino'),
        ),
        const TextField(
          decoration: InputDecoration(labelText: 'Senha'),
          obscureText: true,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Realizar transferência
            Navigator.pop(context);
          },
          child: const Text('Realizar Transferência'),
        ),
      ],
    );
  }
}
