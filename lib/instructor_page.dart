import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_1/add_new_assignment.dart';
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Center(child: Text('Welcome ${p.name}')),
      ),
      floatingActionButton: FloatingActionButton(
          tooltip: 'Create Assignment',
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddNewAssignmentPage(
                    p: p,
                  ))),
          child: const Icon(CupertinoIcons.add)),
    );
  }
}
