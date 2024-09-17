import 'dart:convert';

class Assignment {
  late String instructorId;
  late String name;
  late String desc;
  late int points;
  late DateTime dueDate;
  late List<dynamic> inputs;
  late List<dynamic> outputs;

  Assignment(this.instructorId, this.name, this.desc, this.points, this.dueDate,
      this.inputs, this.outputs);

  Assignment.fromJson(Map<String, dynamic> json) {
    instructorId = json['instructorId'];
    name = json['name'];
    desc = json['desc'];
    points = json['points'];
    dueDate = DateTime.parse(json['dueDate'].toString());
    inputs = json['inputs'];
    outputs = json['outputs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['instructorId'] = instructorId;
    data['name'] = name;
    data['desc'] = desc;
    data['points'] = points;
    data['dueDate'] = dueDate.toIso8601String();
    data['inputs'] = jsonEncode(inputs);
    data['outputs'] = jsonEncode(outputs);
    return data;
  }
}
