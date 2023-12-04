import 'package:astronomy_app/src/models/celestial_body.dart';
import 'package:astronomy_app/src/models/celestial_system.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'celestial_bodies.db'),
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE celestial_bodies(id INTEGER PRIMARY KEY, name TEXT, description TEXT, type TEXT, majorityNature TEXT, size REAL, distanceFromEarth REAL, imagePath TEXT, systemId INTEGER)",
        );
        await db.execute(
            "CREATE TABLE celestial_systems(id INTEGER PRIMARY KEY, name TEXT, imagePath TEXT)");
      },
      version: 1,
    );
  }

  static Future<void> deleteAllRecords() async {
    final db = await DBHelper.database();

    // Delete all records
    await db.delete('celestial_bodies');

    // Reset the ID counter
    await db.setVersion(1);
  }

  static Future<void> saveCelestialSystem(
      CelestialSystem celestialSystem) async {
    final db = await DBHelper.database();
    final List<Map<String, dynamic>> maps = await db.query(
      'celestial_systems',
      where: 'id = ?',
      whereArgs: [celestialSystem.id],
    );
    if (maps.isNotEmpty) {
      await db.update(
        'celestial_systems',
        celestialSystem.toMap(),
        where: 'name = ?',
        whereArgs: [celestialSystem.name],
      );
    } else {
      await db.insert(
        'celestial_systems',
        celestialSystem.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  static Future<List<CelestialSystem>> getCelestialSystems() async {
    final db = await DBHelper.database();
    final List<Map<String, dynamic>> maps = await db.query('celestial_systems');
    return List.generate(maps.length, (i) {
      return CelestialSystem(
          id: maps[i]['id'],
          name: maps[i]['name'],
          imagePath: maps[i]['imagePath']);
    });
  }

  static Future<List<CelestialSystem>> getSystemById(int systemId) async {
    final db = await DBHelper.database();
    final List<Map<String, dynamic>> maps = await db.query(
      'celestial_systems',
      where: 'id = ?',
      whereArgs: [systemId],
    );
    return List.generate(maps.length, (i) {
      return CelestialSystem(
          id: maps[i]['id'],
          name: maps[i]['name'],
          imagePath: maps[i]['imagePath']);
    });
  }

  static Future<void> saveCelestialBody(CelestialBody celestialBody) async {
    final db = await DBHelper.database();
    final List<Map<String, dynamic>> maps = await db.query(
      'celestial_bodies',
      where: 'id = ?',
      whereArgs: [celestialBody.id],
    );
    if (maps.isNotEmpty) {
      await db.update(
        'celestial_bodies',
        celestialBody.toMap(),
        where: 'name = ?',
        whereArgs: [celestialBody.name],
      );
    } else {
      await db.insert(
        'celestial_bodies',
        celestialBody.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  static Future<void> deleteCelestialBody(CelestialBody celestialBody) async {
    final db = await DBHelper.database();
    await db.delete(
      'celestial_bodies',
      where: 'id = ?',
      whereArgs: [celestialBody.id],
    );
  }

  static Future<List<CelestialBody>> getSystemBodies(int systemId) async {
    final db = await DBHelper.database();
    final List<Map<String, dynamic>> maps = await db.query(
      'celestial_bodies',
      where: 'systemId = ?',
      whereArgs: [systemId],
    );
    return List.generate(maps.length, (i) {
      return CelestialBody(
          id: maps[i]['id'],
          name: maps[i]['name'],
          description: maps[i]['description'],
          type: maps[i]['type'],
          majorityNature: maps[i]['majorityNature'],
          size: maps[i]['size'],
          distanceFromEarth: maps[i]['distanceFromEarth'],
          imagePath: maps[i]['imagePath'],
          systemId: maps[i]['systemId']);
    });
  }

  static Future<List<CelestialBody>> getCelestialBodies() async {
    final db = await DBHelper.database();
    final List<Map<String, dynamic>> maps = await db.query('celestial_bodies');
    return List.generate(maps.length, (i) {
      return CelestialBody(
          id: maps[i]['id'],
          name: maps[i]['name'],
          description: maps[i]['description'],
          type: maps[i]['type'],
          majorityNature: maps[i]['majorityNature'],
          size: maps[i]['size'],
          distanceFromEarth: maps[i]['distanceFromEarth'],
          imagePath: maps[i]['imagePath'],
          systemId: maps[i]['systemId']);
    });
  }
}
