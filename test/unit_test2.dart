import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Parse JSON and verify content', () {
    // JSON 字串，模擬從網路或本地讀取的 JSON 資料
    String jsonString = '''
    {
      "name": "John Doe",
      "age": 30,
      "city": "New York",
      "email": "john.doe@example.com",
      "phone": "+1234567890",
      "address": {
        "street": "123 Main Street",
        "city": "Anytown",
        "zipcode": "12345"
      },
      "friends": [
        {
          "name": "Jane Smith",
          "age": 28,
          "email": "jane.smith@example.com"
        },
        {
          "name": "Bob Johnson",
          "age": 32,
          "email": "bob.johnson@example.com"
        }
      ]
    }
    ''';

    // 將 JSON 資料解析為 Map<String, dynamic>
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    print(jsonMap);
    // 進行單元測試
    expect(jsonMap['name'], isNotEmpty);
    expect(jsonMap['age'], isNotNull);
    expect(jsonMap['city'], 'New York');
    expect(jsonMap['email'], 'john.doe@example.com');
    expect(jsonMap['phone'], '+1234567890');

    // Address 部分
    expect(jsonMap['address']['street'], '123 Main Street');
    expect(jsonMap['address']['city'], 'Anytown');
    expect(jsonMap['address']['zipcode'], '12345');

    // Friends 部分
    expect(jsonMap['friends'], isList);
    expect(jsonMap['friends'].length, 2);

    // 測試第一個朋友的資訊
    expect(jsonMap['friends'][0]['name'], 'Jane Smith');
    expect(jsonMap['friends'][0]['age'], 28);
    expect(jsonMap['friends'][0]['email'], 'jane.smith@example.com');

    // 測試第二個朋友的資訊
    expect(jsonMap['friends'][1]['name'], 'Bob Johnson');
    expect(jsonMap['friends'][1]['age'], 32);
    expect(jsonMap['friends'][1]['email'], 'bob.johnson@example.com');
  });
}
