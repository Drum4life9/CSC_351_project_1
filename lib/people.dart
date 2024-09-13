class Person {
  late String name;

  Person(this.name);

  Person.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;

    return data;
  }
}

class Administrator extends Person {
  Administrator(super.name);
}

class Student extends Person {
  Student(super.name);
}

class Instructor extends Person {
  Instructor(super.name);
}
