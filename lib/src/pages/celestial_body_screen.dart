import 'dart:io';

import 'package:astronomy_app/src/pages/systems_bodies.dart';
import 'package:astronomy_app/src/services/db_helper.dart';
import 'package:astronomy_app/src/widgets/custom_icons_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:astronomy_app/src/models/celestial_body.dart';

class CelestialBodyScreen extends StatefulWidget {
  const CelestialBodyScreen({super.key});

  @override
  State<CelestialBodyScreen> createState() => _CelestialBodyScreenState();
}

class _CelestialBodyScreenState extends State<CelestialBodyScreen> {
  static const Map materIcons = {
    'Rock': CustomIcons.stone,
    'Gas': Icons.cloud_outlined,
    'Ice': Icons.ac_unit,
    'Liquid': Icons.water
  };

  static const Map typeIcons = {
    'Planet': Icons.public,
    'Comet': CustomIcons.comet,
    'Moon': Icons.nightlight_rounded,
    'Asteroid': CustomIcons.asteroid
  };

  @override
  Widget build(BuildContext context) {
    final body = ModalRoute.of(context)!.settings.arguments as CelestialBody;
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 400,
              width: double.infinity,
              child: Image.file(File(body.imagePath), fit: BoxFit.cover),
            ),
            Container(
                margin: const EdgeInsets.only(top: 30),
                color: const Color.fromRGBO(0, 0, 0, 0.479),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            Navigator.pop(context);
                          });
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white70,
                          size: 36,
                        )),
                    IconButton(
                        onPressed: () async {
                          try {
                            await DBHelper.deleteCelestialBody(body);
                            final system =
                                await DBHelper.getSystemById(body.systemId);
                            setState(() {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const SystemBodies(),
                                    settings: RouteSettings(
                                      arguments: system[0],
                                    ),
                                  ));
                            });
                          } catch (e) {
                            if (kDebugMode) {
                              print(e);
                            }
                          }
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.white70,
                          size: 36,
                        ))
                  ],
                )),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    body.name,
                    overflow: TextOverflow.clip,
                    style: const TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.none,
                        fontSize: 52),
                  )
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(typeIcons[body.type], size: 16),
                      const SizedBox(width: 8),
                      Text(
                        body.type,
                        style: const TextStyle(
                            color: Colors.white70,
                            decoration: TextDecoration.none,
                            fontSize: 24),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(CustomIcons.radius, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        '${body.size} KM',
                        style: const TextStyle(
                            color: Colors.white70,
                            decoration: TextDecoration.none,
                            fontSize: 24),
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(materIcons[body.majorityNature], size: 16),
                      const SizedBox(width: 8),
                      Text(
                        body.majorityNature,
                        style: const TextStyle(
                            color: Colors.white70,
                            decoration: TextDecoration.none,
                            fontSize: 24),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(CustomIcons.distance, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        '${body.distanceFromEarth} KM',
                        style: const TextStyle(
                            color: Colors.white70,
                            decoration: TextDecoration.none,
                            fontSize: 24),
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(height: 36),
              Text(
                body.description,
                overflow: TextOverflow.clip,
                style: const TextStyle(
                    color: Colors.white70,
                    decoration: TextDecoration.none,
                    fontSize: 16),
              )
            ],
          ),
        )
      ],
    );
  }
}
