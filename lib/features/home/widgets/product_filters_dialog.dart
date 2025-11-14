import 'package:flutter/material.dart';
import 'package:proyecto_1/core/models/product_filters.dart';
import 'package:proyecto_1/core/models/color.dart';
import 'package:proyecto_1/core/services/color_service.dart';

/// Diálogo de filtros de productos.
///
/// Permite al usuario filtrar productos por:
/// - Búsqueda por texto
/// - Rango de precio (mínimo y máximo)
/// - Color (carga dinámica desde backend)
/// - Disponibilidad de modelo 3D
/// - Estado del producto (activo/inactivo)
/// - Ordenamiento (por nombre, precio, popularidad, fecha)
/// - Orden ascendente/descendente
///
/// Características especiales:
/// - Carga asíncrona de colores desde el backend
/// - Opción "Ver más" para expandir lista de colores (muestra 6 inicialmente)
/// - Validación de rangos de precio
/// - Preserva filtros aplicados previamente
class ProductFiltersDialog extends StatefulWidget {
  final ProductFilters initialFilters;

  const ProductFiltersDialog({super.key, required this.initialFilters});

  @override
  State<ProductFiltersDialog> createState() => _ProductFiltersDialogState();
}

class _ProductFiltersDialogState extends State<ProductFiltersDialog> {
  // Controladores de texto para los campos de entrada
  late TextEditingController _searchController;
  late TextEditingController _minPriceController;
  late TextEditingController _maxPriceController;

  // Estado de filtros
  String? _selectedColorId; // UUID del color seleccionado
  List<ColorModel> _availableColors = []; // Colores cargados del backend
  bool _isLoadingColors = true; // Indica si está cargando colores
  bool _showAllColors = false; // Controla si mostrar todos los colores o solo 6
  bool? _hasModel3D;
  String? _selectedStatus;
  String? _selectedSortBy;
  String? _selectedOrder;

  ColorService? _colorService;

  // Opciones de ordenamiento
  final Map<String, String> _sortOptions = {
    'name': 'Nombre',
    'price': 'Precio',
    'favoritesCount': 'Popularidad',
    'createdAt': 'Más recientes',
  };

  // Opciones de orden
  final Map<String, String> _orderOptions = {
    'ASC': 'Ascendente',
    'DESC': 'Descendente',
  };

  @override
  void initState() {
    super.initState();

    // Inicializar controladores con valores actuales de los filtros
    _searchController = TextEditingController(
      text: widget.initialFilters.search ?? '',
    );
    _minPriceController = TextEditingController(
      text: widget.initialFilters.minPrice?.toString() ?? '',
    );
    _maxPriceController = TextEditingController(
      text: widget.initialFilters.maxPrice?.toString() ?? '',
    );

    // Inicializar estado de filtros
    _selectedColorId = widget.initialFilters.colorId;
    _hasModel3D = widget.initialFilters.hasModel3D;
    _selectedStatus = widget.initialFilters.status ?? 'active';
    _selectedSortBy = widget.initialFilters.sortBy;
    _selectedOrder = widget.initialFilters.order;

    // Cargar colores desde el backend de forma asíncrona
    _loadColors();
  }

