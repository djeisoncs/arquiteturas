import 'package:meta/meta.dart';

import '../../domain/entities/entities.dart';

class LocalSurveyAnswerModel {
  final String image;
  final String answer;
  final bool isCurrentAnswer;
  final int percent;

  LocalSurveyAnswerModel({
    this.image,
    @required this.answer,
    @required this.isCurrentAnswer,
    @required this.percent
  });

  factory LocalSurveyAnswerModel.fromJson(Map json) {

    if (!json.keys.toSet().containsAll(['answer', 'isCurrentAnswer', 'percent'])) {
      throw Exception();
    }
    return LocalSurveyAnswerModel(
        image: json['surveyId'],
        answer: json['surveyId'],
        isCurrentAnswer: bool.fromEnvironment(json['isCurrentAnswer']),
        percent: int.parse(json['percent'])
    );
  }

  SurveyAnswerEntity toEntity() => SurveyAnswerEntity(
    image: this.image,
    answer: this.answer,
    isCurrentAnswer: this.isCurrentAnswer,
    percent: this.percent,
  );
}