import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyecto_1/core/extensions/context_localization.dart';
import 'package:proyecto_1/core/models/product.dart';
import 'package:proyecto_1/core/models/category.dart';
import 'package:proyecto_1/core/models/product_filters.dart';
import 'package:proyecto_1/core/widgets/general_chip.dart';
import 'package:proyecto_1/core/services/product_service.dart';
import 'package:proyecto_1/core/services/category_service.dart';
import 'package:proyecto_1/providers/auth_provider.dart';
import 'package:proyecto_1/features/settings/settings_page.dart';
import 'package:proyecto_1/features/profile/profile_page.dart';
import 'widgets/product_grid.dart';
import 'widgets/user_greeting.dart';
import 'widgets/product_filters_dialog.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  int? selectedCategoryId;
  String? selectedCategoryUuid; // ✅ Agregar UUID para enviar al backend
  ProductFilters _currentFilters = ProductFilters.empty;

  List<Product> products = [];
  List<Category> categories = [];
  bool isLoading = true;
  String? errorMessage;
  ProductService? _productService;
  CategoryService? _categoryService;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _productService?.dispose();
    _categoryService?.dispose();
    super.dispose();
  }

  Future<void> _loadData([ProductFilters? filters]) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Obtener el token de autenticación si está disponible
      final authState = ref.read(authProvider);
      _productService = ProductService(authToken: authState.accessToken);
      _categoryService = CategoryService(authToken: authState.accessToken);

      // Crear filtros con la categoría seleccionada actual
      final baseFilters = filters ?? _currentFilters;

      // Usar el UUID de la categoría (no el hashCode) para el backend
      final filtersWithCategory = baseFilters.copyWith(
        categoryId: selectedCategoryUuid, // ✅ Usar UUID en lugar de ID
      );

      // Si no hay categoría seleccionada, limpiar el filtro de categoría
      final finalFilters = selectedCategoryUuid == null
          ? ProductFilters(
              search: filtersWithCategory.search,
              color: filtersWithCategory.color,
              minPrice: filtersWithCategory.minPrice,
              maxPrice: filtersWithCategory.maxPrice,
              hasModel3D: filtersWithCategory.hasModel3D,
              status: filtersWithCategory.status ?? 'active',
              sortBy: filtersWithCategory.sortBy,
              order: filtersWithCategory.order,
              limit: filtersWithCategory.limit,
              offset: filtersWithCategory.offset,
              // categoryId: null (no incluir)
            )
          : filtersWithCategory;

      // Cargar productos y categorías desde el backend en paralelo
      final results = await Future.wait([
        _productService!.getAllProducts(finalFilters),
        _categoryService!.getAllCategories(),
      ]);

      final loadedProducts = results[0] as List<Product>;
      final loadedCategories = results[1] as List<Category>;

      setState(() {
        products = loadedProducts;
        categories = loadedCategories;
        _currentFilters = finalFilters;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  List<Product> get filteredProducts => products;

  Future<void> _openFiltersDialog() async {
    final result = await showDialog<ProductFilters>(
      context: context,
      builder: (context) =>
          ProductFiltersDialog(initialFilters: _currentFilters),
    );

    if (result != null) {
      // Aplicar los nuevos filtros
      await _loadData(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Mostrar error si hubo algún problema
    if (errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: Text(context.loc!.appTitle)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error al cargar productos',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  errorMessage!,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _loadData,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
      );
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
            icon: const Icon(Icons.account_circle),
            tooltip: 'Profile',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const UserGreeting(),

          // Chips de categorías
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
                        // Toggle: si ya está seleccionada, deseleccionar
                        if (selectedCategoryId == category.id) {
                          selectedCategoryId = null;
                          selectedCategoryUuid = null; // ✅ Limpiar UUID
                        } else {
                          selectedCategoryId = category.id;
                          selectedCategoryUuid =
                              category.uuid; // ✅ Guardar UUID
                        }
                      });
                      // Recargar productos con los filtros actuales + nueva categoría
                      _loadData();
                    },
                  ),
                );
              },
            ),
          ),

          // Barra de filtros y búsqueda
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                // Botón de filtros con badge si hay filtros activos
                Badge(
                  isLabelVisible: _currentFilters.activeFiltersCount > 0,
                  label: Text(_currentFilters.activeFiltersCount.toString()),
                  child: FilledButton.tonalIcon(
                    onPressed: _openFiltersDialog,
                    icon: const Icon(Icons.filter_list),
                    label: const Text('Filtros'),
                  ),
                ),
                const SizedBox(width: 12),

                // Indicador de filtros activos
                if (_currentFilters.hasActiveFilters) ...[
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          if (_currentFilters.search != null) ...[
                            Chip(
                              label: Text('🔍 ${_currentFilters.search}'),
                              onDeleted: () {
                                _loadData(
                                  _currentFilters.copyWith(clearSearch: true),
                                );
                              },
                              deleteIcon: const Icon(Icons.close, size: 18),
                            ),
                            const SizedBox(width: 8),
                          ],
                          if (_currentFilters.color != null) ...[
                            Chip(
                              label: Text('🎨 ${_currentFilters.color}'),
                              onDeleted: () {
                                _loadData(
                                  _currentFilters.copyWith(clearColor: true),
                                );
                              },
                              deleteIcon: const Icon(Icons.close, size: 18),
                            ),
                            const SizedBox(width: 8),
                          ],
                          if (_currentFilters.minPrice != null ||
                              _currentFilters.maxPrice != null) ...[
                            Chip(
                              label: Text(
                                '€ ${_currentFilters.minPrice?.toInt() ?? 0} - ${_currentFilters.maxPrice?.toInt() ?? '∞'}',
                              ),
                              onDeleted: () {
                                _loadData(
                                  _currentFilters.copyWith(
                                    clearMinPrice: true,
                                    clearMaxPrice: true,
                                  ),
                                );
                              },
                              deleteIcon: const Icon(Icons.close, size: 18),
                            ),
                            const SizedBox(width: 8),
                          ],
                          if (_currentFilters.hasModel3D == true) ...[
                            Chip(
                              label: const Text('📦 3D'),
                              onDeleted: () {
                                _loadData(
                                  _currentFilters.copyWith(
                                    clearHasModel3D: true,
                                  ),
                                );
                              },
                              deleteIcon: const Icon(Icons.close, size: 18),
                            ),
                            const SizedBox(width: 8),
                          ],
                          if (_currentFilters.sortBy != null) ...[
                            Chip(
                              label: Text('⬍ ${_currentFilters.sortBy}'),
                              onDeleted: () {
                                _loadData(
                                  _currentFilters.copyWith(
                                    clearSortBy: true,
                                    clearOrder: true,
                                  ),
                                );
                              },
                              deleteIcon: const Icon(Icons.close, size: 18),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Botón para limpiar todos los filtros
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _currentFilters = ProductFilters.empty;
                      });
                      _loadData();
                    },
                    icon: const Icon(Icons.clear_all),
                    tooltip: 'Limpiar filtros',
                  ),
                ],
              ],
            ),
          ),

          // Grid de productos
          Expanded(child: ProductGrid(products: filteredProducts)),
        ],
      ),
    );
  }
}
