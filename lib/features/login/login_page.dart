import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyecto_1/core/extensions/context_localization.dart';
// import '../../core/widgets/toggle.dart';
// import '../../core/widgets/dropdown.dart';
// import '../../providers/theme_and_locale_provider.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc?.login ?? 'Login'),
        backgroundColor: const Color.fromARGB(255, 26, 0, 226),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Campo de email
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: context.loc?.email ?? 'Email',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Campo de contraseña
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: context.loc?.password ?? 'Password',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // Botón de login
            ElevatedButton(
              onPressed: () {
                final email = emailController.text;
                final password = passwordController.text;

                // Por ahora solo muestra un diálogo
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Login Info'),
                    content: Text('Email: $email\nPassword: $password'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 26, 0, 226),
              ),
              child: Text(context.loc?.login ?? 'Login'),
            ),
          ],
        ),
      ),
    );
  }
}
