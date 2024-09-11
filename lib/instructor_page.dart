import 'package:flutter/material.dart';
import 'package:project_1/people.dart';

class InstructorPage extends StatefulWidget {
  const InstructorPage({super.key, required this.p});

  final Instructor p;

  @override
  State<InstructorPage> createState() => _InstructorPageState(p);
}

class _InstructorPageState extends State<InstructorPage> {
  _InstructorPageState(this.p);
  final Instructor p;

  @override
  Widget build(BuildContext context) {
    return Text('hello ${p.name} instructor!');
  }
}
