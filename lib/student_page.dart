import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_1/choose_person_page.dart';
import 'package:project_1/people.dart';
import 'package:project_1/serializer.dart';
import 'package:project_1/student_submission.dart';
import 'package:project_1/student_submit_page.dart';
import 'package:tuple/tuple.dart';

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

            assignmentCards.add(Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: TextButton(
                  onPressed: () async {
                    Tuple2<List<Assignment>, List<StudentSubmission>> lis =
                        await JSONSerializer.getAssignmentsAndSubmissions(p);

                    List<Widget> notSubmittedYet = [];

                    for (Assignment a in lis.item1) {
                      bool hasSubmitted = false;
                      for (StudentSubmission ss in lis.item2) {
                        if (ss.assignmentID == a.id && ss.studentID == p.id) {
                          hasSubmitted = true;
                          break;
                        }
                      }
                      if (!hasSubmitted) {
                        notSubmittedYet.add(Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: getAssignmentCard(a, false),
                        ));
                      }
                    }

                    if (notSubmittedYet.isEmpty) {
                      notSubmittedYet.add(const Text(
                          'You submitted all assignments. Great job!'));
                    }

                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: const Text('Assignments to submit:'),
                              content: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: notSubmittedYet,
                                ),
                              ),
                            ));
                  },
                  child: const Text('See Unsubmitted Assignments')),
            ));

            for (Assignment a in listAssignments) {
              assignmentCards.add(getAssignmentCard(a, true));
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

  Widget getAssignmentCard(Assignment a, bool isSubmittable) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
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
                padding: const EdgeInsets.all(2.0),
                child: VerticalDivider(
                  color: Theme.of(context).primaryColor,
                  width: 8,
                ),
              ),
              isSubmittable
                  ? Padding(
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
                    )
                  : const Text(''),
              const Spacer(),
              isSubmittable
                  ? Column(
                      children: [
                        IconButton(
                          onPressed: () => showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: const Text('Submit assignment file'),
                                    content: TextButton(
                                        onPressed: () async {
                                          if (DateTime.now()
                                              .isAfter(a.dueDate)) {
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                      title: const Text(
                                                          'Due date passed'),
                                                      content: const Text(
                                                          'Sorry! The due date has passed for this assignment!'),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: const Text(
                                                                'Ok'))
                                                      ],
                                                    ));
                                            return;
                                          }

                                          FilePickerResult? result =
                                              await FilePicker.platform
                                                  .pickFiles(
                                            type: FileType.custom,
                                            allowedExtensions: ['py'],
                                          );

                                          if (result != null) {
                                            File file =
                                                File(result.files.single.path!);
                                            String code =
                                                file.readAsStringSync();
                                            var response = await JSONSerializer
                                                .submitAssignment(p, a, code);
                                            if (!response.item1) {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  title: const Text(
                                                      'Upload failed'),
                                                  content: const Text(
                                                      'The file upload failed. Please try again'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text('Ok'),
                                                    )
                                                  ],
                                                ),
                                              );
                                              return;
                                            }
                                            //response success
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text(
                                                    'Upload success'),
                                                content: getSubmissionBody(
                                                    response.item2!),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text('Ok'))
                                                ],
                                              ),
                                            );
                                          }
                                        },
                                        child: const Text('Choose file')),
                                  )),
                          icon: const Icon(CupertinoIcons.add),
                          tooltip: 'Add New Submission',
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      StudentSubmittedPage(p: p, a: a))),
                          icon: const Icon(CupertinoIcons.info_circle),
                          tooltip: 'See Assignment Submissions',
                        ),
                      ],
                    )
                  : const Text(''),
            ],
          ),
        ),
      ),
    );
  }

  Widget getSubmissionBody(StudentSubmission ss) {
    double perc = ss.earnedPoints * 100.0 / ss.maxPoints;
    String percString = perc.toStringAsFixed(2);
    percString += '%';
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Result: ${ss.result}'),
        Text('Number of Cases: ${ss.maxPoints}'),
        Text('Number of successes: ${ss.earnedPoints}'),
        const Text('Score on assignment:'),
        Text(percString),
      ],
    );
  }
}
