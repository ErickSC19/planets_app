import 'package:astronomy_app/src/provider/app_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum MaterLabel {
  rock('Rock', Icons.sentiment_satisfied_outlined),
  gas(
    'Gas',
    Icons.cloud_outlined,
  ),
  ice('Ice', Icons.brush_outlined);

  const MaterLabel(this.label, this.icon);
  final String label;
  final IconData icon;
}

class DropdownMater extends StatefulWidget {
  const DropdownMater({super.key});

  @override
  State<DropdownMater> createState() => _DropdownMaterState();
}

class _DropdownMaterState extends State<DropdownMater> {
  final TextEditingController typeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateModel>(
        builder: (context, value, child) => DropdownButton<String>(
              value: value.materialType,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.white),
              underline: Container(
                height: 2,
                color: Colors.white,
              ),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                final appState = context.read<AppStateModel>();
                appState.changeMaterial(value);
              },
              items: MaterLabel.values.map<DropdownMenuItem<String>>(
                (MaterLabel bodyType) {
                  return DropdownMenuItem<String>(
                    value: bodyType.label,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(bodyType.icon),
                        SizedBox(width: 16),
                        Text(
                          bodyType.label,
                          style: TextStyle(fontSize: 20),
                        )
                      ],
                    ),
                  );
                },
              ).toList(),
            ));
  }
}
