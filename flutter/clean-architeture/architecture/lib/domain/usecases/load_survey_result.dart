import 'package:architecture/domain/entities/entities.dart';

abstract class LoadSurveyResult {

  Future<List<SurveyResultEntity>> loadBySurvey({String surveyId});
}