import 'package:meta/meta.dart';

import '../../domain/entities/entities.dart';

import '../../data/http/http.dart';

class RemoteSurveyModel {
  final String id;
  final String question;
  final String dateTime;
  final bool didiAnswer;

  RemoteSurveyModel({
    @required this.id,
    @required this.question,
    @required this.dateTime,
    @required this.didiAnswer
  });

  factory RemoteSurveyModel.fromJson(Map json) {

    return RemoteSurveyModel(
        id: json['id'],
        question: json['question'],
        dateTime: json['date'],
        didiAnswer: json['didiAnswer']
    );
  }

  SurveyEntity toEntity() => SurveyEntity(
    id: this.id,
    question: this.question,
    dateTime: DateTime.parse(this.dateTime),
    didiAnswer: this.didiAnswer
  );
}