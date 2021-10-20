import 'package:architecture/domain/helpers/helpers.dart';
import 'package:faker/faker.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:architecture/domain/entities/entities.dart';

import 'package:architecture/data/models/models.dart';
import 'package:architecture/data/http/http.dart';

class RemoteLoadSurveys {
  final String url;
  final HttpClient<List<Map>> httpClient;

  RemoteLoadSurveys({@required this.url, @required this.httpClient});

  Future<List<SurveyEntity>> load() async {
    try {
      final response = await httpClient.request(url: url, method: 'get');

      return response.map((json) => RemoteSurveyModel.fromJson(json).toEntity()).toList();
    } on HttpError {
      throw DomainError.unexpected;
    }
  }
}

class HttpClientSpy extends Mock implements HttpClient<List<Map>> {}

void main() {
  RemoteLoadSurveys sut;
  HttpClientSpy httpClient;
  String url;
  List<Map> list;

  List<Map> mockValidData() => [
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

  PostExpectation mockRequest() => when(
      httpClient.request(url: anyNamed('url'), method: anyNamed('method')));

  void mockHttpData(List<Map> data) {
    list = data;
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) => mockRequest().thenThrow(error);

  setUp(() {
    url = faker.internet.httpsUrl();
    httpClient = HttpClientSpy();
    sut = RemoteLoadSurveys(url: url, httpClient: httpClient);

    mockHttpData(mockValidData());
  });

  test("Should call HttpClient with correct values", () async {
    await sut.load();

    verify(httpClient.request(url: url, method: 'get'));
  });

  test("Should return suerveys on 200", () async {
    await sut.load();

    verify(httpClient.request(url: url, method: 'get'));
  });

  test("Should return suerveys on 200", () async {
    final surveys = await sut.load();

    expect(surveys, [
      SurveyEntity(
          id: list[0]['id'],
          question: list[0]['question'],
          dateTime: DateTime.parse(list[0]['date']),
          didiAnswer: list[0]['didiAnswer']),
      SurveyEntity(
          id: list[0]['id'],
          question: list[0]['question'],
          dateTime: DateTime.parse(list[0]['date']),
          didiAnswer: list[0]['didiAnswer'])
    ]);
  });

  test("Should throw Unexpected if HttpClient returns 200 with invalid data", () async {
    mockHttpData([{"invalid_key": "invalid_value"}]);

    expect(sut.load(), throwsA(DomainError.unexpected));
  });

  test("Should throw UnexpectedError if HttpClient returns 404", () async {
    mockHttpError(HttpError.notFound);

    expect(sut.load(), throwsA(DomainError.unexpected));
  });

  test("Should throw UnexpectedError if HttpClient returns 500", () async {
    mockHttpError(HttpError.serverError);

    expect(sut.load(), throwsA(DomainError.unexpected));
  });
}
