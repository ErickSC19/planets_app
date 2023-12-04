import 'dart:io';

import 'package:astronomy_app/src/models/celestial_body.dart';
import 'package:astronomy_app/src/models/celestial_system.dart';
import 'package:astronomy_app/src/pages/body_form.dart';
import 'package:astronomy_app/src/pages/celestial_body_screen.dart';
import 'package:astronomy_app/src/services/db_helper.dart';
import 'package:astronomy_app/src/widgets/body_card.dart';
import 'package:astronomy_app/src/widgets/system_card.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(system.name,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w600)),
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
            Container(
              height: 100,
              child: getCelestialSystemsImageGrid(),
            ),
            Row(
              children: [],
            ),
            Container(
                width: 100,
                height: 100,
                child: ListView(
                  children: [],
                ))
          ],
        ),
      ),
    );
  }

  FutureBuilder<List<CelestialBody>> getCelestialSystemsImageGrid() {
    return FutureBuilder<List<CelestialBody>>(
      future: DBHelper.getCelestialBodies(),
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
