import 'package:flutter/material.dart';
import 'package:project_1/people.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key, required this.p});

  final Student p;

  @override
  State<StudentPage> createState() => _StudentPageState(p);
}

class _StudentPageState extends State<StudentPage> {
  _StudentPageState(this.p);
  final Student p;

  @override
  Widget build(BuildContext context) {
    return Text('hello ${p.name}!');
  }
}
