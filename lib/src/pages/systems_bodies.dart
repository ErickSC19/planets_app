import 'dart:io';

import 'package:astronomy_app/src/models/celestial_body.dart';
import 'package:astronomy_app/src/models/celestial_system.dart';
import 'package:astronomy_app/src/pages/body_form.dart';
import 'package:astronomy_app/src/pages/celestial_body_screen.dart';
import 'package:astronomy_app/src/services/db_helper.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class SystemBodies extends StatefulWidget {
  const SystemBodies({super.key});

  @override
  State<SystemBodies> createState() => _SystemBodiesState();
}

class _SystemBodiesState extends State<SystemBodies> {
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
                    style:
                        const TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
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
            getCelestialSystemsImageGrid(),
            Row(
              children: [],
            ),
            ListView(
              children: [],
            )
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
            clipBehavior: Clip.hardEdge,
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              return ExtendedImage.file(
                File(snapshot.data![index].imagePath),
                fit: BoxFit.cover,
                filterQuality: FilterQuality.low,
                cacheHeight: 1000,
                cacheWidth: 1000,
                scale: 0.1,
                enableLoadState: true,
                loadStateChanged: (ExtendedImageState state) {
                  switch (state.extendedImageLoadState) {
                    case LoadState.loading:
                      //_controller.reset();
                      return Image.asset(
                        "assets/images/ckram.gif",
                        fit: BoxFit.cover,
                      );
                    //break;

                    case LoadState.completed:
                      // _controller.forward();
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CelestialBodyScreen(),
                              // Pass the arguments as part of the RouteSettings. The
                              // DetailScreen reads the arguments from these settings.
                              settings: RouteSettings(
                                arguments: snapshot.data![index],
                              ),
                            ),
                          );
                        },
                        child: ExtendedRawImage(
                          image: state.extendedImageInfo?.image,
                          fit: BoxFit.cover,
                        ),
                      );
                    //break;
                    case LoadState.failed:
                      return GestureDetector(
                        child: Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            Image.asset(
                              "assets/images/error.png",
                              fit: BoxFit.cover,
                            ),
                            const Positioned(
                              bottom: 0.0,
                              left: 0.0,
                              right: 0.0,
                              child: Text(
                                "load image failed, click to reload",
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                        onTap: () {
                          state.reLoadImage();
                        },
                      );
                    // break;
                  }
                },
              ); //Image.file(File(snapshot.data![index].imagePath), fit: BoxFit.cover,);
            },
          );
        }
      },
    );
  }
}
