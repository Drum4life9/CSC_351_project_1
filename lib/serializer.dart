import 'dart:convert';

import 'package:flutter/services.dart';

import 'people.dart';

class JSONSerializer {
  static Future<List<Person>> readPeople() async {
    List<Person> peopleList = [];

    String response;

    response = await rootBundle.loadString('assets/People.json');
    final data = json.decode(response);

    final administrators = data['Administrators'];
    final instructors = data['Instructors'];
    final students = data['Students'];

    for (var person in administrators) {
      Administrator p = Administrator(person['name']);
      peopleList.add(p);
    }
    for (var person in instructors) {
      Instructor p = Instructor(person['name']);
      peopleList.add(p);
    }
    for (var person in students) {
      Student p = Student(person['name']);
      peopleList.add(p);
    }

    return peopleList;
  }

  static Future<void> makeNewInstructor(Person p) async {
    var jsonObject = jsonEncode({'name': p.name});
  }
}
