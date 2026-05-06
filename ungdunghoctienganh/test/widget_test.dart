import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ungdunghoctienganh/main.dart';

void main() {
  testWidgets('renders the Home, Content and About screens', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MyApp());

    expect(find.text('English Learning App'), findsOneWidget);
    expect(find.text('Learn English with daily lessons'), findsOneWidget);
    expect(find.text('Submit'), findsOneWidget);

    await tester.tap(find.text('Content'));
    await tester.pumpAndSettle();

    expect(find.text('English Mastery'), findsOneWidget);
    expect(find.text('Learning Path'), findsOneWidget);
    expect(find.text('Study summary'), findsOneWidget);

    await tester.tap(find.text('About'));
    await tester.pumpAndSettle();

    expect(find.text('About'), findsWidgets);
    expect(find.text('App Info'), findsOneWidget);
    expect(find.text('Design Consistency'), findsOneWidget);
  });
}
