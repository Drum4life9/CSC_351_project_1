import 'package:flutter/material.dart';
import 'package:project_1/people.dart';
import 'package:project_1/serializer.dart';
import 'package:flutter/cupertino.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  AsyncSnapshot<dynamic>? lastSnapshot;

  @override
  Widget build(BuildContext context) {
    List<Person> people = [];
    List<Instructor> instructors = [];
    List<Administrator> administrators = [];
    List<Student> students = [];

    TextEditingController tecName = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Center(child: Text('Admin Page')),
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
          if (lastSnapshot == null || snapshot.data != lastSnapshot!.data) {
            lastSnapshot = snapshot;
            people = [];
            people = snapshot.data;

            for (var p in people) {
              if (p is Administrator) {
                administrators.add(p);
              } else if (p is Student) {
                students.add(p);
              } else if (p is Instructor) {
                instructors.add(p);
              }
            }

            //---------add students-------------

            personCards.add(const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Students:'),
              ),
            ));
            for (Student s in students) {
              personCards.add(createPersonCard(s));
            }
            personCards.add(TextButton.icon(
              onPressed: () => showDialog(
                  context: context,
                  builder: (c) => AlertDialog(
                        title: const Text('Add New Student'),
                        content: TextField(
                          controller: tecName,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              Student s = Student(
                                  tecName.text, JSONSerializer.getRandString());
                              await JSONSerializer.writeNewPersonJson(s);
                              Navigator.of(context).pop();
                              setState(() {});
                            },
                            child: const Text('Add'),
                          )
                        ],
                      )),
              label: const Text('Add new Student'),
              icon: const Icon(CupertinoIcons.add),
            ));
            personCards.add(const Divider(
              thickness: 5,
            ));

            //---------add instructors-------------

            personCards.add(const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Instructors:'),
              ),
            ));
            for (Instructor s in instructors) {
              personCards.add(createPersonCard(s));
            }
            personCards.add(TextButton.icon(
              onPressed: () => showDialog(
                  context: context,
                  builder: (c) => AlertDialog(
                        title: const Text('Add New Instructor'),
                        content: TextField(
                          controller: tecName,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              Instructor i = Instructor(
                                  tecName.text, JSONSerializer.getRandString());
                              await JSONSerializer.writeNewPersonJson(i);
                              Navigator.of(context).pop();
                              setState(() {});
                            },
                            child: const Text('Add'),
                          )
                        ],
                      )),
              label: const Text('Add new Instructor'),
              icon: const Icon(CupertinoIcons.add),
            ));
          }

          return Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: ListView(
                children: personCards,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget createPersonCard(Person p) {
    return Card(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(p.name),
          ),
          const Spacer(),
          IconButton(
            onPressed: () async {
              await JSONSerializer.deletePerson(p);
              setState(() {});
            },
            icon: const Icon(CupertinoIcons.minus),
            tooltip: 'Remove person',
          )
        ],
      ),
    );
  }
}
