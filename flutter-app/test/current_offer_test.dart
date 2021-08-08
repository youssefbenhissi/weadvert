import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pim/screens/my_account/edit_car.dart';
import 'package:pim/screens/profile/components/current_offre.dart';

void main() {
  testWidgets('Current offer widget test', (WidgetTester tester) async {
   
    final widget = MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Setting UI",
      home: CurrentOffre(),
    );

    await tester.pumpWidget(widget);
    
    expect(find.byType(FutureBuilder), findsWidgets);
    
  });
}
