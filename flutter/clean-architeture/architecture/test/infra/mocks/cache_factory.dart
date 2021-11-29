import 'package:faker/faker.dart';

class CacheFactory {

  static Map makeSurveyResult() => {
        'surveyId': faker.guid.guid(),
        'question': faker.lorem.sentence(),
        'answers': [
          {
            'image': faker.internet.httpsUrl(),
            'answer': faker.lorem.sentence(),
            'isCurrentAnswer': 'true',
            'percent': '40'
          },
          {
            'answer': faker.lorem.sentence(),
            'isCurrentAnswer': 'false',
            'percent': '60'
          },
        ]
      };

  static Map makeInvalidSurveyResult() => {
        'surveyId': faker.guid.guid(),
        'question': faker.lorem.sentence(),
        'answers': [
          {
            'image': faker.internet.httpsUrl(),
            'answer': faker.lorem.sentence(),
            'isCurrentAnswer': 'invalid bool',
            'percente': 'invalid int'
          }
        ]
      };

  static Map makeIncompleteSurveyResult() => {
        'surveyId': faker.guid.guid(),
      };


  static List<Map> makeSurveyList() => [
    {
      'id': faker.guid.guid(),
      'question': faker.randomGenerator.string(50),
      'didAnswer': 'false',
      'date': '2020-07-20T00:00:00Z'
    },
    {
      'id': faker.guid.guid(),
      'question': faker.randomGenerator.string(50),
      'didAnswer': 'true',
      'date': '2018-02-02T00:00:00Z'
    }
  ];

  static List<Map> makeInvalidSurveyList() => [
    {
      'id': faker.guid.guid(),
      'question': faker.randomGenerator.string(50),
      'didAnswer': 'false',
      'date': 'invalid date'
    }
  ];

  static List<Map> makeIncompleteSurveyList() => [
    {
      'didAnswer': 'false',
      'date': '2020-07-20T00:00:00Z'
    }
  ];
}
