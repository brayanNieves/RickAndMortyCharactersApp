import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  Future<dynamic> pushScreen(Widget screen) async {
    return await Navigator.push(
        this, MaterialPageRoute(builder: (context) => screen));
  }

  void clearFocus() {
    FocusScopeNode currentFocus = FocusScope.of(this);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.focusedChild?.unfocus();
    }
  }
}
