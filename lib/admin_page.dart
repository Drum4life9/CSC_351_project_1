import 'package:flutter/material.dart';
import 'package:project_1/people.dart';
import 'package:project_1/serializer.dart';

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
    JSONSerializer.readPeople().then((peop) => people = peop);

    for (Person p in people) {
      if (p is Administrator) {
        administrators.add(p);
      } else if (p is Student) {
        students.add(p);
      } else if (p is Instructor) {
        instructors.add(p);
      }
    }

    return Scaffold(
      body: Row(
        children: [
          ListView(
            children: [],
          )
        ],
      ),
    );
  }
}

Widget createPersonCard(Person p) {
  return Card();
}
