import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'people.dart';

const String peopleFileName = 'People.json';

class JSONSerializer {
  static Map<String, dynamic> PeopleJSON = {};

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

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$peopleFileName');
  }

  void writeNewPersonJson(Person p) async {
    String jsonString;
    // Initialize the local _filePath
    final filePath = await _localFile;

    //1. Create _newJson<Map> from input<TextField>
    Map<String, dynamic> newJson = {"name": p.name};

    //2. Update _json by adding _newJson<Map> -> _json<Map>
    PeopleJSON.addAll(newJson);

    //3. Convert _json ->_jsonString
    jsonString = jsonEncode(PeopleJSON);

    //4. Write _jsonString to the _filePath
    filePath.writeAsString(jsonString);
  }

  static Future<List<Person>> readPeopleJson() async {
    List<Person> peopleList = [];
    // Initialize _filePath
    final filePath = await _localFile;
    String jsonString;

    // 0. Check whether the _file exists
    bool fileExists = await filePath.exists();

    if (!fileExists) {
      String pathToDocx = await _localPath;
      pathToDocx += "/People.json";
      final File file = File(pathToDocx);
      Map<String, dynamic> jsonMap = {};
      Map<String, dynamic> StudentMap = {
        "Students": [
          {"name": "Student1"}
        ]
      };
      Map<String, dynamic> InstructorMap = {
        "Instructors": [
          {"name": "Instructor1"}
        ]
      };
      Map<String, dynamic> AdminMap = {
        "Administrators": [
          {"name": "Administrator1"}
        ]
      };
      jsonMap.addAll(StudentMap);
      jsonMap.addAll(InstructorMap);
      jsonMap.addAll(AdminMap);
      file.writeAsStringSync(json.encode(jsonMap));
    }

    fileExists = await filePath.exists();
    // If the _file exists->read it: update initialized _json by what's in the _file
    if (fileExists) {
      try {
        //1. Read _jsonString<String> from the _file.
        jsonString = await filePath.readAsString();

        //2. Update initialized _json by converting _jsonString<String>->_json<Map>
        PeopleJSON = jsonDecode(jsonString);
      } catch (e) {
        // Print exception errors
        return [];
      }
      final data = PeopleJSON;

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
    return [];
  }
}