  /// Carga los colores disponibles desde el backend.
  ///
  /// Endpoint: GET /color
  ///
  /// Maneja errores mostrando un SnackBar si falla la petición.
  /// Actualiza [_availableColors] y [_isLoadingColors] al completar.
  Future<void> _loadColors() async {
    try {
      _colorService = ColorService();
      final colors = await _colorService!.getAllColors();
      if (mounted) {
        setState(() {
          _availableColors = colors;
          _isLoadingColors = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingColors = false;
        });
      }
      // Mostrar error al usuario
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al cargar colores: $e')));
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    _colorService?.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final filters = ProductFilters(
      search: _searchController.text.trim().isEmpty
          ? null
          : _searchController.text.trim(),
      colorId: _selectedColorId, // Usar colorId en lugar de color
      minPrice: _minPriceController.text.trim().isEmpty
          ? null
          : double.tryParse(_minPriceController.text.trim()),
      maxPrice: _maxPriceController.text.trim().isEmpty
          ? null
          : double.tryParse(_maxPriceController.text.trim()),
      hasModel3D: _hasModel3D,
      status: _selectedStatus,
      sortBy: _selectedSortBy,
      order: _selectedOrder,
    );

    Navigator.pop(context, filters);
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _minPriceController.clear();
      _maxPriceController.clear();
      _selectedColorId = null; // Limpiar colorId
      _hasModel3D = null;
      _selectedStatus = 'active';
      _selectedSortBy = null;
      _selectedOrder = null;
    });
  }

  /// Parsea un código hexadecimal a Color
  Color _parseHexColor(String hexCode) {
    try {
      final hex = hexCode.replaceAll('#', '');
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      }
      return Colors.grey; // Color por defecto si el formato es incorrecto
    } catch (e) {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.filter_list,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Filtros',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ],
              ),
            ),

            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Búsqueda
                    _buildSectionTitle('Búsqueda', Icons.search),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Buscar productos...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Color
                    _buildSectionTitle('Color', Icons.palette),
                    const SizedBox(height: 8),
                    _isLoadingColors
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : _availableColors.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'No hay colores disponibles',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children:
                                    (_showAllColors
                                            ? _availableColors
                                            : _availableColors.take(6))
                                        .map((color) {
                                          final isSelected =
                                              _selectedColorId == color.id;
                                          return FilterChip(
                                            label: Text(color.name),
                                            avatar: color.hexCode != null
                                                ? CircleAvatar(
                                                    backgroundColor:
                                                        _parseHexColor(
                                                          color.hexCode!,
                                                        ),
                                                    radius: 12,
                                                  )
                                                : null,
                                            selected: isSelected,
                                            onSelected: (selected) {
                                              setState(() {
                                                _selectedColorId = selected
                                                    ? color.id
                                                    : null;
                                              });
                                            },
                                          );
                                        })
                                        .toList(),
                              ),
                              if (_availableColors.length > 6) ...[
                                const SizedBox(height: 8),
                                TextButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      _showAllColors = !_showAllColors;
                                    });
                                  },
                                  icon: Icon(
                                    _showAllColors
                                        ? Icons.expand_less
                                        : Icons.expand_more,
                                  ),
                                  label: Text(
                                    _showAllColors
                                        ? 'Ver menos'
                                        : 'Ver más (${_availableColors.length - 6} más)',
                                  ),
                                ),
                              ],
                            ],
                          ),
                    const SizedBox(height: 24),

                    // Rango de precio
                    _buildSectionTitle('Rango de Precio', Icons.attach_money),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _minPriceController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Mínimo',
                              prefixText: '€ ',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _maxPriceController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Máximo',
                              prefixText: '€ ',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Modelo 3D
                    _buildSectionTitle('Características', Icons.view_in_ar),
                    const SizedBox(height: 8),
                    CheckboxListTile(
                      title: const Text('Tiene modelo 3D'),
                      subtitle: const Text(
                        'Ver productos con visualización AR',
                      ),
                      value: _hasModel3D,
                      tristate: true,
                      onChanged: (value) {
                        setState(() {
                          _hasModel3D = value;
                        });
                      },
                      secondary: const Icon(Icons.view_in_ar),
                    ),
                    const SizedBox(height: 24),

                    // Ordenamiento
                    _buildSectionTitle('Ordenar por', Icons.sort),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedSortBy,
                      decoration: const InputDecoration(
                        hintText: 'Seleccionar orden',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.sort),
                      ),
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('Sin ordenar'),
                        ),
                        ..._sortOptions.entries.map((entry) {
                          return DropdownMenuItem(
                            value: entry.key,
                            child: Text(entry.value),
                          );
                        }),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedSortBy = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Orden (ASC/DESC)
                    if (_selectedSortBy != null) ...[
                      SegmentedButton<String>(
                        segments: _orderOptions.entries.map((entry) {
                          return ButtonSegment(
                            value: entry.key,
                            label: Text(entry.value),
                            icon: Icon(
                              entry.key == 'ASC'
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                            ),
                          );
                        }).toList(),
                        selected: {_selectedOrder ?? 'ASC'},
                        onSelectionChanged: (Set<String> newSelection) {
                          setState(() {
                            _selectedOrder = newSelection.first;
                          });
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Footer - Botones
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: theme.colorScheme.outlineVariant),
                ),
              ),
              child: Row(
                children: [
                  // Botón limpiar
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _clearFilters,
                      icon: const Icon(Icons.clear_all),
                      label: const Text('Limpiar'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Botón aplicar
                  Expanded(
                    flex: 2,
                    child: FilledButton.icon(
                      onPressed: _applyFilters,
                      icon: const Icon(Icons.check),
                      label: const Text('Aplicar Filtros'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
