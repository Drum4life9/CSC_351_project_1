import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'assignment.dart';
import 'people.dart';

const String peopleFileName = 'People.json';

class JSONSerializer {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> _localFile(String fileName) async {
    final path = await _localPath;
    return File('$path/$fileName');
  }

  static Future<void> deletePerson(Person p) async {
    String jsonString;
    Map<String, dynamic> PeopleJSON = {};
    // Initialize the local _filePath
    final filePath = await _localFile('People.json');
    jsonString = await filePath.readAsString();

    //2. Update initialized _json by converting _jsonString<String>->_json<Map>
    PeopleJSON = jsonDecode(jsonString);
    PeopleJSON["Students"].removeWhere((e) => e["id"] == p.id);
    PeopleJSON["Instructors"].removeWhere((e) => e["id"] == p.id);

    //3. Convert _json ->_jsonString
    jsonString = jsonEncode(PeopleJSON);

    //4. Write _jsonString to the _filePath
    filePath.writeAsString(jsonString);
  }

  static Future<void> writeNewPersonJson(Person p) async {
    String jsonString;
    Map<String, dynamic> PeopleJSON = {};
    // Initialize the local _filePath
    final filePath = await _localFile('People.json');

    //1. Create _newJson<Map> from input<TextField>
    Map<String, dynamic> newJson = {"name": p.name, "id": p.id};
    //read file for current people
    jsonString = await filePath.readAsString();

    //2. Update initialized _json by converting _jsonString<String>->_json<Map>
    PeopleJSON = jsonDecode(jsonString);

    if (p is Administrator) {
      PeopleJSON["Administrators"].add(newJson);
    } else if (p is Instructor) {
      PeopleJSON["Instructors"].add(newJson);
    } else {
      PeopleJSON["Students"].add(newJson);
    }

    //3. Convert _json ->_jsonString
    jsonString = jsonEncode(PeopleJSON);

    //4. Write _jsonString to the _filePath
    filePath.writeAsString(jsonString);
  }

  static Future<List<Person>> readPeopleJson() async {
    List<Person> peopleList = [];
    Map<String, dynamic> PeopleJSON = {};
    // Initialize _filePath
    final filePath = await _localFile('People.json');
    String jsonString;

    // 0. Check whether the _file exists
    bool fileExists = await filePath.exists();

    if (!fileExists) {
      String pathToDocx = await _localPath;
      pathToDocx += "/People.json";
      final File file = File(pathToDocx);
      Map<String, dynamic> jsonMap = {};
      Map<String, dynamic> studentMap = {
        "Students": [
          {"name": "Student1", "id": "idc"}
        ]
      };
      Map<String, dynamic> instructorMap = {
        "Instructors": [
          {"name": "Instructor1", "id": "cde"}
        ]
      };
      Map<String, dynamic> adminMap = {
        "Administrators": [
          {"name": "Administrator1", "id": "abc"}
        ]
      };
      jsonMap.addAll(studentMap);
      jsonMap.addAll(instructorMap);
      jsonMap.addAll(adminMap);
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
        Administrator p = Administrator(person['name'], person['id']);
        peopleList.add(p);
      }
      for (var person in instructors) {
        Instructor p = Instructor(person['name'], person['id']);
        peopleList.add(p);
      }
      for (var person in students) {
        Student p = Student(person['name'], person['id']);
        peopleList.add(p);
      }

      return peopleList;
    }
    return [];
  }

  static String getRandString() {
    var random = Random.secure();
    var values = List<int>.generate(16, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }

  // -------------------------------ASSIGNMENTS----------------------------------

  static Future<void> addNewAssignment(Instructor p, Assignment a) async {
    String jsonString;
    Map<String, dynamic> assignmentsJSON = {};
    List<Map<String, dynamic>> listAssignments = [];
    // Initialize the local _filePath
    final filePath = await _localFile('Assignments.json');

    //1. Create _newJson<Map> from input<TextField>
    Map<String, dynamic> newJson = a.toJson();
    //read file for current people
    jsonString = await filePath.readAsString();

    //2. Update initialized _json by converting _jsonString<String>->_json<Map>
    assignmentsJSON = jsonDecode(jsonString);
    listAssignments = assignmentsJSON['Assignments'];
    listAssignments.add(newJson);
    assignmentsJSON['Assignments'] = jsonEncode(listAssignments);

    //3. Convert _json ->_jsonString
    jsonString = jsonEncode(assignmentsJSON);

    //4. Write _jsonString to the _filePath
    filePath.writeAsString(jsonString);
  }
}
