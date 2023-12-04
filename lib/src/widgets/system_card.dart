import 'dart:io';

import 'package:astronomy_app/src/models/celestial_system.dart';
import 'package:astronomy_app/src/pages/systems_bodies.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class SystemCard extends StatelessWidget {
  const SystemCard({required this.system, super.key});

  final CelestialSystem system;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30))),
      child: ExtendedImage.file(
        File(system.imagePath),
        fit: BoxFit.cover,
        filterQuality: FilterQuality.low,
        cacheHeight: 1000,
        cacheWidth: 1000,
        scale: 1,
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
                          arguments: system,
                        ),
                      ),
                    );
                  },
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ExtendedRawImage(
                        image: state.extendedImageInfo?.image,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                              height: 50,
                              padding: const EdgeInsets.only(bottom: 5),
                              alignment: AlignmentDirectional.bottomCenter,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: <Color>[
                                      Colors.black,
                                      Colors.transparent
                                    ]),
                              ),
                              child: Text(
                                system.name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white),
                              ))),
                    ],
                  ));
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
                    Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.only(bottom: 5),
                          alignment: AlignmentDirectional.bottomCenter,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: <Color>[
                                  Colors.black,
                                  Colors.transparent
                                ]),
                          ),
                          child: const Text(
                            "load image failed, click to reload",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        )),
                  ],
                ),
                onTap: () {
                  state.reLoadImage();
                },
              );
            // break;
          }
        },
      ),
    );
  }
}
