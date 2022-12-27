import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  Future<dynamic> pushScreen(Widget screen) async {
    return await Navigator.push(
        this, MaterialPageRoute(builder: (context) => screen));
  }
}
