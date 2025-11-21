// home_state.dart
import 'package:proyecto_1/core/models/product.dart';
import 'package:proyecto_1/core/models/category.dart';
import 'package:proyecto_1/core/models/color.dart';
import 'package:proyecto_1/core/models/product_filters.dart';

class HomeState {
  final List<Product> products;
  final List<Category> categories;
  final List<ColorModel> colors;

  final ProductFilters currentFilters;

  final int? selectedCategoryId; // ID local para chips
  final String? selectedCategoryUuid; // UUID real para backend

  final Set<String> favoriteProductIds;

  const HomeState({
    this.products = const [],
    this.categories = const [],
    this.colors = const [],
    this.currentFilters = ProductFilters.empty,
    this.selectedCategoryId,
    this.selectedCategoryUuid,
    this.favoriteProductIds = const {},
  });

  HomeState copyWith({
    List<Product>? products,
    List<Category>? categories,
    List<ColorModel>? colors,
    ProductFilters? currentFilters,
    int? selectedCategoryId,
    String? selectedCategoryUuid,
    Set<String>? favoriteProductIds,
  }) {
    return HomeState(
      products: products ?? this.products,
      categories: categories ?? this.categories,
      colors: colors ?? this.colors,
      currentFilters: currentFilters ?? this.currentFilters,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      selectedCategoryUuid: selectedCategoryUuid ?? this.selectedCategoryUuid,
      favoriteProductIds: favoriteProductIds ?? this.favoriteProductIds,
    );
  }
}
