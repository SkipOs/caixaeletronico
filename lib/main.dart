import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

// Estou usando o const pra criar widgets imutaveis,
// pra que toda vez que sejjam criados o código não precise
// re-renderizar toda vez que buscar uma informação no
// banco de dados que vamos usar no futuro. isso aumenta a
// performance geral do app, e permite que o código se adapte e seja
// reutilizado em situações diferentes

class MyApp extends StatelessWidget {
  const MyApp({Key? key})
      : super(key: key); // Adicionado o `Key? key` e `const`

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ATM App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(), // `const` adicionado
    );
  }
}
