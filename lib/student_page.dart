import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_1/choose_person_page.dart';
import 'package:project_1/people.dart';
import 'package:project_1/serializer.dart';
import 'package:project_1/student_submit_page.dart';

import 'assignment.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key, required this.p});

  final Student p;

  @override
  State<StudentPage> createState() => _StudentPageState(p);
}

class _StudentPageState extends State<StudentPage> {
  _StudentPageState(this.p);

  AsyncSnapshot<dynamic>? lastSnapshot;
  final Student p;
  List<Assignment> listAssignments = [];

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
              assignmentCards.add(getAssignmentCard(a));
            }

            return ListView(
              children: assignmentCards,
            );
          }
          return const Text('');
        },
      ),
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
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) =>
                                StudentSubmitPage(p: p, a: a))),
                    icon: const Icon(CupertinoIcons.add))
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// showDialog(
// context: context,
// builder: (context) => AlertDialog(
// title: const Text('Submit assignment file'),
// content: TextButton(
// onPressed: () async {
// FilePickerResult? result =
// await FilePicker.platform.pickFiles(
// type: FileType.custom,
// allowedExtensions: ['py'],
// );
//
// if (result != null) {
// File file = File(result.files.single.path!);
// String code = file.readAsStringSync();
// var response =
// await JSONSerializer.submitAssignment(p, code);
// }
// },
// child: const Text('Choose file')),
// ))
