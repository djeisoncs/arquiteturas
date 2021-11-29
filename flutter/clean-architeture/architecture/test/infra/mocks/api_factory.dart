import 'package:faker/faker.dart';

class ApiFactory {

  static Map makeAccountJson() => {'accessToken': faker.guid.guid(), 'name': faker.person.name()};

  static Map makeSurveyResultJson() => {
    'surveyId': faker.guid.guid(),
    'question': faker.randomGenerator.string(50),
    'answers': [
      {
        'image': faker.internet.httpsUrl(),
        'answer': faker.randomGenerator.string(20),
        'isCurrentAccountAnswer': faker.randomGenerator.boolean(),
        'percent': faker.randomGenerator.integer(100),
        'count': faker.randomGenerator.integer(1000),
      },
      {
        'answer': faker.randomGenerator.string(20),
        'isCurrentAccountAnswer': faker.randomGenerator.boolean(),
        'percent': faker.randomGenerator.integer(100),
        'count': faker.randomGenerator.integer(1000),
      }
    ],
    'date': faker.date.dateTime().toIso8601String()
  };

  static List<Map> makeSurveyList() => [
    {
      'id': faker.guid.guid(),
      'question': faker.randomGenerator.string(50),
      'didAnswer': faker.randomGenerator.boolean(),
      'date': faker.date.dateTime().toIso8601String()
    },
    {
      'id': faker.guid.guid(),
      'question': faker.randomGenerator.string(50),
      'didAnswer': faker.randomGenerator.boolean(),
      'date': faker.date.dateTime().toIso8601String()
    }
  ];

  static Map makeInvalidJson() => {'invalid_key': 'invalid_value'};

  static List<Map> makeInvalidList() => [
    makeInvalidJson(),
    makeInvalidJson()
  ];
}