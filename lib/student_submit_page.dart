import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_1/people.dart';
import 'package:project_1/serializer.dart';
import 'package:project_1/student_submission.dart';
import 'package:tuple/tuple.dart';

import 'assignment.dart';

class StudentSubmittedPage extends StatefulWidget {
  const StudentSubmittedPage({super.key, required this.p, required this.a});

  final Student p;
  final Assignment a;

  @override
  State<StudentSubmittedPage> createState() => _StudentSubmittedPageState(p, a);
}

class _StudentSubmittedPageState extends State<StudentSubmittedPage> {
  _StudentSubmittedPageState(this.p, this.a);

  final Student p;
  final Assignment a;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Center(child: Text('Submitted Assignments')),
      ),
      body: FutureBuilder<Tuple2<List<StudentSubmission>, List<Person>>>(
          future: JSONSerializer.readSubmissions(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            Tuple2<List<StudentSubmission>, List<Person>> data = snapshot.data;
            List<StudentSubmission> submits = [];
            List<Widget> submitCards = [];

            for (StudentSubmission ss in data.item1) {
              if (ss.studentID == p.id && ss.assignmentID == a.id) {
                submits.add(ss);
              }
            }

            submits.sort((a, b) => b.submitNumber - a.submitNumber);

            submitCards.add(Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Center(child: Text('Submissions for ${a.name}')),
            ));

            for (var ss in submits) {
              submitCards.add(getSubmitCard(ss));
            }

            if (submitCards.length == 1) {
              submitCards.add(const Text(
                  'You have not submitted anything for this assignment yet.'));
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: submitCards,
              ),
            );
          }),
    );
  }

  Widget getSubmitCard(StudentSubmission ss) {
    String res = ss.result;
    bool errors = res.contains('No Errors');
    String resString = !errors ? 'Success' : 'See errors ->';
    double perc = ss.earnedPoints * 100.0 / ss.maxPoints;
    String percString = perc.toStringAsFixed(2);
    percString += '%';
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Text('Result: $resString'),
                    errors
                        ? IconButton(
                            onPressed: () => showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: const Text('Error'),
                                      content: Text(res),
                                    )),
                            icon: const Icon(CupertinoIcons.info_circle))
                        : const Text(''),
                  ],
                ),
                Text('Submission no: ${ss.submitNumber}')
              ],
            ),
            const Spacer(),
            Column(
              children: [
                const Text('Score: '),
                Text('${ss.earnedPoints}/${ss.maxPoints}'),
                Text(percString)
              ],
            )
          ],
        ),
      ),
    );
  }
}
