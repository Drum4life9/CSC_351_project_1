class Person {
  late String name;
  late String id;

  Person(this.name, this.id);

  Person.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;

    return data;
  }
}

class Administrator extends Person {
  Administrator(super.name, super.id);
}

class Student extends Person {
  Student(super.name, super.id);
}

class Instructor extends Person {
  Instructor(super.name, super.id);
}
