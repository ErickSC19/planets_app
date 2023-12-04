import 'package:astronomy_app/src/provider/app_state_provider.dart';
import 'package:astronomy_app/src/widgets/custom_icons_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FiltersBar extends StatefulWidget {
  const FiltersBar({super.key});

  @override
  State<FiltersBar> createState() => _FiltersBarState();
}

class _FiltersBarState extends State<FiltersBar> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateModel>(
        builder: (context, value, child) => Row(
              children: [
                IconButton(
                    onPressed: () {
                      final appState = context.read<AppStateModel>();
                      if (appState.typeFilter == 'Planet') {
                        appState.changeTypeFilter(null);
                      } else {
                        appState.changeTypeFilter('Planet');
                      }
                    },
                    icon: const Icon(
                      Icons.public,
                      size: 16,
                    ),
                    color: value.typeFilter == 'Planet'
                        ? Colors.white
                        : Colors.white38),
                IconButton(
                  onPressed: () {
                    final appState = context.read<AppStateModel>();
                    if (appState.typeFilter == 'Comet') {
                      appState.changeTypeFilter(null);
                    } else {
                      appState.changeTypeFilter('Comet');
                    }
                  },
                  icon: const Icon(
                    CustomIcons.comet,
                    size: 16,
                  ),
                  color: value.typeFilter == 'Comet'
                      ? Colors.white
                      : Colors.white38,
                ),
                IconButton(
                  onPressed: () {
                    final appState = context.read<AppStateModel>();
                    if (appState.typeFilter == 'Moon') {
                      appState.changeTypeFilter(null);
                    } else {
                      appState.changeTypeFilter('Moon');
                    }
                  },
                  icon: const Icon(
                    Icons.nightlight_rounded,
                    size: 16,
                  ),
                  color: value.typeFilter == 'Moon'
                      ? Colors.white
                      : Colors.white38,
                ),
                IconButton(
                  onPressed: () {
                    final appState = context.read<AppStateModel>();
                    if (appState.typeFilter == 'Asteroid') {
                      appState.changeTypeFilter(null);
                    } else {
                      appState.changeTypeFilter('Asteroid');
                    }
                  },
                  icon: const Icon(
                    CustomIcons.asteroid,
                    size: 16,
                  ),
                  color: value.typeFilter == 'Asteroid'
                      ? Colors.white
                      : Colors.white38,
                )
              ],
            ));
  }
}
