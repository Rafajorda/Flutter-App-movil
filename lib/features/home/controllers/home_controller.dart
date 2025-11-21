// home_controller.dart
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyecto_1/core/models/product.dart';
import 'package:proyecto_1/core/models/category.dart';
import 'package:proyecto_1/core/models/color.dart';
import 'package:proyecto_1/core/models/product_filters.dart';
import 'package:proyecto_1/core/services/product_service.dart';
import 'package:proyecto_1/core/services/category_service.dart';
import 'package:proyecto_1/core/services/color_service.dart';
import 'package:proyecto_1/core/services/favorites_service.dart';
import 'package:proyecto_1/providers/auth_provider.dart';

import 'home_state.dart';

class HomeController extends AsyncNotifier<HomeState> {
  @override
  Future<HomeState> build() async {
    // Carga inicial cuando se crea el provider
    return _loadDataInternal();
  }

  // Helper de acceso a auth/interceptor
  ProductService _productService() {
    final authState = ref.read(authProvider);
    final interceptor = ref.read(authInterceptorProvider);
    return ProductService(
      interceptor: interceptor,
      authToken: authState.accessToken,
    );
  }

  CategoryService _categoryService() {
    final authState = ref.read(authProvider);
    return CategoryService(authToken: authState.accessToken);
  }

  ColorService _colorService() {
    final authState = ref.read(authProvider);
    return ColorService(authToken: authState.accessToken);
  }

  FavoritesService _favoritesService() {
    final authState = ref.read(authProvider);
    final interceptor = ref.read(authInterceptorProvider);
    return FavoritesService(
      interceptor: interceptor,
      authToken: authState.accessToken,
    );
  }

  Future<HomeState> _loadDataInternal([ProductFilters? filters]) async {
    final previous = state.value ?? const HomeState();
    final authState = ref.read(authProvider);

    final baseFilters = filters ?? previous.currentFilters;

    // Incluir UUID de categoría
    final filtersWithCategory = baseFilters.copyWith(
      categoryId: previous.selectedCategoryUuid,
    );

    // Si no hay categoría seleccionada, no mandamos categoryId
    final finalFilters = previous.selectedCategoryUuid == null
        ? ProductFilters(
            search: filtersWithCategory.search,
            colorId: filtersWithCategory.colorId,
            minPrice: filtersWithCategory.minPrice,
            maxPrice: filtersWithCategory.maxPrice,
            hasModel3D: filtersWithCategory.hasModel3D,
            onlyFavorites: filtersWithCategory.onlyFavorites,
            status: filtersWithCategory.status ?? 'active',
            sortBy: filtersWithCategory.sortBy,
            order: filtersWithCategory.order,
            limit: filtersWithCategory.limit,
            offset: filtersWithCategory.offset,
          )
        : filtersWithCategory;

    // 1) Productos
    List<Product> loadedProducts;
    final productService = _productService();
    final favoritesService = _favoritesService();

    if (finalFilters.onlyFavorites == true && authState.isAuthenticated) {
      final favorites = await favoritesService.getMyFavorites();
      loadedProducts = favorites.map((f) => f.product).toList();
      loadedProducts = _applyLocalFilters(loadedProducts, finalFilters);
    } else if (finalFilters.onlyFavorites == true &&
        !authState.isAuthenticated) {
      loadedProducts = [];
    } else {
      loadedProducts = await productService.getAllProducts(finalFilters);
    }

    // 2) Categorías y colores en paralelo
    final categoryService = _categoryService();
    final colorService = _colorService();

    final results = await Future.wait([
      categoryService.getAllCategories(),
      colorService.getAllColors(),
    ]);

    final loadedCategories = results[0] as List<Category>;
    final loadedColors = results[1] as List<ColorModel>;

    // 3) IDs de favoritos
    Set<String> favoriteIds = {};
    if (authState.isAuthenticated) {
      try {
        final favorites = await favoritesService.getMyFavorites();
        favoriteIds = favorites.map((f) => f.product.id).toSet();
      } catch (_) {
        favoriteIds = {};
      }
    }

    return previous.copyWith(
      products: loadedProducts,
      categories: loadedCategories,
      colors: loadedColors,
      currentFilters: finalFilters,
      favoriteProductIds: favoriteIds,
    );
  }

