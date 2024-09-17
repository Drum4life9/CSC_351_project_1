import 'package:flutter/material.dart';
import 'package:project_1/people.dart';
import 'package:project_1/serializer.dart';
import 'package:project_1/student_page.dart';

import 'instructor_page.dart';

class ChoosePersonPage extends StatefulWidget {
  const ChoosePersonPage({super.key});

  @override
  State<ChoosePersonPage> createState() => _ChoosePersonPageState();
}

class _ChoosePersonPageState extends State<ChoosePersonPage> {
  List<Person> people = [];
  List<Widget> instCards = [];
  List<Widget> studCards = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Center(child: Text('Choose Your Person')),
      ),
      body: FutureBuilder<List<Person>>(
          future: JSONSerializer.readPeopleJson(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            List<Widget> personCards = [];
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            people = snapshot.data;
            for (Person p in people) {
              if (p is Student) {
                studCards.add(createPersonCard(p, context));
              } else if (p is Instructor) {
                instCards.add(createPersonCard(p, context));
              }
            }
            personCards.add(const Center(child: Text('Students:')));
            personCards.addAll(studCards);
            personCards.add(Divider(
              height: 20,
              color: Theme.of(context).primaryColor,
            ));
            personCards.add(const Center(child: Text('Instructors:')));
            personCards.addAll(instCards);

            return Center(
              child: ListView(
                children: personCards,
              ),
            );
          }),
    );
  }
}

Widget createPersonCard(Person p, BuildContext context) {
  if (p is Student) {
    return Center(
      child: TextButton(
        child: Text(p.name),
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => StudentPage(p: p))),
      ),
    );
  } else if (p is Instructor) {
    return Center(
      child: TextButton(
        child: Text(p.name),
        onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => InstructorPage(p: p))),
      ),
    );
  }

  return const Text('Something has gone wrong lol');
}
