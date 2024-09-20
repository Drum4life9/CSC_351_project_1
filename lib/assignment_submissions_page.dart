import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_1/people.dart';
import 'package:project_1/serializer.dart';
import 'package:project_1/student_submission.dart';
import 'package:tuple/tuple.dart';

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

  AsyncSnapshot<dynamic>? lastSnapshot;
  List<StudentSubmission> submissions = [];
  List<Person> people = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Center(child: Text('Assignment Submissions')),
      ),
      body: FutureBuilder(
          future: JSONSerializer.readSubmissions(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (lastSnapshot == null || snapshot.data != lastSnapshot!.data) {
              lastSnapshot = snapshot;
              Tuple2<List<StudentSubmission>, List<Person>> data =
                  snapshot.data;
              submissions = data.item1;
              people = data.item2;

              List<Student> students = people.whereType<Student>().toList();
              List<Widget> submissionCards = [];

              for (Student s in students) {
                StudentSubmission? cardSS;
                for (StudentSubmission ss in submissions) {
                  if (ss.studentID == s.id &&
                      ss.instructorID == p.id &&
                      ss.assignmentID == a.id &&
                      (cardSS == null ||
                          cardSS.submitNumber < ss.submitNumber)) {
                    cardSS = ss;
                  }
                }
                submissionCards.add(getStudentSubmissionCard(s, cardSS));
              }

              return ListView(
                children: submissionCards,
              );
            }
            return const Text('');
          }),
    );
  }

  Widget getStudentSubmissionCard(Student s, StudentSubmission? ss) {
    bool hasSS = ss != null;
    double perc;
    String percStr = '';
    if (hasSS) {
      perc = ss.earnedPoints * 100 / ss.maxPoints;
      percStr = perc.toStringAsFixed(2);
      percStr += '%';
    }
    return Card(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(a.name),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text(s.name),
                ),
                hasSS
                    ? Text('Submission no. ${ss.submitNumber}')
                    : const Text('No Submissions'),
              ],
            ),
          ),
          const Spacer(),
          hasSS
              ? Column(
                  children: [
                    const Text('Date submitted: '),
                    Text(DateFormat('yyyy-MM-dd @ kk:mm')
                        .format(ss.dateSubmitted))
                  ],
                )
              : const Text(''),
          hasSS
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      const Text('Score:'),
                      Text('${ss.earnedPoints}/${ss.maxPoints}'),
                      Text(percStr)
                    ],
                  ),
                )
              : const Text(''),
        ],
      ),
    );
  }
}
