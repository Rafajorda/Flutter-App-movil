import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyecto_1/core/extensions/context_localization.dart';
import 'package:proyecto_1/core/models/product.dart';
import 'package:proyecto_1/core/models/category.dart';
import 'package:proyecto_1/core/widgets/general_chip.dart';
import 'package:proyecto_1/providers/auth_provider.dart';
// import 'package:proyecto_1/core/widgets/products/card_product.dart';
import 'package:proyecto_1/features/login/login_page.dart';
import 'package:proyecto_1/features/settings/settings_page.dart';
import 'widgets/product_grid.dart';
import 'widgets/user_greeting.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  int? selectedCategoryId;

  List<Product> products = [];
  List<Category> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final productsJson = await rootBundle.loadString(
        'assets/data/products.json',
      );
      final categoriesJson = await rootBundle.loadString(
        'assets/data/categories.json',
      );

      setState(() {
        products = (json.decode(productsJson) as List)
            .map((json) => Product.fromJson(json))
            .toList();
        categories = (json.decode(categoriesJson) as List)
            .map((json) => Category.fromJson(json))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      debugPrint('❌ Error cargando datos: $e');
      setState(() => isLoading = false);
    }
  }

  List<Product> get filteredProducts => selectedCategoryId == null
      ? products
      : products
            .where((p) => p.categories.contains(selectedCategoryId))
            .toList();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc!.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsPage()),
            ),
          ),
          IconButton(
            icon: Icon(authState.isAuthenticated ? Icons.logout : Icons.login),
            tooltip: authState.isAuthenticated
                ? context.loc!.logout
                : context.loc!.login,
            onPressed: () async {
              if (authState.isAuthenticated) {
                // Mostrar diálogo de confirmación para logout
                final shouldLogout = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(context.loc!.logoutConfirmTitle),
                    content: Text(
                      context.loc!.logoutConfirmMessage(
                        authState.userName ?? context.loc!.user,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text(context.loc!.cancel),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text(context.loc!.logout),
                      ),
                    ],
                  ),
                );

                if (shouldLogout == true) {
                  await ref.read(authProvider.notifier).logout();
                  if (mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                      (route) => false,
                    );
                  }
                }
              } else {
                // Ir a login
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 🔹 Saludo del usuario
          const UserGreeting(),

          // 🔹 Chips de categorías
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: GeneralChip(
                    label: category.name,
                    isSelected: category.id == selectedCategoryId,
                    onSelected: () {
                      setState(() {
                        selectedCategoryId = selectedCategoryId == category.id
                            ? null
                            : category.id;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          // 🔹 Grid de productos
          Expanded(child: ProductGrid(products: filteredProducts)),
        ],
      ),
    );
  }
}
