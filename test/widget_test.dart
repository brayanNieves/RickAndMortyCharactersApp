// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rick_and_morty_characters_app/main.dart';

void main() {
  testWidgets('ListView.builder respects findChildIndexCallback', (WidgetTester tester) async {
    bool finderCalled = false;
    int itemCount = 7;
    late StateSetter stateSetter;
    await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              stateSetter = setState;
              return ListView.builder(
                itemCount: itemCount,
                itemBuilder: (BuildContext _, int index) => Container(
                  key: Key('$index'),
                  height: 2000.0,
                ),
                findChildIndexCallback: (Key key) {
                  finderCalled = true;
                  return null;
                },
              );
            },
          ),
        )
    );
    expect(finderCalled, false);
    // Trigger update.
    stateSetter(() => itemCount = 77);
    await tester.pump();
    expect(finderCalled, true);
  });

  testWidgets('ListView.builder respects findChildIndexCallback', (WidgetTester tester) async {
    await tester.drag(find.byKey(const Key('character-list')), const Offset(0.0, -300));
    await tester.pump();
  });
}
