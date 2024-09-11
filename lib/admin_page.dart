import 'package:flutter/material.dart';
import 'package:project_1/instructor_page.dart';
import 'package:project_1/people.dart';
import 'package:project_1/serializer.dart';
import 'package:flutter/cupertino.dart';
import 'package:project_1/student_page.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    List<Person> people = [];
    List<Instructor> instructors = [];
    List<Administrator> administrators = [];
    List<Student> students = [];
    JSONSerializer.readPeople();

    return Scaffold(
      body: FutureBuilder<List<Person>>(
        future: JSONSerializer.readPeople(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          people = snapshot.data;

          for (var p in people) {
            if (p is Administrator) {
              administrators.add(p);
            } else if (p is Student) {
              students.add(p);
            } else if (p is Instructor) {
              instructors.add(p);
            }
          }

          //---------add students-------------

          List<Widget> personCards = [];
          personCards.add(const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Students:'),
            ),
          ));
          for (Student s in students) {
            personCards.add(createPersonCard(s));
          }
          personCards.add(TextButton.icon(
            onPressed: () => {},
            label: const Text('Add new Student'),
            icon: const Icon(CupertinoIcons.add),
          ));
          personCards.add(const Divider(
            thickness: 5,
          ));

          //---------add instructors-------------

          personCards.add(const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Instructors:'),
            ),
          ));
          for (Instructor s in instructors) {
            personCards.add(createPersonCard(s));
          }
          personCards.add(TextButton.icon(
            onPressed: () => {},
            label: const Text('Add new Instructor'),
            icon: const Icon(CupertinoIcons.add),
          ));

          return Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: ListView(
                children: personCards,
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget createPersonCard(Person p) {
  return Card(
      child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(p.name),
  ));
}
