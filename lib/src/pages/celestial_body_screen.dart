import 'dart:io';

import 'package:flutter/material.dart';
import 'package:astronomy_app/src/models/celestial_body.dart';

class CelestialBodyScreen extends StatelessWidget {
  const CelestialBodyScreen({super.key});

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
                margin: const EdgeInsets.only(top: 28),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white70,
                          size: 36,
                        )),
                    IconButton(
                        onPressed: () {},
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
                      Icon(Icons.ac_unit, size: 16),
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
                      Icon(Icons.ac_unit, size: 16),
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
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.ac_unit, size: 16),
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
                      Icon(Icons.ac_unit, size: 16),
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
              SizedBox(height: 36),
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
