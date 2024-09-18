import 'package:flutter/material.dart';
import 'package:project_1/people.dart';

import 'assignment.dart';

class AssignmentSubmissionsPage extends StatefulWidget {
  const AssignmentSubmissionsPage(
      {super.key, required this.p, required this.a});

  final Instructor p;
  final Assignment a;

  @override
  State<AssignmentSubmissionsPage> createState() =>
      _AssignmentSubmissionsPageState(p, a);
}

class _AssignmentSubmissionsPageState extends State<AssignmentSubmissionsPage> {
  _AssignmentSubmissionsPageState(this.p, this.a);

  final Instructor p;
  final Assignment a;

  @override
  Widget build(BuildContext context) {
    return Text(a.name);
  }
}
