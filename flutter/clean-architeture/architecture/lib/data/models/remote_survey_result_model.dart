

import '../../domain/entities/entities.dart';

import '../../data/http/http.dart';
import 'remote_survey_answer_model.dart';

class RemoteSurveyResultModel {
  final String surveyId;
  final String question;
  final List<RemoteSurveyAnswerModel> answers;

  RemoteSurveyResultModel({
    required this.surveyId,
    required this.question,
    required this.answers
  });

  factory RemoteSurveyResultModel.fromJson(Map json) {

    if (!json.keys.toSet().containsAll(['surveyId', 'question', 'answers'])) {
      throw HttpError.invalidData;
    }
    return RemoteSurveyResultModel(
        surveyId: json['surveyId'],
        question: json['question'],
        answers: json['answers'].map<RemoteSurveyAnswerModel>((answerJson) => RemoteSurveyAnswerModel.fromJson(answerJson)).toList()
    );
  }

  SurveyResultEntity toEntity() => SurveyResultEntity(
    surveyId: this.surveyId,
    question: this.question,
    answers: answers.map<SurveyAnswerEntity>((answer) => answer.toEntity()).toList()
  );
}