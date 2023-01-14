import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'dart:io';

@immutable
class Person {
  final String name;
  final int age;

  const Person({
    required this.name,
    required this.age,
  });

  Person.fromJson(Map<String, dynamic> json)
      : name = json['naem'],
        age = json['age'];

  @override
  String toString() => 'Person name: $name, age: $age';
}

const dummyUrl = 'http://10.0.2.2:5500/person1.json';

Future<Iterable<Person>> getPerson() => HttpClient()
    .getUrl(Uri.parse(dummyUrl))
    .then((req) => req.close())
    .then((resp) => resp.transform(utf8.decoder).join())
    .then((str) => json.decode(str) as List<dynamic>)
    .then((list) => list.map((e) => Person.fromJson(e)));
