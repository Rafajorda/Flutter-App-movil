/// Modelo de filtros para productos
class ProductFilters {
  final String? search;
  final String? categoryId;
  final String? color;
  final double? minPrice;
  final double? maxPrice;
  final bool? hasModel3D;
  final String? status; // "active", "inactive", "all"
  final String? sortBy; // "name", "price", "favoritesCount", "createdAt"
  final String? order; // "ASC", "DESC"
  final int? limit;
  final int? offset;

  const ProductFilters({
    this.search,
    this.categoryId,
    this.color,
    this.minPrice,
    this.maxPrice,
    this.hasModel3D,
    this.status,
    this.sortBy,
    this.order,
    this.limit,
    this.offset,
  });

  /// Crea una copia con algunos campos modificados
  ProductFilters copyWith({
    String? search,
    String? categoryId,
    String? color,
    double? minPrice,
    double? maxPrice,
    bool? hasModel3D,
    String? status,
    String? sortBy,
    String? order,
    int? limit,
    int? offset,
    bool clearSearch = false,
    bool clearCategoryId = false,
    bool clearColor = false,
    bool clearMinPrice = false,
    bool clearMaxPrice = false,
    bool clearHasModel3D = false,
    bool clearStatus = false,
    bool clearSortBy = false,
    bool clearOrder = false,
  }) {
    return ProductFilters(
      search: clearSearch ? null : (search ?? this.search),
      categoryId: clearCategoryId ? null : (categoryId ?? this.categoryId),
      color: clearColor ? null : (color ?? this.color),
      minPrice: clearMinPrice ? null : (minPrice ?? this.minPrice),
      maxPrice: clearMaxPrice ? null : (maxPrice ?? this.maxPrice),
      hasModel3D: clearHasModel3D ? null : (hasModel3D ?? this.hasModel3D),
      status: clearStatus ? null : (status ?? this.status),
      sortBy: clearSortBy ? null : (sortBy ?? this.sortBy),
      order: clearOrder ? null : (order ?? this.order),
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
    );
  }

  /// Convierte los filtros a query parameters para la URL
  Map<String, String> toQueryParameters() {
    final params = <String, String>{};

    if (search != null && search!.isNotEmpty) {
      params['search'] = search!;
    }
    if (categoryId != null && categoryId!.isNotEmpty) {
      params['categoryId'] = categoryId!;
    }
    if (color != null && color!.isNotEmpty) {
      params['color'] = color!;
    }
    if (minPrice != null) {
      params['minPrice'] = minPrice!.toString();
    }
    if (maxPrice != null) {
      params['maxPrice'] = maxPrice!.toString();
    }
    if (hasModel3D != null) {
      params['hasModel3D'] = hasModel3D!.toString();
    }
    if (status != null && status!.isNotEmpty) {
      params['status'] = status!;
    }
    if (sortBy != null && sortBy!.isNotEmpty) {
      params['sortBy'] = sortBy!;
    }
    if (order != null && order!.isNotEmpty) {
      params['order'] = order!;
    }
    if (limit != null) {
      params['limit'] = limit!.toString();
    }
    if (offset != null) {
      params['offset'] = offset!.toString();
    }

    return params;
  }

  /// Verifica si hay filtros activos (excluyendo categoría)
  bool get hasActiveFilters =>
      search != null ||
      color != null ||
      minPrice != null ||
      maxPrice != null ||
      hasModel3D != null ||
      status != null ||
      sortBy != null;

  /// Cuenta cuántos filtros están activos (excluyendo categoría)
  int get activeFiltersCount {
    int count = 0;
    if (search != null && search!.isNotEmpty) count++;
    if (color != null && color!.isNotEmpty) count++;
    if (minPrice != null || maxPrice != null) count++;
    if (hasModel3D != null) count++;
    if (status != null && status != 'active') count++; // 'active' es default
    if (sortBy != null && sortBy!.isNotEmpty) count++;
    return count;
  }

  /// Filtros vacíos (solo activos por defecto)
  static const ProductFilters empty = ProductFilters(status: 'active');

  @override
  String toString() {
    return 'ProductFilters(search: $search, categoryId: $categoryId, '
        'color: $color, minPrice: $minPrice, maxPrice: $maxPrice, '
        'hasModel3D: $hasModel3D, status: $status, sortBy: $sortBy, '
        'order: $order, limit: $limit, offset: $offset)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductFilters &&
        other.search == search &&
        other.categoryId == categoryId &&
        other.color == color &&
        other.minPrice == minPrice &&
        other.maxPrice == maxPrice &&
        other.hasModel3D == hasModel3D &&
        other.status == status &&
        other.sortBy == sortBy &&
        other.order == order &&
        other.limit == limit &&
        other.offset == offset;
  }

  @override
  int get hashCode {
    return Object.hash(
      search,
      categoryId,
      color,
      minPrice,
      maxPrice,
      hasModel3D,
      status,
      sortBy,
      order,
      limit,
      offset,
    );
  }
}
