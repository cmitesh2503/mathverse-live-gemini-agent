class Lesson {

  final String concept;
  final List<dynamic> examples;
  final List<dynamic> homework;

  Lesson({
    required this.concept,
    required this.examples,
    required this.homework,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      concept: json['concept'],
      examples: json['examples'],
      homework: json['homework'],
    );
  }
}