import 'dart:io';
import 'package:astronomy_app/src/pages/system_form.dart';
import 'package:astronomy_app/src/pages/systems_bodies.dart';
import 'package:extended_image/extended_image.dart';
import 'package:astronomy_app/src/models/celestial_system.dart';
import 'package:astronomy_app/src/services/db_helper.dart';
import 'package:flutter/material.dart';

class SystemsScreen extends StatefulWidget {
  const SystemsScreen({super.key});

  @override
  State<SystemsScreen> createState() => _SystemsScreenState();
}

class _SystemsScreenState extends State<SystemsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Systems',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SystemForm()),
                        );
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white70,
                        size: 36,
                      ))
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: getCelestialSystemsImageGrid(),
            )
          ],
        ),
      ),
    );
  }

  FutureBuilder<List<CelestialSystem>> getCelestialSystemsImageGrid() {
    return FutureBuilder<List<CelestialSystem>>(
      future: DBHelper.getCelestialSystems(),
      builder: (BuildContext context,
          AsyncSnapshot<List<CelestialSystem>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Image.asset(
            "assets/images/ckram.gif",
            fit: BoxFit.contain,
            scale: 0.1,
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return GridView.builder(
            shrinkWrap: true,
            clipBehavior: Clip.hardEdge,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
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
                              builder: (context) => const SystemBodies(),
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
