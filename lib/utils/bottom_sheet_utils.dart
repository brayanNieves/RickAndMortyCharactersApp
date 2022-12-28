import 'package:flutter/material.dart';

class BottomSheetUtils {
  static Future<dynamic> open(context,
      {required Widget widget, bool isScrollControlled = false}) async {
    return await showModalBottomSheet(
        isScrollControlled: isScrollControlled,
        useRootNavigator: true,
        elevation: 100,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: (BuildContext bc) {
          return widget;
        });
  }
}
