class QuestionModel {
  String? key;
  String? question;

  QuestionModel({
    this.key,
    this.question,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) => QuestionModel(
        key: json["key"],
        question: json["question"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "question": question,
      };
}
