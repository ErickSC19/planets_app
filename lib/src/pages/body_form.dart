import 'dart:io';

import 'package:astronomy_app/src/models/celestial_body.dart';
import 'package:astronomy_app/src/models/celestial_system.dart';
import 'package:astronomy_app/src/pages/systems_bodies.dart';
import 'package:astronomy_app/src/provider/app_state_provider.dart';
import 'package:astronomy_app/src/services/db_helper.dart';
import 'package:astronomy_app/src/widgets/dropdown_mater.dart';
import 'package:astronomy_app/src/widgets/dropdown_type.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

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
  final sizeController = TextEditingController();
  final distanceController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    descrController.dispose();
    sizeController.dispose();
    distanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sysId = ModalRoute.of(context)!.settings.arguments as int;
    // Build a Form widget using the _formKey created above.
    return Consumer<AppStateModel>(
        builder: (context, value, child) => Scaffold(
              body: ListView(
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 32),
                      child: Column(
                        textDirection: TextDirection.ltr,
                        children: [
                          const Text(
                            'Add a new Celestial Body',
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
                                  controller: nameController,
                                  // The validator receives the text that the user has entered.
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter the name';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                const Text('Body description'),
                                TextFormField(
                                  controller: descrController,
                                  // The validator receives the text that the user has entered.
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a descripton';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                const Text('Size'),
                                TextFormField(
                                  controller: sizeController,
                                  keyboardType: TextInputType.number,
                                  // The validator receives the text that the user has entered.
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter the size';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                const Text('Distance'),
                                TextFormField(
                                  controller: distanceController,
                                  keyboardType: TextInputType.number,
                                  // The validator receives the text that the user has entered.
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter the size';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                const DropdownMater(),
                                const SizedBox(
                                  height: 8,
                                ),
                                const DropdownType(),
                                const SizedBox(
                                  height: 32,
                                ),
                                const Text('Celestial Body Image'),
                                const SizedBox(
                                  height: 16,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                        onPressed: () async {
                                          try {
                                            final img = await ImagePicker()
                                                .pickImage(
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
                                            final img = await ImagePicker()
                                                .pickImage(
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
                                image?.path != null && image?.path != ""
                                    ? Image.file(File(image!.path))
                                    : const Text('--Select an image--',
                                        textAlign: TextAlign.center),
                                const SizedBox(
                                  height: 36,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      // Validate returns true if the form is valid, or false otherwise.
                                      if (_formKey.currentState!.validate() &&
                                          image != null) {
                                        try {
                                          final celestialBody = CelestialBody(
                                              name: nameController.text,
                                              description: descrController.text,
                                              type: value.bodyType,
                                              majorityNature:
                                                  value.materialType,
                                              size: double.parse(
                                                  sizeController.text),
                                              distanceFromEarth: double.parse(
                                                  distanceController.text),
                                              imagePath: image!.path,
                                              systemId: sysId);
                                          await DBHelper.saveCelestialBody(
                                              celestialBody);
                                          final system =
                                              await DBHelper.getSystemById(
                                                  sysId);
                                          setState(() {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
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
                                        // If the form is valid, display a snackbar. In the real world,
                                        // you'd often call a server or save the information in a database.
                                        // ScaffoldMessenger.of(context).showSnackBar(
                                        //   const SnackBar(content: Text('Processing Data')),
                                        // );
                                      } else {
                                        if (image == null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content:
                                                    Text('Select an image.')),
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
                      ))
                ],
              ),
            ));
  }
}
