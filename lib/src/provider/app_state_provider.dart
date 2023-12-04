import 'package:flutter/material.dart';

class AppStateModel extends ChangeNotifier {
  String _bodyType = 'Planet';
  String get bodyType => _bodyType;
  String _materialType = 'Rock';
  String get materialType => _materialType;

  void changeType(val) {
    _bodyType = val;
    notifyListeners();
  }

  void changeMaterial(val) {
    _materialType = val;
    notifyListeners();
  }
}
