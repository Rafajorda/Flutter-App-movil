import 'package:flutter/material.dart';
import 'package:proyecto_1/core/models/color.dart';
import 'package:proyecto_1/features/home/controllers/home_state.dart';
import 'package:proyecto_1/core/extensions/context_localization.dart';

class FiltersBar extends StatelessWidget {
  final HomeState state;
  final Future<void> Function() onOpenFilters;
  final VoidCallback onClearAll;
  final VoidCallback onClearSearch;
  final VoidCallback onClearColor;
  final VoidCallback onClearPriceRange;
  final VoidCallback onClearHasModel3D;
  final VoidCallback onClearOnlyFavorites;
  final VoidCallback onClearSort;

  const FiltersBar({
    required this.state,
    required this.onOpenFilters,
    required this.onClearAll,
    required this.onClearSearch,
    required this.onClearColor,
    required this.onClearPriceRange,
    required this.onClearHasModel3D,
    required this.onClearOnlyFavorites,
    required this.onClearSort,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final loc = context.loc!;
    final filters = state.currentFilters;
    final hasFilters = filters.hasActiveFilters;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Badge(
            isLabelVisible: filters.activeFiltersCount > 0,
            label: Text(filters.activeFiltersCount.toString()),
            child: FilledButton.tonalIcon(
              onPressed: onOpenFilters,
              icon: const Icon(Icons.filter_list),
              label: Text(loc.filters),
            ),
          ),
          const SizedBox(width: 12),
          if (hasFilters) ...[
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: _buildFilterChips(context)),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: onClearAll,
              icon: const Icon(Icons.clear_all),
              tooltip: 'Limpiar filtros',
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildFilterChips(BuildContext context) {
    final chips = <Widget>[];
    final loc = context.loc!;
    final filters = state.currentFilters;

    if (filters.search != null && filters.search!.isNotEmpty) {
      chips.add(
        Chip(
          label: Text('🔍 ${filters.search}'),
          onDeleted: onClearSearch,
          deleteIcon: const Icon(Icons.close, size: 18),
        ),
      );
      chips.add(const SizedBox(width: 8));
    }

    if (filters.colorId != null && filters.colorId!.isNotEmpty) {
      final colorName = state.colors
          .firstWhere(
            (c) => c.id == filters.colorId,
            orElse: () => ColorModel(id: '', name: loc.color),
          )
          .name;

      chips.add(
        Chip(
          label: Text('🎨 $colorName'),
          onDeleted: onClearColor,
          deleteIcon: const Icon(Icons.close, size: 18),
        ),
      );
      chips.add(const SizedBox(width: 8));
    }

    if (filters.minPrice != null || filters.maxPrice != null) {
      chips.add(
        Chip(
          label: Text(
            '€ ${filters.minPrice?.toInt() ?? 0} - ${filters.maxPrice?.toInt() ?? '∞'}',
          ),
          onDeleted: onClearPriceRange,
          deleteIcon: const Icon(Icons.close, size: 18),
        ),
      );
      chips.add(const SizedBox(width: 8));
    }

    if (filters.hasModel3D == true) {
      chips.add(
        Chip(
          label: Text('📦 ${loc.model3D}'),
          onDeleted: onClearHasModel3D,
          deleteIcon: const Icon(Icons.close, size: 18),
        ),
      );
      chips.add(const SizedBox(width: 8));
    }

    if (filters.onlyFavorites == true) {
      chips.add(
        Chip(
          label: Text('❤️ ${loc.onlyFavorites}'),
          onDeleted: onClearOnlyFavorites,
          deleteIcon: const Icon(Icons.close, size: 18),
        ),
      );
      chips.add(const SizedBox(width: 8));
    }

    if (filters.sortBy != null) {
      chips.add(
        Chip(
          label: Text('⬍ ${filters.sortBy}'),
          onDeleted: onClearSort,
          deleteIcon: const Icon(Icons.close, size: 18),
        ),
      );
    }

    return chips;
  }
}
