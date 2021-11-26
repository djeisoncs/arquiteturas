import 'package:faker/faker.dart';

import 'package:architecture/domain/entities/entities.dart';

class FakeSurveyResultFactory {

  static Map makeCacheJson() => {
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

  static Map makeInvalidCacheJson() => {
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

  static Map makeIncompleteCacheJson() => {
        'surveyId': faker.guid.guid(),
      };

  static SurveyResultEntity makeEntity() => SurveyResultEntity(
          surveyId: faker.guid.guid(),
          question: faker.lorem.sentence(),
          answers: [
            SurveyAnswerEntity(
                image: faker.internet.httpsUrl(),
                answer: faker.lorem.sentence(),
                isCurrentAnswer: true,
                percent: 40),
            SurveyAnswerEntity(
                answer: faker.lorem.sentence(),
                isCurrentAnswer: false,
                percent: 60)
          ]);

  static Map makeApiJson() => {
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
}
