import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyecto_1/core/extensions/context_localization.dart';
import 'package:proyecto_1/core/widgets/button.dart';
import 'package:proyecto_1/providers/auth_provider.dart';
import 'package:proyecto_1/features/login/register_page.dart';
import 'package:proyecto_1/features/home/home_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.loc?.completeAllFields ?? 'Please complete all fields',
          ),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );
      return;
    }

    final authNotifier = ref.read(authProvider.notifier);
    await authNotifier.login(email, password);

    // Verificar el resultado
    final authState = ref.read(authProvider);

    if (!mounted) return;

    if (authState.isAuthenticated) {
      // Login exitoso - navegar a home y eliminar login del stack
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MyHomePage()),
        (route) => false,
      );
    } else if (authState.errorMessage != null) {
      // Mostrar error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authState.errorMessage!),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return PopScope(
      // Permitir volver atrás con el botón de hardware solo si no está cargando
      canPop: !authState.isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.loc?.login ?? 'Login'),
          // Mostrar botón de retroceso solo si no está cargando
          automaticallyImplyLeading: !authState.isLoading,
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
                enabled: !authState.isLoading,
                decoration: InputDecoration(
                  labelText: context.loc?.email ?? 'Email',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 16),

              // Campo de contraseña
              TextField(
                controller: passwordController,
                obscureText: true,
                enabled: !authState.isLoading,
                decoration: InputDecoration(
                  labelText: context.loc?.password ?? 'Password',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock),
                ),
                onSubmitted: (_) => _handleLogin(),
              ),
              const SizedBox(height: 24),

              // Botón de login
              SizedBox(
                width: double.infinity,
                child: authState.isLoading
                    ? ElevatedButton(
                        onPressed: null,
                        child: const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : GeneralButton(
                        label: context.loc?.login ?? 'Login',
                        onPressed: _handleLogin,
                        icon: Icons.login,
                      ),
              ),

              const SizedBox(height: 16),

              // Enlace a registro
              TextButton(
                onPressed: authState.isLoading
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterPage(),
                          ),
                        );
                      },
                child: Text(
                  context.loc?.noAccount ?? "Don't have an account? Sign up",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
