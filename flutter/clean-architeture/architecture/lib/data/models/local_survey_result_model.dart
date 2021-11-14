import 'package:meta/meta.dart';

import '../../domain/entities/entities.dart';

import 'local_survey_answer_model.dart';

class LocalSurveyResultModel {
  final String surveyId;
  final String question;
  final List<LocalSurveyAnswerModel> answers;

  LocalSurveyResultModel({
    @required this.surveyId,
    @required this.question,
    @required this.answers
  });

  factory LocalSurveyResultModel.fromJson(Map json) {

    if (!json.keys.toSet().containsAll(['surveyId', 'question', 'answers'])) {
      throw Exception();
    }
    return LocalSurveyResultModel(
        surveyId: json['surveyId'],
        question: json['question'],
        answers: json['answers'].map<LocalSurveyAnswerModel>((answerJson) => LocalSurveyAnswerModel.fromJson(answerJson)).toList()
    );
  }

  // factory LocalSurveyModel.fromEntity(SurveyEntity entity) => LocalSurveyModel(
  //     id: entity.id,
  //     question: entity.question,
  //     date: entity.dateTime,
  //     didAnswer: entity.didAnswer
  // );

  SurveyResultEntity toEntity() => SurveyResultEntity(
    surveyId: this.surveyId,
    question: this.question,
    answers: this.answers.map<SurveyAnswerEntity>((answer) => answer.toEntity()).toList()
  );
  //
  // Map<String, String> toJson() => {
  //   'id': this.id,
  //   'question': this.question,
  //   'date': this.date.toIso8601String(),
  //   'didAnswer': this.didAnswer.toString()
  // };
}