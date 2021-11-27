import 'package:architecture/domain/entities/entities.dart';
import 'package:faker/faker.dart';

class FakeSurveysFactory {

  static List<Map> makeCacheJson() => [
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

  static List<Map> makeInvalidCacheJson() => [
    {
      'id': faker.guid.guid(),
      'question': faker.randomGenerator.string(50),
      'didAnswer': 'false',
      'date': 'invalid date'
    }
  ];

  static List<Map> makeIncompleteCacheJson() => [
    {
      'didAnswer': 'false',
      'date': '2020-07-20T00:00:00Z'
    }
  ];

  static List<SurveyEntity> makeEntities() => [
    SurveyEntity(id: faker.guid.guid(), question: faker.randomGenerator.string(50), dateTime: DateTime.utc(2020, 2, 2), didAnswer: true),
    SurveyEntity(id: faker.guid.guid(), question: faker.randomGenerator.string(50), dateTime: DateTime.utc(2018, 12, 20), didAnswer: false)
  ];

  static List<Map> makeApiJson() => [
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
}