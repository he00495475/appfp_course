import 'package:flutter/material.dart';

class UnitTestWidget extends StatelessWidget {
  final User user;

  const UnitTestWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Name: ${user.name}',
              style: const TextStyle(fontSize: 18.0),
            ),
            Text(
              'Age: ${user.age}',
              style: const TextStyle(fontSize: 18.0),
            ),
            Text(
              'City: ${user.city}',
              style: const TextStyle(fontSize: 18.0),
            ),
            Text(
              'Email: ${user.email}',
              style: const TextStyle(fontSize: 18.0),
            ),
            Text(
              'Phone: ${user.phone}',
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Address:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Text(
              'Street: ${user.address.street}',
              style: const TextStyle(fontSize: 18.0),
            ),
            Text(
              'City: ${user.address.city}',
              style: const TextStyle(fontSize: 18.0),
            ),
            Text(
              'Zipcode: ${user.address.zipcode}',
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Friends:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: user.friends.map((friend) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Name: ${friend.name}',
                      style: const TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      'Age: ${friend.age}',
                      style: const TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      'Email: ${friend.email}',
                      style: const TextStyle(fontSize: 18.0),
                    ),
                    const SizedBox(height: 16.0),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// 定義 User 類別
class User {
  String name;
  int age;
  String city;
  String email;
  String phone;
  Address address;
  List<Friend> friends;

  User({
    required this.name,
    required this.age,
    required this.city,
    required this.email,
    required this.phone,
    required this.address,
    required this.friends,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      age: json['age'],
      city: json['city'],
      email: json['email'],
      phone: json['phone'],
      address: Address.fromJson(json['address']),
      friends: _parseFriends(json['friends']),
    );
  }

  static List<Friend> _parseFriends(List<dynamic> friendsJson) {
    return friendsJson
        .map((friendJson) => Friend.fromJson(friendJson))
        .toList();
  }
}

// 定義 Address 類別
class Address {
  String street;
  String city;
  String zipcode;

  Address({
    required this.street,
    required this.city,
    required this.zipcode,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'],
      city: json['city'],
      zipcode: json['zipcode'],
    );
  }
}

// 定義 Friend 類別
class Friend {
  String name;
  int age;
  String email;

  Friend({
    required this.name,
    required this.age,
    required this.email,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      name: json['name'],
      age: json['age'],
      email: json['email'],
    );
  }
}
