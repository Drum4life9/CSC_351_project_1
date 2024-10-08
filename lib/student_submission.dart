class StudentSubmission {
  late String id;
  late String studentID;
  late String instructorID;
  late String assignmentID;
  late String assignmentName;
  late String result;
  late int submitNumber;
  late int maxPoints;
  late int earnedPoints;
  late DateTime dateSubmitted;

  StudentSubmission(
      {required this.id,
      required this.studentID,
      required this.instructorID,
      required this.assignmentID,
      required this.assignmentName,
      required this.result,
      required this.submitNumber,
      required this.maxPoints,
      required this.earnedPoints,
      required this.dateSubmitted});

  StudentSubmission.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    studentID = json['studentID'];
    instructorID = json['instructorID'];
    assignmentID = json['assignmentID'];
    assignmentName = json['assignmentName'];
    result = json['result'];
    submitNumber = json['submitNumber'];
    maxPoints = json['maxPoints'];
    earnedPoints = json['earnedPoints'];
    dateSubmitted = DateTime.parse(json['dateSubmitted'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['studentID'] = studentID;
    json['instructorID'] = instructorID;
    json['assignmentID'] = assignmentID;
    json['assignmentName'] = assignmentName;
    json['result'] = result;
    json['submitNumber'] = submitNumber;
    json['maxPoints'] = maxPoints;
    json['earnedPoints'] = earnedPoints;
    json['dateSubmitted'] = dateSubmitted.toIso8601String();

    return json;
  }
}
