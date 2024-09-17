import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:project_1/people.dart';
import 'package:project_1/serializer.dart';

import 'assignment.dart';

class AddNewAssignmentPage extends StatefulWidget {
  const AddNewAssignmentPage({super.key, required this.p});

  final Instructor p;

  @override
  State<AddNewAssignmentPage> createState() => _AddNewAssignmentPageState(p: p);
}

class _AddNewAssignmentPageState extends State<AddNewAssignmentPage> {
  TextEditingController tecName = TextEditingController();
  TextEditingController tecDesc = TextEditingController();
  TextEditingController tecPoints = TextEditingController();
  TextEditingController tecInputs = TextEditingController();
  TextEditingController tecOutputs = TextEditingController();
  DateTime dueDate = DateTime.now();
  bool inAsync = false;
  final Instructor p;

  _AddNewAssignmentPageState({required this.p});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
        title: const Center(child: Text('Add Assignment')),
      ),
      body: ModalProgressHUD(
        inAsyncCall: inAsync,
        child: Center(
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: RawScrollbar(
                thumbColor: Theme.of(context).primaryColor,
                thickness: 10,
                radius: const Radius.circular(4),
                child: ListView(
                  primary: true,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text('Enter Name of Assignment'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: tecName,
                      ),
                    ),
                    Divider(
                      height: 20,
                      color: Theme.of(context).primaryColor,
                    ),
                    const Text('Enter description'),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: tecDesc,
                      ),
                    ),
                    Divider(
                      height: 20,
                      color: Theme.of(context).primaryColor,
                    ),
                    const Text('Enter Number of points'),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: tecPoints,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                    ),
                    Divider(
                      height: 20,
                      color: Theme.of(context).primaryColor,
                    ),
                    const Text('Enter Due date'),
                    OmniDateTimePicker(onDateTimeChanged: (d) => dueDate = d),
                    Divider(
                      height: 20,
                      color: Theme.of(context).primaryColor,
                    ),
                    const Text('Enter List of inputs (CSV Style)'),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: tecInputs,
                      ),
                    ),
                    Divider(
                      height: 20,
                      color: Theme.of(context).primaryColor,
                    ),
                    const Text('Enter List of outputs (CSV Style)'),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: tecOutputs,
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        setState(() {
                          inAsync = true;
                        });

                        String inputs = tecInputs.text;
                        List<dynamic> ins = inputs.split(', ');
                        String outputs = tecOutputs.text;
                        List<dynamic> outs = outputs.split(', ');

                        Assignment a = Assignment(tecName.text, tecDesc.text,
                            int.parse(tecPoints.text), dueDate, ins, outs);
                        await JSONSerializer.addNewAssignment(p, a);

                        setState(() {
                          inAsync = false;
                        });

                        showDialog(
                            context: context,
                            builder: (c) => AlertDialog(
                                  title: const Text('Assignment created'),
                                  content: Text(
                                      'Your new assignment for ${dueDate.toString()} has been created'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Ok'),
                                    )
                                  ],
                                ));
                      },
                      child: const Text('Submit'),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
