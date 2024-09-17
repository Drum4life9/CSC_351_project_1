import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_1/add_new_assignment.dart';
import 'package:project_1/people.dart';
import 'package:project_1/serializer.dart';

import 'assignment.dart';

class InstructorPage extends StatefulWidget {
  const InstructorPage({super.key, required this.p});

  final Instructor p;

  @override
  State<InstructorPage> createState() => _InstructorPageState(p);
}

class _InstructorPageState extends State<InstructorPage> {
  _InstructorPageState(this.p);
  List<Assignment> listAssignments = [];

  final Instructor p;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Center(child: Text('Welcome ${p.name}')),
      ),
      body: FutureBuilder<List<Assignment>>(
        future: JSONSerializer.readAssignments(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          listAssignments = snapshot.data;

          List<Widget> assignmentCards = [];
          for (Assignment a in listAssignments) {
            assignmentCards.add(getAssignmentCard(a));
          }

          return ListView(
            children: assignmentCards,
          );
        },
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

  Widget getAssignmentCard(Assignment a) {
    return Card(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(a.name),
          ),
          Text(a.desc),
          Column(
            children: [
              IconButton(
                  onPressed: () => {}, icon: const Icon(CupertinoIcons.minus)),
              IconButton(
                  onPressed: () => {},
                  icon: const Icon(CupertinoIcons.info_circle))
            ],
          ),
        ],
      ),
    );
  }
}
