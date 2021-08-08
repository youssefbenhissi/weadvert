import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pim/screens/my_account/edit_car.dart';

void main() {
  testWidgets('Edit car widget test', (WidgetTester tester) async {
   
    final widget = MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Setting UI",
      home: EditCarPage(),
    );

    await tester.pumpWidget(widget);
    
    expect(find.byType(FutureBuilder), findsWidgets);
    
  });
}
