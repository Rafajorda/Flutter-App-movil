import 'package:flutter/material.dart';
import 'package:proyecto_1/core/widgets/button.dart';
import 'package:proyecto_1/core/widgets/dropdown.dart';
import 'package:proyecto_1/core/widgets/general_chip.dart';
import 'package:proyecto_1/core/widgets/toggle.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catalogo Widgets Generales')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              '🧩 GeneralToggle',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
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
            const Divider(),

            const Text(
              '📋 GeneralDropdown',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
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
            const Divider(),

            const Text(
              '🏷️ GeneralChip',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
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
            const Divider(),
            const Text(
              '🔘 GeneralButton',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            GeneralButton(label: 'Botón de ejemplo', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
