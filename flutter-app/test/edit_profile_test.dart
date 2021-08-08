import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pim/screens/my_account/edit_profile.dart';

void main() {
  testWidgets('Edit account widget test', (WidgetTester tester) async {
  
    final widget = MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Setting UI",
      home: EditProfilePage(),
    );

    await tester.pumpWidget(widget);
    
    expect(find.byType(FutureBuilder), findsWidgets);

    await tester.pump(Duration(seconds: 12));
    expect(find.byType(FutureBuilder), findsWidgets);
  });
}
