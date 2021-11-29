

import '../../domain/entities/entities.dart';

import '../../data/http/http.dart';

class RemoteSurveyModel {
  final String id;
  final String question;
  final String dateTime;
  final bool didAnswer;

  RemoteSurveyModel({
    required this.id,
    required this.question,
    required this.dateTime,
    required this.didAnswer
  });

  factory RemoteSurveyModel.fromJson(Map json) {

    if (!json.keys.toSet().containsAll(['id', 'question', 'didAnswer', 'date'])) {
      throw HttpError.invalidData;
    }
    return RemoteSurveyModel(
        id: json['id'],
        question: json['question'],
        dateTime: json['date'],
        didAnswer: json['didAnswer']
    );
  }

  SurveyEntity toEntity() => SurveyEntity(
    id: this.id,
    question: this.question,
    dateTime: DateTime.parse(this.dateTime),
    didAnswer: this.didAnswer
  );
}