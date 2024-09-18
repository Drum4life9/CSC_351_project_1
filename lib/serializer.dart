import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:project_1/student_submission.dart';
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

  static Future<void> writeNewPersonJson(Person p) async {
    String jsonString;
    Map<String, dynamic> peopleJSON = {};
    // Initialize the local _filePath
    final filePath = await _localFile('People.json');

    //1. Create _newJson<Map> from input<TextField>
    Map<String, dynamic> newJson = {"name": p.name, "id": p.id};
    //read file for current people
    jsonString = await filePath.readAsString();

    //2. Update initialized _json by converting _jsonString<String>->_json<Map>
    peopleJSON = jsonDecode(jsonString);

    if (p is Administrator) {
      peopleJSON["Administrators"].add(newJson);
    } else if (p is Instructor) {
      peopleJSON["Instructors"].add(newJson);
    } else {
      peopleJSON["Students"].add(newJson);
    }

    //3. Convert _json ->_jsonString
    jsonString = jsonEncode(peopleJSON);

    //4. Write _jsonString to the _filePath
    filePath.writeAsString(jsonString);
  }

  static Future<List<Person>> readPeopleJson() async {
    List<Person> peopleList = [];
    Map<String, dynamic> peopleJSON = {};
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
        peopleJSON = jsonDecode(jsonString);
      } catch (e) {
        // Print exception errors
        return [];
      }
      final data = peopleJSON;

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

  static Future<void> deletePerson(Person p) async {
    String jsonString;
    Map<String, dynamic> peopleJSON = {};
    // Initialize the local _filePath
    final filePath = await _localFile('People.json');
    jsonString = await filePath.readAsString();

    //2. Update initialized _json by converting _jsonString<String>->_json<Map>
    peopleJSON = jsonDecode(jsonString);
    peopleJSON["Students"].removeWhere((e) => e["id"] == p.id);
    peopleJSON["Instructors"].removeWhere((e) => e["id"] == p.id);

    //3. Convert _json ->_jsonString
    jsonString = jsonEncode(peopleJSON);

    //4. Write _jsonString to the _filePath
    filePath.writeAsString(jsonString);
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
    // Initialize the local _filePath
    final filePath = await _localFile('Assignments.json');

    //1. Create _newJson<Map> from input<TextField>
    Map<String, dynamic> newJson = a.toJson();
    //read file for current people
    jsonString = await filePath.readAsString();

    //2. Update initialized _json by converting _jsonString<String>->_json<Map>
    assignmentsJSON = jsonDecode(jsonString);
    assignmentsJSON[a.id] = newJson;

    //3. Convert _json ->_jsonString
    jsonString = jsonEncode(assignmentsJSON);

    //4. Write _jsonString to the _filePath
    filePath.writeAsString(jsonString);
  }

  static Future<List<Assignment>> readAssignments() async {
    List<Assignment> assignmentsList = [];
    Map<String, dynamic> assignmentJSON = {};
    // Initialize _filePath
    final filePath = await _localFile('Assignments.json');
    String jsonString;

    // 0. Check whether the _file exists
    bool fileExists = await filePath.exists();

    if (!fileExists) {
      String pathToDocx = await _localPath;
      pathToDocx += "/Assignments.json";
      final File file = File(pathToDocx);
      Map<String, dynamic> jsonMap = {};
      Map<String, dynamic> instructorAssignmentMap = {
        'Kw2I6gdHP_FIFn12mNLGJA==': Assignment(
            'Kw2I6gdHP_FIFn12mNLGJA==',
            'cde',
            'Test1',
            'A test assignment',
            100,
            DateTime.now(),
            [1, 2],
            [2, 4]).toJson(),
        'U3HPsPcXZ5Ozr87oGkpYjw==': Assignment(
            'U3HPsPcXZ5Ozr87oGkpYjw==',
            'cde',
            'Test2',
            'A test2 assignment',
            200,
            DateTime.now(),
            [1, 2],
            [3, 6]).toJson()
      };
      jsonMap.addAll(instructorAssignmentMap);
      file.writeAsStringSync(json.encode(jsonMap));
    }

    fileExists = await filePath.exists();
    // If the _file exists->read it: update initialized _json by what's in the _file
    if (fileExists) {
      try {
        //1. Read _jsonString<String> from the _file.
        jsonString = await filePath.readAsString();

        //2. Update initialized _json by converting _jsonString<String>->_json<Map>
        assignmentJSON = jsonDecode(jsonString);
      } catch (e) {
        // Print exception errors
        return [];
      }
      final data = assignmentJSON;

      for (var a in data.values) {
        List<dynamic> ins = jsonDecode(a["inputs"]);
        List<dynamic> out = jsonDecode(a["outputs"]);
        Assignment assign = Assignment(a['id'], a['instructorId'], a['name'],
            a['desc'], a['points'], DateTime.parse(a['dueDate']), ins, out);
        assignmentsList.add(assign);
      }

      return assignmentsList;
    }
    return [];
  }

  static Future<void> deleteAssignment(Assignment a) async {
    String jsonString;
    Map<String, dynamic> assignmentsJSON = {};
    // Initialize the local _filePath
    final filePath = await _localFile('Assignments.json');
    jsonString = await filePath.readAsString();

    //2. Update initialized _json by converting _jsonString<String>->_json<Map>
    assignmentsJSON = jsonDecode(jsonString);

    assignmentsJSON.removeWhere((s, d) => s == a.id);

    //3. Convert _json ->_jsonString
    jsonString = jsonEncode(assignmentsJSON);

    //4. Write _jsonString to the _filePath
    filePath.writeAsString(jsonString);
  }

  //---------------------------STUDENT_SUBMISSIONS-----------------------
  static Future<List<StudentSubmission>> readSubmissions() async {
    List<StudentSubmission> submissionList = [];
    Map<String, dynamic> submissionJSON = {};
    // Initialize _filePath
    final filePath = await _localFile('Submissions.json');
    String jsonString;

    // 0. Check whether the _file exists
    bool fileExists = await filePath.exists();

    if (!fileExists) {
      String pathToDocx = await _localPath;
      pathToDocx += "/Submissions.json";
      final File file = File(pathToDocx);
      Map<String, dynamic> jsonMap = {};
      String rand1 = getRandString();
      String rand2 = getRandString();
      Assignment a1 = Assignment('Kw2I6gdHP_FIFn12mNLGJA==', 'cde', 'Test1',
          'A test assignment', 100, DateTime.now(), [1, 2], [2, 4]);
      Assignment a2 = Assignment('U3HPsPcXZ5Ozr87oGkpYjw==', 'cde', 'Test2',
          'A test2 assignment', 200, DateTime.now(), [1, 2], [3, 6]);
      Map<String, dynamic> submissionsMap = {
        rand1: StudentSubmission(
          id: rand1,
          studentID: 'idc',
          instructorID: 'cde',
          assignmentID: a1.id,
          maxPoints: a1.points,
          earnedPoints: a1.points,
          dateSubmitted: a1.dueDate.subtract(const Duration(days: 2)),
          submitNumber: 1,
        ),
        rand2: StudentSubmission(
          id: rand2,
          studentID: 'idc',
          instructorID: 'cde',
          assignmentID: a2.id,
          maxPoints: a2.points,
          earnedPoints: a2.points,
          dateSubmitted: a2.dueDate.subtract(const Duration(days: 1)),
          submitNumber: 1,
        ),
      };
      jsonMap.addAll(submissionsMap);
      file.writeAsStringSync(json.encode(jsonMap));
    }

    fileExists = await filePath.exists();
    // If the _file exists->read it: update initialized _json by what's in the _file
    if (fileExists) {
      try {
        //1. Read _jsonString<String> from the _file.
        jsonString = await filePath.readAsString();

        //2. Update initialized _json by converting _jsonString<String>->_json<Map>
        submissionJSON = jsonDecode(jsonString);
      } catch (e) {
        // Print exception errors
        return [];
      }
      final data = submissionJSON;

      for (var a in data.values) {
        StudentSubmission ss = StudentSubmission(
            id: a['id'],
            instructorID: a['instructorId'],
            studentID: a['studentID'],
            assignmentID: a['assignmentID'],
            maxPoints: a['maxPoints'],
            earnedPoints: a['earnedPoints'],
            dateSubmitted: DateTime.parse(a['dateSubmitted']),
            submitNumber: a['submitNumber']);
        submissionList.add(ss);
      }

      return submissionList;
    }
    return [];
  }
}
