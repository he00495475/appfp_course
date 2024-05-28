import 'package:appfp_course/unitTestWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('UserWidget displays user details', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: UnitTestWidget(
        user: User(
          name: 'John Doe',
          age: 30,
          city: 'New York',
          email: 'john.doe@example.com',
          phone: '+1234567890',
          address: Address(
            street: '123 Main Street',
            city: 'Anytown',
            zipcode: '12345',
          ),
          friends: [
            Friend(
              name: 'Jane Smith',
              age: 28,
              email: 'jane.smith@example.com',
            ),
            Friend(
              name: 'Bob Johnson',
              age: 32,
              email: 'bob.johnson@example.com',
            ),
          ],
        ),
      ),
    ));

    // 在widget樹中尋找特定文本來驗證widget是否正確渲染
    expect(find.text('Name: John Doe'), findsOneWidget);
    expect(find.text('Age: 30'), findsOneWidget);
    expect(find.text('City: New York'), findsOneWidget);
    expect(find.text('Email: john.doe@example.com'), findsOneWidget);
    expect(find.text('Phone: +1234567890'), findsOneWidget);
    expect(find.text('Street: 123 Main Street'), findsOneWidget);
    expect(find.text('City: Anytown'), findsOneWidget);
    expect(find.text('Zipcode: 12345'), findsOneWidget);
    expect(find.text('Name: Jane Smith'), findsOneWidget);
    expect(find.text('Age: 28'), findsOneWidget);
    expect(find.text('Email: jane.smith@example.com'), findsOneWidget);
    expect(find.text('Name: Bob Johnson'), findsOneWidget);
    expect(find.text('Age: 32'), findsOneWidget);
    expect(find.text('Email: bob.johnson@example.com'), findsOneWidget);
  });
}
