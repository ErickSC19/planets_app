import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  MyWidget({super.key, required this.planetId});
  final String planetId;
  
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}