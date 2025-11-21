// my_home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:proyecto_1/core/extensions/context_localization.dart';
import 'package:proyecto_1/core/models/product_filters.dart';
import 'package:proyecto_1/core/models/color.dart';
import 'package:proyecto_1/features/home/controllers/home_controller.dart';
import 'package:proyecto_1/features/home/controllers/home_state.dart';
import 'package:proyecto_1/features/home/widgets/filters_bar.dart';
import 'package:proyecto_1/features/settings/settings_page.dart';
import 'package:proyecto_1/features/profile/profile_page.dart';

import 'widgets/product_grid.dart';
import 'widgets/user_greeting.dart';
import 'widgets/product_filters_dialog.dart';
import 'widgets/home_error_view.dart';
import 'widgets/category_chips_list.dart';
import 'widgets/home_app_bar.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(homeControllerProvider);
    final controller = ref.read(homeControllerProvider.notifier);

    return asyncState.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) => HomeErrorView(
        errorMessage: error.toString(),
        onRetry: controller.reload,
      ),
      data: (state) => Scaffold(
        appBar: HomeAppBar(
          onSettingsTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SettingsPage()),
          ),
          onProfileTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfilePage()),
          ),
        ),
        body: Column(
          children: [
            const UserGreeting(),

            // Chips de categorías
            CategoryChipsList(
              categories: state.categories,
              selectedCategoryId: state.selectedCategoryId,
              onCategorySelected: controller.selectCategory,
            ),

            // Barra de filtros
            FiltersBar(
              state: state,
              onOpenFilters: () async {
                final result = await showDialog<ProductFilters>(
                  context: context,
                  builder: (context) => ProductFiltersDialog(
                    initialFilters: state.currentFilters,
                  ),
                );
                if (result != null) {
                  await controller.applyFilters(result);
                }
              },
              onClearAll: controller.clearAllFilters,
              onClearSearch: controller.clearSearch,
              onClearColor: controller.clearColor,
              onClearPriceRange: controller.clearPriceRange,
              onClearHasModel3D: controller.clearHasModel3D,
              onClearOnlyFavorites: controller.clearOnlyFavorites,
              onClearSort: controller.clearSort,
            ),

            // Grid de productos
            Expanded(
              child: ProductGrid(
                products: state.products,
                favoriteProductIds: state.favoriteProductIds,
                onProductReturn: () {
                  controller.reload(state.currentFilters);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
