import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'dart:io';

class User {
  final int id;
  final String name;
  final int age;
  final String imageUrl;
  final Uint8List? imageData;
  final bool isLoading;

  const User({
    required this.id,
    required this.name,
    required this.age,
    required this.imageUrl,
    required this.imageData,
    required this.isLoading,
  });

  User copy([
    bool? isLoading,
    Uint8List? imageData,
  ]) =>
      User(
        id: id,
        name: name,
        age: age,
        imageUrl: imageUrl,
        imageData: imageData ?? this.imageData,
        isLoading: isLoading ?? this.isLoading,
      );

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        age = json['age'],
        imageUrl = json['image_url'],
        imageData = null,
        isLoading = false;

  @override
  String toString() {
    return '(User id: $id, name: $name age: $age)';
  }
}

const dummyUrl = 'http://10.0.2.2:5500/person1.json';

Future<Iterable<User>> getUser() => HttpClient()
    .getUrl(Uri.parse(dummyUrl))
    .then((req) => req.close())
    .then((resp) => resp.transform(utf8.decoder).join())
    .then((str) => json.decode(str) as List<dynamic>)
    .then((list) => list.map((e) => User.fromJson(e)));
