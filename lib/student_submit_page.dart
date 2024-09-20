import 'package:flutter/material.dart';
import 'package:project_1/people.dart';

import 'assignment.dart';

class StudentSubmitPage extends StatefulWidget {
  const StudentSubmitPage({super.key, required this.p, required this.a});

  final Student p;
  final Assignment a;

  @override
  State<StudentSubmitPage> createState() => _StudentSubmitPageState(p, a);
}

class _StudentSubmitPageState extends State<StudentSubmitPage> {
  _StudentSubmitPageState(this.p, this.a);

  AsyncSnapshot<dynamic>? lastSnapshot;

  final Student p;
  final Assignment a;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Center(child: Text('Submit Assignment')),
      ),
    );
  }
}
