import 'package:astronomy_app/src/provider/app_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum TypeLabel {
  planet('Planet', Icons.sentiment_satisfied_outlined),
  comet(
    'Comet',
    Icons.cloud_outlined,
  ),
  moon('Moon', Icons.brush_outlined),
  asteroid('Asteroid', Icons.favorite);

  const TypeLabel(this.label, this.icon);
  final String label;
  final IconData icon;
}

class DropdownType extends StatefulWidget {
  const DropdownType({super.key});

  @override
  State<DropdownType> createState() => _DropdownTypeState();
}

class _DropdownTypeState extends State<DropdownType> {
  final TextEditingController typeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateModel>(
        builder: (context, value, child) => DropdownButton<String>(
              value: value.bodyType,
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
                appState.changeType(value);
              },
              items: TypeLabel.values.map<DropdownMenuItem<String>>(
                (TypeLabel bodyType) {
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
