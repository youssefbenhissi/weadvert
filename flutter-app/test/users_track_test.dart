import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pim/screens/annonceur_side/current_users.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
void main() {
  testWidgets('Current users track widget test', (WidgetTester tester) async {
   
    final widget = MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Setting UI",
      home: CurrentUsersPositions(PopupSnap.markerTop),
    );

    await tester.pumpWidget(widget);
    
    expect(find.byType(FlutterMap), findsOneWidget);
  });
}

