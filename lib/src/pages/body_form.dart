import 'dart:io';

import 'package:astronomy_app/src/models/celestial_body.dart';
import 'package:astronomy_app/src/models/celestial_system.dart';
import 'package:astronomy_app/src/services/db_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// Define a custom Form widget.
class BodyForm extends StatefulWidget {
  const BodyForm({super.key});

  @override
  BodyFormState createState() {
    return BodyFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class BodyFormState extends State<BodyForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<SystemFormState>.
  XFile? image;

  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final descrController = TextEditingController();
  final typeController = TextEditingController();
  final natController = TextEditingController();
  final sizeController = TextEditingController();
  final distanceController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    //setState(() {
    // image = null;
    //);
    nameController.dispose();
    descrController.dispose();
    typeController.dispose();
    natController.dispose();
    sizeController.dispose();
    distanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sysId = ModalRoute.of(context)!.settings.arguments as int;
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Column(
            textDirection: TextDirection.ltr,
            children: [
              const Text(
                'Add a new system',
                style: TextStyle(fontSize: 32),
              ),
              const SizedBox(
                height: 48,
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Body Name'),
                    TextFormField(
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the name';
                        }
                        return null;
                      },
                    ),
                    const Text('Body description'),
                    TextFormField(
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the name';
                        }
                        return null;
                      },
                    ),
                    const Text('Size'),
                    TextFormField(
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 36,
                    ),
                    const Text('System Image'),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            onPressed: () async {
                              try {
                                final img = await ImagePicker().pickImage(
                                    source: ImageSource.gallery,
                                    requestFullMetadata: true);
                                setState(() {
                                  image = img;
                                });
                              } catch (e) {
                                if (kDebugMode) {
                                  print(e);
                                }
                              }
                            },
                            icon: const Icon(
                              Icons.photo,
                              size: 64,
                            )),
                        IconButton(
                            onPressed: () async {
                              try {
                                final img = await ImagePicker().pickImage(
                                    source: ImageSource.camera,
                                    requestFullMetadata: true);
                                setState(() {
                                  image = img;
                                });
                              } catch (e) {
                                if (kDebugMode) {
                                  print(e);
                                }
                              }
                            },
                            icon: const Icon(
                              Icons.add_a_photo,
                              size: 64,
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    image?.path != ""
                        ? Image.file(File(image!.path))
                        : const FlutterLogo(),
                    const SizedBox(
                      height: 36,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: ElevatedButton(
                        onPressed: () async {
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_formKey.currentState!.validate() &&
                              image != null) {
                            try {
                              final celestialSystem = CelestialBody(
                                  name: nameController.text,
                                  description: descrController.text,
                                  type: typeController.text,
                                  majorityNature: natController.text,
                                  size: sizeController.text as double,
                                  distanceFromEarth:
                                      distanceController.text as double,
                                  imagePath: image!.path,
                                  systemId: sysId);
                              await DBHelper.saveCelestialBody(celestialSystem);
                              setState(() {
                                Navigator.pop(context);
                              });
                            } catch (e) {
                              if (kDebugMode) {
                                print(e);
                              }
                            }
                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   const SnackBar(content: Text('Processing Data')),
                            // );
                          } else {
                            if (image == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Select an image.')),
                              );
                            }
                          }
                        },
                        child: const Text('Add Celestial Body'),
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