  /// Recargar explícitamente (por ejemplo tras cambiar filtros)
  Future<void> reload([ProductFilters? filters]) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _loadDataInternal(filters));
  }

  /// Filtros locales (favoritos)
  List<Product> _applyLocalFilters(
    List<Product> products,
    ProductFilters filters,
  ) {
    var filtered = products;

    if (filters.search != null && filters.search!.isNotEmpty) {
      final searchLower = filters.search!.toLowerCase();
      filtered = filtered.where((p) {
        return p.name.toLowerCase().contains(searchLower) ||
            p.description.toLowerCase().contains(searchLower);
      }).toList();
    }

    if (filters.minPrice != null) {
      filtered = filtered.where((p) => p.price >= filters.minPrice!).toList();
    }

    if (filters.maxPrice != null) {
      filtered = filtered.where((p) => p.price <= filters.maxPrice!).toList();
    }

    if (filters.hasModel3D != null) {
      filtered = filtered.where((p) {
        final hasModel = p.images.isNotEmpty;
        return filters.hasModel3D! ? hasModel : !hasModel;
      }).toList();
    }

    if (filters.colorId != null && filters.colorId!.isNotEmpty) {
      filtered = filtered.where((p) {
        return p.colors.any((c) => c.id == filters.colorId);
      }).toList();
    }

    if (filters.sortBy != null) {
      filtered = List<Product>.from(filtered);
      switch (filters.sortBy) {
        case 'name':
          filtered.sort((a, b) => a.name.compareTo(b.name));
          break;
        case 'price':
          filtered.sort((a, b) => a.price.compareTo(b.price));
          break;
        case 'favoritesCount':
          filtered.sort((a, b) => a.favoritesCount.compareTo(b.favoritesCount));
          break;
      }

      if (filters.order == 'DESC') {
        filtered = filtered.reversed.toList();
      }
    }

    return filtered;
  }

  /// Selección de categoría desde los chips
  Future<void> selectCategory(Category? category) async {
    final previous = state.value ?? const HomeState();
    final updated = previous.copyWith(
      selectedCategoryId: category?.id,
      selectedCategoryUuid: category?.uuid,
    );
    state = AsyncData(updated);
    await reload(updated.currentFilters);
  }

  /// Aplicar nuevos filtros desde el diálogo
  Future<void> applyFilters(ProductFilters filters) async {
    await reload(filters);
  }

  /// Limpiar todos los filtros
  Future<void> clearAllFilters() async {
    final previous = state.value ?? const HomeState();
    final updated = previous.copyWith(currentFilters: ProductFilters.empty);
    state = AsyncData(updated);
    await reload(updated.currentFilters);
  }

  // Helpers para limpiar filtros individuales
  Future<void> clearSearch() async {
    final prev = state.value;
    if (prev == null) return;
    await applyFilters(prev.currentFilters.copyWith(clearSearch: true));
  }

  Future<void> clearColor() async {
    final prev = state.value;
    if (prev == null) return;
    await applyFilters(prev.currentFilters.copyWith(clearColorId: true));
  }

  Future<void> clearPriceRange() async {
    final prev = state.value;
    if (prev == null) return;
    await applyFilters(
      prev.currentFilters.copyWith(clearMinPrice: true, clearMaxPrice: true),
    );
  }

  Future<void> clearHasModel3D() async {
    final prev = state.value;
    if (prev == null) return;
    await applyFilters(prev.currentFilters.copyWith(clearHasModel3D: true));
  }

  Future<void> clearOnlyFavorites() async {
    final prev = state.value;
    if (prev == null) return;
    await applyFilters(prev.currentFilters.copyWith(clearOnlyFavorites: true));
  }

  Future<void> clearSort() async {
    final prev = state.value;
    if (prev == null) return;
    await applyFilters(
      prev.currentFilters.copyWith(clearSortBy: true, clearOrder: true),
    );
  }
}

// Provider AsyncNotifier
final homeControllerProvider = AsyncNotifierProvider<HomeController, HomeState>(
  HomeController.new,
);
