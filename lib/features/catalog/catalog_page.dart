import 'package:flutter/material.dart';
import 'package:proyecto_1/core/widgets/button.dart';
import 'package:proyecto_1/core/widgets/dropdown.dart';
import 'package:proyecto_1/core/widgets/general_chip.dart';
import 'package:proyecto_1/core/widgets/toggle.dart';
import 'package:proyecto_1/core/widgets/loading_indicator.dart';
import 'package:proyecto_1/core/utils/snackbar.dart';
import 'package:proyecto_1/core/widgets/error_view.dart';
import 'package:proyecto_1/core/widgets/empty_state.dart';
import 'package:proyecto_1/core/widgets/color_chip.dart';
import 'package:proyecto_1/core/models/color.dart';

/// Página de catálogo que muestra todos los widgets generales disponibles.
///
/// Esta página sirve como documentación viva de los componentes reutilizables
/// y permite visualizar su comportamiento y apariencia.
class GeneralWidgetsCatalogPage extends StatefulWidget {
  const GeneralWidgetsCatalogPage({super.key});

  @override
  State<GeneralWidgetsCatalogPage> createState() =>
      _GeneralWidgetsCatalogPageState();
}

class _GeneralWidgetsCatalogPageState extends State<GeneralWidgetsCatalogPage> {
  // Estado de ejemplo para los widgets
  bool switchValue = false;
  String selectedOption = 'Op 1';
  int selectedChip = 0;
  String selectedColorId = '1';

  // Colores de ejemplo para ColorChipWithCircle
  final List<ColorModel> exampleColors = [
    ColorModel(id: '1', name: 'Rojo', hexCode: '#FF0000'),
    ColorModel(id: '2', name: 'Azul', hexCode: '#0000FF'),
    ColorModel(id: '3', name: 'Verde', hexCode: '#00FF00'),
    ColorModel(id: '4', name: 'Amarillo', hexCode: '#FFFF00'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catálogo Widgets Generales')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // ========== WIDGETS ORIGINALES ==========
            _buildSectionTitle('🧩 GeneralToggle'),
            GeneralToggle(
              title: 'Activar notificaciones',
              subtitle: 'Ejemplo de interruptor general',
              icon: Icons.notifications,
              value: switchValue,
              onChanged: (value) {
                setState(() {
                  switchValue = value;
                });
              },
            ),
            const Divider(height: 32),

            _buildSectionTitle('📋 GeneralDropdown'),
            GeneralDropdown<String>(
              title: 'Selecciona una opción',
              value: selectedOption,
              icon: Icons.arrow_drop_down,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedOption = value;
                  });
                }
              },
              items: const [
                DropdownMenuItem(value: 'Op 1', child: Text('Op 1')),
                DropdownMenuItem(value: 'Op 2', child: Text('Op 2')),
                DropdownMenuItem(value: 'Op 3', child: Text('Op 3')),
              ],
            ),
            const Divider(height: 32),

            _buildSectionTitle('🏷️ GeneralChip'),
            Wrap(
              spacing: 8,
              children: List.generate(3, (index) {
                return GeneralChip(
                  label: 'Chip ${index + 1}',
                  isSelected: selectedChip == index,
                  onSelected: () {
                    setState(() {
                      selectedChip = selectedChip == index ? -1 : index;
                    });
                  },
                );
              }),
            ),
            const Divider(height: 32),

            _buildSectionTitle('🔘 GeneralButton'),
            GeneralButton(
              label: 'Botón de ejemplo',
              onPressed: () {
                GeneralSnackBar.success(context, '¡Botón presionado!');
              },
            ),
            const Divider(height: 32),

            // ========== NUEVOS WIDGETS ==========
            _buildSectionTitle('⏳ GeneralLoadingIndicator'),
            const Text(
              'Inline (siempre visible en catálogo):',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 8),
            const GeneralLoadingIndicator(
              size: 30,
              message: 'Cargando datos...',
            ),
            const SizedBox(height: 16),
            GeneralButton(
              label: 'Ver Loading Pantalla Completa',
              icon: Icons.hourglass_empty,
              onPressed: () {
                // Mostrar loading overlay por 2 segundos
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const GeneralLoadingIndicator(
                    fullScreen: true,
                    size: 50,
                    message: 'Procesando...',
                  ),
                );
                Future.delayed(const Duration(seconds: 2), () {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                });
              },
            ),
            const Divider(height: 32),

            _buildSectionTitle('💬 GeneralSnackBar'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: () =>
                      GeneralSnackBar.success(context, '¡Operación exitosa!'),
                  icon: const Icon(Icons.check_circle),
                  label: const Text('Éxito'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () =>
                      GeneralSnackBar.error(context, 'Error al procesar'),
                  icon: const Icon(Icons.error),
                  label: const Text('Error'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () =>
                      GeneralSnackBar.info(context, 'Información importante'),
                  icon: const Icon(Icons.info),
                  label: const Text('Info'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () =>
                      GeneralSnackBar.warning(context, 'Advertencia detectada'),
                  icon: const Icon(Icons.warning),
                  label: const Text('Warning'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade700,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const Divider(height: 32),

            _buildSectionTitle('❌ GeneralErrorView'),
            Container(
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: GeneralErrorView(
                message: 'No se pudieron cargar los datos',
                onRetry: () {
                  GeneralSnackBar.info(context, 'Reintentando...');
                },
              ),
            ),
            const Divider(height: 32),

            _buildSectionTitle('📭 GeneralEmptyState'),
            Container(
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                child: SizedBox(
                  height: 300,
                  child: GeneralEmptyState(
                    icon: Icons.favorite_border,
                    iconSize: 64, // Reducido de 80 a 64
                    title: 'No tienes favoritos',
                    subtitle: 'Añade productos a tu lista de favoritos',
                    actionLabel: 'Explorar productos',
                    onAction: () {
                      GeneralSnackBar.info(context, 'Navegando a productos...');
                    },
                  ),
                ),
              ),
            ),
            const Divider(height: 32),

            _buildSectionTitle('🎨 ColorChipWithCircle'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: exampleColors.map((color) {
                return ColorChipWithCircle(
                  colorModel: color,
                  isSelected: selectedColorId == color.id,
                  onSelected: () {
                    setState(() {
                      selectedColorId = color.id;
                    });
                  },
                  showLabel: true,
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Text(
              'Color seleccionado: ${exampleColors.firstWhere((c) => c.id == selectedColorId).name}',
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  /// Helper para construir títulos de sección consistentes
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
