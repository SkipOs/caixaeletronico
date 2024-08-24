import 'package:flutter/material.dart';

class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atualizar Perfil'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: UpdateProfileForm(),
      ),
    );
  }
}

class UpdateProfileForm extends StatelessWidget {
  const UpdateProfileForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TextField(
          decoration: InputDecoration(labelText: 'Nome'),
        ),
        const TextField(
          decoration: InputDecoration(labelText: 'E-mail'),
        ),
        const TextField(
          decoration: InputDecoration(labelText: 'Senha Atual'),
          obscureText: true,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Atualizar perfil
          },
          child: const Text('Atualizar'),
        ),
      ],
    );
  }
}
