import 'package:flutter/material.dart';

class PixScreen extends StatelessWidget {
  const PixScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pix'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: PixForm(),
      ),
    );
  }
}

class PixForm extends StatelessWidget {
  const PixForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Saldo Atual: R\$ *****,**',
          style: TextStyle(fontSize: 24),
        ),
        ElevatedButton(
          onPressed: () {
            // Enviar Pix
          },
          child: const Text('Enviar'),
        ),
        ElevatedButton(
          onPressed: () {
            // Receber Pix
          },
          child: const Text('Receber'),
        ),
      ],
    );
  }
}
