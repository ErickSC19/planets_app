import 'dart:io';

import 'package:astronomy_app/src/models/celestial_body.dart';
import 'package:astronomy_app/src/models/celestial_system.dart';
import 'package:astronomy_app/src/pages/body_form.dart';
import 'package:astronomy_app/src/pages/celestial_body_screen.dart';
import 'package:astronomy_app/src/provider/app_state_provider.dart';
import 'package:astronomy_app/src/services/db_helper.dart';
import 'package:astronomy_app/src/widgets/body_card.dart';
import 'package:astronomy_app/src/widgets/filters_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SystemBodies extends StatefulWidget {
  const SystemBodies({super.key});

  @override
  State<SystemBodies> createState() => _SystemBodiesState();
}

class _SystemBodiesState extends State<SystemBodies> {
  String? selectedType;

  void changeFilter(val) {
    setState(() {
      selectedType = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    final system =
        ModalRoute.of(context)!.settings.arguments as CelestialSystem;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(
              height: 24,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Planets',
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.w600)),
                    Text(system.name,
                        style: const TextStyle(
                            fontSize: 16, color: Colors.white70)),
                  ],
                ),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BodyForm(),
                          settings: RouteSettings(
                            arguments: system.id,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white70,
                      size: 36,
                    ))
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              height: 400,
              child: getCelestialBodiesImages(),
            ),
            SizedBox(
              height: 16,
            ),
            const FiltersBar(),
            SizedBox(
              height: 16,
            ),
            Container(
              height: 180,
              child: getCelestialBodiesFilter(),
            )
          ],
        ),
      ),
    );
  }

  FutureBuilder<List<CelestialBody>> getCelestialBodiesFilter() {
    final system =
        ModalRoute.of(context)!.settings.arguments as CelestialSystem;
    return FutureBuilder<List<CelestialBody>>(
      future: DBHelper.getSystemBodies(system.id as int),
      builder:
          (BuildContext context, AsyncSnapshot<List<CelestialBody>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Image.asset(
            "assets/images/ckram.gif",
            fit: BoxFit.contain,
            scale: 0.1,
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Consumer<AppStateModel>(
              builder: (context, value, child) => ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    clipBehavior: Clip.hardEdge,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext ct, int index) {
                      final appState = context.read<AppStateModel>();
                      switch (appState.typeFilter) {
                        case 'Planet':
                          if (snapshot.data![index].type == 'Planet') {
                            return SBodyCard(
                              body: snapshot.data![index],
                              hideName: false,
                            );
                          }
                          break;
                        case 'Comet':
                          if (snapshot.data![index].type == 'Comet') {
                            return SBodyCard(
                              body: snapshot.data![index],
                              hideName: false,
                            );
                          }
                          break;
                        case 'Moon':
                          if (snapshot.data![index].type == 'Moon') {
                            return SBodyCard(
                              body: snapshot.data![index],
                              hideName: false,
                            );
                          }
                          break;
                        case 'Asteroid':
                          if (snapshot.data![index].type == 'Asteroid') {
                            return SBodyCard(
                              body: snapshot.data![index],
                              hideName: false,
                            );
                          }
                          break;
                        default:
                          return SBodyCard(
                            body: snapshot.data![index],
                            hideName: false,
                          );
                      }
                      return null;
                    },
                  ));
        }
      },
    );
  }

  FutureBuilder<List<CelestialBody>> getCelestialBodiesImages() {
    final system =
        ModalRoute.of(context)!.settings.arguments as CelestialSystem;
    return FutureBuilder<List<CelestialBody>>(
      future: DBHelper.getSystemBodies(system.id as int),
      builder:
          (BuildContext context, AsyncSnapshot<List<CelestialBody>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Image.asset(
            "assets/images/ckram.gif",
            fit: BoxFit.contain,
            scale: 0.1,
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.hardEdge,
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              return SBodyCard(body: snapshot.data![index]);
            },
          );
        }
      },
    );
  }
}
