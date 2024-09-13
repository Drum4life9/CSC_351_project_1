import 'package:flutter/material.dart';
import 'package:project_1/people.dart';
import 'package:project_1/student_page.dart';

import 'instructor_page.dart';

class ChoosePersonPage extends StatefulWidget {
  const ChoosePersonPage({super.key});

  @override
  State<ChoosePersonPage> createState() => _ChoosePersonPageState();
}

class _ChoosePersonPageState extends State<ChoosePersonPage> {
  @override
  Widget build(BuildContext context) {
    return const Text('Choose an arbitrary person!');
  }
}

Widget createPersonCard(Person p, BuildContext context) {
  if (p is Student) {
    return TextButton(
      child: Text(p.name),
      onPressed: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => StudentPage(p: p))),
    );
  } else if (p is Instructor) {
    return TextButton(
      child: Text(p.name),
      onPressed: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => InstructorPage(p: p))),
    );
  }

  return const Text('Something has gone wrong lol');
}
