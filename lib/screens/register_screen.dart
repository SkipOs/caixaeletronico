import 'package:flutter/material.dart';
import '../services/api_service.dart'; // Importe o ApiService

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmeSenhaController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dataNascimentoController =
      TextEditingController();

  // Crie uma instância do ApiService
  final ApiService _apiService = ApiService('http://18.216.40.254:8080');

  @override
  void dispose() {
    _cpfController.dispose();
    _nomeController.dispose();
    _senhaController.dispose();
    _confirmeSenhaController.dispose();
    _emailController.dispose();
    _dataNascimentoController.dispose();
    super.dispose();
  }

  // Função para registrar usuário e conta
  void _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      Map<String, dynamic> usuarioContaData = {
        'usuario': {
          'cpf': _cpfController.text,
          'nome': _nomeController.text,
          'senha': _senhaController.text,
          'email': _emailController.text,
          'dataNascimento': _dataNascimentoController.text,
        },
        'conta': {
          // Adicione os campos da conta aqui, se necessário
        }
      };

      try {
        final response =
            await _apiService.cadastrarUsuarioConta(usuarioContaData);

        if (response != null &&
            response['message'] == 'Pessoa e conta cadastradas com sucesso!') {
          final numeroConta = response['numeroConta'];
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Usuário cadastrado com sucesso! Número da conta: $numeroConta'),
            ),
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AccountDetailsScreen(numeroConta: numeroConta),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erro ao cadastrar usuário. Tente novamente.'),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao conectar com o servidor.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Criar Conta'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _cpfController,
                  decoration: const InputDecoration(labelText: 'CPF'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu CPF';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nomeController,
                  decoration: const InputDecoration(labelText: 'Nome'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu nome';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _senhaController,
                  decoration: const InputDecoration(labelText: 'Senha'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira uma senha';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _confirmeSenhaController,
                  decoration:
                      const InputDecoration(labelText: 'Confirme a Senha'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, confirme sua senha';
                    }
                    if (value != _senhaController.text) {
                      return 'As senhas não coincidem';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu e-mail';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Por favor, insira um e-mail válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _dataNascimentoController,
                  decoration:
                      const InputDecoration(labelText: 'Data de Nascimento'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira sua data de nascimento';
                    }
                    // Validação simples para a data
                    if (!RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(value)) {
                      return 'Formato de data inválido. Use DD/MM/AAAA';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _register,
                  child: const Text('Cadastrar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Tela para exibir detalhes da conta
class AccountDetailsScreen extends StatelessWidget {
  final String numeroConta;

  const AccountDetailsScreen({super.key, required this.numeroConta});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Conta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'Número da Conta: $numeroConta',
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
