import 'package:meta/meta.dart';

import '../../domain/entities/entities.dart';

import '../../data/http/http.dart';

class LocalSurveyModel {
  final String id;
  final String question;
  final DateTime date;
  final bool didAnswer;

  LocalSurveyModel({
    @required this.id,
    @required this.question,
    @required this.date,
    @required this.didAnswer
  });

  factory LocalSurveyModel.fromJson(Map json) {

    // if (!json.keys.toSet().containsAll(['id', 'question', 'didAnswer', 'date'])) {
    //   throw HttpError.invalidData;
    // }
    return LocalSurveyModel(
        id: json['id'],
        question: json['question'],
        date: DateTime.parse(json['date']),
        didAnswer: bool.fromEnvironment(json['didAnswer'])
    );
  }

  SurveyEntity toEntity() => SurveyEntity(
    id: this.id,
    question: this.question,
    dateTime: this.date,
    didAnswer: this.didAnswer
  );
}