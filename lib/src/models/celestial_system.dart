// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class CelestialSystem {
  final int? id;
  final String name;
  final String imagePath;

  CelestialSystem({
    this.id,
    required this.name,
    required this.imagePath,
  });

  CelestialSystem copyWith({
    int? id,
    String? name,
    String? imagePath,
  }) {
    return CelestialSystem(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'imagePath': imagePath,
    };
  }

  factory CelestialSystem.fromMap(Map<String, dynamic> map) {
    return CelestialSystem(
      id: map['id'] as int,
      name: map['name'] as String,
      imagePath: map['imagePath'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CelestialSystem.fromJson(String source) =>
      CelestialSystem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'CelestialSystem(id: $id, name: $name, imagePath: $imagePath)';

  @override
  bool operator ==(covariant CelestialSystem other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.imagePath == imagePath;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ imagePath.hashCode;
}
