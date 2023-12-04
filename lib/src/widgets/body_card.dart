import 'dart:io';

import 'package:astronomy_app/src/models/celestial_body.dart';
import 'package:astronomy_app/src/pages/celestial_body_screen.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class SBodyCard extends StatelessWidget {
  const SBodyCard({required this.body, this.hideName = true, super.key});

  final CelestialBody body;
  final bool hideName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: !hideName ? 130 : 275,
      padding: const EdgeInsets.all(8),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: ExtendedImage.file(
          File(body.imagePath),
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
                          builder: (context) => const CelestialBodyScreen(),
                          // Pass the arguments as part of the RouteSettings. The
                          // DetailScreen reads the arguments from these settings.
                          settings: RouteSettings(
                            arguments: body,
                          ),
                        ),
                      );
                    },
                    child: !hideName
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ExtendedRawImage(
                                image: state.extendedImageInfo?.image,
                                fit: BoxFit.cover,
                              ),
                              Text(
                                body.name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white),
                              )
                            ],
                          )
                        : ExtendedRawImage(
                            image: state.extendedImageInfo?.image,
                            fit: BoxFit.cover,
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
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: <Color>[
                                    Colors.black,
                                    Colors.transparent
                                  ]),
                            ),
                          )),
                      const Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Text(
                          "load image failed, click to reload",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
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
        ),
      ),
    );
  }
}
