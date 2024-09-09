class Person {
  String name;

  Person(this.name);

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