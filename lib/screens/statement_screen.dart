import 'package:flutter/material.dart';

class StatementScreen extends StatelessWidget {
  const StatementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Extrato'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: StatementList(),
      ),
    );
  }
}

class StatementList extends StatelessWidget {
  const StatementList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ListTile(
          title: Text('Transferência para a conta 121****-1'),
          subtitle: Text('20/07 - R\$ -15,00'),
        ),
        ListTile(
          title: Text('Depósito'),
          subtitle: Text('19/07 - R\$ +315,00'),
        ),
        ListTile(
          title: Text('Saque'),
          subtitle: Text('18/07 - R\$ -20,00'),
        ),
        // Adicionar mais transações conforme necessário
      ],
    );
  }
}
