import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_1/add_new_assignment_page.dart';
import 'package:project_1/assignment_submissions_page.dart';
import 'package:project_1/choose_person_page.dart';
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
  AsyncSnapshot<dynamic>? lastSnapshot;

  final Instructor p;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Center(child: Text('Welcome ${p.name}')),
        leading: IconButton(
            onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) => const ChoosePersonPage())),
            tooltip: 'Logout',
            icon: const Icon(CupertinoIcons.arrow_left)),
      ),
      body: FutureBuilder<List<Assignment>>(
        future: JSONSerializer.readAssignments(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (lastSnapshot == null || snapshot.data != lastSnapshot!.data) {
            lastSnapshot = snapshot;
            listAssignments = snapshot.data;

            List<Widget> assignmentCards = [];
            for (Assignment a in listAssignments) {
              if (a.instructorId == p.id) {
                assignmentCards.add(getAssignmentCard(a));
              }
            }

            return ListView(
              children: assignmentCards,
            );
          }
          return const Text('');
        },
      ),
      floatingActionButton: FloatingActionButton(
          tooltip: 'Create Assignment',
          onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) => AddNewAssignmentPage(p: p))),
          child: const Icon(CupertinoIcons.add)),
    );
  }

  Widget getAssignmentCard(Assignment a) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Row(
          children: [
            Column(
              children: [
                Text(a.name),
                Text(a.desc),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: VerticalDivider(
                color: Theme.of(context).primaryColor,
                width: 8,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Due Date: ${DateFormat('yyyy-MM-dd @ kk:mm').format(a.dueDate)}'),
                  Text('No. of Points: ${a.points}'),
                  Text('No. of Test Cases: ${a.inputs.length}')
                ],
              ),
            ),
            const Spacer(),
            Column(
              children: [
                IconButton(
                    onPressed: () async {
                      await JSONSerializer.deleteAssignment(a);
                      setState(() {});
                    },
                    icon: const Icon(CupertinoIcons.minus)),
                IconButton(
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) =>
                                AssignmentSubmissionsPage(p: p, a: a))),
                    icon: const Icon(CupertinoIcons.info_circle))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
